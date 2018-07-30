<style>
.cadd,.cfriend{
cursor:pointer;
}
</style>
<!--面包削导航位置-->
<div class="zhicwl-mib-nav">
	<ul>
		<li><a href="javascript:;">店铺列表</a></li>
	</ul>
</div>
<!--/面包削导航位置-->

<div class="zhicwl-yxclsj">
	<ul>
<?php
if(($friend_uid = AccountMod::get_current_service_provider('friend_uid')) && 
	($fs = Dba::readAllAssoc('select uid, account, name from service_provider where friend_uid = '.
	$friend_uid))) {
	$html = '';
	foreach($fs as $f) {
	if(!$f['name']) $f['name'] = '&nbsp;';
	if(!$f['account']) $f['account'] = '&nbsp;';
	$html .= '
		<li>
			<a class="cfriend" data-id="'.$f['uid'].'">
				<div class="zhicwl-yxclsj-left background-color1"><span class="iconfont">&#xe60f;</span></div>
				<div class="zhicwl-yxclsj-right">
					<h6>'.$f['name'].'</h6>
					<samp>'.$f['account'].'</samp>
				</div>
			</a>
		</li>';
	}
	echo $html;
}
?>

		<li>
			<a class="cadd">
				<div class="zhicwl-yxclsj-left background-color3"><span class="iconfont add"></span></div>
				<div class="zhicwl-yxclsj-right">
					<h6>新增店铺</h6>
					<samp></samp>
				</div>
			</a>
		</li>

	</ul>
</div>
<!--/店铺扩展-->
<?php
$extra_js = array(
    '/spv3/sp/static/js/friends2.js',
);
?>

