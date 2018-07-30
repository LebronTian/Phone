<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
    .padding-left0{padding-left: 0;}
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id" <?php if(!empty($product)) echo 'data-id="'.$product['uid'].'"'; ?>>
        <strong class="am-text-primary am-text-lg">  <?php echo(!empty($product) ? '编辑' : '添加')?>活动</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            活动名称
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="product_title" placeholder="必填" minlength="1" <?php if(!empty($product)) echo 'value="'.$product['title'].'"'; ?>>
        </div>
    </div>



    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            时间
        </div>

        <div class="am-u-sm-8 am-u-end">

            <label class="am-checkbox time-label padding-left0">
                开始时间
                <input class="am-animation-slide-left" style="width: 18em ;" type="datetime-local"
                       id="start_time" value="<?php if(!empty($product['start_time'])){ echo date('Y-m-d',$product['start_time']).'T'.date('h:i:s',$product['start_time']);} ?>">

            </label>

            <label class="am-checkbox time-label padding-left0">
                结束时间
                <input class="am-animation-slide-left" style="width: 18em;" type="datetime-local"
                       id="end_time" value="<?php if(!empty($product['end_time'])){ echo date('Y-m-d',$product['end_time']).'T'.date('h:i:s',$product['end_time']);}?>">

            </label>

        </div>
    </div>


    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            活动商品
        </div>
        <div class="am-u-sm-8 am-u-end extra-content">
           <!-- <button class="am-btn am-btn-secondary am-btn-sm am-icon-plus add-extra-info">&nbsp;添加商品</button> -->
            <input type="text" id="p_uid" placeholder="" minlength="1" <?php if(!empty($product)) echo 'value="'.$product['p_uid'].'"'; ?>>
            <small style="white-space: nowrap">填写商品id,以英文逗号(,)分割</small>
        </div>
    </div>



    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            活动图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary buttonImg1" data-addr="#act-img-src" data-func="mainImg">从图片库选择</button>
            <input id="act-img-src" type="hidden" <?php if(!empty($product)) echo'src="'.$product['act_img'].'"'; ?>/>
            <div id="act-img-box" style="margin: 10px 0">
                <?php if(!empty($product)) echo'<img id="act_img" src="'.$product['act_img'].'"/> '; ?>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            活动类型
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-radio" style="float: left">
                <label>
                    <input type="radio" name="deli-radio" value="0" checked>普通活动
                </label>
            </div>
            <div class="am-radio" style="float: left">
                <label>
                    <input type="radio" name="deli-radio" value="1">促销活动
                </label>
            </div>
        </div>
    </div>

    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            活动详情
        </div>
        <div class="am-u-sm-8 am-u-end">
            <script id="product-content" name="content" type="text/plain" style="height:250px">
            </script>
        </div>
    </div>


    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveProduct">保存</button>
        </div>
    </div>
</div>



<?php

    echo '<script>var g_virtual_info= '.(!empty($product['virtual_info']) ? json_encode($product['virtual_info']) : 'null').';</script>';

    echo '
    <script>
    var edit_product = '.json_encode($product).' ;
    var catsAll = '.(!empty($parents) ? json_encode($parents):'[]').';
    var a_data = "'.$GLOBALS['_UCT']['ACT'].'";
//    var catsAll = [];
    </script>';

    $extra_js = array(


        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',

        '/static/js/select2/js/select2.min.js',
        '/static/js/catlist_yhc.js',

        $static_path.'/js/district-all.js',

        $static_path.'/js/addactivity.js',

        $static_path.'/js/catsSelect.js',


        );
?>
<script>
    seajs.use(['selectPic', 'selectVir']);
</script>
