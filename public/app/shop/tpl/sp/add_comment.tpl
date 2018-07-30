
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/static/css/select_user.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addcomment.css"/>


<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">添加评论</strong>
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品uid
        </div>
        <div class="am-u-sm-8 am-u-end">
            <a id="product_uid" data-uid="<?php echo $comment['product_uid'] ?>"><?php echo $comment['product_uid'] ?></a>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top" >
        <div class="am-u-sm-2 am-text-right">
            用户
        </div>
        <div class="am-u-sm-8 am-u-end extra-content">
            <div id="id_user" data-uid="<?php if(!empty($car['su_uid']))echo $car['su_uid'];?>">
                <?php
                $img = '/static/images/null_avatar.png';
                $name = '';
                if(!empty($car['su_uid'])) {
                $su = AccountMod::get_service_user_by_uid($car['su_uid']);
                if($su['avatar'])$img = $su['avatar'];
                $name = $su['name'] ? $su['name'] : $su['account'];
                }
                ?>
                <img style="width:64px;height:64px;" src="<?php echo $img;?>"> <span><?php echo $name;?></span>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            评论图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary" data-addr="#more-img-src" data-func="moreImg">从图片库选择</button>
            <input id="more-img-src" type="hidden"/>
            <div id="more-img-box" style="margin: 10px 0;overflow: hidden">
                <?php
                if(!empty($car['images'])){
                    foreach($car['images'] as $img){
                        echo'<div class="more-img-content"><img class="more-img" src="'.$img.'"/><span class="am-icon-trash del-img"></span></div>';
            }
            }
            ?>
        </div>
    </div>
</div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        评论：
    </div>
    <div class="am-u-sm-8 am-u-end">
        <textarea id="id_brief"></textarea>
    </div>
</div>

<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
    <div class="am-u-sm-2 am-text-right">
        &nbsp;
    </div>
    <div class="am-u-sm-8 am-u-end" data-id="" id="documentUid">
        <button class="am-btn am-btn-secondary"  id="saveDocument">保存</button>
    </div>
</div>
</div>


<?php

    $extra_js = array(

        '/static/js/select_user.js',
        '/static/js/select2/js/select2.min.js',
        '/static/js/catlist_yhc.js',
        '/app/shop/static/js/addcomment.js'
        );

?>
<script>
    seajs.use(['selectPic']);
</script>