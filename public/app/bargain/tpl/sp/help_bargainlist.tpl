<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">帮砍列表</strong> / <small>总计 <?php echo $data['count'];?> 条记录</small></div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">删除此砍价</div>
		<div class="am-modal-bd">
			确定要删除吗？
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>


<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
          <div class="am-btn-toolbar am-fl">


        </div>
    </div>
    </div>

</div>
<br/>
<br/>
<!-- 头部工具栏 end -->

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<!--<th class="table-check"><input type="checkbox"></th>-->
			<th class="table-title">用户</th>
			<th class="table-date">帮砍uid</th>
			<th class="table-type">帮砍价格(&yen;)</th>
			<th class="table-date">时间</th>
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
		foreach($data['list'] as $l) {
			//$su = AccountMod::get_service_user_by_uid($l['su_uid']);
			$html .= '<tr';
			$html .= ' data-id="'.$l['uid'].'">';
			$html .= '
              <td class="cuser" data-id="'.$l['su_uid'].'">'.($l['su']['name']?$l['su']['name']:$l['su']['account']).'</td>
			  <td>'.($l['bu_uid']).'</td>
			  <td>'.($l['bargain_fee']/100).'</td>';

			  $html .='<td>'.date('Y-m-d H:i:s', $l['create_time']).'</td>';

			$html .= '
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs"><button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$l['uid'].
					'"><span class="am-icon-trash-o"></span>删除</button>';
			$html .= '
                  </div>
                </div>
              </td>
            </tr>
			';
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
	$extra_js = $static_path.'/js/help_bargainlist.js';
	//echo '<script>var g_su_uid = '.(!empty($option['su_uid']) ? $option['su_uid'] : 0).';</script>';
?>

