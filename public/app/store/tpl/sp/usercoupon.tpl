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
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">已发放的优惠劵</strong> / <small>总计 <?php echo $data['count'];?> 张</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=store&_u=sp.addusercoupon" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 发放优惠劵</a>
	</div>

	<div class="am-form-group am-margin-left am-fl">
	指定优惠券: 
	<select data-am-selected="{btnSize: 'lg' }" class="option_cat2">
<?php
	$cats = $coupons['list'];
	array_unshift($cats, array('uid' => 0, 'title' => ' -不限- '));
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		if($option['coupon_uid'] == $c['uid']) $html .= ' selected';
			$html .= '>'.$c['title'].'</option>';
		}
		echo $html;
?>
      </select>
	</div>

	<div class="am-form-group am-margin-left am-fl">
	是否核销: 
	<select data-am-selected="{btnSize: 'lg' }" class="option_cat3">
<?php
	$cats = array(
				array('uid' => 0, 'name' => ' -不限- '),
				array('uid' => 1, 'name' => ' 已核销 '),
				array('uid' => 2, 'name' => ' 未核销 '),
	);
	$html = '';
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		if($option['writeoff'] == $c['uid']) $html .= ' selected';
			$html .= '>'.$c['name'].'</option>';
		}
		echo $html;
?>
      </select>
	</div>

	<div class="am-form-group am-margin-left am-fl">
	指定门店: 
	<select data-am-selected="{btnSize: 'lg' }" class="option_cat">
<?php
	$cats = $stores['list'];
	$html = '';
	array_unshift($cats, array('uid' => 0, 'name' => ' -不限- '));
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		if($option['store_uid'] == $c['uid']) $html .= ' selected';
			$html .= '>'.$c['name'].'</option>';
		}
		echo $html;
?>
      </select>
	</div>

	<div class="am-form-group am-margin-left am-fl">
		<button data-am-popover="{content: '导出当前数据到excel格式文件', trigger: 'hover focus'}"
			class="am-btn am-btn-lg am-btn-secondary" id="id_download"><span class="am-icon-file-excel-o"></span> 下载</button>
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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm2">
  <div class="am-modal-dialog ">
    <div class="am-modal-hd">核销门店</div>
	<hr/>
	<form class="am-form am-form-horizontal">
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_writeoff_store_uid">核销门店</label> 		
			<div class="am-u-sm-9">
				<select id="id_writeoff_store_uid" class="am-form-field">
<?php
	$cats = $stores['list'];
	$html = '';
	array_unshift($cats, array('uid' => 0, 'name' => ' -自动- '));
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		$html .= '>'.$c['name'].'</option>';
	}
	echo $html;
?>
					
				</select>
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
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
<?php if(!empty($_REQUEST['_d'])) {
	echo '<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>';
}
	echo '<a href="javascript:;" class="am-text-primary am-text-lg cwriteoffall" style="margin-left:10px;"><span class="am-icon-pencil"></span></a>';
			?>
			</th>
			<th class="table-title">优惠劵名称</th>
			<th class="table-parent">图片</th>
			<th class="table-image">顾客</th>
			<th class="table-time">发放时间</th>
            <th class="table-time2">过期时间</th>
			<th class="table-time">使用情况</th>
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
			$html .= '<tr';
			if(($c['used_time'])) {
				$html .= ' class="am-success"';
			}
			else if($c['expire_time'] >0 && ($c['expire_time'] < $_SERVER['REQUEST_TIME'])) {
				$html .= ' class="am-danger"';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['info']['title'].'</td>'.
					'<td><img src="'.$c['info']['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$user = AccountMod::get_service_user_by_uid($c['user_id']);
			$html .= '<td>'.($user['name'] ? $user['name'] : $user['account']).'</td>'.
					'<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>
					<td>'.($c['expire_time']!=0 ? date('Y-m-d H:i:s',$c['expire_time']):"无限期").'</td>';

			if($c['used_time'] > 0) {
				if($c['store_uid']) {
					 $s = StoreMod::get_store_by_uid($c['store_uid']);	
					$s = '('.$s['name'].')';
				}
				else $s = '';
				$html .= '<td>已核销('.date('Y-m-d H:i:s', $c['used_time']).') '.$s.'</td>';
			}
			else if($c['expire_time'] >0 && ($c['expire_time'] < $_SERVER['REQUEST_TIME'])) {
					$html .= '<td><a class="am-btn am-btn-xs am-btn-warning">已过期</a></td>';
			}
			else {
					$html .= '<td>未使用</td>';
			}

			$html.= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			//$html .= '<a href="?_a=takeaway&_u=sp.addstorecoupon&uid='.$c['uid']
			//	.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			if(!empty($_REQUEST['_d']))$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
			if(!$c['used_time']) $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-primary cwriteoff" data-id="'.$c['uid'].'"><span class="am-icon-pencil"></span> 核销</button>';
		
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

<?php
	$extra_js = $static_path.'/js/usercoupon.js';
?>
