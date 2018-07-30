<?php
uct_use_app('su');
$su_uid = SuMod::require_su_uid();
$option['su_uid'] = $su_uid;
$option = array(
    'su_uid' => $su_uid,
    'page' => requestInt('page',0),
    'limit' => 10
);
$point_info = SuPointMod::get_user_points_by_su_uid($su_uid);
$point_list = SuPointMod::get_user_point_list($option);

$pagination = uct_pagination($option['page'], ceil($point_list['count']/$option['limit']),
    '?_easy=vipcard.single.index.point&limit='.$option['limit'].'&page=');
?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge">
    <meta name="format-detection" content="telephone=no,email=no,address=no">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta http-equiv="Cache-Control" content="no-siteapp">
    <title>我的积分</title>
    <!--<link rel="shortcut icon" href="<?php /*echo $static_path . '/images/logo.png' */?>" type="image/x-icon">-->
    <link rel="stylesheet" href="/static_seajs/public_toolkit/amazeui/amazeui2.1.min.css">
    <style>
        .point-table{padding-left: 0.7em}
    </style>
</head>
<body>
<div>
    <div class="am-cf am-padding">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">积分记录</strong> / <small>Integral record</small></div>
    </div>
    <?php
    if(!empty($point_list['list'])){
        ?>
        <table class="point-table am-table ">
            <thead>
            <tr>
                <th>积分信息</th>
                <th>时间</th>
                <th>改动</th>
            </tr>
            </thead>
            <tbody>
            <tr class="am-primary">
                <td>现有积分</td>
                <td></td>
                <td><?php if(!empty($point_info['point_remain'])) echo $point_info['point_remain'] ?></td>
            </tr>
            <?php
            foreach($point_list['list'] as $p){
                ?>
                <tr class="am-<?php echo(($p['type']=='2')?'success':'warning') ?>">
                    <td><?php if(!empty($p['info'])) echo $p['info'] ?></td>
                    <td><?php echo(!empty($p['create_time'])? date('Y-m-d H:i:s',$p['create_time']):'未知') ?></td>
                    <td><?php echo(($p['type']=='2')?'+':'-') ?><?php if(!empty($p['point'])) echo $p['point'] ?></td>
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
        <p class="am-text-center">没有积分记录  ╮(￣▽￣")╭</p>
    <?php
    }
    ?>

    <div style="padding-left: 0.7em">
        <?php echo $pagination ?>
    </div>

</div>
<script>
    console.log('?')
</script>
</body>
</html>
