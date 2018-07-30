<!-- <div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">客户数目</strong> / <small>总计 <?php echo $fans['count'];?> </small></div>
</div> -->

<div class="am-g am-padding pd0 ">
	<div class="am-u-md-8 am-cf">
        <div class="am-form-inline" role="form">
        	<div class="am-form-group">
        		<input type="text" class="am-form-field normal-input-self option_key" value="<?php echo $option['key'];?>" placeholder="输入微信昵称">
        	</div>
            <button class="am-btn am-btn-secondary option_key_btn fans-btn-self" type="button">搜索</button>
        </div> 
      </div>

    

	<div class="am-u-md-4">
	        <div class="am-form-group am-margin-left mt0 am-fr">
		        <a data-am-popover="{content: '导出数据到excel格式文件', trigger: 'hover focus'}"
		           class="am-btn fans-btn-self  am-btn-secondary" href="?_a=su&_u=sp.fanslist_excel" target="_Blank"> 导出数据</a>
		    </div>
            <div class="am-form-group am-margin-left mt0 am-fr">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '<option value="0"';
					if($option['g_uid']==0) $html .= ' selected ';
					$html .= '>所有分组</option>';
					
					foreach($groups as  $c) {
					$html .= '<option value="'.$c['uid'].'"';
					if($option['g_uid'] == $c['uid']) $html .= ' selected';
					$html .= '>'.$c['name'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
            <?php   if(count($all_public)!=1) {?>
            <div class="am-form-group am-margin-left am-fl" style="display: none;">
                <select data-am-selected="{btnSize: 'lg' }" class="option_public">
                    <?php
                    $html = '<option value="0"';
                    if($option['public_uid']==0) $html .= ' selected ';
                    $html .= '>所有小程序</option>';

                    foreach($all_public as  $c) {
                        $html .= '<option value="'.$c['uid'].'"';
                        if($option['public_uid'] == $c['uid']) $html .= ' selected';
                        $html .= '>'.$c['public_name'].'</option>';
                    }
                    echo $html;
                    ?>
                </select>
            </div>
            <?php }?>
        <div class="am-form-group am-margin-left am-fl" style="display: none;">
            <?php
            if(empty($syn_fans))
            {
				if(0&&!empty($_REQUEST['_d'])) {
                echo '<button class="am-btn am-btn-primary am-btn-sm template_refresh_quick"> <i class="am-icon-refresh "></i> 快速同步粉丝</button>';
                echo '<button class="am-btn am-btn-primary am-btn-sm template_refresh"> <i class="am-icon-refresh "></i> 完全同步粉丝</button>';
				}
            }else
            {
                echo '<button class="am-btn am-btn-success am-btn-sm "> <i class="am-icon-spinner am-icon-spin"></i> 同步中</button>';
            }
            ?>
        </div>
    </div>
	
</div>

<?php
	if(!empty($option['from_su_uid'])) {
		$from_su = AccountMod::get_service_user_by_uid($option['from_su_uid']);
		echo '
<div class="am-g am-padding">
	<a href="?_a=su&_u=sp.fansdetail&uid='.$option['from_su_uid'].'">'.($from_su['name'] ? $from_su['name'] : $from_su['account']).'</a> 的邀请用户列表
</div>
		';
	}
        else if(!empty($option['from_su_uid2'])) {
                $from_su = AccountMod::get_service_user_by_uid($option['from_su_uid2']);
                echo '
<div class="am-g am-padding">
        <a href="?_a=su&_u=sp.fansdetail&uid='.$option['from_su_uid'].'">'.($from_su['name'] ? $from_su['name'] : $from_su['account']).'</a> 的邀请二级用户列表
</div>
                ';
        }
        else if(!empty($option['from_su_uid3'])) {
                $from_su = AccountMod::get_service_user_by_uid($option['from_su_uid3']);
                echo '
<div class="am-g am-padding">
        <a href="?_a=su&_u=sp.fansdetail&uid='.$option['from_su_uid'].'">'.($from_su['name'] ? $from_su['name'] : $from_su['account']).'</a> 的三级邀请用户列表
</div>
                ';
        }

?>


<?php
	//var_export($fans);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除分类</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12 fans_box">
<table class="table-self">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
			</th>
			<th class="table-title">微信昵称</th>
			<th class="table-title">手机</th>
			<th class="table-parent">身份</th>
			<th class="table-image">头像</th>
			<th class="table-gender">性别</th>
			<th class="table-time">加入时间</th>
			<th class="table-time">购买次数</th>
			<th class="table-time">积分</th>
			<th class="table-set">审核</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$fans['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($fans['list'] as $f) {
			$html .= '<tr';
			if($f['status']==2) {
				$html .= ' class="am-danger "';
			}

			$html .= ' data-id="'.$f['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td class="am-text-truncate width200"><a href="?_a=su&_u=sp.fansdetail&uid='.$f['uid'].'">'.
					($f['name'] ? $f['name'] : ($f['account'] ? $f['account'] : '['.$f['uid'].']')).
			'</a></td>';
			$p = SuMod::get_su_profile($f['uid']);
			$html .= '<td>'.(!empty($p['phone']) ? $p['phone'] : '-').'</td>';
			
			$html .= '<td>';//.(!empty($f['group_type']) ? $f['group_type'] : '-').'

			// 用户分组
			$html .= '<div class="am-form-group mb0">';
			
			$html.='<select class=" form-group-self group-select" data-id="'.$f['uid'].'" data-guid="'.$f['g_uid'].'">';
			$html .= '<option class="group-option" g_uid="0">-</option>';
        	foreach($groups as  $c) {
				$html .= '<option value="'.$c['uid'].'"';
				if($f['g_uid'] == $c['uid']) $html .= ' selected';
				$html .= '>'.$c['name'].'</option>';
			}
        	$html.='</select></div>';

			$html.='</td><td><img src="'.$f['avatar'].'" style="max-width:50px;max-height:50px;"></td><td>';
            switch($f['gender']){
                case 0:
                    $html .='-';
                    break;
                case 1:
                    $html .='男';
                    break;
                case 2:
                    $html .='女';
                    break;
            }
			$html.='</td><td>'.date('Y-m-d H:i:s', $f['create_time']).'</td>';
			$cnt = Dba::readOne('select count(*) from shop_order where user_id = '.$f['uid']);
			$html .= '<td><a href="?_a=shop&_u=sp.orderlist&user_id='.$f['uid'].'">'.$cnt.'</a></td>';
			$pt = SuPointMod::get_user_points_by_su_uid($f['uid']);
			$html .= '<td><a href="?_a=su&_u=sp.supointlist&su_uid='.$f['uid'].'">'.$pt['point_remain'].'</a></td>';
			$html .= '<td>'.'
			<!-- <div class="am-form-group mb0">
		      <select class="form-group-self private_verify" data-id="'.$f['uid'].'">
		        <option value="option1">请选择</option>
		        <option value="option2" class="am-btn-success" value="pass">通过</option>
		        <option value="option3" class="am-btn-danger" value="refuse">拒绝</option>
		      </select>
		      <span class="am-form-caret"></span>
		    </div> -->

		    <div class="am-form-group mb0">';
			
			$html.='<select class="form-group-self private_verify" data-id="'.$f['uid'].'" data-guid="'.$f['g_uid'].'">';
			
			$html .= '<option value="new"';
			if($f['status'] == 0) $html .= ' selected';
			$html .= '>未审核</option>';

			$html .= '<option value="pass"';
			if($f['status'] == 1) $html .= ' selected';
			$html .= '>通过</option>';

			$html .= '<option value="refuse"';
			if($f['status'] == 2) $html .= ' selected';
			$html .= '>拒绝</option>';

        	$html.='</select></div>

		    <!-- <ul class="am-dropdown-content creview" data-uid="'.$f['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
			    <li class="am-btn-success" data-id="'.$f['uid'].'" sp="1">通过</li>
			    <li class="am-btn-danger" data-id="'.$f['uid'].'" sp="2">拒绝</li>
			  </ul>
			<div class="am-dropdown private_verify" data-am-dropdown>
			  <button class="am-btn ';
				if($f['status']==0)
					$html.='am-btn-default';
				if($f['status']==1)
					$html.='am-btn-success';
				if($f['status']==2)
					$html.='am-btn-danger';
				$html.=' am-dropdown-toggle am-btn am-btn-default am-selected-btn dropdown-self" data-am-dropdown-toggle "><i class="am-selected-icon am-icon-caret-down"></i>.
			</button>
			  <ul class="am-dropdown-content creview" data-uid="'.$f['uid'].'" style="cursor:pointer; text-align:center;">
			    <li class="am-btn-success" data-id="'.$f['uid'].'" sp="1">通过</li>
			    <li class="am-btn-danger" data-id="'.$f['uid'].'" sp="2">拒绝</li>
			  </ul>
			</div> -->
			'.'</td>';
			
			$html .= '
              <td>
                ';
			$html .= '<a style="color: #fff;" class="score_sucharge am-btn am-btn-danger am-btn-xs am-text-primary" data-id="'.$f['uid'].	
				'"> 赠送积分</a>';
			
			$html .= '
              </td>
            </tr>
			';
		}
		echo $html;
	}
?>
<style>
	.admin-content{overflow: auto;}
	.change_page{min-height: 250px}
	.apart_team {margin-right: 20px;}
	.apart_team > ul {min-width:160px;}
	.apart_team > ul > li > a {padding:6px 20px;cursor:pointer}
	.apart_team > ul > li > a:hover {background-color: #0a6999;color:white;}
	.apart_team .am-dropdown-toggle {cursor:pointer;width: 160px}


</style>


	</tbody>
</table>
</div>

<div class="am-dropdown" data-am-dropdown="" style="margin-left:20px">
<button class="am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle>批量添加粉丝到分组</button>
<button class="am-btn am-btn-success all_pass" data-am-dropdown-toggle>批量通过</button>
<button class="am-btn am-btn-danger all_refuse" data-am-dropdown-toggle>批量拒绝</button>
<ul class="am-dropdown-content all_move" style="min-width:162px">
<?php
$html ='';
	$html .= '<li><a data-id="0" g_uid="0">未分组</a></li>';
	if($groups)
	foreach($groups as  $c) 
	{
		$html .= '<li><a data-id="'.$c['uid'].'" g_uid="'.$c['uid'].'">'.$c['name'].'</a></li>';
	}
	echo $html;
 ?>
</ul>

</div>
        	




<div class="am-u-sm-12 change_page">
<?php
	echo $pagination;
?>
</div>
<div class="am-modal am-modal-confirm" tabindex="-1" id="score-confirm">
  <div class="am-modal-dialog ">
    <div class="am-modal-hd">给 <?php echo @$user['name']; ?> 赠送积分</div>
	<hr/>
	<form class="am-form am-form-horizontal">
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_charge_price">赠送积分</label> 		
			<div class="am-u-sm-9">
				<input id="id_charge_price" class="am-form-field" data-id="<?php echo isset($option['su_uid']) ? $option['su_uid'] : 0;?>" >
    		</div>
    	</div>
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_brief">备注信息</label> 		
			<div class="am-u-sm-9">
				<input id="id_brief" class="am-form-field" value="管理员赠送" >
    		</div>
    	</div>
   	 </form>
	
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12">
<script>
    var optionData = <?php echo(!empty($option)? json_encode($option):"null")?>;
    var fansData = <?php echo(!empty($fans)? json_encode($fans):"null")?>;
    console.log(fansData);
</script>
<?php
	$extra_js = array(
		$static_path.'/js/fanslist.js',
		'/spv3/su/static/js/supointlist.js'
	)
?>
