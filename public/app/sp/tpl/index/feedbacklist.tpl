<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">工单列表</strong> / <small>总计 <?php echo $data['count'];?> 个</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
    <a  href="?_a=sp&_u=index.addfeedback" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 提工单</a>
	</div>
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$cats = array(
						array('uid' => 0, 'title' => '待处理'),	
						array('uid' => 1,   'title' => '处理中 '),	
						array('uid' => 2,      'title' => '已处理'),	
					);

					$html = '<option value="-1"';
					if($option['status']==-1) $html .= ' selected ';
					$html .= '>所有工单</option>';
					
					foreach($cats as  $c) {
					$html .= '<option value="'.$c['uid'].'"';
					if($option['status'] == $c['uid']) $html .= ' selected';
					$html .= '>'.$c['title'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除工单</div>
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
			<th class="table-title">工单号</th><th class="table-status">状态</th>
			<th class="table-parent">提交时间</th>
			<th class="table-image">处理时间</th>
			<th class="table-time">内容</th>
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
			if($c['status'] == 1) {
				//$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td>'.$c['uid'].'</td>'.
					'<td>';
			if($c['status'] == 0) {
				$html .= '<a class="cdopay am-btn am-btn-xs am-btn-primary">待处理</a>';
			}
			else if($c['status'] == 1) {
				$html .= '<a class="cstatus am-btn am-btn-xs am-btn-success">处理中</a>';
			}
			else if($c['status'] == 2) {
				$html .= '<a class="cstatus am-btn am-btn-xs am-btn-default">已处理</a>';
			}
			else {
				$html .= $c['status'];
			}
			$html .= '</td>'.
					'<td>'.(date('Y-m-d H:i:s', $c['create_time'])).'</td>'.
					'<td>';
			if($c['process_time']) {
				$html .= date('Y-m-d H:i:s', $c['process_time']);
			}
			else {
				$html .= '-';
			}
			$html .= '</td>'.
					'<td>'.($c['content']).'</td>'.
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';

			if(1 || in_array($c['status'], array(0,2)))
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
	$extra_js = $static_path.'/js/feedbacklist.js';
?>

