<?php
//必须先选择店铺
if(empty($_SESSION['has_select_shop']) && 
	!in_array($GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'], 
array('index.friends', 'index.gotofriend', 'index.addpublic', 'index.logout', 
'index.addpublic_real','api.add_public', 'api.add_fake_public','api.get_component_url'))) {
	redirectTo('?_a=sp&_u=index.friends');
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
<title>小程序后台管理系统V3</title>
<link rel="stylesheet" href="app/shop/static/modules/css/bootstrap.min.css" />
<link rel="stylesheet" href="spv3/sp/static/css/normalize.css" />
<link rel="stylesheet" href="spv3/sp/static/css/frame.css?2" />
<link rel="stylesheet" href="spv3/sp/static/css/iconfont/iconfont.css">
<link rel="stylesheet" href="spv3/sp/static/css/leftfont/iconfont.css?1">
<script src="/static/js/jquery2.1.min.js"></script>
<link rel="stylesheet" href="/static/css/amazeui2.1.spv3.min.css"/>
<script src="/static/js/amazeui2.1.min.js"></script>
<script>
var path_option = {
	'static':<?php echo(!empty($static_path)? json_encode($static_path):"null")?>,
	'tpl':<?php echo(!empty($tpl_path)? json_encode($tpl_path):"null")?>
};
</script>
<script src="/static_seajs/public_toolkit/seajs/sea.js"></script>
<script src="/static_seajs/public_toolkit/seajs/seajs-css.js"></script>
<script src="/static_seajs/public_toolkit/seajs/seajs-preload.js"></script>
<script src="/static_seajs/js/seajs-option.js"></script>
<script src="/static/js/tip.js"></script>
<script src="/spv3/sp/static/js/frame.js"></script>
</head>
<style>
html,
body {
	height: 100%;
	overflow: hidden;
}
</style>

<body>
<!--页面中部-->
<div class="conter">
	<!--左则导航菜单1-->
	<div class="conter-left float-left">
		<h2>
			<span class="iconfont icon-shouqisanjidaohang16" style="font-size: 14px; color:#788BA1;"></span>
		</h2>
		<div class="conter-left-div">
			<div class="conter-left-logo">
				<a sp_uid="<?php echo AccountMod::get_current_service_provider('uid');?>" href="?_a=sp&_u=index.profile"><img style="height:70px;" src="<?php echo AccountMod::get_current_service_provider('avatar') ? AccountMod::get_current_service_provider('avatar') :  '/spv3/sp/static/images/userpic17.png'?>"></a>
			</div>
<script>
<?php
$_g_menu = array(
	array('name' => '首页', 'icon' => 'icon-shouye', 'link' => '?_a=sp', 'active' => 'sp.index.index',
	),

	array('name' => '流量池', 'icon' => 'icon-zhuanqugengduoliuliang', 'link' => '//y.szwlhd.com/'),

	array('name' => '客服坐席', 'icon' => 'icon-kefu', 'link' => '//i.szwlhd.com/'),

	array('name' => '小程序', 'icon' => 'icon-xiaochengxu1', 'link' => '', 'menus' => array(
		array('name' => '授权发布', 'link' => 'sp.index.xiaochengxu',),
		array('name' => '支付设置', 'link' => 'pay.sp.xiaochengxupay',),
		array('name' => '提现设置', 'link' => 'pay.sp.withdraw',),
	)
	),

	array('name' => '店铺', 'icon' => 'icon-msnui-shop', 'link' => '', 'menus' => array(
		array('name' => '店铺概况', 'link' => 'shop.sp.gaikuang',),
		array('name' => '店铺装修', 'link' => 'shop.sp.visualview',),
		array('name' => '文件管理', 'link' => 'sp.index.imgmanage',),
		array('name' => '全场包邮', 'link' => 'shop.sp.delivery_discount',),
		array('name' => '全场满减', 'link' => 'shopman.sp.index',),
	)
	),

	array('name' => '商品', 'icon' => 'icon-shangpinliebiao1', 'link' => '', 'menus' => array(
		array('name' => '商品管理', 'link' => 'shop.sp.productlist',),
		array('name' => '商品分类', 'link' => 'shop.sp.catlist',),
	)
	),

	array('name' => '订单', 'icon' => 'icon-single', 'link' => '', 'menus' => array(
		array('name' => '所有订单', 'link' => 'shop.sp.orderlist',),
		array('name' => '评价管理', 'link' => 'shop.sp.commentslist',),
		array('name' => '退款维权', 'link' => 'shop.sp.orderlist8',),
	)
	),

	array('name' => '客户', 'icon' => 'icon-kehu', 'link' => '', 'menus' => array(
		array('name' => '客户概况', 'link' => 'su.sp.index',),
		array('name' => '客户管理', 'link' => 'su.sp.fanslist',),
		array('name' => '会员管理', 'link' => 'vipcard.sp.vip_card_list',),
		array('name' => '会员卡', 'link' => 'vipcard.sp.uiset33',),
		array('name' => '会员储值', 'link' => 'su.sp.cashset',),
		array('name' => '积分管理', 'link' => 'su.sp.supointlist',),
	)
	),

	array('name' => '数据', 'icon' => 'icon-shujutu', 'link' => '', 'menus' => array(
		array('name' => '数据概况', 'link' => 'shop.sp.index',),
		array('name' => '商品分析', 'link' => 'shop.sp.visit_record',),
	)
	),

	array('name' => '资产', 'icon' => 'icon-zichan', 'link' => '', 'menus' => array(
		array('name' => '我的资产', 'link' => 'shop.sp.zichan',),
		array('name' => '交易记录', 'link' => 'shop.sp.orderlistjiaoyi',),
		array('name' => '储值资金', 'link' => 'su.sp.sucashlist',),
	)
	),

	'yx' => array('name' => '营销', 'icon' => 'bgfenlei', 'link' => '', 'menus' => array(
		array('name' => '应用市场', 'link' => 'sp.index.pluginstore',),
	)
	),

	array('name' => '设置', 'icon' => 'icon-shezhi1', 'link' => '', 'menus' => array(
		array('name' => '店铺信息', 'link' => 'shop.sp.set',),
		array('name' => '员工管理', 'link' => 'subsp.sp.index',),
		array('name' => '修改密码', 'link' => 'sp.index.password',),
		//array('name' => '操作记录', 'link' => 'subsp.sp.index',),
		/*array('name' => '切换店铺', 'link' => 'sp.index.friends',),*/
		//array('name' => '退出登录', 'link' => 'sp.index.logout',),
	)
	),
);
if(0 == which_agent_provider()) {
	unset($_g_menu[1]);
	unset($_g_menu[2]);
}

$_plugs = array('templatexcxmsg', 'form', 'shopcoupon', 'shoptuan', 'bargain', 'shopsec', 'reward', 'qrposter', 'qrxcx', 'shopman', 'shopdist', 'usign', 'store', 'vote', 'site', 'book', 'shopbiz','yayi','sharecode', 'auction', 'kefu');
if($GLOBALS['_UCT']['ACT'] == 'pluginstore' || in_array($GLOBALS['_UCT']['APP'], $_plugs)) {
	if(in_array($GLOBALS['_UCT']['APP'], $_plugs) && 
		($_dir = WeixinplugMod::get_plugin_by_dir($GLOBALS['_UCT']['APP'])) &&
		!empty($_dir['spv3_menu'])) {
		array_unshift($_dir['spv3_menu'], array('name' => '<b style="color:#F37B1D;">应用商店</b>', 'link' => 'sp.index.pluginstore'));
		$_g_menu['yx']['menus'] = $_dir['spv3_menu'];
		#$_g_menu[$GLOBALS['_UCT']['APP']]['menus'] = $_dir['spv3_menu'];
		#$_g_menu[$GLOBALS['_UCT']['APP']]['name'] = $_dir['name'];
	} else {
		$_ps = WeixinplugMod::get_weixin_public_plugins_all();
		if($_ps) 
		foreach($_ps as $_p) {
			if(in_array($_p['dir'], $_plugs)) {
			$_g_menu['yx']['menus'][] = array('name' => '<b style="color:#F37B1D;">'.$_p['name'].'</b>', 'link' => $_p['dir'].'.sp.index');
			}
		}
	}
}

#var_export($_ps);die;


$_url= $GLOBALS['_UCT']['APP'].'.'.$GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'];
echo 'var _g_menu = '.json_encode($_g_menu).';';
echo 'var _g_url = '.json_encode($_url).';';
?>;
</script>

<?php
$_html = '<ul class="conter-left-div-nav">';
foreach($_g_menu as $k => $g) {
	$_on = '';
	if(!empty($g['active']) && ($g['active'] == $_url)) {
		$_on = 'on';
	} else {
	if(!empty($g['menus']))
	foreach($g['menus'] as $gg) {
		if($gg['link'] == $_url) {
			$_on = 'on';continue;
		}
	}
	}
	if(empty($g['link']) && !empty($g['menus'][0]['link'])) 
		$g['link'] = '?_easy='.$g['menus'][0]['link']; 
	$_link = !empty($g['link']) ? 'href="'.$g['link'].'"' : '';
	$_html .= '<li class="inye '.$_on.'" data-key="'.$k.'">
					<a '.$_link.'>
						<span class="iconfont '.$g['icon'].'"></span>
						<!--  左边导航栏 营销按钮添加醒目标记 CSP 2018/06/06 -->
						<samp>'.$g['name'].'</samp>
						'.($g['name']==='营销'?'<span style="padding: 2px 3px;background-color: red;color: #ffffff;margin-left:5px;border-radius: 3px;">Hot</span>':'').'
					</a>
				</li>';
}
$_html .= '</ul>';
echo $_html;

$_p_uid = AccountMod::get_current_service_provider('parent_uid');
if(!$_p_uid) $_p_uid = 31;
uct_use_app('sp');
$_p = SpMod::get_sp_profile($_p_uid);
if($_p['uid'] == 1064) {
	$_p['phone'] = '18938656256';
	$_p['qq'] = '';
}
?>
		
		<ul class="conter-left-div-nav conter-leftdowm-div-nav">
			<!--<li style="<?php if($_p_uid == 1072) echo 'display:none;';?>">-->
				<!--<a href="http://i.szwlhd.com">-->
						<!--<span class="iconfont bgfenlei"></span>-->
						<!--<samp>客服坐席</samp>-->
				<!--</a>-->
			<!--</li>-->
			<li>
				<a href="?_easy=sp.index.friends">
						<span class="iconfont icon-qiehuan-"></span>
						<samp>切换店铺</samp>
				</a>
			</li>
			<li>
				<a id="id_logout">
						<span class="iconfont icon-tuichu5"></span>
						<samp>退出系统</samp>
				</a>
			</li>
		</ul>
		</div>
		<div style="height:50px;"></div>
	</div>
	<!--/左则导航菜单1-->


	<!--右则-->
	<div class="conter-rigfyos" style="z-index:1">

		<!--展开收起-->
		<div class="kzlst2 zy-zk2">
			<span class="iconfont icon-zhankaisanjidaohang16"></span>
		</div>
		<!--/展开收起-->
		<div class="conter-rigfyos-hearder public-hearder">
			<i class="am-icon-question-circle"></i>帮助和服务
		</div>
		<div class="help-container-body" style="<?php if($_p_uid == 1072) echo 'display:none;';?>">
							<div class="help-body-title" style="margin-left: 10px;">
								帮助中心
								<a href="?_a=web&_u=index.problemlist" class="pull-right">
									进入
								<i class="app-help-icon app-help-icon-more"></i></a>
							</div>
							<div class="help-body-content">
								<div class="help-body-text">
									<p><span style="color: #000000;">微信小程序搭建实施流程</span><br><span style="color: #808080;">微信推广、微博推广、线下推广等方式引导买家进入店铺 。</span>
										<a href="?_a=web&_u=index.problem&uid=38">详情<br></a>
									</p>
									<p><span style="color: #000000;">商城中影响价格因素</span><br><span style="color: #808080;"> 商城中影响价格因素。</span>
										<a href="?_a=web&_u=index.problem&uid=301">详情<br></a>
									</p>
									<hr>
									<p>
										<a href="?_a=web&_u=index.problem&uid=300">小程序的八大赚钱模式</a>
									</p>
								</div>
							<div>
								<div class="help-body-split-line"></div>
								<div class="help-body-title">服务窗口</div>
								<div class="help-body-service">
									<!-- 客服头像 -->
									<a class="service-region panama-entrance" href="javascript:;"><i class="service-avatar" style="background-image: url(<?php echo $_p['avatar'] ? $_p['avatar'] :  '/spv3/sp/static/images/userpic17.png'?>);"></i>
										<h4 class="service-name mt0"><?php echo $_p['fullname'];?></h4>
										<p class="service-name-title mt0">客户经理</p>
									</a>
									<a class="customer-contact-block" target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=<?php echo $_p['qq'];?>&site=qq&menu=yes">
										<div class="panama-customer-block"><span class="panama-customer-button"><span class="panama-customer-inner">在线客服<i class="unread"></i></span></span>
										</div>
										<div class="service-hotline">电话客服：<?php echo $_p['phone'];?></div>
									</a>
								</div>
							</div>
							<div class="help-body-split-line"></div>
							<div class="help-body-title">
								找服务
								<a href="###" class="pull-right">
									发布服务需求
									<i class="app-help-icon app-help-icon-more"></i></a>
							</div>
						</div>
					</div>

		<!-- <div class="conter-weklaj">
			<div class="conter-toslre">
				<h5>
					<span class="iconfont">&#xe60f;</span>
					<samp><?php echo $_p['fullname'];?></samp>
				</h5>
				<div class="conter-zxkfu">
					<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=<?php echo $_p['qq'];?>&site=qq&menu=yes">
						<span class="iconfont">&#xe60f;</span>
						<samp>在线客服</samp>
					</a>
				</div>
				<div class="conter-dhkfu"> 电话客服：<span style="font-weight:bold;"><?php echo $_p['phone'];?></span> </div>
			</div>
			<div class="conter-rigfyos-moksl">
				<h5>
					<span class="iconfont">&#xe60f;</span>
					<samp>产品运营</samp>
				</h5>
				<ul>
					<li>
						<a href="?_a=web&_u=index.problem&uid=300">
							<span>[收藏]</span> 小程序的八大赚钱模式</a>
					</li>
				</ul>
			</div>
			<div class="conter-rigfyos-moksl">
				<h5>
					<span class="iconfont">&#xe60f;</span>
					<samp>功能更新</samp>
				</h5>
				<ul>
					<li>
						<a href="javascript:;"
							<span>[收藏]</span> 小程序后台系统V3即将发布！</a>
					</li>
				</ul>
			</div>
			<div class="conter-rigfyos-moksl">
				<h5>
					<span class="iconfont">&#xe60f;</span>
					<samp>帮助中心</samp>
				</h5>
				<ul>
					<li>
						<a href="?_a=web&_u=index.problem&uid=38">
							<span>[收藏]</span> 微信小程序搭建实施流程</a>
					</li>
					<li>
						<a href="?_a=web&_u=index.problem&uid=301">
							<span>[收藏]</span> 商城中影响价格因素</a>
					</li>
				</ul>
			</div>
		</div> -->
	</div>
	<!--/右则-->
	
	
<?php
//$v = include 'app/sp/tpl/macro_all_tpl_vars.tpl';var_export($v);die;
if(!empty($view_path)) {
	$_file = (is_array($view_path) ? array_pop($view_path) : $view_path);
	if(file_exists($_file)) {
		if(count($view_path) == 0) {
		echo '<div class="conter-right zhicwl-hxgaolr">';
		include($_file);
		echo '</div>';
		} else {
		include($_file);
		}
	}
	else {
		echo 'warning! tpl file not found!! '.substr($_file, strlen(UCT_PATH));
	}
}
if(!empty($extra_js)) {
	if(!is_array($extra_js)) {
		$extra_js = array($extra_js);
	}
	foreach($extra_js as $j) {
		if(!empty($GLOBALS['_UCT']['TPL']) && !file_exists(UCT_PATH.$j)) {
			$j = str_replace(DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'view' . DS . $GLOBALS['_UCT']['TPL'] . DS . 'static',
							DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'static', $j);				
		}
		echo '<script src="'.$j.'"></script>';
	}
}
?>

	
</div>
<!--/页面中部-->

<script>
function switch_menu(key) {
	var menu = _g_menu[key];
	console.log('switch', key, menu, $('#id_conter_left2'));
	if(!menu || !menu.menus || !menu.menus.length) {
		$('.conter-left2').hide();
	} else {
		var html = '<div class="public-hearder am-text-center conter-left2-hearder">' +
				menu.name + '</div><div class="conter-left2-div">';
		for(var i=0;i<menu.menus.length;i++) {
		html += '<ul class="' + (menu.menus[i].link == _g_url ? 'on' : '')+ '">' +
				'<h3><a href="?_easy='+menu.menus[i].link +
				'"><span class="iconfont"></span><samp>' +
				menu.menus[i].name + '</samp></a></h3></ul>';
		}
		html += '</div>';
		$('#id_conter_left2').html(html);
		$('.conter-left2').show();
	}

	if(typeof update_where_am_i == 'function') update_where_am_i();
}
$('.conter-left').on('mouseenter2,click', '.inye', function(){
	var key = $(this).attr('data-key');
	switch_menu(key);
});

//
console.log('switch ...');
$(function(){
switch_menu($('.conter-left .on:first').attr('data-key') || '<?php echo $GLOBALS['_UCT']['APP'];?>');
});

</script>
<!-- 模态窗  CSP  2018/06/14 -->
<div style="display:none;" class="modal fade" id="addKinsfolk" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加家庭组成员</h4>
      </div>
      <div class="modal-body">
        <div class="row">
				<div class="col-xs-2  form-group">
					<label>姓名</label>
				</div>
				<div class="col-xs-1  form-group">
					<input type="text" class="form-control" placeholder="" style="width:170px;"></input>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2 form-group">
					<label>手机号</label>
				</div>
				<div class="col-xs-1 form-group">
					<input type="number" class="form-control" placeholder="" style="width:170px;"></input>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2 form-group">
					<label>会员剩余天数</label>
				</div>
				<div class="col-xs-1 form-group">
					<input type="number" class="form-control" placeholder="" style="width:170px;"></input>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2 form-group">
					<label>客户来源</label>
				</div>
				<div class="col-xs-1 form-group">
					<input type="text" class="form-control" placeholder="" style="width:170px;"></input>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2 form-group">
					<label>客户身份</label>
				</div>
				<div class="col-xs-1 form-group">
					<select class="form-control" style="width:170px;">
                        <option>VIP会员</option>
                        <option>非会员</option>
                    </select>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2 form-group">
					<label>与该会员关系</label>
				</div>
				<div class="col-xs-1 form-group">
					<select class="form-control" style="width:170px;">
                        <option>夫妻</option>
                        <option>兄弟/姐妹</option>
                        <option>子女</option>
                    </select>
				</div>
			</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary">确定</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
