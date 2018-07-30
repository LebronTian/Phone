
<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">留言管理</strong> / <small>总计 <?php echo $messages['count'];?> 篇</small></div>
</div>

<style>
	.table-check{min-width:60px;}
</style>
<div class="am-g am-padding">
	<div class="am-u-md-6">
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
	//var_export($messages);
?>

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-name" data-uid="<?php echo $site['sp_uid']?>">用户</th>
			<th class="table-contact">联系方式</th>
			<th class="table-brief">留言内容</th>
			<th class="table-brief">留言时间</th>
			<th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$messages['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($messages['list'] as $m) {
			$html .= '<tr';
			if($m['status']==1) {
				$html .= ' class="am-success "';
			}
			if($m['status']==2) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$m['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>';
		
			if(!empty($m['su_uid'])) {
				$html .= '<a href="?_a=su&_u=sp.fansdetail&uid='.$m['su_uid'].'">'.$m['name'].'</a>';
			}
			else {
				$html .= $m['name'];
			}
			$html .= '</td><td>'.$m['contact'].'</td><td><a href="?_a=site&_u=sp.messagedetail&uid='.$m['uid'].'">'
					.$m['brief'].'</a></td><td>'.date('Y-m-d H:i:s', $m['create_time']).'</td><td>'.'<div class="am-dropdown private_verify" data-am-dropdown>
  <button class="am-btn ';
	if($m['status']==0)
		$html.='am-btn-default';
	if($m['status']==1)
		$html.='am-btn-success';
	if($m['status']==2)
		$html.='am-btn-danger';
	$html.=' am-dropdown-toggle" data-am-dropdown-toggle style="width:40px;height:30px"></button>
  <ul class="am-dropdown-content creview" data-uid="'.$m['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
    <li class="am-btn-success msg_pass" data-id="'.$m['uid'].'" sp="1">通过</li>
    <li class="am-btn-danger msg_unpass" data-id="'.$m['uid'].'" sp="2">拒绝</li>
  </ul>
</div>'.'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$m['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
			if(empty($m['reply']) ) {
			$html .= ' <button class="am-btn am-btn-default am-btn-xs am-text-warning creply" data-id="'.$m['uid'].'"><span class="am-icon-reply"></span> 回复</button>';
			}
			else {
			$html .= ' <button class="am-btn am-btn-default am-btn-xs am-text-success chasreply" data-id="'.$m['uid'].'"><span class="am-icon-reply"></span> 已回复</button>';
			}
		
			$html .= '</div></div></td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<button style="margin-left:20px" class="cdeleteall am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle>批量删除</button>
<button class="passall am-btn am-btn-success all_pass" data-am-dropdown-toggle>批量通过</button>
<button class="unpassall am-btn am-btn-danger all_refuse" data-am-dropdown-toggle>批量拒绝</button>
<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog ">
    <div class="am-modal-hd">回复留言</div>
	<hr/>
	<form class="am-form am-form-horizontal">
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_reply">回复内容</label> 		
			<div class="am-u-sm-9">
				<input id="id_reply" class="am-form-field">
    		</div>
    	</div>
   	 </form>
	
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>


<?php
	$extra_js = $static_path.'/js/messagelist.js';
?>
