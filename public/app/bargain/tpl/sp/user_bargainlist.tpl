<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">砍价列表</strong> / <small>总计 <?php echo $data['count'];?> 条记录</small></div>
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
			<th class="table-date">商品标题</th>
			<th class="table-type">当前价格(&yen;)</th>
			<th class="table-date">支持人数</th>
			<th class="table-type">状态</th>
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
			$su = AccountMod::get_service_user_by_uid($l['su_uid']);
			$html .= '<tr';
			$html .= ' data-id="'.$l['uid'].'">';
			$html .= '
              <td class="cuser" data-id="'.$l['su_uid'].'">'.($su['name']?$su['name']:$su['account']).'</td>
			  <td>'.($l['bargain']['title']).'</td>
			  <td>'.($l['current_price']/100).'</td>';
			  $html .= '<td><a href="?_a=bargain&_u=sp.help_bargainlist&bu_uid='.$l['uid'].'">'.$l['support_cnt']
		.($l['support_cnt'] ? ' (点击查看)': '').'</a></td>';
			  $html .= '<td><a data-status="'.$l['status'].'" class="cstatus am-btn am-btn-xs ';
				if($l['status']==2){
					$html .= 'am-btn-success">已完成</a></td>';
				}elseif($l['status']==1){
					$html .= 'am-btn-danger">已结束</a></td>';
				}else{
					$html .= 'am-btn-default">进行中</a></td>';
				}
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
	$extra_js = $static_path.'/js/user_bargainlist.js';
	echo '<script>var g_su_uid = '.(!empty($option['su_uid']) ? $option['su_uid'] : 0).';</script>';
?>

<script>
//$('.cuser').click(function(){
//	var uid = $(this).attr('data-id');
//	window.location.href= '?_a=bargain&_u=sp.user_bargainlist&su_uid='+uid;
//});
</script>
