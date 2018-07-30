<style>
.am-btn-white {
	background-color: white !important;
	border: 1px dotted gray;
}
.th-field {
	color: gray;
}
.am-form-group{
	margin-top:5px;
}
</style>

<div class="am-cf am-padding">
	<div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
  	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
  <strong class="am-text-defualt am-text-lg"><?php echo $reward['title']
.' <a href="?_a=reward&_u=sp.activitydata&r_uid='.$reward['uid'].'"><span class="am-icon-line-chart"></span></a>';?></strong> 的抽奖记录 / <small>总计 <?php echo $records['count'];?> 条记录</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-3">
		<button class="am-btn am-btn-success am-btn-warning beditall am-icon-eye am-icon-edit" >查看模式</button>

		<div class="am-form-group am-fr ">
			<span id="color_sign">根据标记查看</span> ：<div class="am-dropdown" data-am-dropdown>
			<button class="am-btn <?php 
				$sp_remarks = array(
					-1 => 'am-btn-white',
					1 => 'am-btn-default',
					2 => 'am-btn-danger',
					3 => 'am-btn-success',
					4 => 'am-btn-primary',
				);
				echo (isset($sp_remarks[$option['sp_remark']]) ? $sp_remarks[$option['sp_remark']] : 'am-btn-white');
			?>
			am-dropdown-toggle" data-am-dropdown-toggle></button>
			<ul class="am-dropdown-content csp_remarks" style="min-width:34px !important; cursor:pointer;">
				<li class="am-btn-white"   sp="-1">&nbsp;</li>
				<li class="am-btn-default" sp="1">&nbsp;</li>
				<li class="am-btn-danger"  sp="2">&nbsp;</li>
				<li class="am-btn-success" sp="3">&nbsp;</li>
				<li class="am-btn-primary" sp="4">&nbsp;</li>
			</ul>
			</div>
		   
		</div>
	</div>
 
	<div class="am-u-md-3 ">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
     </div>

</div>


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除记录</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<?php
				if(!empty($_REQUEST['_d']))
				echo '
				<a href="javascript:;" class="am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
				&nbsp;&nbsp;|&nbsp;&nbsp; 
				'.
				
				'<a href="javascript:;" class="am-text-lg ceditall" style=""><span class="am-icon-edit"></span></a>';
				?>
			</th>
			<th class="table-title">用户</th>
			<th class="table-parent">抽奖时间</th>
			<!--<th class="table-image">标记</th>
			<th class="table-set">操作</th>-->
			<th class="table-parent" >中奖情况</th>
			<th class="table-time">标记 <span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '例如您可以用 红色 来标记已经领奖的用户', trigger: 'hover focus'}"></span></th>
		</tr>
	</thead>
	<tbody>
<?php
	$reward_win_rule=!empty($reward['win_rule']['type'])?true:false;
	if(!$records['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {

		$html = '';
		foreach($records['list'] as $c) {
			$html .= '<tr';
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.(empty($c['user']) ? '游客' : $c['user']['name']).'</td>'.
					'<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>';


			//$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			//$html .= '<a href="?_a=reward&r_uid='.$c['r_uid'].'&uid='.$c['uid']
			//	.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-link"></span> 查看详情</a>';
			
			$html .= '<td style="position:relative"><div class="show_rule_data" >';
			$rewardret='未中奖';
		
			if(!empty($c['item_uid'])&&$rewardret=RewardMod::get_reward_item_by_uid($c['item_uid']))
			{	
				$rewardret=$rewardret['title'];
					$html .='<button  type="button" class="am-btn am-btn-secondary am-radius"><span class="am-icon-gift"></span>'.$rewardret.'</button>';
				if($reward_win_rule)
				{				
					if(!empty($c['data']))
					{	
						$html .='<button  type="button" class="am-btn am-btn-default am-round">表单</button>';
						$html .='<div class="win_rule_data" style="display: none;z-index:9999;position:absolute;top:-100%;left:140px;">
						<table class="am-table am-table-bordered am-table-radius " style="background-color:#fff">';
						$size=count($reward['win_rule']['data']);
						for($i=0;$i<$size;$i++)
						{
							$html .='<tr><td>'.$reward['win_rule']['data'][$i].'</td><td>'.(empty($c['data'][$i])?'':$c['data'][$i]).'</td><tr>';
						}
						$html .='</div></table>';
		
					}
				}
			}
			else
			{
				$html .=$rewardret;
			}
			$html .='</div></td>'; 
			if(!empty($_REQUEST['_d']))
			$html .= '<td><button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button></td>';
			$html .='<td> <div class="am-dropdown" data-am-dropdown><button class="am-btn ';
			$sp_remarks = array(
				-1 => 'am-btn-white',
				1 => 'am-btn-default',
				2 => 'am-btn-danger',
				3 => 'am-btn-success',
				4 => 'am-btn-primary',
			);
			$html .=isset($sp_remarks[$c['sp_remark']]) ? $sp_remarks[$c['sp_remark']] : 'am-btn-white';

			$html .=' am-dropdown-toggle" data-am-dropdown-toggle></button>'.
				'<ul class="am-dropdown-content csp_remark" style="min-width:34px !important; cursor:pointer;">'.
					'<li class="am-btn-while" sp="-1">&nbsp;</li>'.
					'<li class="am-btn-default" sp="1">&nbsp;</li>'.
					'<li class="am-btn-danger"  sp="2">&nbsp;</li>'.
					'<li class="am-btn-success" sp="3">&nbsp;</li>'.
					'<li class="am-btn-primary" sp="4">&nbsp;</li>'.
				'</ul>'.
				'</div>'.
			'</td>';

			$html .= '</tr>';
		}
		echo $html;
	}
?>

	</tbody>
</table>
</div>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	echo '<script>g_r_uid='.$reward['uid'].';</script>';
	$extra_js = $static_path.'/js/recordlist.js';
?>
