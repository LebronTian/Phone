  <link rel="stylesheet" href="/static/css/amazeui2.1.min.css"/>
  <link rel="stylesheet" href="/app/sp/static/css/index.css"/>
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.pagewalkthrough.css">
	<!--基础框架-->
	<script src="/static_seajs/public_toolkit/jquery/jquery2.1.min.js"></script>
	<script src="/static_seajs/public_toolkit/cookie/jquery.cookie.js"></script>
    <script src="/static_seajs/public_toolkit/amazeui/amazeui2.1.min.js"></script>
	<script src="/static_seajs/js/tip.js"></script>
	<!--seajs-->
	<script>
		var path_option = {
			'static':<?php echo(!empty($static_path)? json_encode($static_path):"null")?>,
			'tpl':<?php echo(!empty($tpl_path)? json_encode($tpl_path):"null")?>
		};
	</script>
	<script src="/static_seajs/public_toolkit/seajs/sea.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-css.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-preload.js"></script>
	<script src="/static_seajs/js/seajs-option.js"></script>

<style>
    .addpublic-content{
        text-align: center;
    }
    .addpublic-title{
        font-size: 2em;
        margin-top:1em;
        margin-bottom: 1.5em;
        font-weight: bold;
    }
    .addpublic-slide{
        font-size: 1em;
    }
    .btn-box{
        padding: 0 9em;
        display: table;
        vertical-align: middle;
        width: 100%; } .btn-box ul{
        display: table-row;
    }
    .btn-box li{
        display: table-cell;
        position: relative;
    }
    .add-btn{
        width: 11em;
        height: 8em;
        font-size: 2em;
    }
    .btn-inside{
        font-size: 0.8em;
    }
    .form-body{
        width: 55em;
        border:thin solid #ddd;
        margin: 0 auto;
        padding: 1em 0;
        display: none;
    }
    #head-form2{
        border-top: 0;
    }
    .recommend-icon{
        position: absolute;
        top:-12em;bottom: 0;
        right: -18em;left: 0;margin: auto;
        z-index: 100;
        /*CSS3*/
        /*transform: rotate(-30deg);*/
        /*-ms-transform: rotate(-30deg);		*//* IE 9 */
        /*-webkit-transform: rotate(-30deg);	*//* Safari and Chrome */
        /*-o-transform: rotate(-30deg);		*//* Opera */
        /*-moz-transform: rotate(-30deg);		*//* Firefox */
    }


    @-webkit-keyframes am-scale-down {
        0% {
            opacity: 0;
            -webkit-transform: scale(1.8) rotate(0deg);
            transform: scale(1.8) rotate(0deg)
        }
        100% {
            opacity: 1;
            -webkit-transform: scale(1) rotate(-30deg);
            transform: scale(1) rotate(-30deg)
        }
    }

    @keyframes am-scale-down {
        0% {
            opacity: 0;
            -webkit-transform: scale(1.8) rotate(0deg);
            transform: scale(1.8) rotate(0deg)
        }
        100% {
            opacity: 1;
            -webkit-transform: scale(1) rotate(-30deg);
            transform: scale(1) rotate(-30deg)
        }
    }




</style>

<div class="addpublic-content" <?php if(!empty($public['uid'])) echo 'style="display:none"' ?>>
    <p class="addpublic-title" data-am-scrollspy="{animation:'scale-up', repeat: false}">请选择绑定公众号(小程序)方式</p>
<!--    <p class="addpublic-slide" data-am-scrollspy="{animation:'scale-up', repeat: false}">请选择绑定公众号方式</p>-->
    <div class="btn-box">
        <ul>
            <li>
                <button class="am-btn am-btn-secondary add-btn head-add">手动添加</button>
<!--                <img class="recommend-icon" src="/static/images/recommend.png"/>-->
            </li>
            <li>
                <button class="am-btn am-btn-success add-btn auto-add component_btn">自动添加</button>
                <img class="recommend-icon" src="/static/images/recommend.png" data-am-scrollspy="{animation:'scale-down', repeat: false,delay:500}" />
            </li>
        </ul>
        <div style="text-align: left;margin-top: 100px">
            <button class="fake-public am-btn">跳过</button>
        </div>
    </div>


</div>
<div class="am-modal am-modal-confirm" tabindex="-1" id="fake-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">跳过将自动生成一个<span class="am-btn-danger">伪公众号</span></div>
        <div class="am-modal-bd">
            <span class="am-btn-danger">伪公众号</span>无法正常使用公众号相关功能，如：自定义菜单，群发等。<br/>
            可用作基础功能及平台体验使用。
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>



<div class="form-body" id="head-form1" <?php if(!empty($public['uid'])) echo 'style="display:block"' ?>>
    <?php
    if(!empty($public['uid'])){
        ?>
        <div class="am-cf am-padding">
            <div class="am-fl am-cf">
                <strong class="am-text-primary am-text-lg">编辑公众号/小程序</strong> / <small>信息编辑</small>
                    <button style="margin-left: 1em;" class="am-btn am-btn-secondary component_btn">重新自动授权</button>
            </div>
        </div>
    <?php
    }else{
        ?>
        <button style="margin-left: 1em;" class="head-add am-btn am-btn-secondary">返回</button>
    <?php
    }
    ?>
    <div class="am-form">
        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                名称
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_public_name" <?php if(!empty($public['public_name'])) echo 'value="'.$public['public_name'].'"';?>>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                原始ID
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_origin_id"
                    <?php
                    if(!empty($public['origin_id'])) {
                        echo 'value="'.$public['origin_id'].'"';
                        if(substr($public['origin_id'],0,3)!="fk_"){
                            echo 'readonly';
                        }

                    }?>
                >
                <small>原始ID填写以后无法修改</small>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                公众号类型
            </div>
            <div class="am-u-sm-8 am-u-end">
                <label class="am-radio"><input type="radio" name="radio2" value="1">订阅号</label>
                <label class="am-radio"><input type="radio" name="radio2" value="2">服务号</label>
                <label class="am-radio"><input type="radio" name="radio2" value="3">企业号</label>
                <label class="am-radio"><input type="radio" name="radio2" value="8">小程序</label>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                认证情况
            </div>
            <div class="am-u-sm-8 am-u-end">
                <label class="am-checkbox">
                    <input type="checkbox" id="id_has_verified" data-am-ucheck <?php if(!empty($public['has_verified'])) echo 'checked';?>>
                    已通过微信认证</label>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                微信号
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_weixin_name" <?php if(!empty($public['weixin_name'])) echo 'value="'.$public['weixin_name'].'"';?>>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                介绍
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_weixin_brief" <?php if(!empty($public['weixin_brief'])) echo 'value="'.$public['weixin_brief'].'"';?>>
            </div>
        </div>

		<?php if(!empty($public['uid'])) {
		$biz = WeixinMod::get_weixin_public_biz($public['uid']);
		echo
        '<div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right am-text-warning">
                __biz 参数
            </div>
            <div class="am-u-sm-6">
                <input type="text" id="id_biz" value="'.($biz ? $biz : '').'">
				<small>打开任意一篇公众号文章链接中的"__biz="后固定参数，形如 MzA3NzA1OTY0NQ== </small>
            </div>
			<div class="am-u-sm-4 am-u-end">
				<button class="am-btn am-btn-warning" id="id_set_biz" data-uid="'.$public['uid'].'">设置</button>
			</div>
        </div>';
		echo
        '<div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
				二维码图片
            </div>
            <div class="am-u-sm-6">
            <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" id="search_pic" style="border: 1px solid #CCC;width: 130px;height: 32px;background-color: #0E90D2;color: #FFF;font-size: 14px;">从图片库选择</button>
            <div id="idImgBox">
                <img id="id_img" src="'.$public['qrcode_url'].'" style="width:100px;height:100px;">
            </div>
            </div>

			<div class="am-u-sm-4 am-u-end">
				<button class="am-btn am-btn-primary" data-uid="'.$public['uid'].'" id="id_set_qrcode_url">保存</button>
			</div>
        </div>';
		}
		?>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                &nbsp;
            </div>
            <div class="am-u-sm-8 am-u-end">
                <button <?php if(!empty($public['uid'])) echo 'style="display:none"' ?> class="am-btn am-btn-success saveFirst">下一步</button>
            </div>
        </div>
    </div>
</div>

<div class="form-body" id="head-form2" <?php if(!empty($public['uid'])) echo 'style="display:block"' ?>>
    <button style="margin-left: 1em;<?php if(!empty($public['uid'])) echo 'display:none' ?>" onclick="nextBtn()" class="am-btn am-btn-secondary">返回</button>
    <div class="am-form">
        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                AppID(应用ID)
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_app_id" <?php if(!empty($public['app_id'])) echo 'value="'.$public['app_id'].'"';?>>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                AppSecret(应用密钥)
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_app_secret" <?php if(!empty($public['app_secret'])) echo 'value="'.$public['app_secret'].'"';?>>
            </div>
        </div>

        <?php
        if(!empty($public)){
            if(1 || $public['access_mod']!=1){
                ?>
        <hr>


<?php
//小程序的callback
if(($public['public_type'] & 8) == 8) {
?>
        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                小程序接口前缀地址:
            </div>
            <div class="am-u-sm-8 am-u-end" style="width:83.3333333%">
                <input style="width:79%;float:left" readonly type="text" id="id_url" value="<?php
echo 'https://'.getDomainName().'/?_uct_token='.WeixinMod::get_current_weixin_public('uct_token').'&';?>"> <a  style="width:20%;float:right" id="copy_url" >点击复制</a>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
		&nbsp;
            </div>
            <div class="am-u-sm-8 am-u-end" style="width:83.3333333%">
                <a href2="?_a=sp&_u=index.xiaochengxu&uid=<?php echo $public['uid'];?>" class="agoto am-btn am-disabled3 am-btn-lg am-btn-danger">一键获取小程序代码</a>
                <a href2="?_a=pay&_u=sp.xiaochengxupay&uid=<?php echo $public['uid'];?>" class="agoto am-btn am-btn-lg am-btn-primary">设置小程序微信支付</a>
            </div>
        </div>


<?php
}
?>
        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                URL(服务器地址)
            </div>
            <div class="am-u-sm-8 am-u-end" style="width:83.3333333%">
                <input style="width:79%;float:left" readonly type="text" id="id_url2" <?php if(!empty($public['url'])) echo 'value="'.$public['url'].'"';?>> <a  style="width:20%;float:right" id="copy_url2" >点击复制</a>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                Token(令牌)
            </div>
            <div class="am-u-sm-8 am-u-end" style="width:83.3333333%">
                <input style="width:79%;float:left" readonly type="text" id="id_token" <?php if(!empty($public['token'])) echo 'value="'.$public['token'].'"';?>>
                <a id="copy_token" style="width:20%;float:right">点击复制</a>
            </div>
        </div>


        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                消息加解密方式
            </div>
            <div class="am-u-sm-8 am-u-end">
                <label class="am-radio"><input type="radio" name="radio1" value="1">明文模式</label>
                <label class="am-radio"><input type="radio" name="radio1" value="3">加密模式</label>
            </div>
        </div>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                EncodingAESKey(消息加解密密钥)
            </div>
            <div class="am-u-sm-8 am-u-end">
                <input type="text" id="id_aes_key" <?php if(!empty($public['aes_key'])) echo 'value="'.$public['aes_key'].'"';?>>
            </div>
        </div>

            <?php
            }
        }
        ?>

        <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
                &nbsp;
            </div>
            <div class="am-u-sm-8 am-u-end">
                <button class="am-btn am-btn-success over-btn saveFirst">完成</button>
            </div>
        </div>
    </div>
</div>


<?php
echo '<script>var g_uid = '.(empty($public['uid']) ? 0 : $public['uid'])
    .';var g_public_type='.(empty($public['public_type']) ? 1 : $public['public_type'])
    .';var g_msg_mode='.(empty($public['msg_mode']) ? 1 : $public['msg_mode']).';</script>';
$extra_js = array(
    '/static/js/jquery.zclip.js',
    '/app/sp/static/js/addpublic.js',
);
?>

<script>
//var publichao =<?php //echo(!empty($public) ? json_encode($public) : "null") ?>//;
    seajs.use(['selectPic']);
</script>

<?php
	if(!empty($extra_js)) {
		if(!is_array($extra_js)) {
			$extra_js = array($extra_js);
		}
		foreach($extra_js as $j) {
			if(!empty($GLOBALS['_UCT']['TPL']) && !file_exists(UCT_PATH.$j)) {
				$j = str_replace(DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'view' . DS . $GLOBALS['_UCT']['TPL'] . DS . 'static',
								DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'static', $j);				
			}

			echo '<script src="'.$j.'"></script>';
		}
	}
?>
