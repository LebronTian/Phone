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
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge">
    <meta name="format-detection" content="telephone=no,email=no,address=no">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta http-equiv="Cache-Control" content="no-siteapp">
    <title>我的余额</title>
    <!--<link rel="shortcut icon" href="<?php /*echo $static_path . '/images/logo.png' */?>" type="image/x-icon">-->
    <link rel="stylesheet" href="/static_seajs/public_toolkit/amazeui/amazeui2.1.min.css">
    <style>
        .point-table{padding-left: 0.7em}
    </style>
</head>
<body>
<div>
    <div class="am-cf am-padding">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">余额记录</strong> / <small>Account details</small></div>
    </div>
<style type="text/css">
		.money-o{padding-left: 1.6rem;}
		.money-o button{background-color: #0e90d2;color: #fff;border-radius: 4px;margin-right: 1rem;position: relative;top: -.5rem;padding: 0.2rem 0.6rem;outline: none;}
</style>
    <div class="money-o">
    	<button onclick="window.location.href='?_easy=shop.1to1.user.recharge'">我要充值</button>
    	<button onclick="window.location.href='?_a=pay&_u=index.do_withdraw'">我要提现</button>
    </div>
    <?php
    if(!empty($cash_list['list'])){
        ?>
        <table class="point-table am-table ">
            <thead>
            <tr>
                <th>余额信息</th>
                <th>时间</th>
                <th>改动(&yen;)</th>
            </tr>
            </thead>
            <tbody>
            <tr class="am-primary">
                <td>现有余额</td>
                <td></td>
                <td><?php if(!empty($point_info['cash_remain'])) echo $point_info['cash_remain']/100 ?></td>
            </tr>
            <?php
            foreach($cash_list['list'] as $p){
                ?>
                <tr class="am-<?php echo(($p['type']=='2')?'success':'warning') ?>">
                    <td><?php if(!empty($p['info'])) echo $p['info'] ?></td>
                    <td><?php echo(!empty($p['create_time'])? date('Y-m-d H:i:s',$p['create_time']):'未知') ?></td>
                    <td><?php echo(($p['type']=='2')?'+':'-') ?><?php if(!empty($p['cash'])) echo ($p['cash']/100) ?></td>
                </tr>
                <?php
            }
            ?>

            </tbody>
        </table>
        <?php
    }
    else{
        ?>
        <p class="am-text-center">没有余额记录  ╮(￣▽￣")╭</p>
        <?php
    }
    ?>

    <div style="padding-left: 0.7em">
        <?php echo $pagination ?>
    </div>

</div>
<script>

</script>
</body>
</html>
