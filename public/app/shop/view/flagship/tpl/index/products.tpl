<?php include $tpl_path.'/header.tpl'; ?>
<!--todo:************************************************************************************************************-->
<link rel="stylesheet" href="<?php echo $static_path;?>/css/index2.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/good.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/goodlist.css">   
<link rel="stylesheet" href="<?php echo $static_path;?>/css/fonts.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/font/footer-font.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/products.css">
<link rel="stylesheet" href="" />
<header class="b-main search-header">
    <div class="header-search border-box vertical-box">
        <input id="search" class="border-box" type="text" placeholder="请输入关键字">
        <div class="search-btn-container vertical-box"><i class="search-btn vertical-middle border-box index-icon icon-search"></i></div>
    </div>
    <div class="header-left vertical-box" onclick="history.back()">
        <span class="vertical-middle">
            <img class="img-btn" src="<?php echo $static_path;?>/images/back.png">
        </span>
    </div>
    <div class="header-right vertical-box" >
        <span id="trigger" class="vertical-middle">搜索</span>
    </div>
</header>
<nav class="goodlist-nav">
    <div class="nav-left clearfix">
        <span class="show-nav-select text-active left-2 border-box">综合排序<i class="triangle-icon"></i></span>
        <span class="left-2 border-box">销量优先</span>
        <!-- <span class="left-1 border-box">筛选</span> -->
    </div>
   <!--  <div class="nav-right border-box" onclick="window.location.replace('?_a=shop&_u=index.goodlist2')">
        <img src="<?php echo $static_path;?>/images/list_good.png">
    </div> -->
    <ul class="goodlist-nav-select border-box" data-type="price" style="display: none">
        <li class="text-active">综合排序</li>
        <li>价格从高到低</li>
        <li>价格从低到高</li>
    </ul>
</nav>
<div class="goodlist-nav-mask" style="display: none"></div>
<article class="goodlist-article clear"> 
   <?php
    if(!empty($products['list'])){
        foreach($products['list'] as $p){
            ?>
            <section class="index-section" onclick="window.location.href='?_a=shop&_u=index.product&uid=<?php echo $p['uid'] ?>'">
               
                <div class="index-section-pic-box">
                    <img class="index-section-pic" data-echo="<?php echo $p['main_img'] ?>" src="">
                    <div class="section-pic-tips-group">
                        <?php
                        $count = 0;
                        $status = $p['info'];
                        do{
                            if($status%2==1){
                                switch($count){
                                    case 6:
                                        echo '<p class="section-pic-tips" style="background: #fc7539;">热销</p>';
                                        break;
                                    case 7:
                                        echo '<p class="section-pic-tips" style="background: #7fbf23;">推荐</p>';
                                        break;
                                }
                            }
                            $status = $status/2;
                            $count++;
                        }
                        while(($status>=1)&&($count<20));//这里设一个上限，防止死循环
                        ?>
                    </div>  
                    <p class="index-section-title fz14" ><?php echo $p['title'] ?></p><!--todo:字数限制-->
                </div>
                <div class="index-section-footer" style="color: #fd9801;">
                    <span class="secondary-font fz12">&yen;<span class="fz18"><?php echo sprintf("%.2f", $p['price']/100) ?></span></span>
                    <?php
                    if(!empty($p['ori_price']) && ($p['ori_price']>$p['price'])){
                        ?>
                        <span class="white-tips-font small-text c-gray fz12" style="text-decoration: line-through">
                            &yen;<?php echo sprintf("%.2f", $p['ori_price']/100) ?>
                        </span>
                        <?php
                    }
                    ?>
                     
                </div>
            </section>
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
<?php include $tpl_path.'/footer2.tpl';?>
	
<!--todo:************************************************************************************************************-->
<script src="<?php echo $static_path;?>/c_js/public/sea.js"></script>
<script src="<?php echo $static_path;?>/c_js/public/seajs-css.js"></script>
<script src="<?php echo $static_path;?>/c_js/seajs-option.js"></script>
<!--todo:************************************************************************************************************-->
<script>
    var products = <?php echo(!empty($products) ? json_encode($products) : 'null') ?>;
    console.log('products',products);
    var cats = <?php echo(!empty($cats) ? json_encode($cats) : 'null') ?>;
    console.log('cats',cats);  
    // seajs.use(['zepto'], function () { 
    //     seajs.use('fastclick', function () {
    //         // 还原刷新前本地存储的数据
    //         if (localStorage.htmlcontent) {
    //          $('show-nav-select').html(localStorage.htmlcontent);
    //         }
    //         FastClick.attach(document.body);
    //         /*导航*/
    //         $('.show-nav-select').click(function () {
    //             $('.goodlist-nav-select').toggle();
    //             $('.goodlist-nav-mask').toggle()
    //         });
    //         $('.goodlist-nav-select li').click(function () {
    //             $(this).addClass('text-active').siblings().removeClass('text-active');
    //             $('.goodlist-nav-mask').hide();
    //             $(this).parent().hide();

    //             $(this).addClass('text-active').siblings().removeClass('text-active'); 
    //             $('.goodlist-nav-mask').hide();
    //             $(this).parent().hide(); 
    //             // var url='?_a=shop&_u=index.products&sort='+$(this).attr('data-id');
    //             // window.location.href=url; 
    //             html=$(this).html(); 
    //             localStorage.htmlcontent=html; 
    //             console.log(localStorage.htmlcontent);
    //         });
    //         $('.goodlist-nav-mask').click(function () {
    //             $(this).hide();
    //             $('.goodlist-nav-select').hide();
    //         })
    //     });
    //     seajs.use('echo', function () {
    //         echo.init({
    //             offset:0
    //         })
    //     })

    // });
      seajs.use(['zepto'], function () {
        
        seajs.use('fastclick', function () {
            FastClick.attach(document.body);
             /*关键字搜索功能*/
            $('#trigger').click(function(){
                var searchContent=$('#search').val();
                console.log('searchContent',searchContent); 
                if (!searchContent=="") {
                  var url=window.location.href+'&key='+searchContent;  
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
            $('.goodlist-nav-select li').click(function () {
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
        seajs.use('echo', function () {
            echo.init({
                offset:0
            })
        })
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
    
    seajs.use(['jquery','echo'], function () {
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
        })
    });
    $('.index-section-pic').height($('.index-section-pic').width())
</script>
</body>
</html>