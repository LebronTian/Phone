<?php #var_export($groups)?>
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">配送员订单</strong> / <small>总计 <?php echo $list['count']; ?> 条数据</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
    <a  href="?_a=shop&_u=sp.adddeliveries" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加配送员订单</a>
	</div>
	</div>

	<!--<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
    </div>-->

</div>



<?php
	//var_export($articles);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除配送订单</div>
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
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">配送员名称</th>
			<th class="table-parent">订单编号</th>
			<th class="table-time">创建时间</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$list) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($list['list'] as $c) {
			if(empty($c['name'])){
				$c['name'] = "--";
			}
			$html .= '<tr';
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>';
			$html .='<td><a href="?_a=shop&_u=sp.deliveries&su_uid='.$c['su_uid'].'">'
		.$c['name'].'</a></td>';
  			$html .='<td><a href="?_a=shop&_u=sp.orderdetail&uid='.$c['order_uid'].'">'
					.$c['order_uid'].'</a></td><td>'.date('Y-m-d H:i:s', $c['create_time']).'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=shop&_u=sp.adddeliveries&uid='.$c['uid']
				.'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
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
	$extra_js = $static_path.'/js/delivery.js';
?>
