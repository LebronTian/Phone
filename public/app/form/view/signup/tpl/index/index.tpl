<?php
    uct_use_app('su');
    SuMod::require_su_uid();
	if(1 || $form['uid'] == 29) {
	#if($form['uid'] != 29) {
		uct_use_app('pay');
		$openid = WxPayMod::require_order_wxjs_open_id();
	}
?>
<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/static/css/loading.css">
<script type="text/javascript" src="/static/js/loading.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style>
    *{ margin: 0; padding: 0;}
    body{ font-family: '微软雅黑'; font-size: 16px; background-color: #f1f1f1; color: #666;}
    .agreement-bar{ display: none; color: #333; position: absolute; width: 100%; height: 100%; background: rgba(0,0,0,0.7); left: 0; top: 0; z-index: 9999;}
    .agreement-bar h2{ font-weight: normal; text-align: center;}
    .agreement-bar button{ width: 100%; height: 30px; border: none; background: none; background-color: #eccc07; color: #FFF; border-radius: 5px; font-size: 18px;}
    .agreement-bar>div{ position: relative; width: 100%; height: 100%;}
    .agreement-bar>div>article{ padding: 5%; position: absolute; width: 80%; height: 400px; left: 50%; margin-left: -45%; top: 50%; margin-top: -200px; background-color: #FFF; overflow-y: auto;}
    .form-article{ padding: 10px;}
    .form-article>section{ margin-bottom: 10px;}
    input:focus{ outline: none;}
    .form-article h3{ font-size: 18px; font-weight: normal; margin-bottom: 8px; color: #eccc07;}
    .really-info-bar>p{ font-size: 12px; margin-bottom: 5px;}
    .form-input-bar{ overflow: hidden;}
    .form-input-bar .weui_cells{ margin-top: 0; font-size: 16px;}
    .form-input-bar input{ border: none; text-align: right; width: 100%;}
    .sex-select-input{text-align: right;}
    .form-input-bar>div.left{ width: 100%; float: left; background-color: #FFF; border-radius: 5px; overflow: hidden;}
    .form-input-bar>div.left>div{ overflow: hidden; padding: 5px;/* border-bottom: 1px solid #EEE;*/}
    .form-input-bar>div.left>div>div.l{width: 30%; float: left;}
    .form-input-bar>div.left>div>div.r{width: 70%; float: right;}
    .person-type-select{ border: none; font-size: 16px; font-family: '微软雅黑'; background: none;}
    .form-input-bar>div.right{ width: 20%; float: right;}
    #add-form-list{ float: right; border: none; background-color: #FFF; border-radius: 5px; margin-top: 41px; padding: 15px 10px; font-size: 30px; color: #666;}
    .pay-detail-bar{ overflow: hidden;}
    .pay-detail-bar>div{ padding: 10px 15px; overflow: hidden; border-radius: 5px; background-color: #FFF;}
    .pay-detail-bar>div>div{ width: 33.33%; float: left; }
    .pay-detail-bar>div>div:nth-child(2){ text-align: center;}
    .pay-detail-bar>div>div:nth-child(3){ text-align: right;}
    .pay-detail-bar>div>div>span,
    .pay-type-bar .recommend{ color: #eccc07;}
    .pay-type-bar{ overflow: hidden;}
    .pay-type-bar p{ font-size: 16px;}
    .pay-type-bar .weui_cells{ border-radius: 5px; margin-top: 0;}
    .weui_dialog>div{ padding: 5px 0; border-bottom: 1px solid #EEE;}
    .weui_dialog>div.active{ color: #eccc07;}
    .person-type-select{ position: relative;}
    .person-type-select>i{ 
        position: absolute; 
        right: -5px; 
        top: 50%;
        margin-top: -3px; 
        width:0;
        height:0;  
        line-height:0;  
        border-width:5px;  
        border-style:solid;  
        border-color: #666 transparent transparent transparent;
    }
    .goto-pay-bar{ height: 40px; line-height: 40px; padding-left: 5%; overflow: hidden; position: fixed; left: 0; bottom: 0; width: 95%; background-color: #FFF;}
    .goto-pay-bar>div.l{ width: 70%; float: left;}
    .goto-pay-bar>div.l>span{ color: #eccc07;}
    .goto-pay-bar>div.r{ width: 30%; float: left;}
    .goto-pay-bar>div.r>button{ width: 100%; height: 40px; background: none; border: none; background-color: #CCC; font-size: 18px; color: #FFF;}
    .goto-pay-bar>div.r>button.active{ background-color: #eccc07;}
    #is-checked-or-not{ width: 14px; height: 14px;}
    #getmobilecode{ float: right; border: none; background: none; background-color: #eccc07; color: #FFF; padding: 5px 15px; border-radius: 5px;}
    .getmobilecodecolor{ background-color: #CCC;}
</style>
<div class="weui_dialog_alert person-type-box" style="display:none;">
    <div class="weui_mask"></div>
    <div class="weui_dialog">
        <div class="active">身份证</div>
        <div>护照</div>
        <div>其他</div>
    </div>
</div>
<div class="weui_dialog_alert sex-select-box" style="display:none;">
    <div class="weui_mask"></div>
    <div class="weui_dialog">
        <div>男</div>
        <div>女</div>
    </div>
</div>

<article class="form-article">
    <section class="really-info-bar">
        <h3>请填写真实信息</h3>
        <!-- <p>32号将为您投保“畅游华夏”境内旅行保险</p> -->
        <div class="form-input-bar">
            <div class="left">
                <div class="weui_cells weui_cells_form">
                    <div class="weui_cell">
                        <div class="weui_cell_hd">
                            <label class="weui_label">姓名</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" type="text" value="<?php echo(!empty($record['data'][0]) ? $record['data'][0] : '') ?>" id="username" placeholder="必填">
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui_cell_hd person-type-select">
                            <label class="weui_label person-type-select-btn">身份证</label>
                            <!-- <i></i> -->
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" type="tel" value="<?php echo(!empty($record['data'][2]) ? $record['data'][2] : '') ?>" id="person-id-code" placeholder="必填">
                        </div>
                    </div>
                    <!-- <div class="weui_cell">
                        <div class="weui_cell_hd">
                            <label class="weui_label">生日</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" readonly type="text" id="select-time" placeholder="必填">
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui_cell_hd">
                            <label class="weui_label">性别</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input sex-select-input" readonly type="text" placeholder="请选择">
                        </div>
                    </div> -->
                    <div class="weui_cell">
                        <div class="weui_cell_hd">
                            <label class="weui_label">手机号</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" type="tel" value="<?php echo(!empty($record['data'][1]) ? $record['data'][1] : '') ?>" id="telephone" placeholder="必填">
                        </div>
                    </div>
				<?php
					if(0 && empty($record['data']))
					echo 
                    '<div class="weui_cell">
                        <div class="weui_cell_hd">
                            <label class="weui_label">验证码</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" style="width:50%;" type="tel" id="mobilecode" placeholder="必填">
                            <button id="getmobilecode">获取验证码</button>
                        </div>
                    </div>'
				?>
                </div>

            </div>
            <!-- <div class="right">
                <button id="add-form-list">+</button>
            </div> -->
        </div>
    </section>
    <section class="pay-detail-bar">
        <h3>费用详情</h3>
        <div>
            <div>基础价格</div>
            <div><span><?php  if(!empty($form['access_rule']['order']['price'])) echo ''.($form['access_rule']['order']['price']*119.6/10000).'';?></span>元/人</div>
            <div><span>1</span>人</div>
        </div>
    </section>
    <section class="pay-type-bar">
        <h3>支付方式</h3>
        <div class="weui_cells weui_cells_radio">
            <label class="weui_cell weui_check_label" for="x11">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>微信支付<span class="recommend">（推荐）</span></p>
                </div>
                <div class="weui_cell_ft">
                    <input type="radio" class="weui_check" name="radio1" id="x11" checked="checked">
                    <span class="weui_icon_checked"></span>
                </div>
            </label>
            
        </div>
    </section>
    <section class="is-read-agree">
        <label><input type="checkbox" id="is-checked-or-not">我已阅读并同意<a href="javascript:;" id="agreement-btn">活动协议及免责条款</a></label>
    </section>
</article>
<?php //var_dump($record);?>
<div class="agreement-bar">
    <div>
        <article>
            <section>
            <p><?php echo $form['brief']; ?></p>    
            </section>
            <button>确认</button>
        </article>
    </div>
</div>

<div class="goto-pay-bar">
    <div class="l">优惠费用：<span><?php if(!empty($form['access_rule']['order']['price'])) echo ($form['access_rule']['order']['price']/100);?></span>元 
(已优惠<?php if(!empty($form['access_rule']['order']['price'])) echo ($form['access_rule']['order']['price']*19.6/10000); ?>元)</div>
    <div class="r"><?php 
		if(!empty($record['order']['paid_time'])) {
			echo '<button style="background-color:green;">已支付</button></div>';
		}else {
			echo '<button id="pay-btn" disabled="disabled">支付</button></div>';
		}
	?>
</div>

<?php include $tpl_path.'/footer.tpl'; ?>
<!-- <script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="/app/form/view/signup/static/js/date.js"></script>
<script type="text/javascript" src="/app/form/view/signup/static/js/iscroll.js"></script> -->
<script type="text/javascript" src="/app/pay/view/uct/static/js/uct.wxjs.js?v2.5"></script>
<script>
    var record = <?php echo (!empty($record) ? json_encode($record) : "null") ?>;
    var form = <?php echo (!empty($form) ? json_encode($form) : "null") ?>;
	var wx_cfg = <?php echo json_encode(WeixinMod::get_jsapi_params()).';';?>
	if(wx_cfg && wx) {
		wx_cfg['jsApiList'] = ['onMenuShareTimeline', 'onMenuShareAppMessage', 'showOptionMenu', 'chooseWXPay'];
		wx.config(wx_cfg);
	}
<?php
if($form['uid'] == 29){	echo 'var dbg_url = "'.getCurrentUrl().'"; console.log("url is --->"+dbg_url);';
	echo 'var dbg_svr = '.json_encode($_SERVER).';';
}
if($form['uid'] == 30) {
	echo 'var dbg_openid= '.json_encode($openid).';';
//	echo 'alert("openid is " + dbg_openid);';
}
?>

    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            /*//显示弹出框
            $('.person-type-select-btn').on('click', function(){
                $('.person-type-box').show();
            });
            //选择
            $('.person-type-box>.weui_dialog>div').on('click', function(){
                $(this).addClass('active').siblings('div').removeClass('active');
                $('.person-type-select-btn').text($(this).text());
                $('.person-type-box').hide(); 
            });
            //性别选择
            $('.sex-select-input').on('click', function(){
                $('.sex-select-box').show();
            });
            //性别选择
            $('.sex-select-box>.weui_dialog>div').on('click', function(){
                $(this).addClass('active').siblings('div').removeClass('active');
                $('.sex-select-input').val($(this).text());
                $('.sex-select-box').hide(); 
            });*/
            var f_uid = parseInt(getUrlParam('f_uid'));

            $('#is-checked-or-not').on('click', function(){
                if($(this).is(':checked')){
                    $('#pay-btn').addClass('active').attr('disabled',false);
                }else{
                    $('#pay-btn').removeClass('active').attr('disabled',true);
                }
            });

            //验证身份证号码
            $('#person-id-code').on('blur', function(){
                var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
                if(!reg.test(this.value)){
                    $(this).val('');
                    $(this).attr('placeholder','身份证号格式错误');
                }
            });

            //手机号输入11位失去焦点
            $('#telephone').on('keyup', function(){
                if(this.value.length==11){
                    $(this).blur();
                }
            });

            //验证手机号码
            $('#telephone').on('blur', function(){
                var reg = /^1[3|4|5|7|8]\d{9}$/;
                if(!reg.test(this.value)){
                    $(this).val('');
                    $(this).attr('placeholder','手机号格式错误');
                }
            });

            //获取验证码
            $('#getmobilecode').on('click', function(){
                var telephone = $('#telephone').val();
                if($.trim(telephone)){
                    $.post('?_a=su&_u=ajax.mobilecode', {phone : telephone}, function(ret){
                        ret = $.parseJSON(ret);
                        console.log(ret);
                        if(ret.errno==0){
                            setTime();    
                        }
                        else if(ret.errno==604){
                            alert('您的操作过快，请稍后重试。');
                        }
                        
                    });
                }else{
                    alert('请先输入手机号');
                }
            });

            //支付
            $('#pay-btn').on('click', function(){
                var username = $('#username').val();
                var person_id_code = $('#person-id-code').val();
                var telephone = $('#telephone').val();
                var mobilecode = $('#mobilecode').val();
                if($.trim(username) && $.trim(person_id_code) && $.trim(telephone)/* && $.trim(mobilecode) */) {
                    var data = {
                        realname : username,
                        card_id : person_id_code,
                        phone : telephone
                        //,mobilecode : mobilecode
                    }
                    $.post('?_a=su&_u=ajax.update_su_profile', data, function(ret){
                        ret = $.parseJSON(ret);
                        console.log(ret);

                        if(ret.errno==0){
                    	}
                            var post = {
                                data : {
                                    '0' : username,
                                    '1' : telephone,
                                    '2' : person_id_code
                                },
                                f_uid : f_uid
                            }
                            console.log(post);
                            //return;
							<?php
								if(!empty($record['uid'])) {
									if(1 || $form['uid'] == 29) {
										echo 'var _d = '.json_encode($form['uid'] == 29).';';
										echo 'uct_wxjs_pay({_d: _d, ele:"#pay-btn", oid:"d'.$record['uid'].'", openid: "'.$openid.'", run: true});';
									}else
                                     echo 'window.location.href = "?_a=pay&oid=d'.$record['uid'].'"';
								}
								else {
							?>
                            $.post('?_a=form&_u=ajax.addformrecord', post, function(ret){
                                ret =JSON.parse(ret);
                                console.log(ret);
                                //todo
                                //if(ret.errno==0)
                                if(ret.data){
                                    // window.location.href = '?_a=pay&oid=d'+ret.data;
									uct_wxjs_pay({ele:"#pay-btn", oid:"d"+ret.data, openid: "<?php echo $openid;?>", run: true});
                                }
                            });
							<?php } ?>
                        }

                        //else if(ret.errno==428){
                         //   alert('验证码错误');
                        //}
						);
                }else{
                    alert('请填写完整再提交');
                }
            });

            //协议
            $('#agreement-btn').on('click', function(){
                $('.agreement-bar').show();
            });
            $('.agreement-bar').find('button').on('click', function(){
                $('.agreement-bar').hide();
            });
            
        })
    });
    
    function setTime(){
        var timer = null;
        var times = 60;
        if(timer){
            clearInterval(timer);
            timer= null;
        }
        timer= setInterval(function(){
            times--;
            if(times<=0){
                clearInterval(timer);
                $('#getmobilecode').text('获取验证码').css({'background-color':'#eccc07'}).attr('disabled',false);
                times= 60;
                
            }else{
                $('#getmobilecode').text(times+'秒后重试').css({'background-color':'#CCC'}).attr('disabled',true);  
            }
        },1000);
    }

    function getUrlParam(name) {  
       var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
       var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
       if (r != null) return unescape(r[2]); return null; //返回参数值  
    } 
    
</script>
