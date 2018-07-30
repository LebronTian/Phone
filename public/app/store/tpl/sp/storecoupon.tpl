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
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">优惠劵管理</strong> / <small>总计 <?php echo $data['count'];?> 种</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=store&_u=sp.addstorecoupon" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 创建优惠劵</a>
	</div>

	<div class="am-form-group am-margin-left am-fl">
	指定门店: 
	<select data-am-selected="{btnSize: 'lg' }" class="option_cat">
<?php
	$cats = $stores['list'];
	array_unshift($cats, array('uid' => 0, 'name' => '不限'));
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		if($option['store_uid'] == $c['uid']) $html .= ' selected';
			$html .= '>'.$c['name'].'</option>';
		}
		echo $html;
?>
      </select>
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

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<?php if(!empty($_REQUEST['_d'])) echo '<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>';
			?>
			</th>
			<th class="table-title">名称</th>
			<th class="table-parent">图片</th>
			<th class="table-parent">适用门店</th>
			<th class="table-image">已发放/总发放</th>
			<th class="table-time">说明</th>
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
			if(/*$c['publish_cnt'] >0 && */$c['publish_cnt'] <= $c['used_cnt']) {
				$html .= ' class="am-danger"';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['title'].'</td>'.
					'<td><img src="'.$c['img'].'" style="max-width:100px;max-height:100px;"></td>';
			if(!empty($c['store_uids'][0]) && ($s = StoreMod::get_store_by_uid($c['store_uids'][0]))) {
				$name = $s['name'];	
			}
			else {
				$name = '不限';
			}
			$html .= '<td>'.$name.'</td>';
			
			$html .= 
					'<td>'.($c['used_cnt'] ? '<a href="?_a=store&_u=sp.usercoupon&coupon_uid='.$c['uid'].'">'.$c['used_cnt'].'</a>' : '-').'/'.($c['publish_cnt'] ? $c['publish_cnt'] : '-').'</td>'.
					'<td>'.$c['brief'].'</td>'.
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=store&_u=sp.addstorecoupon&uid='.$c['uid']
				.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
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
	$extra_js = $static_path.'/js/storecoupon.js';
?>
