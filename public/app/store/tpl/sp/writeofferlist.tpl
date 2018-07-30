<style>
.am-btn-white {
	background-color: white !important;
	border: 1px dotted gray;
}
.th-field {
	color: gray;
}
</style>

<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">核销员管理</strong> / <small>总计 <?php echo $data['count'];?> 位</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-u-md-6">
        <div class="am-fl am-form-group am-margin-right">
		<a class="am-btn am-btn-lg am-btn-success" href="?_a=store&_u=sp.addwriteoffer"><span class="am-icon-plus"></span> 添加核销员</a>
		</div>
        <div class="am-fl am-cf">审核状态:
            <div class="am-dropdown" data-am-dropdown>
                <button class="am-btn <?php
                $reviews = array(
                    0 => 'am-btn-default',
                    1 => 'am-btn-success',
                    2 => 'am-btn-danger',
                );
                echo (isset($reviews[$option['status']]) ? $reviews[$option['status']] : 'am-btn-white');
                ?> am-dropdown-toggle" data-am-dropdown-toggle></button>
                <ul class="am-dropdown-content creviews" style="min-width:40px !important; cursor:pointer; text-align:center;">
                    <li class="am-btn-white"   sp="-1"> 全部 </li>
                    <li class="am-btn-success" sp="1"> 通过 </li>
                    <li class="am-btn-danger"  sp="2"> 拒绝 </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="am-u-md-3 am-cf">
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

<?php
	//var_export($data);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-review">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">审核通过</div>
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
				<?php if(!empty($_REQUEST['_d'])) echo '<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>';
			?>
                <a href="javascript:;" class="am-text-lg ceditall" style=""><span class="am-icon-edit"></span></a>
			</th>
			<th class="table-title">昵称</th>
			<th class="table-title">联系方式</th>
			<th class="table-parent">所属门店</th>
			<th class="table-time">申请时间</th><th class="table-status">审核</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$data['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($data['list'] as $c) {
			$c['user'] = AccountMod::get_service_user_by_uid($c['su_uid']);
			$profile = Dba::readRowAssoc('select realname, phone from service_user_profile where uid = '.$c['su_uid']);
			$cnt = Dba::readOne('select count(*) from ticket_seller_order where seller_uid = '.$c['uid']);
			$html .= '<tr';
			if($c['status'] == 2) {
				$html .= ' class="am-danger"';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['user']['name'].'</td>'.
					'<td>'.($profile ? $profile['realname'].' (<span class="am-icon-mobile"></span> '.$profile['phone'].')' : '-').'</td>'.
					'<td>';
			if(!empty($c['store_uids'][0]) && ($s = StoreMod::get_store_by_uid($c['store_uids'][0]))) {
				$name = $s['name'];	
			}
			else {
				$name = '不限';
			}
			$html .= $name.'</td>'.
					'<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>'.
					'<td>'.'<div class="am-dropdown" data-am-dropdown>
  <button class="am-btn '
	.(isset($reviews[$c['status']]) ? $reviews[$c['status']] : 'am-btn-white')
	.' am-dropdown-toggle" data-am-dropdown-toggle></button>
  <ul class="am-dropdown-content creview" data-uid="'.$c['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
    <li class="am-btn-success" sp="1">通过</li>
    <li class="am-btn-danger"  sp="2">拒绝</li>
  </ul>
</div>'.

					'</td>'.
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			//$html .= '<a href="?_a=takeaway&_u=sp.addchef&uid='.$c['uid']
			//	.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			if(!empty($_REQUEST['_d'])) {
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
			}
			$html .= '</div></div></td>'.'</tr>';
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

<script>
    var cheflist =<?php echo( !empty($data) ? json_encode($data['list']) : "null") ?>;
</script>


<?php
	$extra_js = $static_path.'/js/writeofferlist.js';
?>
