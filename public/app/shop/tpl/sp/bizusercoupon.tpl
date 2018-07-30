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
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">已发放<?php if(!empty($coupon))echo '（'.$coupon['title'].'）' ?>红包</strong> / <small>总计 <?php echo $data['count'];?> 张</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <!--<a  href="?_a=shop&_u=sp.addusercoupon" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 发放优惠劵</a>-->
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
			<th class="table-title">红包名称</th>
			<th class="table-parent">图片</th>
			<th class="table-image">顾客</th>
			<th class="table-time">发放时间</th>
            <th class="table-time2">过期时间</th>
            <th class="table-time2">使用时间</th>
            <th class="table-discount">折扣(&yen;)</th>
            <th class="table-min_price">满N元(&yen;)可用</th>
			<th class="table-time">状态</th>
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
			if($c['use_time'] > 0 || ($c['expire_time'] >0 && ($c['expire_time'] < $_SERVER['REQUEST_TIME']))) {
				$html .= ' class="am-danger"';
			}
			if(isset($c['used_time'])){
				$used_time = date('Y-m-d H:i:s',$c['used_time']);
			}else{
				$used_time = '-';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['info']['title'].'</td>'.
					'<td><img src="'.$c['info']['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$user = AccountMod::get_service_user_by_uid($c['user_id']);
			$html .= '<td>'.($user['name'] ? $user['name'] : $user['account']).'</td>'.
					'<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>
					<td>'.($c['expire_time']!=0 ? date('Y-m-d H:i:s',$c['expire_time']):"无限期").'</td>';
			$html .='<td>'.$used_time.'</td>';
			$html .= '<td>'. (empty($c['info']['rule']['discount'])?'-':sprintf('%.2f',$c['info']['rule']['discount']/100)).'</td>';
			$html .= '<td>'. (empty($c['info']['rule']['min_price'])?'-':sprintf('%.2f',$c['info']['rule']['min_price']/100)).'</td>';
			if($c['use_time'] > 0) {
					$html .= '<td><a class="am-btn am-btn-xs am-btn-default">已使用</a></td>';
			}
			else if($c['expire_time'] >0 && ($c['expire_time'] < $_SERVER['REQUEST_TIME'])) {
					$html .= '<td><a class="am-btn am-btn-xs am-btn-warning">已过期</a></td>';
			}
			else {
					$html .= '<td><a class="am-btn am-btn-xs am-btn-success">正常</a></td>';
			}
			$html.= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			//$html .= '<a href="?_a=takeaway&_u=sp.addshopcoupon&uid='.$c['uid']
			//	.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
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
	echo '<script>
var biz_uid = ' . (!empty($coupon) ? $coupon['biz_uid'] : "null") . ';
</script>';

	$extra_js = $static_path.'/js/bizusercoupon.js';
?>
