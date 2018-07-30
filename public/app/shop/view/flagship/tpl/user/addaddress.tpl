<?php include $tpl_path.'/header.tpl'; ?>
<body onload="setup();preselect('');promptinfo();">
<script type="text/javascript" src="<?php echo $static_path?>/js/geo.js"></script>
<link rel="stylesheet" href="<?php echo $static_path?>/css/addaddress.css" />
<header class="color-main vertical-box">
    <span class="header-title"><?php echo (requestInt('uid'))?'编辑':'新增'?>收货地址</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="addaddress-article">
    <section class="linear-section margin-top-section">
        <span class="linear-title vertical-box">收货人</span>
        <input class="name-input linear-input border-box" type="text" value="<?php echo (requestInt('uid'))?$address['name']:''?>" placeholder="请输入收货人的姓名">
    </section>
    <section class="linear-section">
        <span class="linear-title vertical-box">手机号码</span>
        <input class="phone-input linear-input border-box" type="text" value="<?php echo (requestInt('uid'))?$address['phone']:''?>" placeholder="请输入收货人的手机号码">
    </section>

    <section class="select-section linear-section">
        <span class="linear-title vertical-box"><span><?php foreach($addr_name as $an){
        if($an['level']==1)echo $an['address'];}  ?></span></span>
        <select class="select-address first-select linear-select linear-input white-tips-font" id="s1">
            <option></option>
        </select>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>

    <section class="select-section linear-section">
        <span class="linear-title vertical-box"><span><?php foreach($addr_name as $an){
        if($an['level']==2)echo $an['address'];}  ?></span></span>
        <select class="select-address second-select linear-select linear-input white-tips-font" id="s2">
            <option></option>
        </select>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>

    <section class="select-section linear-section">
        <span class="linear-title vertical-box"><span><?php foreach($addr_name as $an){
        if($an['level']==3)echo $an['address'];}  ?></span></span>
        <select class="select-address third-select linear-select linear-input white-tips-font" id="s3">
            <option></option>
        </select>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>

    <section class="linear-section last-liner-section">
        <span class="linear-title vertical-box">详细地址</span>
        <input class="address-input linear-input border-box" type="text" value="<?php echo (requestInt('uid'))?$address['address']:''?>" placeholder="请输入详细地址">
    </section>
    <!--<section class="linear-section last-liner-section linear-noinput">
        <p>设为默认地址</p>
        <p class="white-tips-font small-text">注：每次下单时会使用该地址</p>
        <span class="linear-right vertical-box"><span>

        </span></span>
    </section>-->
    <footer class="btn-footer footer-one-btn margin-top-section clearfix border-box">
        <button class="saveBtn color-primary">保存并使用</button>
    </footer>
</article>

<?php include $tpl_path.'/footer.tpl';?>

<script>

var url_uid='<?php echo requestInt('uid');?>';
function promptinfo() {}
var $address_province='<?php echo (requestInt('uid'))?$address['province']:null ?>';
var $address_city='<?php echo (requestInt('uid'))?$address['city']:null ?>';
var $address_town='<?php echo (requestInt('uid'))?$address['town']:null ?>';
//console.log(edit_addr);
//'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            seajs.use('jquery_cookie', function () {
            	//          seajs.use('js/selectaddress.js');
                if(url_uid !='0'){
            		$('#s1').val($address_province).change();
            		$('#s2').val($address_city).change();
            		$('#s3').val($address_town);
            	}
                $('.saveBtn').click(function () {
                    var name = $('.name-input').val().trim();
                    var phone = $('.phone-input').val().trim();
					var province=$('#s1').find("option:selected").text();
					var city=$('#s2').find("option:selected").text();
					var town=$('#s3').find("option:selected").text();
                    var address = $('.address-input').val().trim();
					if(!name) {
						alert("收货人姓名未填写");
						return false;
					}
					if(!(/^.{2,8}$/.test(name))){
						alert('姓名仅允许2-8字');
						return;
					}
				    if(!(/^1(3|4|5|7|8)\d{9}$/.test(phone))){ 
				        alert("手机号码有误，请重填");  
				        return false; 
				    }	
                    if((province=='请选择')||(city=='请选择')){
                        alert('请选择收货地址');
                        return
                    }
                    if(address==''){
                        alert('请填写详细地址信息');
                        return
                    }
                    if(url_uid){
                    	var data ={
	                        name:name,
	                        phone:phone,
	                        address:address,
	                        province:province,
	                        town:town,
	                        city:city,
							uid:url_uid,
                    	};
                    }else{
                    	var data = {
                    	    name:name,
                    	    phone:phone,
                    	    address:address,
                    	    province:province,
                    	    town:town,
                    	    city:city
                    	};
                    }

                    $.post('?_a=shop&_u=ajax.add_address',data, function (ret) {
                        ret = JSON.parse(ret);
                        if(ret.errno==0){
                            $.cookie('freshen_add_data','true');
                            location.href='?_a=shop&_u=user.address';
                        }
                    })
                })
                
            });
        })
    });



</script>
</body>
</html>