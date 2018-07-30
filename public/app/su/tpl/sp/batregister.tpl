<link rel="stylesheet" href="/static/css/select_user.css"/>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">批量注册新用户</strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             账号：
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_account" placeholder="可以用英文分号;分开多个账号，不填将自动生成随机账号">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             密码：
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_passwd" value="888888">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             个数：
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_count" value="1">
       		     </div>
			</div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
			推荐人
        </div>
        <div class="am-u-sm-4 am-u-end">
			<div id="id_user">
			<img style="width:64px;height:64px;" src="/static/images/null_avatar.png"> <span></span>
			</div>
        </div>
    </div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">立即注册</button></p>
				</div>
			</div>

</div>

<?php
        $extra_js =  array( 
          //'/static/js/jquery.uploadify-3.1.min.js',
		  '/static/js/select_user.js',
          $static_path.'/js/batregister.js',
    );

?>



