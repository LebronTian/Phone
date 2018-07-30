<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">留言详情</strong> / <small>  </small></div>
</div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">时间：</div>
    <div class="am-u-sm-8 am-u-end">
        <?php echo  date('Y-m-d H:i:s', $message['create_time']);?>
    </div>
</div>
                
<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">用户：</div>
    <div class="am-u-sm-8 am-u-end">
        <?php echo  $message['su_uid'] ? '<a href="?_a=su&_u=sp.fansdetail&uid='
					.$message['su_uid'].'">'.$message['name'].'</a>' : $message['name']; ?>
    </div>
</div>
                
<?php
if(!empty($message['title'])) {
?>
<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">标题：</div>
    <div class="am-u-sm-8 am-u-end">
        <?php echo  $message['title']; ?>
    </div>
</div>
<?php
}
?>

<?php
if(!empty($message['imgs'])) {
?>
<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">图片：</div>
    <div class="am-u-sm-8 am-u-end">
        <?php 
		if(!is_array($message['imgs'])) $message['imgs'] = array($message['imgs']);
		foreach($message['imgs'] as $img) {
			echo  '<img src="'.$img.'">';
		}
		?>
    </div>
</div>
<?php
}
?>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">内容：</div>
    <div class="am-u-sm-8 am-u-end">
        <?php echo  $message['brief']; ?>
    </div>
</div>
                
<hr>
<div class="am-g am-margin">
<?php
	if(empty($message['reply'][0])) {
		echo '<a class="creply am-btn am-btn-warning" data-id="'.$message['uid'].'">未回复</a>';
	}
	else {
		$r = $message['reply'][0];
		echo '<a class="chasreply am-btn am-btn-success" data-id="'.$message['uid'].'">已回复</a>';
		echo '<p>回复时间： '.date('Y-m-d H:i:s', $r['create_time']).'</p>';
		echo '<p>回复内容： '.$r['brief'].'</p>';
	}
	
	//var_export($message);
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
