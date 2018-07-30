<?php
$sql = 'select uid, account, name, avatar from service_provider where uid = '.AccountMod::get_current_service_provider('uid');
if(($friend_uid = AccountMod::get_current_service_provider('friend_uid'))) { 
	$sql .= ' || friend_uid = '.$friend_uid;
}

$fs = Dba::readAllAssoc($sql);
?>

<link rel="stylesheet" type="text/css" href="/spv3/sp/static/css/friends.css" />
<div class="hearder clearfix">
					<div class="logo fl">
						<img src="" style="display:none;" />
					</div>
					<p class="fl hearder-title">创建小程序</p>
					<a href="?_a=sp&_u=index.logout" class="fr">退出</a>
					<p class="fr"><?php echo AccountMod::get_current_service_provider('account');?></p>
				</div>
				<div class="main">
					<div class="main-header">
						<div class="main-header-img">
<?php
if(AccountMod::get_current_service_provider('avatar'))
echo '<img src="'.AccountMod::get_current_service_provider('avatar').'" style=""/>';
?>
							
						</div>
						<div class="main-header-info">
							<p>我的小程序</p>
							<p><?php echo AccountMod::get_current_service_provider('account');?></p>
						</div>
					</div>
					<div class="main-center">
						<div class="main-center-header">
							<p class="fl">我的小程序</p>
							<div class="main-center-search fr">
								<input type="search" name="" id="" value="" placeholder="小程序名称" />
								<button>搜索</button>
							</div>
						</div>
						<div id="xcxlist" class="main-center-section clearfix">
							<div class="main-center-addbox main-center-box">
								<a class="cadd"><img src="/spv3/sp/static/images/plus123.png"></a>
							</div>

<?php
$html = '';
foreach($fs as $f) {
	$html .= '<div class="main-center-box"><figure class="cfriend" data-id="'.$f['uid'].'">';
	if($f['avatar']) $html .= '<img src="'.$f['avatar'].'">';
	else $html .= '<img src="/spv3/sp/static/images/userpic17.png">';

$html .= '<figcaption>'.$f['name'].'('.$f['account'].')</figcaption></figure><div class="main-center-control"><a class="cfriend" data-id="'.$f['uid'].'">管理</a><a style="display:none" data-id="'.$f['uid'].'" class="cdel">删除</a></div></div>';
}
echo $html;
?>

						</div>
					</div>
				</div>
<?php
$extra_js = array(
    '/spv3/sp/static/js/friends.js',
);
?>



