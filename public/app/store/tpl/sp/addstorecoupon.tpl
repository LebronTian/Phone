<head>
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
    <style type="text/css">
        .reward-limit-box .am-ucheck-icons{
            top:10px;
        }
        .reward-limit-box label{
            height: 46px;
            line-height: 41px;
        }
        .reward-limit-box input[type='number']{
            display: inline-block;
            width: 8em;
            text-align: center;
        }

    </style>
</head>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($coupon['uid']) ? '编辑优惠劵' : '添加优惠劵')?></strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            优惠劵名称
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="id_title" <?php if(!empty($coupon['title'])) echo 'value="'.$coupon['title'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            发放数目
        </div>
        <div class="am-u-sm-4">
            <input type="text" id="id_publish_cnt" <?php echo 'value="'.(empty($coupon['publish_cnt']) ? 0 : $coupon['publish_cnt']).'"';?>>
        </div>
        <div class="am-u-sm-4 am-u-end">
            <small>0表示一张也不发放</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            有效期
        </div>
        <div class="am-u-sm-8 am-u-end">

            <?php
            $html = '<select data-am-selected="{btnWidth: 150, btnSize: \'lg\' }" class="option_duration">';
            $vs = array(
                array('uid' => 0, 'title' => '永久有效',),
                array('uid' => 86400, 'title' => '一天内有效',),
                array('uid' => 86400*7, 'title' => '一周内有效',),
                array('uid' => 86400*30, 'title' => '一月内有效',),
            );
            if(empty($coupon['duration'])) $coupon['duration'] = 0;
            $vs[] = array('uid' => ($coupon['duration'] > 86400*30 ? $coupon['duration'] : strtotime('+2 month')), 'title' => '指定日期前有效');

            foreach($vs as $p) {
				$tmp = end($vs);
				$tmp = $tmp['uid'];
                $html .= '<option value="'.$p['uid'].'"';
                if($coupon['duration'] == $p['uid']) $html .= ' selected';
                $html .= '>'.$p['title'].'</option>';
            }
            $html .= '</select>';
            $html .= '<input type="text" class="am-input-lg" style="width:150px;display:inline;margin-left:5px;" value="'
                .date('Y-m-d', $tmp).
                '" data-am-datepicker id="doc-datepicker">';
            echo $html;
            ?>

        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            适用门店
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_store_uids">
                <?php
                array_unshift($stores['list'], array('uid' => 0, 'name' => '不限'));
                $store = !empty($coupon['store_uids'][0]) ? $coupon['store_uids'][0] : 0;
                $html = '';
                foreach($stores['list'] as $p) {
                    $html .= '<option value="'.$p['uid'].'"';
                    if($store == $p['uid']) $html .= ' selected';
                    $html .= '>'.$p['name'].'</option>';
                }
                echo $html;
                ?>
            </select>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            种类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_parent">
                <?php
                $vs = array(
                    array('uid' => 0, 'title' => '代金券'),
                    array('uid' => 1, 'title' => '礼品券'),
                    array('uid' => 2, 'title' => '折扣券'),
                    array('uid' => 3, 'title' => '团购券'),
                );
                if(empty($coupon['valuation'])) $coupon['valuation'] = 0;
                $html = '';
                foreach($vs as $p) {
                    $html .= '<option value="'.$p['uid'].'"';
                    if($coupon['valuation'] == $p['uid']) $html .= ' selected';
                    $html .= '>'.$p['title'].'</option>';
                }
                echo $html;
                ?>
            </select>
        </div>
    </div>

    <!--
      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               优惠金额
               </div>
               <div class="am-u-sm-4 am-u-end">
                 <input type="text" id="id_discount" <?php if(!empty($coupon['rule']['discount']))
        echo 'value="'.($coupon['rule']['discount']/100).'"';?>>
               </div>
      </div>
-->


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            图片
        </div>

        <div class="am-u-sm-9">
            <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                <input type="file" name="file" id="file_upload"/>

            </form> -->
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
            <div>
                <img id="id_img" src="<?php if(!empty($coupon['img'])) echo $coupon['img'];?>"  style="width:100px;height:100px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            领取限制
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group reward-limit-box">
                <p style="margin-bottom: 8px"><span style="margin-right: 10px" class="am-icon-lightbulb-o am-warning am-icon-sm"></span>不选择就代表不限制</p>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($coupon['rule']['max_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt" <?php if(!empty($coupon['rule']['max_cnt'])) echo 'value="'.$coupon['rule']['max_cnt'].'"';else echo 'style="display: none"';?>/>
                    每个用户最多允许领取多少张
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($coupon['rule']['max_cnt_day'])) echo 'checked';?>>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($coupon['rule']['max_cnt_day'])) echo 'value="'.$coupon['rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                    每个用户每天最多允许领取多少张
                </label>

            </div>
        </div>
    </div>




    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            详情
        </div>
        <!--文本编辑/-->

        <div class="am-u-sm-8 am-u-end">
            <script id="container" name="content" type="text/plain" style="height:250px;"><?php if(!empty($coupon['brief'])) echo ''.$coupon['brief'].'';?></script>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
        </div>
    </div>

</div>

<?php
echo '<script>var g_uid = '.(!empty($coupon['uid']) ? $coupon['uid'] : 0).';</script>';
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',
    $static_path.'/js/addstorecoupon.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>
