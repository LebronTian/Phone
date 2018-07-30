<style>
.ccolor {
	display: inline-block;
	width:28px;
	height:28px;
	border-radius:50%;
	cursor:pointer;
	margin:5px;
}
.cselected {
	width:50px;
	height:50px;
	border: 5px solid yellow;
	margin-bottom:-5px;
}
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">  颜色设置</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right" style="line-height:60px">
            商城颜色
        </div>
        <div class="am-u-sm-8 am-u-end">
<?php
$theme = isset($GLOBALS['arraydb_sys']['theme_'.$shop['sp_uid']]) ? $GLOBALS['arraydb_sys']['theme_'.$shop['sp_uid']] : 'purple';
$cs = array(
array('theme' => 'blue', 'color' => '2A7EF0'),
array('theme' => 'red', 'color' => 'FF4526'),
array('theme' => 'green', 'color' => '3CAE48'),
array('theme' => 'pink', 'color' => 'FF327C'),
array('theme' => 'purple', 'color' => '8E71B2'),
array('theme' => 'brown', 'color' => 'AF7C62'),
array('theme' => 'indigo', 'color' => '00BAF4'),
);	
foreach ($cs as $c) {
	echo '<a class="ccolor'.($c['theme'] == $theme ? ' cselected' : '').
		'" theme="'.$c['theme'].'" color="'.$c['color'].'" style="background:#'.$c['color'].
		'"></a>';
}
?>
		</div>
	</div>

<div <?php if(empty($_REQUEST['_d'])) echo 'style="display:none;"';?>>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商城颜色1
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" class="color" maxlength="6" size="6" id="id_color1" <?php if(!empty($color1)) echo 'value="'.$color1.'"';?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商城颜色2
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" class="color" maxlength="6" size="6" id="id_color2" <?php if(!empty($color2)) echo 'value="'.$color2.'"';?>>
        </div>
    </div>
</div>

<script type="text/javascript">
	if($('#id_color1').val() || $('#id_color2').val()){
		console.log('颜色已设置')
	}
</script>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            <button class="am-btn am-btn-lg am-btn-primary save">保存
            </button>
        </div>
        <!--<div class="am-u-sm-10 am-u-sm">
            <button class="am-btn am-btn-lg am-btn-primary show_tpl"  data-src="<?php echo DomainMod::get_app_url('site', 0, '__tpl=eyeis');?>
            ">预览
            </button>
        </div>-->

    </div>

</div>
<style type="text/css">
    .moveBar {position: absolute;width:300px;height:529px;z-index:10;right:100px;
top:50px;
}
    .phone_png{width:300px;height:529px;position:absolute;z-index:-10;top:0}
    #banner { cursor: move;height:75px;opacity:0;}
    .content{position:absolute;top:77px;left:23px;height:382px;width:258px;}
    .close_show{position:absolute;right:15px;top:15px;cursor:pointer;border-radius:1000px}
    #back{position:absolute;left:123px;bottom:13px;height:46px;width:56px;cursor:pointer;border-radius:30px;opacity:0}
    .gallery-desc{min-width:222px}
    .gallery-desc>button{font-size:1.3rem;}
    .gallery-desc>a{font-size:1.3rem;}
    .url_erweima{width:215px;height:215px;position:absolute;display:none}
</style>
<?php
        $extra_js =  array( 
          $static_path.'/js/jscolor.js',
          $static_path.'/js/sp.setcolor.js',
    );
?>


