<!DOCTYPE html>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <script>
        window.scale=1;
        if (window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
            //scale = 0.5;
        }
        var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale +', minimum-scale=' + scale + ', user-scalable=no" />';
        document.write(text);
    </script>
    <title>我要推广</title>
    <link rel="stylesheet" href="/static/css/weui0.42.css" />
    <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/index.css" />
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/share.css?v=2017-5-22.1" />
</head>
<script>
    if(window.scale==0.5){document.write('<body class="zh_CN ratio2 ">');}
    else{document.write('<body class="zh_CN ">');}
</script>
<div class="wx_page" >
    <div class="shop_module_item shop_module_banner js_shopModuleWrapper"data-moduletype="banner"name="banner">
        <strong class="shop_banner_title"id="js_title"><?php
            echo  !empty($referee_su_pro['realname'])?$referee_su_pro['realname']:$referee_su['name'];
            ?></strong>
        <span class="shop_banner_title shop_banner_src">我为<?php echo empty($fullname)?"他":$fullname;?>代言</span>
        <span class="banner_logo"><img src="<?php echo $referee_su['avatar'] ? $referee_su['avatar'] : '/static/images/null_avatar.png'; ?>"alt=""id="js_logo"></span>
        <!--    <span class="banner_bg"><img src="--><?php //echo $static_path;?><!--/image/banner.jpg" class="banner_pic" id="js_banner"></span>-->
        <span class="banner_bg">
            <span class="circle">
            </span>
        </span>
    </div>

    <div class="sm-txt">
        <div class="sm-hr sm-hr">
            <span><?php  echo ($su_uid==$referee_su['uid'])?"长按图片分享给朋友":'为你推荐';  ?></span>
        </div>
<!--            <span class="sm-hr sm-hr-lift"></span>-->
<!--            <span class="sm-hr sm-hr-right"></span>-->
    </div>
    <div style="<?php if($su_uid==$referee_su['uid']) echo 'display: none'?>" >
        <div class="product-box goods_list" style="overflow-y: auto;">
            <div class="product-pic"> <a href="?_a=qrposter&_u=index.productdetail&uid=<?php echo $product['uid']?>">
                    <img class="cover" src="<?php echo $product['main_img']?>">
                </a>
            </div>
            <div class="product-info">
                <h4 class="product-title"><?php echo $product['title']?></h4>
                <span class="product-price"><?php $product['point_price'] && printf('积分：%d ',$product['point_price'])
                    ?><?php ($product['point_price'] && $product['price']) && printf('%s','＋')
                    ?><?php $product['price'] && printf('￥%.2f ',$product['price']/100) ?></span>
                <span class="product-buy"><button class="weui_btn weui_btn_primary weui_btn_mini duihuan" data-uid="<?php echo $product['uid']?>">去购买</button></span>
            </div>

        </div>
        <div class="explain-box">
            <span class="explain-title"><i class="fa fa-question-circle-o"></i> 项目说明：</span>
            <div class="explain-src">
<!--                <div>-->
<!--                   <p> 1、全年不限次特定项目面部护理；</p>-->
<!--                   <p> 2、无限次介绍朋友享受3次面部护理项目；</p>-->
<!--                   <p> 3、送价值4980元家居套；</p>-->
<!--                   <p> 4、送医美卡1张（玻尿酸，去皱）；</p>-->
<!--                   <p> 5、送光电项目卡1张（小气泡，水光、超声刀、眼袋、私密、溶脂）；</p>-->
<!--                    <p>6、美牙体验疗程（清洁、美白、养护）；</p>-->
<!--                    <p>7、特色体验疗程1次；</p>-->
<!--                   <p> 8、半永久免费体验1次；</p>-->
<!--                   <p> 9、两癌筛查（女：乳腺、宫颈）（男：生殖、肺）；。</p>-->
<!--                </div>-->
                <div><?php echo !empty($product['share']['explain'])? XssHtml::clean_xss($product['share']['explain']):(!empty($prodcut_share['explain'])? XssHtml::clean_xss($prodcut_share['explain']):'');?></div>
            </div>
            <span class="explain-title"><i class="fa fa-question-circle-o"></i> 积分规则：</span>
            <div class="explain-src">
<!--                <div>-->
<!--                    <p> 1、推荐1个朋友成为创始会员可立即获得1000积分；</p>-->
<!--                    <p> 2、推荐2人成为创始会员可立即兑现2000元“创始红包”并成为“私董会员”；</p>-->
<!--                    <p>3、推荐2人成为私董会员开始享受150元/人的“私董分红”</p>-->
<!--                </div>-->
                <div><?php echo !empty($product['share']['jfrule'])? XssHtml::clean_xss($product['share']['jfrule']):(!empty($prodcut_share['jfrule'])? XssHtml::clean_xss($prodcut_share['jfrule']):'');?></div>
            </div>
        </div>
    </div>
    <div class="share_pic" style="<?php if($su_uid!=$referee_su['uid']) echo 'display: none'?>">
        <img class="share_pic_src" src="">
    </div>

    <div class="to_share-btn">

      <button style="<?php if($su_uid==$referee_su['uid']) echo 'display: none'?>" class="weui_btn weui_btn_primary to_share">我要分享</button>
    </div>
    <div class="home-btn">
        <a href="/?_a=qrposter"> <i class="fa fa-home "></i></a>
    </div>

</div>
<canvas id="myCanvas"  style="display: none">
</canvas>
<?php include(UCT_PATH."/app/qrposter/view/v2/tpl/buy.tpl"); ?>
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="<?php echo $static_path;?>/js/index.js?v=2017-01-21"></script>
<script>
    var is_had_binding  = <?php echo empty($is_had_binding)?'false':true;?>;
    var point_remain  = <?php echo $point['point_remain'];?>;
    var referee  = <?php echo $point['point_remain'];?>;
    var g_goods  = <?php echo '{"'.$product['uid'].'":'.json_encode($product).'}';?>;
    var referee  = <?php echo $referee_su['uid'];?>;
    var su_uid  = <?php echo $su_uid;?>;
    var is_ratio_law  = <?php echo empty($is_ratio_law)?'false':$is_ratio_law[1]/$is_ratio_law[0];?>;
    var product_share  = <?php echo json_encode($prodcut_share);?>;
    var share_product_url = "<?php echo '/?_a=web&_u=index.qrcode&url='.urlencode(DomainMod::get_app_url('qrposter',AccountMod::require_sp_uid(),'&_u=index.share&puid='.$product['uid'].'&referee='.$su_uid));?>"
    //    cxt.fillStyle="#FF0000";
    //    cxt.fillRect(0,0,150,75);
    $('.to_share').on('click',function () {
        if(!is_had_binding)
        {
            alert('您还未非注册会员，请注册后再分享')
        }
        window.location.href="<?php
        echo empty($is_had_binding)?'?_a=aitaimei&_u=index.register&goto='.
            urlencode(DomainMod::get_app_url('qrposter',AccountMod::require_sp_uid(),'&_u=index.share&puid='.$product['uid'].'&referee='.$su_uid))
            :'?_a=qrposter&_u=index.share&puid='.$product['uid'].'&referee='.$su_uid?>"

    })
    if(su_uid==referee)
    {
        if(product_share!={}){
            product_share.photo_info = {}
            product_share.photo_info.img_url= '<?php echo $static_path;?>/image/a.jpg'
            product_share.photo_info.qrcode = {"x":"79","y":"902","w":"238","h":"245"}
        }
        var photo_info =product_share.photo_info;
        var imglist=[]
        imglist.push(photo_info.img_url);
        imglist.push(share_product_url);
        share_pic(imglist)
    }
    function share_pic(img_list) {
        var c=$('#myCanvas').get(0);
        var ctx=c.getContext("2d");
        load_img(img_list,draw)
        function load_img(imglist,call_back) {
            var tmp_cnt = 0;
            var tmp_arr = [];
            for(var i =0;i<imglist.length;i++){
                tmp_cnt++
                var img = new Image()
                img.onload = function(){
                    tmp_cnt--
                    if(tmp_cnt==0){
                        call_back(tmp_arr)
                    }
                };
                img.src=imglist[i]
                tmp_arr.push(img)
            }
        }
        function draw(tmp_arr) {
            $('#myCanvas').attr('height',tmp_arr[0].height)
            $('#myCanvas').attr('width',tmp_arr[0].width)
            ctx.drawImage(tmp_arr[0],0,0);
            ctx.drawImage(tmp_arr[1],photo_info.qrcode.x, photo_info.qrcode.y, photo_info.qrcode.w, photo_info.qrcode.h); //裁剪图片


            $('.share_pic_src').attr('src',c.toDataURL("image/jpeg", 0.85));
        }
    }

</script>

</body>
</html>
