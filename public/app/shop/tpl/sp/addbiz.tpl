<link rel="stylesheet" href="/static/css/select_user.css"/>
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
    #main-img {
         max-width: 200px;
    }
    .am-form input[type=search]{
        display: block;
    }

    .type-add-li {
        width: 64px;
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .type-red-li {
        width: 64px;
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .class_user{
        padding-top: 5px;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id" <?php if(!empty($biz)) echo 'data-id="'.$biz['uid'].'"'; ?>>
        <strong class="am-text-primary am-text-lg">  <?php echo(!empty($biz) ? '编辑' : '添加')?>商家</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商家名称
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="biz_title" minlength="1" <?php if(!empty($biz)) echo 'value="'.$biz['title'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商家账号
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="biz_account" minlength="1" placeholder="请输入修改账号" <?php if(!empty($biz)) echo 'value="'.$biz['account'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商家密码
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="biz_passwd" minlength="1" placeholder="请输入修改密码" value="">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            分类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button style="vertical-align: baseline" class="am-btn am-btn-primary choose-cats" id="biz_type"><?php echo (!empty($biz['type']) ? $biz['type']:"选择分类") ?></button>
            <small>选择分类，可用于本平台商家的分类检索</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            人均消费
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="number" id="biz_percost" placeholder="" <?php if(!empty($biz['per_cost'])) echo 'value="'.(sprintf('%.2f',$biz['per_cost']/100)).'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            浏览数
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="number" id="read_cnt" placeholder="" <?php if(!empty($biz['read_cnt'])) echo 'value="'.$biz['read_cnt'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            评分
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="number" id="biz_score_total" placeholder="" <?php if(!empty($biz['score_total'])) echo 'value="'.$biz['score_total'].'"'; ?>>
            <small>满分100分</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            地址
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="address" placeholder="选填" <?php if(!empty($biz['location'])) echo 'value="'.$biz['location'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            地理位置 经纬度
        </div>
        <div class="am-u-sm-2">
            <input type="text" id="p_lat" placeholder="纬度" <?php if(!empty($biz['lat'])) echo 'value="'.$biz['lat'].'"'; ?>>
        </div>
        <div class="am-u-sm-2  am-u-end">
            <input type="text" id="p_lng" placeholder="经度" <?php if(!empty($biz['lng'])) echo 'value="'.$biz['lng'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top" >
        <div class="am-u-sm-2 am-text-right">
            联系用户
        </div>
        <div class="am-u-sm-8 am-u-end extra-content">
            <div id="biz_user" data-uid="<?php if(!empty($biz['su_uid']))echo $biz['su_uid'];?>">
                <?php
                $img = '/static/images/null_avatar.png';
                $name = '';
                if(!empty($biz['su_uid'])) {
                $su = AccountMod::get_service_user_by_uid($biz['su_uid']);
                if($su['avatar'])$img = $su['avatar'];
                $name = $su['name'] ? $su['name'] : $su['account'];
                }
                ?>
                <img style="width:64px;height:64px;" src="<?php echo $img;?>"> <span><?php echo $name;?></span>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            管理员
        </div>
        <div class="am-u-sm-8 am-u-end extra-content userlist">
            <?php
            if(!empty($biz['admin_uids'])){
            foreach($biz['admin_uids'] as $su_uid){ ?>
            <div class="class_user" data-uid="<?php if(!empty($su_uid))echo $su_uid;?>">
                <?php
    $img = '/static/images/null_avatar.png';
    $name = '';
    if(!empty($su_uid)) {
    $su = AccountMod::get_service_user_by_uid($su_uid);
    if($su['avatar'])$img = $su['avatar'];
    $name = $su['name'] ? $su['name'] : $su['account'];
    }
    ?>
                <img style="width:64px;height:64px;" src="<?php echo $img;?>"> <span><?php echo $name;?></span>
            </div>
            <?php }
             }?>
            <div class="type-add-li"><span class="am-icon-plus"></span></div>
            <div class="type-red-li"><span class="am-icon-minus"></span></div>
        </div>

    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            联系人姓名
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="biz_contact" placeholder="选填" <?php if(!empty($biz['contact'])) echo 'value="'.$biz['contact'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            联系电话
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="biz_phone" placeholder="选填" <?php if(!empty($biz['phone'])) echo 'value="'.$biz['phone'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            店内设施
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select class="biz_info am-modal-prompt-input" multiple style="width:80%;margin-top: 10px">
                <?php
                if(isset($biz['extra_info']['bar_installation'])){
                    foreach($biz['extra_info']['bar_installation'] as $v){
                        echo '<option selected>'.$v.'</option>';
                       }
                  }else{
                       echo '<option selected>wifi</option>
                            <option selected>微信支付</option>
                            <option selected>支付宝支付</option>
                            <option selected>停车位</option>';
                  }
                ?>
            </select>
            <br/><small style="text-align: left">店内设施，例如：微信支付。输入一个后按回车键标识。</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            营业时间
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="business_time" placeholder="选填" <?php if(isset($biz['extra_info']['business_time'])) echo 'value="'.$biz['extra_info']['business_time'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            排序
        </div>
        <div class="am-u-sm-8 am-u-end" style="width: 120px">
            <input type="number" id="biz_sort" placeholder="选填" <?php if(!empty($biz)) echo 'value="'.$biz['sort'].'"'; ?>>
            <small style="white-space: nowrap">填正整数，从大到小排序</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            商家主图/LOGO
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary buttonImg1" data-addr="#main-img-src" data-func="mainImg">从图片库选择</button>
            <input id="main-img-src" type="hidden" <?php if(!empty($biz)) echo'src="'.$biz['main_img'].'"'; ?>/>
            <div id="main-img-box" style="margin: 10px 0">
                <?php if(!empty($biz)) echo'<img id="main-img" src="'.$biz['main_img'].'"/> '; ?>
            </div>
            <small>建议大小100*100</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            更多图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary" data-addr="#more-img-src" data-func="moreImg">从图片库选择</button>
            <input id="more-img-src" type="hidden"/>
            <div id="more-img-box" style="margin: 10px 0;overflow: hidden">
                <?php
                if(!empty($biz['images'])){
                    foreach($biz['images'] as $img){
                        echo'<div class="more-img-content"><img class="more-img" src="'.$img.'"/><span class="am-icon-trash del-img"></span></div>';
            }
            }
            ?>
        </div><small>建议大小750*450</small>

    </div>
</div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            店铺简介
        </div>
        <div class="am-u-sm-8 am-u-end">
            <script id="biz-content" name="content" type="text/plain" style="height:250px">
            </script>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            是否加V
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label style="margin-top: 0.2em;padding-top: 0em" class="am-checkbox">
                <input <?php if(!empty($biz)&&($biz['hadv'])) echo "checked" ?>  id="biz-addv" type="checkbox"  data-am-ucheck> 是
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            是否加推荐
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label style="margin-top: 0.2em;padding-top: 0em" class="am-checkbox">
                <input <?php if(!empty($biz)&&($biz['hadrecommend'])) echo "checked" ?>  id="biz-addrecommend" type="checkbox"  data-am-ucheck> 是
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end" >
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="1" data-am-ucheck>
                审核通过
            </label>
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="2" data-am-ucheck>
				审核不通过
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveBiz">保存</button>
        </div>
    </div>
</div>

<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <select class="catList-yhc"></select>
            </div>
        </div>
    </div>
</div>

<?php

    echo '
    <script>
    var edit_biz = '.json_encode($biz).' ;
    var catsAll = '.(!empty($parents) ? json_encode($parents):'[]').';
    </script>';

    $extra_js = array(
        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',
            '/static/js/select_user.js',
        '/static/js/select2/js/select2.min.js',
        '/static/js/catlist_yhc.js',

        'http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ',
        '/static/js/baidumap/SearchInfoWindow_min.js',
        '/static/js/choose_address.js',
        '/static/js/geo.js',

        $static_path.'/js/addbiz.js',
        $static_path.'/js/bizcatsSelect.js',
        );
?>
<script>
    seajs.use(['selectPic']);
</script>
