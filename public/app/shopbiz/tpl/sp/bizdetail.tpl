<style>
    .am-tabs-d2 .am-tabs-nav li{
        background: white;
        border-bottom: 2px solid #eeeeee;
    }
    .am-tabs-d2 .am-tabs-nav{
        background: white;
    }
    .address-div p{
        margin: 0.3em 0;
    }
    .address-div p:first-child{
        margin-top: 0;
    }
    .head-img{
        width: 5em;
        height: 5em;
        border-radius: 50%;
        margin-left: 0.5em;
    }
    #chef-map{
        width: 100%;
        height: 20em;
    }

.zhicwl-yxclsj-left {
	width:48px;
	height:48px;
	background:white;
}
.zhicwl-yxclsj-left span{
color: #0e90d2;
}
</style>
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo $biz['title'];?></strong> /
		<small>商家详情</small>
		<a href="?_a=shopbiz&_u=sp.bizlist"> [全部商家]</a>
	</div>
</div>
<hr>

<div class="zhicwl-yxclsj">
<ul>
	<li>
		<a href="?_a=shop&_u=sp.productlist&biz_uid=<?php echo $biz['uid'];?>">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $biz['product_number_all']; ?></h6>
			<samp>商品数</samp>
		</div>
		</a>
	</li>
	<li>
		<a href="?_a=shop&_u=sp.orderlist&biz_uid=<?php echo $biz['uid'];?>">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $biz['order_number']; ?></h6>
			<samp>订单数</samp>
		</div>
		</a>
	</li>

	<li>
		<a href="?_a=shopbiz&_u=sp.bizcoupon&biz_uid=<?php echo $biz['uid'];?>">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $biz['coupon_number']; ?></h6>
			<samp>优惠券数</samp>
		</div>
		</a>
	</li>
</ul>
</div>

<div id="id_print_area" class="am-g am-padding" style="padding-top: 0">
    <div data-am-widget="tabs" class="am-tabs am-tabs-d2 my-tab" data-am-tabs-noswipe="1">
        <ul class="am-tabs-nav am-cf">
            <li class="am-active">
                <a href="[data-tab-panel-0]">商家资料</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-1]">管理员信息</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-2]">审核资料</a>
            </li>
        </ul>

<hr>

        <div class="am-tabs-bd">
            <div data-tab-panel-0 class="am-tab-panel am-active">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        入驻商名称：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo $biz['title'].' ('.$biz['type'].')'; ?>
						<img src="<?php echo $biz['main_img']; ?>" style="width:100px;height:100px;">

						<a href="?_a=shopbiz&_u=sp.addbiz&uid=<?php echo $biz['uid'];?>"> [编辑]</a>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        申请入驻时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
[                        <?php echo date("Y年m月d日 H:i:s",$biz['create_time']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        联系人：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo $biz['contact'].' ('.$biz['phone'].')'; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        地址：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo $biz['location']; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        营业状态：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo $biz['is_closed'] ? '暂停营业' : '开业中'; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        审核状态：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
					<?php
			$html ='<div class="am-dropdown am-dropdown-up private_verify" data-am-dropdown>
  <button class="am-btn ';
	if($biz['status']==0) {
		$html.='am-btn-default';
	}
	else if($biz['status']==1) {
		$html.='am-btn-success';
	}
	else  {
		$html.='am-btn-danger';
	}
	$html.=' am-dropdown-toggle" data-am-dropdown-toggle style="width:40px;height:30px"></button>
  <ul id="uidx" class="am-dropdown-content creview" data-uid="'.$biz['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
    <li class="am-btn-default" data-id="'.$biz['uid'].'" sp="0">&nbsp;</li>
    <li class="am-btn-success" data-id="'.$biz['uid'].'" sp="1">通过</li>
    <li class="am-btn-danger" data-id="'.$biz['uid'].'" sp="2">拒绝</li>
  </ul>
</div>';

	echo $html;
					?>
					</div>
				</div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        更多：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
						<table>
						<thead><tr><th></th><th></th></tr></thead>
                        <tbody style="text-align: center">
						<tr><td>评分</td><td><?php echo $biz['score_total'];?></td></tr>
						<tr><td>收藏</td><td><?php echo $biz['fav_cnt'];?></td></tr>
						<tr><td>人气</td><td><?php echo $biz['read_cnt'];?></td></tr>
						<tr><td>人均消费</td><td><?php echo $biz['per_cost']/100;?></td></tr>
						<tr><td>加v</td><td><?php echo $biz['hadv'] ? '<span class="am-icon-checked"></span>' : '-';?></td></tr>
						<tr><td>推荐</td><td><?php echo $biz['hadrecommend'] ? '<span class="am-icon-checked"></span>' : '-';?></td></tr>
						</tbody>
						</table>
                    </div>
                </div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        简介：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo $biz['brief']; ?>
                    </div>
                </div>
              </div>

            <div data-tab-panel-1 class="am-tab-panel ">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right" style="height: 5em;line-height: 5em">
                        管理后台登陆账号：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
						<?php  echo $biz['account']; ?>
						<a href="?_a=shop&_u=admin">  [入驻商后台入口]</a>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right" style="height: 5em;line-height: 5em">
                        申请人：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
<?php
if(!empty($biz['su_uid'])) {
	$su = AccountMod::get_service_user_by_uid($biz['su_uid']);
	echo '<a href="?_a=su&_u=sp.fansdetail&uid='.$su['uid'].'">'.$su['name'].'</a> <img class="head-img" src="'.$su['avatar'].'">';
}
?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right" style="height: 5em;line-height: 5em">
                        更多管理员：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
<?php
if(!empty($biz['admin_uids'])) {
	foreach($biz['admin_uids'] as $uid) {
		if($uid == $biz['su_uid']) continue;
		$su = AccountMod::get_service_user_by_uid($uid);
		echo '<p><a href="?_a=su&_u=sp.fansdetail&uid='.$su['uid'].'">'.$su['name'].'</a> <img class="head-img" src="'.$su['avatar'].'"></p>';
	}
}
?>
                    </div>
                </div>
            </div>

            <div data-tab-panel-2 class="am-tab-panel ">
<?php
$html = '';
if(!empty($biz['extra_info'])) {
foreach($biz['extra_info'] as $k => $v) {
	if($k == 'bar_installation') {
		$k = '店铺设施';
		if(is_array($v)) $v = implode(' ', $v);
	} else if($k == 'business_time') {
		$k = '营业时间';
	} else if($k == 'idcard') {
		$k = '身份证';
	}


	$html .= '<div class="am-g am-margin-top-sm">
<div class="am-u-sm-2 am-text-right" style="height: 5em;line-height: 5em">
'.$k.'</div><div class="am-u-sm-8 am-u-end">'.$v.'</div></div>';
}
}
echo $html;
?>
            </div>
        </div>
    </div>

<script>
$(function(){
	$('.creview li').click(function(){
		var uid=$(this).attr('data-id');
		var status=$(this).attr('sp');
		var data={uid:uid, status:status}
		$.post('?_a=shop&_u=api.addbiz' , data , function(ret){
			var ret = $.parseJSON(ret);
			if(ret.errno==0)
				window.location.reload();
		});
	});
});
</script>

