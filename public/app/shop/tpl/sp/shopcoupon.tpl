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
    <a  href="?_a=shop&_u=sp.addshopcoupon" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 创建优惠劵</a>
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
			if($c['publish_cnt'] >0 && $c['publish_cnt'] <= $c['used_cnt']) {
				$html .= ' class="am-danger"';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['title'].'</td>'.
					'<td><img src="'.$c['img'].'" style="max-width:100px;max-height:100px;"></td>'.
					'<td>'.$c['used_cnt'].'/'.($c['publish_cnt'] ? $c['publish_cnt'] : '-').'</td>';

			$html .= '<td>'. (empty($c['rule']['discount'])?'-':sprintf('%.2f',$c['rule']['discount']/100)).'</td>';
			$html .= '<td>'. (empty($c['rule']['min_price'])?'-':sprintf('%.2f',$c['rule']['min_price']/100)).'</td>';

			$html .='<td style="position: relative"><button class="copy-link am-btn am-btn-success am-btn-xs" data-am-popover="{theme: \'primary\',content: \'链接可使用在首页幻灯片链接等地方\', trigger: \'hover focus\'}">复制链接</button></td>';

			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs"><a href="?_a=shop&_u=sp.addshopcoupon&uid='.$c['uid'];
			$html .='" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
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
	$extra_js = $static_path.'/js/shopcoupon.js';
?>

<script>
	seajs.use('zclip', function () {
		$('.copy-link').zclip({
			copy: function () {
				var uid = $(this).closest('tr').data('id');
				//return '?_a=shop&_u=index.get_coupon&coupon_uid='+uid;
				return '<?php echo DomainMod::get_app_url('shop') ?>&_u=index.get_coupon&coupon_uid='+uid;
			},
			afterCopy: function () {
				showTip('','复制成功，请粘贴使用',1000)
			}
		})
	})
</script>