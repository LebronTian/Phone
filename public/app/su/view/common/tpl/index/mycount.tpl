<?php
uct_use_app('su');
$su_uid = SuMod::require_su_uid();
$option['su_uid'] = $su_uid;
$option = array(
    'su_uid' => $su_uid,
    'page' => requestInt('page',0),
    'type' => requestInt('type',0), //类型, 1 提现或消费减余额, 2 收入增加余额
    'limit' => 10
);
$point_info = SuPointMod::get_user_points_by_su_uid($su_uid);
$cash_list = SuPointMod::get_user_cash_list($option);

$pagination = uct_pagination($option['page'], ceil($cash_list['count']/$option['limit']),
    '?_easy=vipcard.single.index.cash&limit='.$option['limit'].'&page=');
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>充值</title>
	<link rel="stylesheet" type="text/css" href="/static/css/loading.css?v=1.5">
	<link rel="stylesheet" href="/app/express/view/v1/static/css/noticedetail.css?v=0.2">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/mycount.css">
</head>
<style>
    .margin-top-section{margin-top: 1.5rem;}
    .addaddress-article .linear-input{padding: 1.2rem;padding-left: 7rem}
    .linear-select{
        appearance: button;
        -webkit-appearance: button;
        -moz-appearance:button;
    }
    .select-section .linear-right img{
        transform: rotate(90deg);
        -ms-transform: rotate(90deg);       /* IE 9 */
        -webkit-transform: rotate(90deg);   /* Safari and Chrome */
        -o-transform: rotate(90deg);        /* Opera */
        -moz-transform: rotate(90deg);      /* Firefox */
    }   
 </style>
<header class="color-main vertical-box">
    <span class="header-title">我的账户</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="/static/images/back.png" onclick="window.location.href='?_a=shop&_u=user.index'">
    </div>
</header>
<article class="mycount-countainer">
    <div class="price-container vertical-box">
    <p class="vertical-middle">余额（元）<br/><span class="text-xl"><?php if(!empty($point_info['cash_remain'])) echo $point_info['cash_remain']/100 ?></span></p>
    </div>
    <div class="account-operate btn-container">
    <button class="btn-long text-l" onclick="window.location.href='?_easy=su.common.index.recharge'">充值</button>
    <button class="btn-long text-l" style="background:#4bbce6;" onclick="window.location.href='?_easy=su.common.index.withdraw'">提现</button>
    <div class="cut-of-line-container">
        <div class="cut-of-line border-disable text-disable" style="background: #888888;">
            <div class="cut-of-container">
                <span class="cut-of-title">
                    <span>余额明细</span>
                </span>
            </div>
        </div>
    </div>
    <section>
    <?php
    if(!empty($cash_list['list'])){
            foreach($cash_list['list'] as $p){
                ?>
		        <div class="line">
		            <div class="line-left">
		                <p><?php if(!empty($p['info'])) echo $p['info'] ?></p>
		                <p><?php echo(!empty($p['create_time'])? date('Y-m-d H:i:s',$p['create_time']):'未知') ?></p>
		            </div>
		            <div class="line-right c-green"><?php echo(($p['type']=='2')?'+':'-') ?><?php if(!empty($p['cash'])) echo ($p['cash']/100) ?>元</div>
		        </div>
        <?php
    }}
    else{
        ?>
        <p>没有余额记录  ╮(￣▽￣")╭</p>
        <?php
    }
    ?>
    </section>
</article>
</body>
</html>