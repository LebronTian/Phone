<?php
uct_use_app('su');
//SuMod::keep_silent();
SuMod::require_su_uid();
$su = AccountMod::get_current_service_user();
if((!$su['from_su_uid']) && ($from_su_uid = requestInt('from_su_uid'))) {
if($from_su_uid != $su['uid'])
Dba::write('update service_user set from_su_uid = '.$from_su_uid.' where uid = '.$su['uid']);
}

?>
<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/static/css/swiper/swiper.min.css">  
<script src="/static/css/swiper/swiper.min.js"></script>
<style>
    body{background-color: /*#e8fcfc*/}
    .form-article{}
    .form-section{  margin-bottom: 0.8rem; border-radius: 6px }
    .status-btn{float: right;padding: 0.3rem 0.6rem;border-radius: 6px;border: thin solid white;}
    .form-title{padding: 1rem;line-height: 1.6}
    .form-bottom{padding: 1rem;}
    .form-detail{margin: 0.5rem 0;line-height: 1.5}
    .go-btn{padding: 0.5rem;border-radius: 4px;border: none}
    .date-icon{height: 1.3rem}
    .form-section:nth-child(odd){  background: /*#e8fcfc;*/  }
    .form-section:nth-child(even){  background: #f2f7fd;  }
    .form-section:nth-child(odd) .form-title{  background: /*#b22229*/;  color: white;  }
    .form-section:nth-child(even) .form-title{  background: #b22229;  color: white;  }
    .form-section:nth-child(odd) .status-btn{  background:rgb(241, 89, 34); color: white }
    .form-section:nth-child(even) .status-btn{  background:#197ccd; color: white }

    .new-color{  background: #b22229;  color: white; }

    #id_form_content{
        padding: 0.8rem;
        padding-top: 0;
    }
    body>header{
        overflow: hidden;
    }
    .form-article .linear-title{
        text-align: right;
    }
    .remark-input{
        color: #666666;
        font-size: 1em;
    }
</style>
<!--<header class="color-main vertical-box">
    <span class="header-title"><?php /*echo $form['title'] */?></span>
</header>-->
<article class="form-article btn-footer-margin">

        <section class="form-section">
            <p class="form-title clearfix">
<img src="<?php echo $static_path;?>/images/logo.jpg" style="height:44px;margin-top:5px;">
<!--
				<?php 
uct_use_app('sp');
$sp = AccountMod::get_service_provider_by_uid(AccountMod::require_sp_uid());
#$sp = AccountMod::get_current_service_provider(); 
#var_export($sp);
$profile = SpMod::get_sp_profile($sp['uid']);
echo !empty($profile['fullname']) ? $profile['fullname'] : $sp['name'];
?> - 产品介绍
-->
            </p>

<div class="swiper-container"style="width: 100%;"><!--swiper容器[可以随意更改该容器的样式-->  
    <div class="swiper-wrapper">  
        <div class="swiper-slide"><img src="<?php echo $static_path;?>/images/yidaicheng1.jpg"></div>  
        <div class="swiper-slide"><img src="<?php echo $static_path;?>/images/yidaicheng2.jpg"></div>  
        <div class="swiper-slide"><img src="<?php echo $static_path;?>/images/yidaicheng3.jpg"></div>  
    </div>  
    <div class="swiper-pagination" style=""></div><!--分页器--> 
</div>  

            <div class="form-bottom" style="height:auto;">
<?php
if(!empty($forms['list'])){
	$html = '';
	foreach ($forms['list'] as $form) {
		$html .= '<a style="width: 50%;text-align:center;padding-top:15px;float:left;color:#b22229;cursor:pointer;" 
			href="?_a=form&f_uid='.$form['uid'].'">
			<img style="width:96px;height:96px;border-radius:0%;" src="'.$form['img'].'">
			<p>'.$form['title'].'</p>
		</a>';
	}
	echo $html;
}
?>
<div style="clear:both;"></div>
            </div>
        </section>

<!--
            <div class="form-bottom" style="height:auto;">
			<?php echo $profile['brief'];?>
	</div>
-->

        <section id="id_form_content">
			<p style="text-align:center;color:gray;">© 易贷诚金融</p>
        </section>

</article>



<?php include $tpl_path.'/footer.tpl'; ?>
<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('zepto', function () {
        $(document).ready(function () {
        })
    });

	var mySwiper = new Swiper(".swiper-container",{  
        	direction:"horizontal",/*横向滑动*/  
		loop:true,/*形成环路（即：可以从最后一张图跳转到第一张图*/  
		pagination:".swiper-pagination",/*分页器*/  
		prevButton:".swiper-button-prev",/*前进按钮*/  
		nextButton:".swiper-button-next",/*后退按钮*/  
		autoplay:3000/*每隔3秒自动播放*/  
	});  

</script>
