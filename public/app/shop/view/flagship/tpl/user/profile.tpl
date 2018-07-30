<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/profile.css" />
<header class="color-main vertical-box">
    <span class="header-title">个人资料</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<div class="container">
	<p>
		<span class="textLeft">微信呢称</span>
		<span class="textRight"><?php echo $su['name']?></span>
	</p>
	<p>
		<span class="textLeft">会员编号</span>
		<span class="textRight"><?php echo $su['recommend_uid']?></span>
	</p>
	<p>
		<span class="textLeft">联系电话</span>
		<span class="textRight phone_okBtn hide">确定</span><input type="text" class="phone" value="<?php echo (!empty($profile['phone']))?$profile['phone'] :null?>" placeholder="请输入联系电话"/>
	</p>
	<p>
		<span class="textLeft">推荐人</span>
		<span class="textRight <?php echo (!empty($from['name']))?'':'recommend'?>"><?php echo (!empty($from['name']))?$from['name']:'无推荐人，请补充'?></span>
		<span class="textRight recommend_okBtn hide">确定</span>
		<input class="recommend hide" type="" name="" id="" value="" />
	</p>
</div>
<?php include $tpl_path.'/footer.tpl'; ?>
<script type="text/javascript" charset="utf-8" >
	$('span.recommend').click(function(){
		$(this).fadeOut(500,function(){
			$('input.recommend').fadeIn(500)
			$('.recommend_okBtn').fadeIn(500)
		})
	})
	$('.recommend_okBtn').click(function(){
		var num=$(this).next().val();
		if(!num){
			alert('编号为空，请填写')
		}else if(!(/^\d{7}$/.test(num))){
			alert('编号为七位数，请核对')
		}else{
			$.post('?_a=su&_u=ajax.get_service_user_by_recommend_uid',{uid:num},function(ret){
				ret=JSON.parse(ret);
				if(ret.data!=0 &&ret.data!=false){
					if(confirm('该推荐人名字是：'+ret.data.name+'，是否保存（请注意，仅可填写一次！）')){
						$.post('?_a=su&_u=ajax.update_su',{from_su_uid:num},function(ret){
							ret=JSON.parse(ret);console.log(ret);
							if(ret.errno ==0){
								alert('推荐人保存成功');
								location.reload()
							}
						})
					}
				}else{
					alert('推荐人编号不存在，请核对')
				}
			})
		}
		
	})
	
	$('input.phone').focus(function(){
		$('.phone_okBtn').fadeIn(1000)
	})
	$('.phone_okBtn').click(function(){
		var _this=$(this);
		var new_phone=$(this).next().val();
		if(!new_phone){
			alert('请输入手机号码');return
		}else if(!(/^1(3|4|5|7|8)\d{9}$/.test(new_phone))){
			alert("手机号码有误，请重填");return
		}else{
			$.post('?_a=su&_u=ajax.update_su_profile',{phone :new_phone},function(ret){
				ret=JSON.parse(ret);
				_this.fadeOut(1000)
			})
		}
	})


</script>
</body>
</html>
