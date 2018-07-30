<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">粉丝数目</strong> / <small>总计 <?php echo $fans['count'];?> </small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-8">
            <div class="am-form-group am-margin-left am-fl">
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
            <div class="am-form-group am-margin-left am-fl">
                <select data-am-selected="{btnSize: 'lg' }" class="option_public">
                    <?php
                    $html = '<option value="0"';
                    if($option['public_uid']==0) $html .= ' selected ';
                    $html .= '>所有公众号</option>';

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
        <div class="am-form-group am-margin-left am-fl">
            <?php
            if(empty($syn_fans))
            {
				if(!empty($_REQUEST['_d'])) {
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
    <div class="am-form-group am-margin-left am-fl">
        <a data-am-popover="{content: '导出数据到excel格式文件', trigger: 'hover focus'}"
           class="am-btn  am-btn-secondary" href="?_a=su&_u=sp.fanslist_excel" target="_Blank"><span class="am-icon-file-excel-o"></span> 下载</a>
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
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
			</th>
			<th class="table-title">用户名</th>
			<th class="table-parent">分组</th>
			<th class="table-image">头像</th>
			<th class="table-gender">性别</th>
			<th class="table-time">加入时间</th>
			<th class="table-set">审核</th>
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

			$html .= ' data-id="'.$f['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td><a href="?_a=su&_u=sp.fansdetail&uid='.$f['uid'].'">'.
					($f['name'] ? $f['name'] : ($f['account'] ? $f['account'] : '['.$f['uid'].']')).
			'</a></td><td>';//.(!empty($f['group_type']) ? $f['group_type'] : '未分组').'
			$html .= '<div class="am-dropdown apart_team" data-am-dropdown=""><button class="am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle data-guid="'.$f['g_uid'].'">';
			if($f['g_uid']==0)
				$html.='未分组';
			foreach ($groups as $g) {
				if($f['g_uid']==$g['uid'])
				$html.=$g['name'];
			}

			$html.='</button><ul class="am-dropdown-content private_move">';
			$html .= '<li><a data-id="'.$f['uid'].'" g_uid="0">未分组</a></li>';
        	foreach($groups as  $c) {
					$html .= '<li><a data-id="'.$f['uid'].'"g_uid="'.$c['uid'].'">'.$c['name'].'</a></li>';
			}
        	$html.='</ul></div>';
			$html.='</td><td><img src="'.$f['avatar'].'" style="max-width:100px;max-height:100px;"></td><td>';
            switch($f['gender']){
                case 0:
                    $html .='未知';
                    break;
                case 1:
                    $html .='男';
                    break;
                case 2:
                    $html .='女';
                    break;
            }
			$html.='</td><td>'.date('Y-m-d H:i:s', $f['create_time']).'</td>';

			$html .='<td>'.'<div class="am-dropdown private_verify" data-am-dropdown>
  <button class="am-btn ';
	if($f['status']==0)
		$html.='am-btn-default';
	if($f['status']==1)
		$html.='am-btn-success';
	if($f['status']==2)
		$html.='am-btn-danger';
	$html.=' am-dropdown-toggle" data-am-dropdown-toggle style="width:40px;height:30px"></button>
  <ul class="am-dropdown-content creview" data-uid="'.$f['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
    <li class="am-btn-success" data-id="'.$f['uid'].'" sp="1">通过</li>
    <li class="am-btn-danger" data-id="'.$f['uid'].'" sp="2">拒绝</li>
  </ul>
</div>'.'</td>'.'</tr>';
		}
		echo $html;
	}
?>
<style>
	.admin-content{overflow: auto;}
	.change_page{min-height: 250px}
	.am-btn {padding: 0.3em 0.5em}
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

<script>
    var optionData = <?php echo(!empty($option)? json_encode($option):"null")?>;
    var fansData = <?php echo(!empty($fans)? json_encode($fans):"null")?>;
    console.log(fansData);
</script>
<?php
	$extra_js = $static_path.'/js/fanslist.js';
?>
