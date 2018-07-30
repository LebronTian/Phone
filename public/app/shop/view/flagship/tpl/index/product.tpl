<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper/swiper.min.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/detail.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/count_box.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/my.css">
<header class="b-main vertical-box">
    <span class="header-title">宝贝详情</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path;?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path;?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<nav>
    <div class="nav-swiper-container">
        <div class="swiper-wrapper">
            <?php
            if(!empty($product['images'])){
                foreach($product['images'] as $img){
                    ?>
                    <div class="swiper-slide"><img class="slide-img detail-nav-scale" src="<?php echo $img ?>"></div>
            <?php
                }
            }
            else{
                ?>
                <div class="swiper-slide"><img class="slide-img detail-nav-scale" src="<?php echo $product['main_img'] ?>"></div>
            <?php
            }
            ?>
        </div>
        <div class="swiper-count-box">
            <span class="active-index-num">1</span> / <span class="all-index-num">1</span>
        </div>
    </div>
    <div class="section-pic-tips-group">
       <?php
	if($product['info'] & (1 << 6)) echo '<p class="section-pic-tips" style="background: #fc7539;">热销</p>';
	if($product['info'] & (1 << 7)) echo '<p class="section-pic-tips" style="background: #7fbf23;">推荐</p>';
       ?>
    </div>
</nav>
<article class="detail-margin">
    <div class="detail-box">
        <section class="title-section text-section big-text"><?php echo $product['title'] ?></section>
        <section class="price-section text-section">
            <span class="secondary-font big-text">&yen;<?php echo sprintf("%.2f", $product['price']/100) ?></span>
            <?php
            if(!empty($product['ori_price']) && $product['ori_price']>$product['price']){
                ?>
                <span class="white-tips-font small-text" style="text-decoration: line-through">&yen;<?php echo sprintf("%.2f", $product['ori_price']/100) ?></span>
            <?php
            }
            ?>
        </section>
        <?php
        /*无规格，在规格里选择数量*/
        if(empty($product['sku_table'])){
            ?>
            <section class="linear-section vertical-box linear-noinput">
                <span class="linear-title vertical-box">购买数量（剩余库存：<?php echo(!empty($product['quantity']))?$product['quantity']:"0"?>）</span>
                <span class="linear-right vertical-box">
                    <span>
                        <span class="section-type sku-type count-box clearfix">
                            <button class="count-btn cut-btn big-text border-box">-</button>
                            <input class="count-input border-box" type="text" value="1" readonly>
                            <button class="count-btn add-btn big-text border-box">+</button>
                        </span>
                    </span>
                </span>
            </section>
        <?php
        }
        ?>

        <?php
        if(!empty($product['extra_info'])){
            ?>
            <section class="info-section linear-section vertical-box linear-noinput">
                <span class="linear-title vertical-box">产品参数</span>
            <span class="linear-right vertical-box">
                <span>
                    <img class="info-icon" src="<?php echo $static_path;?>/images/go.png">
                </span>
            </span>
            </section>
            <div class="info-content last-liner-section" style="display: none;">
                <?php
                foreach($product['extra_info'] as $info){
                    ?>
                    <p>
                        <span class="info-ukey"><?php echo $info['ukey'] ?></span>：
                        <span class="info-data"><?php echo $info['data'] ?></span>
                    </p>
                <?php
                }
                ?>
            </div>
        <?php
        }
        ?>

        <section class="linear-section last-liner-section vertical-box linear-noinput" <?php if($product['comment_cnt']!='0') echo 'onclick="window.location.href=\'?_a=shop&_u=index.commentlist&uid='.$product['uid'].'\'"' ?> >
            <span class="linear-title vertical-box">宝贝评价（<?php echo $product['comment_cnt'] ?>）</span>
            <span class="linear-right vertical-box"><span>
                <span class="tips-font">全部</span><img src="<?php echo $static_path;?>/images/go.png">
            </span></span>
        </section>
        <section class="detail-section ">
        	<p id="detail_btn" class="linear-noinput last-liner-section">宝贝详情(点击查看)</p>
            <div class="big-text margin-top fize0">
                <?php echo $product['content'] ?>
            </div>
        </section>
        <div class="bottom-btn vertical-box"><img src="<?php echo $static_path;?>/images/bottom.png"></div>
    </div>
</article>

<?php
/*有规格，在规格里选择数量*/
if(!empty($product['sku_table'])){
    ?>
<div class="sku-window hide">
	<div class="sku-container">
		<div class="sku-head">
			<span class="sku-img"><img src="<?php echo $product['main_img']?>" alt="" /></span>
			<span class="sku-head-text">
				<p class="price c-red">&yen;<?php echo sprintf("%.2f", $product['price']/100) ?></p>
				<p class="cnt">库存 <?php echo(!empty($product['quantity']))?$product['quantity']:"0"?>件</p>
				<p class="sku">请选择属性</p>
			</span>
			<span class="sku-close">
				<svg t="1495023730808" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4362" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M512 960C264.96 960 64 759.04 64 512S264.96 64 512 64s448 200.96 448 448S759.04 960 512 960zM512 128.288C300.416 128.288 128.288 300.416 128.288 512c0 211.552 172.128 383.712 383.712 383.712 211.552 0 383.712-172.16 383.712-383.712C895.712 300.416 723.552 128.288 512 128.288z" p-id="4363"></path><path d="M557.056 513.376l138.368-136.864c12.576-12.416 12.672-32.672 0.256-45.248-12.416-12.576-32.704-12.672-45.248-0.256l-138.56 137.024-136.448-136.864c-12.512-12.512-32.736-12.576-45.248-0.064-12.512 12.48-12.544 32.736-0.064 45.248l136.256 136.672-137.376 135.904c-12.576 12.448-12.672 32.672-0.256 45.248 6.272 6.336 14.496 9.504 22.752 9.504 8.128 0 16.256-3.104 22.496-9.248l137.568-136.064 138.688 139.136c6.24 6.272 14.432 9.408 22.656 9.408 8.192 0 16.352-3.136 22.592-9.344 12.512-12.48 12.544-32.704 0.064-45.248L557.056 513.376z" p-id="4364"></path></svg>
			</span>
		</div>
		<div class="sku-body">
			<?php
			foreach($product['sku_table']['table'] as $in => $table){
			    ?>
			<div class="sku-body-content">
				<p class="title" data-sku="<?php echo $in ?>"><?php echo $in ?></p>
				<ul>
				<?php
				foreach($table as $t){
				    ?>
					<li><?php echo $t ?></li>
				<?php
				}
				?>
				</ul>
			</div>
            <?php
            }
            ?>
			<div class="cnt line-bottom-eee line-top-eee">
				<span class="left title">购买数量</span>
				<span class="right">
					<span class="sub">-</span>
					<span class="num">1</span>
					<span class="add">+</span>
				</span>
			</div>
		</div>
		<div class="sku-footer b-main hide">
			<div class="sku-defineBtn">
				确定
			</div>
		</div>
	</div>
</div>
<?php
}
?></div>
<div><span class="circle-btn vertical-box b-main" onclick="window.location.href='?_a=shop&_u=index.cart'"><img src="<?php echo $static_path;?>/images/cart.png"></span></div>
<br /><br />
<footer class="detail-footer" style="z-index: 251;">
    <div class="detail-footer-box">
        <span><svg t="1494471599294" class="addFavlist icon <?php echo (!empty($product['hadfav']))? 'hide':''?>" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4362" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M767.104 959.936c-5.344 0-10.688-1.344-15.52-4.032l-241.312-133.856-241.824 133.024c-10.72 5.92-23.904 5.152-33.888-1.92-10.016-7.072-15.104-19.264-13.12-31.328l46.88-284.736-196.448-202.08c-8.256-8.512-11.168-20.928-7.456-32.192 3.68-11.296 13.312-19.616 25.024-21.632l155.072-26.592c17.632-2.944 33.984 8.736 36.96 26.144 2.976 17.408-8.704 33.952-26.144 36.96l-95.168 16.32 165.344 170.08c7.072 7.296 10.272 17.504 8.64 27.488l-38.816 235.68 199.616-109.824c9.632-5.312 21.344-5.312 30.944 0.064l199.168 110.464-38.016-235.776c-1.632-10.016 1.632-20.224 8.704-27.456l164.672-168.256-225.664-34.816c-10.56-1.632-19.584-8.416-24.128-18.08l-99.2-212.384-100.064 211.84c-7.552 16-26.624 22.816-42.624 15.264-15.968-7.552-22.816-26.624-15.264-42.624l129.152-273.44c5.312-11.2 16.576-18.336 28.928-18.336 0 0 0.032 0 0.064 0 12.416 0.032 23.68 7.232 28.928 18.464l120.8 258.624 270.336 41.728c11.872 1.824 21.696 10.144 25.504 21.504 3.776 11.36 0.864 23.936-7.488 32.48l-196.928 201.216 45.92 284.864c1.952 12.096-3.2 24.256-13.216 31.296C780 958.016 773.568 959.936 767.104 959.936z" p-id="4363"></path></svg>
	            <svg t="1494471607593" class="addFavlist icon svg-main <?php echo (!empty($product['hadfav']))? '':'hide'?>" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4491" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M957.216 404.32c-3.808-11.36-13.632-19.68-25.504-21.504l-270.336-41.728-120.8-258.624C535.328 71.232 524.032 64.032 511.648 64c0 0-0.032 0-0.064 0-12.384 0-23.648 7.136-28.928 18.336l-121.856 258.016-270.72 40.8c-11.872 1.792-21.728 10.048-25.568 21.408-3.84 11.36-0.992 23.936 7.36 32.512l196.448 202.08L221.44 921.952c-1.984 12.096 3.104 24.256 13.12 31.328 9.984 7.072 23.168 7.808 33.888 1.92l241.824-133.024 241.312 133.856C756.416 958.656 761.76 960 767.104 960c0.256 0 0.48 0 0.64 0 17.696 0 32-14.304 32-32 0-3.968-0.704-7.776-2.016-11.296l-44.896-278.688 196.928-201.248C958.08 428.224 960.992 415.68 957.216 404.32z" p-id="4492"></path></svg>
        <p>收藏</p>
        </span>
        <span onclick="window.location.href='tel:<?php echo $sp['phone']?>'"><svg t="1493796279451" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="10084" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs> </defs><path d="M835.2 588.8c6.4-16 0-35.2-16-41.6-16-6.4-35.2 0-41.6 16-16 28.8-80 44.8-169.6 44.8-19.2 0-32 12.8-32 32s12.8 32 32 32h9.6c83.2 0 185.6-16 217.6-83.2z"   p-id="10085"></path><path d="M905.6 438.4l-41.6-16c-12.8-182.4-166.4-329.6-352-329.6-188.8 0-342.4 150.4-352 336l-19.2 12.8c-6.4 6.4-12.8 16-12.8 25.6v134.4c0 19.2 12.8 32 32 32s32-12.8 32-32v-115.2l19.2-12.8c6.4-6.4 12.8-16 12.8-28.8 0-160 128-288 288-288s288 128 288 288c0 12.8 9.6 25.6 22.4 28.8l41.6 16v108.8c0 19.2 12.8 32 32 32s32-12.8 32-32v-134.4c0-9.6-9.6-22.4-22.4-25.6z"   p-id="10086"></path><path d="M512 649.6c-99.2 0-182.4-80-182.4-182.4 0-99.2 80-182.4 182.4-182.4 99.2 0 182.4 80 182.4 182.4 0 12.8 0 25.6-3.2 38.4-3.2 16 6.4 35.2 25.6 38.4 16 3.2 35.2-6.4 38.4-25.6 3.2-16 6.4-35.2 6.4-51.2 0-134.4-108.8-246.4-246.4-246.4s-246.4 108.8-246.4 246.4c0 86.4 44.8 160 112 204.8-112 38.4-195.2 128-217.6 246.4-3.2 16 6.4 35.2 25.6 38.4h6.4c16 0 28.8-9.6 32-25.6 25.6-131.2 140.8-217.6 288-217.6 19.2 0 32-12.8 32-32-3.2-19.2-16-32-35.2-32zM755.2 710.4c-12.8-9.6-35.2-9.6-44.8 6.4-9.6 12.8-9.6 35.2 6.4 44.8 44.8 35.2 99.2 89.6 115.2 172.8 3.2 16 16 25.6 32 25.6h6.4c16-3.2 28.8-19.2 25.6-38.4-19.2-102.4-86.4-169.6-140.8-211.2z" p-id="10087"></path></svg><p>客服</p></span>
        <?php
        if($product['quantity']==0){
            ?>
            <button class="color-disable">已经卖光啦</button>
        <?php
        }
        else{
            ?>
            <button class="addCartNow sku-data footer-button-first b-ori">加入购物车</button>
            <button class="buyImmediately sku-data b-main">立即购买</button>
        <?php
        }
        ?>

    </div>
</footer>
<div class="detail-shadow"></div>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var product_uid = <?php echo(!empty($product['uid'])? json_encode($product['uid']):"null")?>;//useful
    var product_sku = <?php echo(!empty($product['sku_table'])? json_encode($product['sku_table']):"null")?>;//useful
    
    $('#detail_btn').click(function(){
		$(this).next().show();
	})
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        /*todo:在网络不好的时候，js会等待图片加载完？才执行！？把ready去除就没事了，why？*/
        /*$(document).ready(function () {*/
            /*轮播页*/
            seajs.use('seajs/swiper');
            /*详情*//*sku*/
            //seajs.use(['seajs/detail_scroll','seajs/sku_select'], function (scroll,sku) {
            seajs.use(['','seajs/sku_select'], function (scroll,sku) {/*不滚动版本*/
                /*
                    下订单
                */
                $('.buyImmediately').click(function () {
                    /*数量*/
                    var quantity = $('.sku-body .num').text();
                    if( !$('.sku-window').hasClass('has_sku')){
                    	quantity=$('.count-input').val();
                    }
                    quantity = (isNaN(quantity))?1:quantity;
                    /*规格*/
                    if(product_sku){
                        var sku_index = $(this).data('sku');
                        if(sku_index){
                        	//console.log('sku-ready',sku_index);
	                    		window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity+'&sku='+sku_index;
                        }
                        else {
//                          if(scroll){ /*有滚动效果的时候*/
//                              var status = scroll.getStatus();
//                              if(status.down){
//                                  scroll.functionDown();
//                                  sku.in();
//                              }
//                              if(status.up){
//                                  sku.in();
//                              }
//                          }
//                          else{       /*不要滚动的时候*/
//                              sku.in();
//                          }
$('.sku-window').show().addClass('has_sku');
                        }
                    }
                    /*无规格*/	
                    else {
                    		window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity;	
                    }
                });
/*收藏*/
                $('.addFavlist').click(function(){
                	var _this=$(this);
                	if($(this).attr('t') =='1494471599294'){
	                	$.post('?_a=shop&_u=ajax.add_to_fav',{product_uid:product_uid},function(ret){
							ret=JSON.parse(ret);
							if(ret.errno ==402){
								location.href='?_a=shop&_u=user.index';
							}
							else{
								_this.hide().siblings().show();
							}
	                	})
                	}else{
	                	$.post('?_a=shop&_u=ajax.delete_fav_product',{uids:product_uid},function(ret){
							ret=JSON.parse(ret);
								_this.hide().siblings().show();
	                	})
                	}
                })
/*加入购物车*/
                $('.addCartNow').click(function () {
                    /*数量*/
                    var quantity = $('.sku-body .num').text();
                    if( !$('.sku-window').hasClass('has_sku')){
                    	quantity=$('.count-input').val();
                    }
                    quantity = (isNaN(quantity))?1:quantity;
                    var sku_uid = product_uid;
                    /*规格*/
                    if(product_sku){
                        var sku_index = $(this).data('sku');
                        if(sku_index){
                            sku_uid += ';'+sku_index;
                        }
                        else {
//                          if(scroll){
//                              var status = scroll.getStatus();
//                              if(status.down){
//                                  scroll.functionDown();
//                                  sku.in();
//                              }
//                              if(status.up){
//                                  sku.in();
//                              }
//                          }
//                          else{
//                              sku.in();
//                          }
				$('.sku-window').show().addClass('has_sku');
                            return;//！！！！
                        }
                    }
                		var data = {
                		    sku_uid:sku_uid,
                		    quantity:quantity
                		};
                		console.log(data);
                		$.post('?_a=shop&_u=ajax.add_to_cart',data, function (ret) {
                		    ret = $.parseJSON(ret);
                		    console.log(ret);
                		    if(ret.errno==0 && ret.data != '0'){
                		        showTip('','加入购物车成功','');
                		        location.reload();
                		    }
                		    else{
                		        showTip('','加入失败，未知错误'+ret.errno,'');
                		    }
                		})
                });

                /*
                    点击规格section
                */
                $('.sku-section').click(function () {
                    var status = $(this).data('status');
                    if(status=='in')    sku.out();
                    else                sku.in();
                });
                /*
                    sku-butotn-规格按钮点击;
                    成功收集sku后往：.sku-data注入数据
                */
                $('.sku-body li').click(function () {
              		$(this).addClass('selected').siblings().removeClass('selected');
                    var sku_p = $('.sku-body-content');
                    var all_sku = sku_p.length;
                    var now_sku = $('.sku-body li.selected').length;
                    if(all_sku==now_sku){
                        var sku_index = '';
                        sku_p.each(function () {
                            var index = $(this).children('.title').data('sku');
                            var value = $(this).children().children('li.selected').text();
                            sku_index+=';'+index+':'+value
                        });
                        sku_index = sku_index.substr(1);

                        /*
                            获取到sku名字后的操作
                            todo:可以把这里写成一个func，如果到时候要cookie记录规格，用product_sku['info'][sku_index]作为参数来初始化
                        */
                        if(product_sku['info'][sku_index]){
                            $('.sku-img img').attr('src',product_sku['info'][sku_index]['icon_img']);
                            $('.sku-head-text .price').text('¥'+(product_sku['info'][sku_index]['price']/100).toFixed(2));
                            $('.sku-head-text .sku').html('已选：'+sku_index);
                            $('.sku-head-text .cnt').text('库存 '+product_sku['info'][sku_index]['quantity']+'件');
                            if(product_sku['info'][sku_index]['quantity']==0){
                            }
                        }
                        $('.sku-data').data('sku',sku_index)
                    }
                });
	            /* 数量*/
				$('.sku-body .sub').click(function(){
					if($(this).next().text()*1>=2){
						$(this).next().text($(this).next().text()*1-1)
					}
				})
				$('.sku-body .add').click(function(){
						$(this).prev().text($(this).prev().text()*1+1)
				})   
            });
            
            
            /*商品数目*/
            seajs.use('seajs/count_box', function (count) {
                //console.log(count);
                $('.count-box .add-btn').click(function () {
                    var box = $(this).parents('.count-box');
                    count.add(box)
                });
                $('.count-box .cut-btn').click(function () {
                    var box = $(this).parents('.count-box');
                    count.cut(box)
                });
            });
			$('.sku-close').click(function(){
				$(this).parent().parent().parent().hide().removeClass('has_sku');
			})


            seajs.use('transit', function () {
                $('.info-section').click(function () {
                    var section = $(this);
                    var status = section.data('status');
                    if(status=='in'){
                        section.data('status','out').find('.info-icon').transition({rotate:'0deg'});
                        $('.sku-section').show();
                        section.nextAll('section').show();
                        $('.info-content').hide();
                    }
                    else{
                        section.data('status','in').find('.info-icon').transition({rotate:'90deg'});
                        $('.sku-section').hide();
                        section.nextAll('section').hide();
                        $('.info-content').show();
                    }

                })
            });

            seajs.use('jquery_cookie', function () {
                $.cookie('coupon_uid',null)
            });

        /*})*/
       
    });
    
    
    /*历史记录*/
   $(function(){
	var art_title = $(".title-section").text(); //文章标题 
	if(!art_title) return false; //没获取到标题，返回
	var art_url = document.URL; //页面地址
	var art_img ='<?php echo $product['main_img']?>';
	if(!art_img) return false; //没获取到图片，返回
	var canAdd = true; //初始可以插入cookie信息 
	var hisArt = $.cookie("hisArt"); 
	var len = 0; 
	if(hisArt){ 
		hisArt = eval("("+hisArt+")"); 
		len = hisArt.length; 
		$(hisArt).each(function(){ 
			if(this.title == art_title){ 
				canAdd = false; //已经存在，不能插入 
				return false; 
			} 
		});
	}  
	
	if(canAdd==true){ 
		var json = "["; 
		var start = 0; 
		if(len>4){start = 1;} 
		for(var i=start;i<len;i++){ 
			json = json + "{\"title\":\""+hisArt[i].title+"\",\"url\":\""+hisArt[i].url+"\",\"img\":\""+hisArt[i].img+"\"},"; 
		} 
		json = json + "{\"title\":\""+art_title+"\",\"url\":\""+art_url+"\",\"img\":\""+art_img+"\"}]"; 
		$.cookie("hisArt",json,{path: "/", expires: (2)});
	}
});


</script>
</body>
</html>
