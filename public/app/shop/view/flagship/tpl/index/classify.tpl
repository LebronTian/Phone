<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/footer-font.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/style2.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/fonts.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/classify.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/index-font.css"> 
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/footer-font.css">
<style>
    .active-font {
         color: #ff6600;
    }
</style>

<header class="title-header bg-primary vertical-box">
    <span class="header-title">分类</span>
</header> 
<div class="classify-container border-box">
    <aside class="classify-aside border-box"> 
        <?php 
            if(!empty($f_cats)){
                $html = '';
                foreach ($f_cats as $v) {
                    $html='<section data-src="'.$v['uid'].'">'.$v['title'].'</section>';
                    echo $html;
                }

            }
        ?>  
    </aside>
    <div class="classify-brief border-box">
        	<?php 
        		?>
        	<!--<span style="cursor: pointer;" class="productstotal text-l text-primary border-primary" onclick="window.location.href='?_a=shop&_u=index.products&cat_uid=<?php 
	$param= $parent_uid; 
	if(!empty($s_cats))	
	foreach ($s_cats as $c) {
		$param = $param.';'.$c['uid']; 
	} 
	echo $param; 
?> '">     
        <article class="icon-article hot-classify clearfix">
           <?php var_export($s_cats)?>
            <?php 
              if(!empty($s_cats)){
                foreach ($s_cats as $c) { 
            ?>  
                <section onclick="window.location.href='?_a=shop&_u=index.products&cat_uid=<?php echo $c['uid'] ?>'">
                    <div class="hot-classify-icon" data-src="<?php echo $c['uid'] ?>">
                        <div class="square-div border-box">
                            <img src="<?php echo $c['image']?>" alt="">
                        </div>
                    </div>
                    <p class="hot-classify-title text-s"><?php echo $c['title'] ?></p>
                </section>
            <?php
                }
              }
            ?>
             
        </article> -->  
        <article class="icon-article hot-classify clearfix">
           <?php 
              if(!empty($products['list'])){
                foreach ($products['list'] as $c) { 
            ?>  
                <section onclick="window.location.href='?_a=shop&_u=index.product&uid=<?php echo $c['uid'] ?>'" style="font-size: 0;">
                    <!--<div class="hot-classify-icon" data-src="<?php echo $c['uid'] ?>">
                        <div class="square-div border-box">
                            <img src="<?php echo $c['main_img']?>" alt="">
                        </div>
                    </div>
                    <p class="hot-classify-title text-s"><?php echo $c['title'] ?></p>-->
                    <div class="classify-content-list" data-src="<?php echo $c['uid'] ?>">
                    	<div class="classify-content-list-left">
							<img src="<?php echo $c['main_img']?>" alt="" />                    		
                    	</div>
                    	<div class="classify-content-list-right">
                    		<p class="classify-content-list-right-top"><?php echo $c['title'] ?></p>
                    		<p class="classify-content-list-right-middle"></p>
                    		<p class="classify-content-list-right-bottom c-green">¥<span class="price"><?php echo $c['price']/100 ?></span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c-gray"><?php echo $c['sell_cnt'] ?>人付款</span></p>
                    		<p class="classify-content-list-right-bottomright c-gray hide">库存：<?php echo $c['quantity'] ?></p>
                    	</div>
                    </div>
                </section>
            <?php
                }
              }
            ?>
        </article>
    </div>
</div> 
<?php include $tpl_path.'/footer2.tpl';?>

<script src="<?php echo $static_path;?>/c_js/public/sea.js"></script>
<script src="<?php echo $static_path;?>/c_js/public/seajs-css.js"></script>
<script src="<?php echo $static_path;?>/c_js/seajs-option.js"></script> 
<script>
	$('.classify-content-list-left,.classify-content-list-right').height($('.classify-content-list-left').width())
	
    var f_cats = <?php echo(!empty($f_cats) ? json_encode($f_cats) : 'null') ?>;
    var ff_uid = f_cats[0]['uid'];//获取一级分类第一个的类别标识
    var s_cats = <?php echo(!empty($s_cats) ? json_encode($s_cats) : 'null') ?>;
    seajs.use(['zepto'], function () { 
        seajs.use('fastclick', function () {
            FastClick.attach(document.body);
            // 全部商品
            // $('.classify-aside>section:first-child').addClass('text-active');
            $('.classify-aside section').click(function () {
                //$(this).addClass('text-active').siblings().removeClass('text-active')
                var param=$(this).attr('data-src');
                (function(){
                    var url = '?_a=shop&_u=index.classify&parent_uid='+param+'&cat_uid='+param;
                    window.location.href = url;
                }()); 
            });
            $('.classify-aside').click(function () {
                $('.classify-brief').addClass('on');
                setTimeout(function () {
                    $('.classify-brief').removeClass('on');
                },800)
            })
        });
        var param_id = getUrlParam('parent_uid');
            	$.post('?_a=shop&_u=ajax.getcolor1',function(ret){
	    			ret=JSON.parse(ret);
	    			$('.b-main').css('background','#'+ret.data);
	    		})
        if (!param_id) { 
            $('.classify-aside>section:first-child').addClass('b-main');
        }else{
            $('.classify-aside').children('section[data-src="'+param_id+'"]').addClass('b-main');
        }  
    });
   //获取url中的参数  
    function getUrlParam(name) {  
       var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
       var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
       if (r != null) return unescape(r[2]); return null; //返回参数值  
    }   
</script>
</body>
</html>
