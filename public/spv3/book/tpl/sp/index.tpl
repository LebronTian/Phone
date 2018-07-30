<?php
echo '<script>window.location.href="?_easy=book.sp.itemlist"</script>';
return;
?>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">门店预约</strong> / <small></small></div>
</div>


<div class="am-g am-padding">
	<div class="am-u-md-4">
	手机扫一扫,访问 <a target="_blank" href="<?php $url =  DomainMod::get_app_url('book'); echo $url;?>" >
	门店预约</a>
	<br/>
	<?php if(empty($ep['status']))echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url='.urlencode($url).'">'; ?>
	</div>

</div>


<?php
  $extra_js = array(
  );

?> 


