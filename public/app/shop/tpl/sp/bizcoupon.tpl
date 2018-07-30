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
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商家（<?php echo $biz['title'] ?>）的红包</strong> / <small>总计 <?php echo $data['count'];?> 种</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
		<a  href="?_a=shop&_u=sp.addbizcoupon&biz_uid=<?php echo $option['biz_uid'] ?>" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 创建优惠劵</a>
	</div>
	<div class="am-fl am-cf" style="padding-left: 10px">
		<a  href="?_a=shop&_u=sp.bizusercoupon&biz_uid=<?php echo $option['biz_uid'] ?>" type="button" class="am-btn am-btn-primary">发放记录</a>
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
			<th class="table-image">发放数目</th>
			<th class="table-discount">折扣</th>
			<th class="table-min_price">满N元(&yen;)可用</th>
			<th>状态</th>
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
			if(($c['publish_cnt'] >0 && $c['publish_cnt'] <= $c['used_cnt'])||($c['status'] == 1)) {
				$html .= ' class="am-danger"';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['title'].'</td>'.
					'<td><img src="'.$c['img'].'" style="max-width:100px;max-height:100px;"></td>'.
					'<td><a href="?_a=shop&_u=sp.bizusercoupon&coupon_uid='.$c['uid'].'">'.$c['used_cnt'].'/'.($c['publish_cnt'] ? $c['publish_cnt'] : '-').'(点击查看)</a></td>';
			$html .= '<td>'. (empty($c['rule']['discount'])?'-':sprintf('%.2f',$c['rule']['discount']/100)).'</td>';
			$html .= '<td>'. (empty($c['rule']['min_price'])?'-':sprintf('%.2f',$c['rule']['min_price']/100)).'</td>';
			$html .='<td><a class="cStatus am-btn am-btn-xs '.($c["status"]==1 ? 'am-btn-danger">下线' : 'am-btn-success">上线').'</a></td>';

				$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
				$html .='<a target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary" href="?_a=shop&_u=sp.addbizcoupon&biz_uid='.$biz['uid'].'&uid='.$c['uid'].'"><span class="am-icon-edit"></span> 编辑</a>';
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button></div></div></td>';


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
	echo '<script>
	var biz_uid = ' . (!empty($biz) ? $biz['uid'] : "null") . ';
	</script>';

	$extra_js = $static_path.'/js/bizcoupon.js?a=1';
?>

