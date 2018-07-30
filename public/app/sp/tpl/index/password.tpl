<head>
	<style type="text/css">

		form{ width: 600px; margin-top: 60px; margin-left: 108px;}	
		hr{ height: 1px; color: #ccc;}
	</style>
</head>
<body>
	<div class="am-cf am-padding profile-tit">
      <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">修改密码</strong> / <small>Password information</small></div>
      <hr>
    </div>
   
    	
    	<form class="am-form am-form-horizontal pro-form" data-am-validator>
          <div class="am-form-group">
            <label class="am-u-sm-8 am-form-label">修改 <?php 
			$name = $GLOBALS['service_provider']['name'] ? $GLOBALS['service_provider']['name'] 
			: $GLOBALS['service_provider']['account'];
			if($subsp_uid = AccountMod::has_subsp_login()) {
				$name = Dba::readOne('select name from sub_sp where uid = '.$subsp_uid) . '('.$name.')';
			}
			echo $name;
			?>
 				的密码</label>
          </div>
			<hr/>
			
         
          <div class="am-form-group">
            <label for="user-name" class="am-u-sm-3 am-form-label">原始密码</label>
            <div class="am-u-sm-9">
              <input type="password" value="" id="oldpsd" minlength="3" placeholder="请输入旧密码" required/>
            </div>
          </div>
          
          <div class="am-form-group">
            <label for="doc-vld-pwd-1" class="am-u-sm-3 am-form-label">新密码</label>
            <div class="am-u-sm-9">
              <input type="password" value="" id="newpsd" placeholder="请输入新密码" pattern='^(.{6,32})$' required/>
            </div>
          </div>

          <div class="am-form-group">
            <label for="doc-vld-pwd-2" class="am-u-sm-3 am-form-label">确认新密码</label>
            <div class="am-u-sm-9">
              <input type="password" value="" id="re_newpsd" placeholder="请再次输入新密码"  data-equal-to="#doc-vld-pwd-1" required/>
            </div>
          </div>

          <div class="am-form-group">
            <label for="user-email" class="am-u-sm-3 am-form-label"></label>
            <div class="am-u-sm-9">
              <button type="subimt" class="am-btn am-btn-primary btn_save">保存修改</button>
            </div>
          </div>
              
    </form>  
    <?php
  $extra_js = array(
            '/app/sp/static/js/password.js',         
            );
?>  
</body>
