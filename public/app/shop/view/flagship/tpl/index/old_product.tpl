<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper/swiper.min.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/detail.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/count_box.css">
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
            <span class="secondary-font big-text">￥<?php echo sprintf("%.2f", $product['price']/100) ?></span>
            <?php
            if(!empty($product['ori_price']) && $product['ori_price']>$product['price']){
                ?>
                <span class="white-tips-font small-text" style="text-decoration: line-through">￥<?php echo sprintf("%.2f", $product['ori_price']/100) ?></span>
            <?php
            }
            ?>
        </section>
        <?php
        /*有规格，在规格里选择数量*/
        if(!empty($product['sku_table'])){
            ?>
            <section class="sku-section linear-section vertical-box linear-noinput">
                <span class="linear-title vertical-box">选择规格（请选择）</span>
                <span class="linear-right vertical-box"><span>
                    <img class="sku-icon" src="<?php echo $static_path;?>/images/go.png">
                </span></span>
            </section>
            <div style="display: none" class="sku-content last-liner-section">
                <?php
                foreach($product['sku_table']['table'] as $in => $table){
                    ?>
                    <p class="sku-p" data-sku="<?php echo $in ?>">
                        <?php
                        foreach($table as $t){
                            ?>
                            <button class="normal-text tips-font"><?php echo $t ?></button>
                        <?php
                        }
                        ?>
                    </p>
                <?php
                }
                ?>
                <p class="show-quantity small-text"></p>
                <div class="count-content"><div class="sku-type count-box clearfix">
                        <button class="count-btn cut-btn big-text border-box">-</button>
                        <input class="count-input border-box" type="text" value="1" readonly>
                        <button class="count-btn add-btn big-text border-box">+</button>
                    </div></div>
            </div>
        <?php
        }
        /*没有的单独选择*/
        else{
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
            <div class="html-box">
                <?php echo $product['content'] ?>
            </div>
        </section>
        <div class="bottom-btn vertical-box"><img src="<?php echo $static_path;?>/images/bottom.png"></div>
    </div>
</article>
<footer class="detail-footer">
    <div class="detail-footer-box vertical-box">
        <span class="circle-btn vertical-box" onclick="window.location.href='?_a=shop&_u=index.cart'"><img src="<?php echo $static_path;?>/images/cart.png"></span>
        <?php
        if($product['quantity']==0){
            ?>
            <button class="color-disable">已经卖光啦</button>
        <?php
        }
        else{
            ?>
            <button class="addCartNow sku-data color-warning footer-button-first">加入购物车</button>
            <button class="buyImmediately sku-data color-secondary">立即预定</button>
            	<div class="weui_dialog_confirm hide" id="yuding-taocan">
			    	<div class="weui_mask"></div>
			 	   <div class="weui_dialog">
	            		<div class="weui_dialog_hd">
				            <strong class="weui_dialog_title weui_btn_default">选择预定套餐<span class="yuding_taocan"></span></strong>
				            <p data-type = "3" class="yuding-taocan-choose-btn b-main">周套餐：一周 3 次预定</p>
				            <p data-type = "12"  class="yuding-taocan-choose-btn b-main">月套餐：一月 12 次预定</p>
				        </div>
			       </div>
            	</div>
			    <div class="weui_dialog_confirm" id="confirm_yuyue_time" style="display: none;">
			    <div class="weui_mask"></div>
			    <div class="weui_dialog">
			        <div class="weui_dialog_hd">
			            <strong class="weui_dialog_title weui_btn_default">选择预定时间<span class="yuding_taocan"></span></strong>
			        </div>
			        <div style="border: 1px solid #b2b2b2;">
			            <div class="days" data-num='1'>
			                <button class="weui_btn weui_btn_mini weui_btn_default" data-date="1970-01-01">01-01</button>         
			            </div>
			        </div>
			        <div>
			            <div class="times">
			                <button  class="weui_btn weui_btn_mini weui_btn_default">07:30</button>  
			                <button  class="weui_btn weui_btn_mini weui_btn_default">08:00</button>          
			            </div>
			        </div>
			<!--        <div class="weui_cell">-->
			<!--            <div class="weui_cell_hd"><label class="weui_label">备注</label></div>-->
			<!--            <div class="weui_cell_bd weui_cell_primary">-->
			<!--                <input class="weui_input sevice_remarks" type="text"  placeholder="备注信息">-->
			<!--            </div>-->
			<!--        </div>-->
			        <div class="weui_cells_tips tips weui_warn" style="display: none;color:#ff6d6d"></div>
			        <div class="weui_dialog_ft">
			            <a href="javascript:;" class="weui_btn_dialog default yuyue_cancel">取消</a>
			            <a href="javascript:;" class="weui_btn_dialog primary yuyue_go">确定</a>
			        </div>
			    </div>
			</div>
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
                    var quantity = $('.count-input').val();
                    quantity = (isNaN(quantity))?1:quantity;
                    /*规格*/
                    if(product_sku){
                        var sku_index = $(this).data('sku');
                        if(sku_index){
                        	//console.log('sku-ready',sku_index);
	                    	if($('#confirm_yuyue_time')){
	                    		$('#yuding-taocan').show();
	                    		$('.yuding-taocan-choose-btn').click(function(){
		                    		$('#yuding-taocan').hide();
	                    			var taocan_type=$(this).data('type');
	                    			if(taocan_type =='3'){
	                    				fun();
	                    				$('.yuding_taocan').text('(周套餐)');
	                    				$('.days').attr('data-num','3');
	                    			}
	                    			if(taocan_type =='12'){
	                    				fun32();
	                    				$('.yuding_taocan').text('(月套餐)');
	                    				$('.days').attr('data-num','12');
	                    			}
	                    			$('#confirm_yuyue_time').show();
	                    			$('#confirm_yuyue_time').on('click','.yuyue_go',function(){
	                    				var yy_time_date=$(this).parent().parent().find('.days').children('.chose').data('date');
	                    				var yy_time_times=$(this).parent().parent().find('.times').children('.chose').text();
	                    				if(!yy_time_date || !yy_time_times){
	                    					alert('请选择预定时间');return
	                    				}
	                    				else if($(this).parent().parent().find('.days').children('.chose').length<$(this).parent().parent().find('.days').data('num')){
	                    					alert('周套餐请选择三天，月套餐请选择十二天');return
	                    				}
	                    				else{
	                    			window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity+'&yy_time=日期:'+yy_time_date+';时间:'+yy_time_times;
	                    				}
	                    			})
	                    		})
	                    	}
	                    	else{
	                    		window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity+'&sku='+sku_index;
	                    	}
                        }
                        else {
                            if(scroll){ /*有滚动效果的时候*/
                                var status = scroll.getStatus();
                                if(status.down){
                                    scroll.functionDown();
                                    sku.in();
                                }
                                if(status.up){
                                    sku.in();
                                }
                            }
                            else{       /*不要滚动的时候*/
                                sku.in();
                            }
			    alert('请选择规格');
                        }
                    }
                    /*无规格*/
                    else {
                    	if($('#confirm_yuyue_time')){
                    		$('#yuding-taocan').show();
                    		$('.yuding-taocan-choose-btn').click(function(){
	                    		$('#yuding-taocan').hide();
                    			var taocan_type=$(this).data('type');
                    			if(taocan_type =='3'){
                    				fun();
                    				$('.yuding_taocan').text('(周套餐)');
                    				$('.days').attr('data-num','3');
                    			}
                    			if(taocan_type =='12'){
                    				fun32();
                    				$('.yuding_taocan').text('(月套餐)');
                    				$('.days').attr('data-num','12');
                    			}
                    			$('#confirm_yuyue_time').show();
                    			$('#confirm_yuyue_time').on('click','.yuyue_go',function(){
                    				var yy_time_date=[];
                    				var date_has_chose=$(this).parent().parent().find('.days').find('button');
                    				$.each(date_has_chose, function(ii,i) {
                    					var date=$(i).data('date');
                    					if($(i).hasClass('chose')){
                    						yy_time_date.push(date);
                    					}
                    				});
                    				var yy_time_times=$(this).parent().parent().find('.times').children('.chose').text();
                    				if(!yy_time_date || !yy_time_times){
                    					alert('请选择预定时间');return
                    				}
	                    				else if($(this).parent().parent().find('.days').children('.chose').length<$(this).parent().parent().find('.days').data('num')){
	                    					alert('周套餐请选择三天，月套餐请选择十二天');return
	                    				}
                    				else{
                    			window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity+'&yy_time=日期:'+yy_time_date+';时间:'+yy_time_times;
                    				}
                    			})
                    		})
                    	}
                    	else{
                    		window.location.href='?_a=shop&_u=index.makeorder&uid='+product_uid+'&quantity='+quantity;	
                    	}
                    }
                });

                $('.addCartNow').click(function () {
                    /*数量*/
                    var quantity = $('.count-input').val();
                    quantity = (isNaN(quantity))?1:quantity;
                    var sku_uid = product_uid;
                    /*规格*/
                    if(product_sku){
                        var sku_index = $(this).data('sku');
                        if(sku_index){
                            sku_uid += ';'+sku_index;
                        }
                        else {
                            if(scroll){
                                var status = scroll.getStatus();
                                if(status.down){
                                    scroll.functionDown();
                                    sku.in();
                                }
                                if(status.up){
                                    sku.in();
                                }
                            }
                            else{
                                sku.in();
                            }
			    alert('请选择规格');
                            return;//！！！！
                        }
                    }
                    console.log("?",sku_uid,quantity);
                    var data = {
                        sku_uid:sku_uid,
                        quantity:quantity
                    };
                    $.post('?_a=shop&_u=ajax.add_to_cart',data, function (ret) {
                        ret = $.parseJSON(ret);
                        console.log(ret);
                        if(ret.errno==0){
                            showTip('','加入购物车成功','');
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
                $('.sku-p').children('button').click(function () {
                    $(this).addClass('active-border').addClass('active-font').addClass('selected-sku')
                        .siblings().removeClass('active-border').removeClass('active-font').removeClass('selected-sku');
                    var sku_p = $('.sku-p');
                    var all_sku = sku_p.length;
                    var now_sku = $('.selected-sku').length;
                    if(all_sku==now_sku){
                        var sku_index = '';
                        sku_p.each(function () {
                            var index = $(this).data('sku');
                            var value = $(this).children('.selected-sku').text();
                            sku_index+=';'+index+':'+value
                        });
                        sku_index = sku_index.substr(1);

                        /*
                            获取到sku名字后的操作
                            todo:可以把这里写成一个func，如果到时候要cookie记录规格，用product_sku['info'][sku_index]作为参数来初始化
                        */
                        console.log(product_sku['info'][sku_index]);
                        if(product_sku['info'][sku_index]){
                            $('.price-section').children('.big-text').text('￥'+(product_sku['info'][sku_index]['price']/100).toFixed(2));
                            $('.sku-section').children('.linear-title').html('选择规格（'+sku_index+'）');
                            $('.show-quantity').text('剩余库存（'+product_sku['info'][sku_index]['quantity']+'）');
                            if(product_sku['info'][sku_index]['quantity']==0){

                            }
                        }
                        $('.sku-data').data('sku',sku_index)
                    }
                });
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

//预定时间
function fun(e){
			        	var d1= new Date();
						var date =[];
						var b;
						for(var i=2;i<9;i++){
							b =(new Date(new Date(d1.getTime()+ 24 * 3600 * 1000 * i)).getMonth() +1) + "-" +(new Date(new Date(d1.getTime()+ 24 * 3600 * 1000 * i)).getDate());
							date.push(b);
						}
						
						var a='';
						$.each(date,function(i,ii){
							a+='<button class="weui_btn weui_btn_mini weui_btn_default" data-date="'+ii+'">'+ii+'</button>';
						});
						$('.days').html(a)

}
function fun32(e){
			        	var d1= new Date();
						var date =[];
						var b;
						for(var i=2;i<32;i++){
							b =(new Date(new Date(d1.getTime()+ 24 * 3600 * 1000 * i)).getMonth() +1) + "-" +(new Date(new Date(d1.getTime()+ 24 * 3600 * 1000 * i)).getDate());
							date.push(b);
						}
						
						var a='';
						$.each(date,function(i,ii){
							a+='<button class="weui_btn weui_btn_mini weui_btn_default" data-date="'+ii+'">'+ii+'</button>';
						});
						$('.days').html(a)
}
						
        $('.yuyue_cancel').on('click',function () {
            $('#confirm_yuyue_time').off('click').hide();
            location.reload();
        });
	    $('.days').on('click','button',function()
	    {
	    	if($('.days button.chose').length >=$(this).parent().data('num') && !$(this).hasClass('chose')){
	    		alert('超出预定次数，请替换日期或修改套餐');return
	    	}
	    	else{
//	    	$(this).parent().children('button').removeClass('chose');
			$(this).toggleClass('chose');
	    	}
	    })
	    $('.times').on('click','button',function()
	    {
	        $(this).parent().children('button').removeClass('chose');
	        $(this).addClass('chose');
	    })


</script>
</body>
</html>
