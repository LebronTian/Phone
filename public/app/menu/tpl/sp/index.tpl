<link rel="stylesheet" href="/static/css/swiper/swiper.min.css"/>
<link rel="stylesheet" href="/app/material/static/css/newPT2.css"/>
<link rel="stylesheet" href="/vendor/emoji/emoji.css"/>
<style>
    .add_menu, .add_menu_sub {
        text-align: center;
        border: 1px dashed gray !important;
        cursor: pointer;
    }
    .toolbar, .toolbar_sub {
        width: 100%;
        height: 42px;
        line-height: 36px;
        cursor: pointer;
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        z-index: 100;
        background: rgba(180,180,180,0.8);
        padding: 3px;
        text-align: center;
    }

    .menu .am-dropdown-toggle {
        background: white;
    }

    .menu .am-dropdown {
        border: 1px solid #ddd;
        width: 104px;
        background: white;
    }
    .option_cat {
        margin: 5px 0 5px 0;
    }
    .menu{
        padding: 572px 10px 94px 84px;
        background: url(/app/default/static/images/weixin.png) no-repeat 0 0;
        background-size: 100% 100%;
        width: 423px;
        position: relative;
    }
    .am-dropdown-content{
        min-width: 103px;
    }
    .text-ellipsis{
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    /*历史记录-start****************************************************/
    .history-slide{
        min-height: 100px;
        width: 100%;
    }
    .slide-title{
        font-weight: 700;
        color: #0e90d2;
        background: white;
        border: none;
    }
    .history-swiper{
        height: 390px;
    }
    .history-swiper .swiper-slide{
        /*background: moccasin;*/
        /*height: 500px;*/
        padding: 45px 0;
        /*todo**************************************/
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .history-swiper .swiper-slide:nth-child(odd){
        /*background: darkolivegreen;*/
    }
    .swiper-pagination-bullet-active{
        background: #0e90d2;
    }
    .history-menu-box{
        width: 100%;
        border: 1px solid #e2e2e2;
        padding: 10px;
        background: #eee;
        border-radius: 5px;
    }
    .display-table{
        width: 100%;
        display: table;
        text-align: center;
    }
    .display-table ul{
        display: table-row;
    }
    .display-table li{
        width: 135px;   /*todo*****************************/
        display: table-cell;
    }
    .history-menu{
        background: white;
        height: 45px;
        line-height: 45px;
        border: 1px solid #e2e2e2;
    }
    .history-menu-name{
        max-width: 130px;
        display: inline-block;
    }
    .sub-button-icon:after{
        content: "";
        position: absolute;
        bottom: -5px;  left: 15px;
        border-left: 8px solid transparent;
        border-right: 8px solid transparent;
        border-top: 8px solid #e2e2e2;
        z-index: 5;
    }
    .sub-button-icon:before{
        content: "";
        position: absolute;
        bottom: -4px;  left: 15px;
        border-left: 8px solid transparent;
        border-right: 8px solid transparent;
        border-top: 8px solid white;
        z-index: 10;
    }
    /*********************************结构******************************/
    aside.history-slide{
        position: absolute;
        top: 0;left: 0;z-index: 50;
        min-height: 100px;
        width: 100%;
        margin-left: 440px;
        margin-top: 212px;
    }
    .history-slide .slide-title{
        margin-bottom: 10px;
    }
    .history-slide .swiper-button-prev{
        top: 0;left: 0;right: 0;bottom: auto;
        margin: auto;
        transform: rotate(90deg);
        -ms-transform: rotate(90deg);		/* IE 9 */
        -webkit-transform: rotate(90deg);	/* Safari and Chrome */
        -o-transform: rotate(90deg);		/* Opera */
        -moz-transform: rotate(90deg);		/* Firefox */
    }
    .history-slide .swiper-button-next{
        bottom: 0;left: 0;right: 0;top: auto;
        margin: auto;
        transform: rotate(90deg);
        -ms-transform: rotate(90deg);		/* IE 9 */
        -webkit-transform: rotate(90deg);	/* Safari and Chrome */
        -o-transform: rotate(90deg);		/* Opera */
        -moz-transform: rotate(90deg);		/* Firefox */
    }
    .history-menu-box .history-sub-button{
        margin-bottom: 10px;
    }
    .history-sub-button li{
        position: relative;
    }
    .recover-btn{
        position: absolute;
        top: 0;left: 0;  z-index: 10;
    }
    .history-record-time{
        position: absolute;
        top: 0;right: 0;z-index: 10;
    }
    /*历史记录-end******************************************************/
</style>

<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered">

    <div class="am-cf am-padding profile-tit">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">自定义菜单</strong> / <small>公众号底部菜单</small></div>
        <!--    <input type="text" class="asdasdasd"/>-->
    </div>

    <div class="menu">

        <div class="am-dropdown add_menu" data-am-dropdown>
            <button class="am-btn am-dropdown-toggle " data-am-dropdown-toggle><span class="am-icon-plus"></span></button>
        </div>
        <!--历史记录-->
        <aside class="history-slide">
            <p><span class="slide-title">历史记录</span> / <small>自定义菜单的历史记录</small></p>
            <div class="history-swiper swiper-container">
                <div class="swiper-wrapper">
                    <?php
                    if(!empty($menu_record)){
                        $record = json_decode($menu_record,true);
                        foreach($record as $i => $re){
                            $re = json_decode($re,true);
                            if($re['is_menu_open']==0){
                                continue;
                            }
                            ?>
                            <div class="swiper-slide">
                                <div class="history-menu-box">
                                    <!--sub_button-->
                                    <div class="history-sub-button display-table">
                                        <ul>
                                            <?php
                                            foreach ($re['selfmenu_info']['button'] as $button) {
                                                ?>
                                                <li <?php if(!empty($button['sub_button'])) echo 'class="sub-button-icon"' ?>>
                                                    <?php
                                                    if(!empty($button['sub_button'])){
                                                        foreach ($button['sub_button']['list'] as $sub) {
                                                            ?>
                                                            <div class="history-menu">
                                                                <span class="history-menu-name text-ellipsis"><?php echo (empty($sub['name'])?'':$sub['name']); ?></span>
                                                            </div>
                                                    <?php
                                                        }
                                                    }
                                                    ?>
                                                </li>
                                                <?php
                                            }
                                            ?>
                                        </ul>
                                    </div>
                                    <!--button-->
                                    <div class="display-table">
                                        <ul>
                                            <?php
                                            foreach ($re['selfmenu_info']['button'] as $button) {
                                                ?>
                                                <li>
                                                    <div class="history-menu">
                                                        <span class="history-menu-name text-ellipsis"><?php echo (empty($button['name'])?'':$button['name']);  ?></span>
                                                    </div>
                                                </li>
                                            <?php
                                            }
                                            ?>
                                        </ul>
                                    </div>
                                </div>
                                <button data-index="<?php echo $i ?>" class="recover-btn am-btn am-btn-success am-btn-sm">预览此菜单</button>
                                <?php if(!empty($i) && $i>1446453315) echo '<span class="history-record-time" style="color: #0e90d2">'.date("Y-m-d H:i",$i).'</span>';?>
                            </div>
                    <?php
                        }
                    }
                    ?>
                </div>
                <div class="swiper-pagination"></div>
                <div class="swiper-button-prev"></div>
                <div class="swiper-button-next"></div>
            </div>
        </aside>
    </div>

    <p>
        <?php
        $ret=WeixinMod::get_current_weixin_public();
        if($ret['access_mod'] == 0 &&
            !$ret['has_verified'] && $ret['public_type']==1 ) {
            echo '<div class="am-text-danger"><span class="am-icon-warning"></span> 未认证的订阅号无法通过接口设置菜单, 请登陆微信后台进行设置.</div>';
        }
        else {
            echo '<button class="am-btn am-btn-lg am-btn-primary save" data-am-loading="{spinner: \'spinner\', loadingText: \'正在请求...\'}">设置</button>';
        }
        ?>
        <button class="am-btn am-btn-lg am-btn-secondary sync" data-am-loading="{spinner: 'spinner', loadingText: '正在请求...'}">从微信获取菜单</button>
    </p>
</div>

<div class="am-modal am-modal-prompt" tabindex="-1" id="my-prompt3">
    <div class="am-modal-dialog am-form">
        <div class="am-modal-hd">菜单编辑</div>
        <small>查看微信自定义菜单<a href="http://mp.weixin.qq.com/wiki/13/43de8269be54a0a6f64413e4dfa94f39.html" target="_blank">文档</a></small>
        <div class="am-g">
            <div class="am-u-md-2 am-text-right">名称</div><div class="am-u-md-10"> <input type="text" id="id_menu_name" class="am-modal-prompt-input"></div>
        </div>
        <div class="am-g">
            <div class="am-u-md-2 am-text-right">类型</div><div class="am-u-md-10">
                <select class="option_cat">
                    <?php
                    if(($ret['access_mod']  == 1) && ($ret['public_type'] == 1) && !$ret['has_verified']  ){ ?>
                        <option value="null">无(一级菜单不需要设置)</option>
                        <option value="media_id">下发消息（除文本消息）</option>
                        <option value="view_limited">跳转图文消息URL</option>
                    <?php }
                    else{?>
                        <option value="view">跳转到指定链接（设置时请带http://）</option>
                        <option value="miniprogram">打开小程序</option>
                        <option value="null">无(一级菜单不需要设置)</option>
                        <option value="click">点击推送事件（即触发关键词）</option>
                        <option value="scancode_push">扫码推事件</option>
                        <option value="scancode_waitmsg" >扫码带提示</option>
                        <option value="pic_sysphoto">弹出系统拍照发图</option>
                        <option value="pic_photo_or_album">弹出拍照或者相册发图</option>
                        <option value="pic_weixin">弹出微信相册发图器</option>
                        <option value="location_select">弹出地理位置选择器</option>
                    <?php } ?>
                </select>
            </div>
        </div>
        <div class="am-g">
            <div class="am-u-md-2 am-text-right other_name">其他</div><div class="am-u-md-10">
                <input type="text" class="other" key="">
            </div>
        </div>
        <div class="am-g">
            <div class="am-u-md-2 am-text-right other_name2">其他2</div><div class="am-u-md-10">
                <input type="text" class="other2" key="">
            </div>
        </div>

        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm id="id_modal_ok">确定</span>

        </div>
    </div>
</div>
<!--选择图文素材-->
<div class="am-modal am-modal-no-btn" tabindex="-1" id="mass-modal" style="width: 1012px">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择素材
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div class="mass-modal-body">

            </div>
            <!--页码--------->
            <ul class="am-pagination select-page">

            </ul>
        </div>
    </div>
</div>

<script>
    var g_menu = <?php echo(!empty($menu)? json_encode($menu):"null")?>;
    var recordData = <?php echo(!empty($menu_record)? $menu_record:"null")?>;
    console.log("!",recordData);
//    console.log(recordData[0])
</script>



<?php
    $extra_js = array(
        '/static/css/swiper/swiper.min.js',
        '/app/mass/static/js/mass_material.js',
        $static_path.'/js/menu.js',

    )
?>

