<?php 
        	$f_cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'], 'status'=>0,'parent_uid'=>0));
        ?>
<?php include $tpl_path.'/header.tpl';	?>
	


<!-- 使用了模块的样式 -->
<link rel="stylesheet" href="<?php echo $static_path;?>/css/style2.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper/swiper.min.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/index2.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/goodlist.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/index-font.css"> 
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/footer-font.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/fonts.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/coupon.css">
<script src="<?php echo $static_path;?>/css/swiper/swiper.min.js"></script>
	<div class="header c-green">
		<span class="header-logo" onclick="location.href='?_a=shop'">
			<img src="<?php if(!empty($shop['logo'])) echo $shop['logo'] ?>"/>
		</span>
		<span class="header-title" disabled="disabled"><?php if(!empty($shop['title'])) echo $shop['title'] ?></span>
		<span class="header-user" onclick="location.href='?_a=shop&_u=user.index'">
			<svg t="1493775150614" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="9562" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M800 384c0-160-128-288-288-288s-288 128-288 288c0 108.8 57.6 201.6 147.2 249.6-121.6 48-214.4 153.6-240 288-3.2 16 6.4 35.2 25.6 38.4h6.4c16 0 28.8-9.6 32-25.6 28.8-150.4 160-259.2 313.6-262.4h6.4c156.8 0 284.8-128 284.8-288zM288 384c0-124.8 99.2-224 224-224s224 99.2 224 224c0 121.6-99.2 220.8-220.8 224H505.6C384 604.8 288 505.6 288 384zM723.2 675.2c-16-9.6-35.2-6.4-44.8 9.6-9.6 16-6.4 35.2 9.6 44.8 73.6 51.2 124.8 121.6 140.8 204.8 3.2 16 16 25.6 32 25.6h6.4c16-3.2 28.8-19.2 25.6-38.4-19.2-99.2-80-185.6-169.6-246.4z" p-id="9563"></path></svg>
			<!--<p>个人中心</p>-->
		</span>
	</div>

	<div class="flex cart b-main" onclick="location.href='?_a=shop&_u=index.cart'">
		<img src="<?php echo $static_path?>/images/cart.png" alt="" />
	</div>
	
<header class="bg-primary search-header hide">
    <div class="header-search border-box vertical-box">
        <input class="border-box" <?php if(!empty($option['key'])) echo ' value="'.$option['key'].'"';?> 
	id="search" type="text" placeholder="请输入关键字">
        <div class="search-btn-container vertical-box"><i class="search-btn vertical-middle border-box index-icon icon-search"></i></div>
    </div>
    <!--<div class="header-left vertical-box" onclick="history.back()">
        <span class="vertical-middle">
            <img class="img-btn" src="<?php echo $static_path;?>/images/back.png">
        </span>
    </div>-->
    <div class="header-right vertical-box">
        <span id="trigger" class="vertical-middle">搜索</span>
    </div>
</header>
   <div class="clear"></div>
   <!--banner轮播开始-->
	<section class="banner clear">
	    <div class="swiper-container">
            <div class="swiper-wrapper">
<?php
uct_use_app('shop');
if($slides) {
$html = '';
foreach($slides as $s) {
	$html .= '<div class="swiper-slide"><a href="'.$s['link'].'"><img src="'.$s['image'].'" width="100%" height="100%"  alt="'.$s['title'].'"></a></div>';
}
echo $html;
}
?>
            </div>
            <div class="swiper-pagination" style="float: right">
	    </div>
	</section>
	
<div class="index-coupon" style="font-size: 0;">
<?php 
	$c = $coupons['list'];
	$a;
	$cnt =count($c);
	if(count($c)>=2){
		$a= 2;
	}else{
		$a = count($c);
	}

	if(!empty($c)){
		//for($i = 0;$i<$a;$i++){
		foreach($c as $val){
			if($a>0){
			$a--;
			$had = 0;
			if(!empty($val['had_coupon'])){
				//没限制用户领取张数
				if($val['rule']['max_cnt'] == 0){
					$had = 0;
					if(!empty($val['had_coupon_day'])){
						//没限制用户一天领取张数
						if($val['rule']['max_cnt_day'] == 0){
							$had = 0;
						}else if($val['had_coupon_day'] >= $val['rule']['max_cnt_day']){
							$had = 1;
						}

					}
				}else if($val['had_coupon'] >= $val['rule']['max_cnt']){
					$had = 1;
				}else{
					//限制一天领取
					if(!empty($val['had_coupon_day'])){
						if($val['rule']['max_cnt_day'] == 0){
							$had = 0;
						}else if($val['had_coupon_day'] >= $val['rule']['max_cnt_day']){
							$had = 1;
						}
					}
				}
			}

			?>

		<section class="coupon-section clearfix <?php echo !empty($had)? 'b-ccc':''?>" data-uid="<?php echo $val['uid']?>">
	                <div class="coupon-left border-box">
	                    <p class="small-text text-center">
                        <?php
                        if(!empty($val['rule']['min_price'])){
                            echo '满'.($val['rule']['min_price']/100).'可用';
                        }
                        else{
                            echo '无条件使用';
                        }
                        ?></p>
	                    <p class="coupon-price text-ellipsis">
	                        &yen;<span class="coupon-num"><?php echo substr($val['rule']['discount'],0,-2) ?></span><span class="fz14">.<?php echo substr($val['rule']['discount'],-2) ?></span>
	                    </p>
	                    <p class="coupon-bottom-tips small-text">
	                    <span class="c-w">
	                        有效期：
	                        <?php
	                        if(!empty($val['expire_time'])){
	                            echo date('Y.m.d',($val['expire_time']));
	                        }
	                        else{
	                            echo '永久';
	                        }
	                        ?>
	                    </span>
	                    </p>
	                </div>
	                <div class="coupon-right border-box">
	                    <p class="right-text c-w"><?php echo !empty($had)? '已领取':'现金券'?></p>
	                </div>
	            </section>
	<?php }	} }?>
		
	<?php if($cnt!=0){ ?>
    <p class="list-bottom-tips margin-bottom tips-font" style="font-size: 1.3rem;margin-top: 1rem" onclick="window.location.href='?_a=shop&_u=index.get_coupon'">
    	<?php echo '更多优惠券，点击这里'; ?>
    </p>
    <?php } ?>
</div>

<?php if(!empty($f_cats)) {?>
<div class="index-content classify">
	<div class="index-classify-head">
		<p>
			产品分类
		</p>
	</div>
	<ul style="overflow: hidden;">
        <?php 
                $html = '';
                foreach ($f_cats as $v) {
                    $html='<li class="hand" data-uid="'.$v['uid'].'"><img src="'.$v['image'].'" alt="" /><p class="index-classify-title">'.$v['title'].'</p></li>';
                    echo $html;
              	}
        ?>
	</ul>
</div>
<?php }?>
<div class="index-notice">
	<svg t="1493708987936" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="21773" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M526.432 924.064c-20.96 0-44.16-12.576-68.96-37.344L274.752 704 192 704c-52.928 0-96-43.072-96-96l0-192c0-52.928 43.072-96 96-96l82.752 0 182.624-182.624c24.576-24.576 47.744-37.024 68.864-37.024C549.184 100.352 576 116 576 160l0 704C576 908.352 549.28 924.064 526.432 924.064zM192 384c-17.632 0-32 14.368-32 32l0 192c0 17.664 14.368 32 32 32l96 0c8.48 0 16.64 3.36 22.624 9.376l192.064 192.096c3.392 3.36 6.496 6.208 9.312 8.576L512 174.016c-2.784 2.336-5.952 5.184-9.376 8.608l-192 192C304.64 380.64 296.48 384 288 384L192 384z" p-id="21774"></path><path d="M687.584 730.368c-6.464 0-12.992-1.952-18.656-6.016-14.336-10.304-17.632-30.304-7.328-44.672l12.672-17.344C707.392 617.44 736 578.624 736 512c0-69.024-25.344-102.528-57.44-144.928-5.664-7.456-11.328-15.008-16.928-22.784-10.304-14.336-7.04-34.336 7.328-44.672 14.368-10.368 34.336-7.04 44.672 7.328 5.248 7.328 10.656 14.464 15.968 21.504C764.224 374.208 800 421.504 800 512c0 87.648-39.392 141.12-74.144 188.32l-12.224 16.736C707.36 725.76 697.568 730.368 687.584 730.368z" p-id="21775"></path><path d="M796.448 839.008c-7.488 0-15.04-2.624-21.088-7.936-13.28-11.648-14.624-31.872-2.976-45.152C836.608 712.672 896 628.864 896 512c0-116.864-59.392-200.704-123.616-273.888-11.648-13.312-10.304-33.504 2.976-45.184 13.216-11.648 33.44-10.336 45.152 2.944C889.472 274.56 960 373.6 960 512s-70.528 237.472-139.488 316.096C814.144 835.328 805.312 839.008 796.448 839.008z" p-id="21776"></path></svg>
	<ul><?php foreach($radio as $ra){ ?>
		<li data-uid="<?php echo $ra['uid'] ?>"><?php echo $ra['title'] ?></li>
	<?php }?></ul>
</div>
<div class="index-content flash hide" style="overflow: hidden;">
	<div class="flash-title">
		<span style="font-size: 1.8rem;font-weight: bold;">限时抢购</span>
		<span class="flash-title-right">
			<span class="flash-start-or-end">距结束</span><span class="flash-end-time"><span id="t_h">00</span>：<span id="t_m">00</span>：<span id="t_s">00</span></span>
		</span>
	</div>
	<ul>
	</ul>
</div>


	<div class="index-classify-head">
		<p>
			人气精选
		</p>
	</div>
<nav class="goodlist-nav">
    <div class="nav-left clearfix">
        <span class="show-nav-select text-active left-2 border-box">综合排序<i class="triangle-icon"></i></span>
        <span data-id='12' class="left-2 sell_cnt border-box">销量优先</span> 
    </div>
   <!--  <div class="nav-right border-box" onclick="window.location.replace('?_a=shop&_u=index.goodlist2')">
        <img src="<?php echo $static_path?>/images/list_good.png">
    </div> -->
    <ul class="goodlist-nav-select border-box" data-type="price" style="display: none">
        <li data-id='1'>综合排序</li>
        <li data-id='14'>价格从高到低</li>
        <li data-id='13'>价格从低到高</li>
    </ul>
</nav>
<div class="goodlist-nav-mask" style="display: none"></div>
<article class="goodlist-article" style="font-size: 0;"> 
    <?php
    if(!empty($products['list'])){
        foreach($products['list'] as $p){
            ?>
            <a href='?_a=shop&_u=index.product&uid=<?php echo $p['uid'] ?>'"><section class="index-section">
                <div class="index-section-pic-box"><span class="index-section-pic-img"><img class="index-section-pic" src="<?php echo $p['main_img'] ?>" src=""></span>
                    <div class="section-pic-tips-group">
                        <?php
                        if($p['info'] & (1 << 6)) echo '<p class="section-pic-tips" style="background: #fc7539;">热销</p>';
                        if($p['info'] & (1 << 7)) echo '<p class="section-pic-tips" style="background: #7fbf23;">推荐</p>';
                        ?>
                    </div>
                </div>
                <p class="index-section-title fz14"><?php echo $p['title'] ?></p><!--todo:字数限制-->
                <div class="index-section-footer">
                    <span class="secondary-font fz12">￥<span class="fz18"><?php echo sprintf("%.2f", $p['price']/100) ?></span></span>&nbsp;&nbsp;
                    <?php
                    if(!empty($p['ori_price']) && ($p['ori_price']>$p['price'])){
                        ?>
                        <span class="white-tips-font ori-price-style fz-13">
                            ￥<?php echo sprintf("%.2f", $p['ori_price']/100) ?>
                        </span>
                        <?php
                    }
                    ?>
			<!--
                    <article class="section-btn-group clearfix">
                        <section class="add-cart-btn vertical-box"><img src="<?php echo $static_path?>/images/cart.png"></section>
                        <section class="vertical-box"><img src="<?php echo $static_path?>/images/collect.png"></section>
                        <section class="vertical-box"><img src="<?php echo $static_path?>/images/share.png"></section>
                    </article>
			-->
                </div>
            </section></a>
    <?php
        }
    }
    else{
        ?>
        <p class="list-bottom-tips">缺少商品，请在管理后台添加商品</p>
    <?php
    }
    ?>
</article>

<div class="renqijingxuan hide">
	<div class="index-classify-head">
		<p>
			热门活动
		</p>
	</div>
<!--	 
<div class="swiper-container remenhuodong-content bor-e5">
    <div class="swiper-wrapper">
    </div>  
</div> -->
	
	

</div>
<?php include $tpl_path.'/footer2.tpl';?>
	

<script src="<?php echo $static_path;?>/c_js/public/sea.js"></script>
<script src="<?php echo $static_path;?>/c_js/public/seajs-css.js"></script>
<script src="<?php echo $static_path;?>/c_js/seajs-option.js"></script>
<script src="<?php echo $static_path;?>/js/index.js"></script>
<!--todo:************************************************************************************************************-->
<script type="text/javascript">
	var su='<?php echo AccountMod::has_su_login() ?>' ;
    var products = '<?php echo(!empty($products) ? json_encode($products) : 'null') ?>';
    var cats = '<?php echo(!empty($cats) ? json_encode($cats) : 'null') ?>';

	$('.swiper-container').height($('.swiper-container').width()/2);
	$('.index-content.classify ul li img').height($('.index-content.classify ul li img').width());
	$('.index-section-pic-img').height($('.index-section-pic-img').width());
	
	$('.index-notice').on('click','li',function(){
		location.href='?_a=shop&_u=index.noticedetail&uid='+$(this).data('uid');
	})
	$('.index-content.classify').on('click','li',function(){
		location.href='?_a=shop&_u=index.products&cat_uid='+$(this).data('uid');
	})
	$('.index-content.flash').on('click','li',function(){
		location.href='?_a=shop&_u=index.product&uid='+$(this).data('uid');
	})
	
//	swiper

	    var mySwiper = new Swiper(".swiper-container",{  
	        direction:"horizontal",/*横向滑动*/  
	        loop:true,/*形成环路（即：可以从最后一张图跳转到第一张图*/  
	        pagination:".swiper-pagination",/*分页器*/  
	        prevButton:".swiper-button-prev",/*前进按钮*/  
	        nextButton:".swiper-button-next",/*后退按钮*/  
	        autoplay:3000/*每隔3秒自动播放*/  
	    }) 
	    
/*公告滚动*/
//	$.post('?_a=shop&_u=ajax.get_document_all',function(str){
//		str=JSON.parse(str);
//		$.each(str.data,function(ii,i){
//			$('.index-notice ul').append('<li data-uid="'+i.uid+'">'+i.title+'</li>');
//		})
//	})
					var scroll_area=$(".index-notice ul");    
					var timespan=3000;    
					var timeID;
					scroll_area.hover(function(){
						clearInterval(timeID);        
					},function(){        
						timeID=setInterval(function(){
							var moveline=scroll_area.find('li:first');
							var lineheight=moveline.height();            moveline.animate({marginTop:-lineheight+'px'},500,function(){                moveline.css('marginTop',0).appendTo(scroll_area);
							});            
						},timespan);        
					}).trigger('mouseleave');
	
/*普通活动*/
//$.post('?_a=shop&_u=ajax.get_activity_by_type&type=0',function(ret){
//	ret=JSON.parse(ret);
//	if(ret.data){
//		var html='';
//		$(ret.data).each(function(ii,i){
//			html+='<a href=""  class="swiper-slide"><img src="'+i.act_img+'" width="100%" height="100%"  alt="'+i.title+'" ><p>'+i.title+'</p></a>';
//		})
//		$('.remenhuodong-content>div').html(html);
//		var mySwiper = new Swiper(".swiper-container",{
//      direction:"horizontal",/*横向滑动*/  
//      loop:true,/*形成环路（即：可以从最后一张图跳转到第一张图*/  
//      pagination:".swiper-pagination",/*分页器*/  
//      prevButton:".swiper-button-prev",/*前进按钮*/  
//      nextButton:".swiper-button-next",/*后退按钮*/  
//      autoplay:3000/*每隔3秒自动播放*/  
//  }) 
//	}
//})

	
    seajs.use(['zepto'], function () { 
        seajs.use('fastclick', function () {
            FastClick.attach(document.body);
            /*关键字搜索功能*/
            $('#trigger').click(function(){
                var searchContent=$('#search').val();
                if (!searchContent=="") {
//                var url='?_a=shop&key='+searchContent;  
                  var url='?_a=shop&_u=index.products&key='+searchContent;  
                  window.location.href=url;
                }else{alert('请输入您要搜索的内容...');}  
            }); 
            /*导航*/
            $('.show-nav-select').click(function () {
                $('.goodlist-nav-select').toggle();
                $('.goodlist-nav-mask').toggle()
            }); 
            $('.sell_cnt').click(function () {
                // $(this).addClass('text-active').siblings().removeClass('text-active');     
                var url='?_a=shop&sort='+$(this).attr('data-id');
                window.location.href=url; 
                $('.goodlist-nav-select li').removeClass('text-active'); 
               
            });
            $('.goodlist-nav-select li').click(function(){
                // $(this).addClass('text-active').siblings().removeClass('text-active'); 
                $('.goodlist-nav-mask').hide();
                $(this).parent().hide(); 
                var url='?_a=shop&sort='+$(this).attr('data-id');
                window.location.href=url; 
                html=$(this).html()+'<i class="triangle-icon">'; 
                localStorage.htmlcontent=html; 
            });

            $('.goodlist-nav-mask').click(function () {
                $(this).hide();
                $('.goodlist-nav-select').hide();
            })
            // 将对应选中的样式对应上
            var param = getUrlParam('sort');
            $('.goodlist-nav-select').children('li[data-id="'+param+'"]').addClass('text-active').siblings().removeClass('text-active');
            $('.nav-left').children('span[data-id="'+param+'"]').addClass('text-active').siblings().removeClass('text-active');

        });
        // 还原刷新前本地存储的数据
        if (localStorage.htmlcontent) {
         $('.show-nav-select').html(localStorage.htmlcontent);
        }
    });
    //获取url中的参数  
    function getUrlParam(name) {  
       var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
       var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
       if (r != null) return unescape(r[2]); return null; //返回参数值  
    } 
    
    seajs.use(['jquery'], function () {
        $(document).ready(function () { 
            seajs.use('transit',function () {
                /*公告滚动效果*/
                var scroll_speed = 60;//平均速度，px/秒
                var delay_time = 1000;//延迟时间
                $('.horn-auto-scroll').each(function () {
                    var parent_length = $(this).closest('.horn-aside').width()-40;
                    var length = $(this).width();
                    if(length>parent_length){
                        var scroll_time = length/scroll_speed*1000;
                        var $this = $(this);
                        function scroll() {
                            $this.transition({
                                'left':'-100%',
                                'duration':scroll_time,
                                'delay':delay_time,
                                'complete': function (ret) {
                                    $this.css('left',0)
                                }
                            })
                        }
                        setInterval(function () {
                            scroll();
                        },500);
                    }
                })
            });
            $('.index-coupon .coupon-section').click(function () {
            	if(su == 0){
            		alert('请先登录');
            		location.href='?_a=shop&_u=user.index';
            	}else{
	                var uid = $(this).data('uid');
	                $.post('?_a=shop&_u=ajax.addusercoupon',{coupon_uid:uid}, function (ret) {
	                    ret = JSON.parse(ret);
	                    if(ret.errno==0){
	                        alert('领取成功');
	                    }
	                    else if(ret.errno==403){
	                        alert('您已经领取过了');
	                    }
	                    else{
	                        alert('领取失败，请确认领取资格，错误代码：'+ret.errno);
	                    }
	                })
            	}
            })
        })
    });
</script>
</body>
</html>