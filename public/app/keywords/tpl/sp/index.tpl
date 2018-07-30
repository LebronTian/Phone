
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css">
<link rel="stylesheet" href="/app/keywords/static/keywords.css">
<link rel="stylesheet" href="/static/css/source_select.css">
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered">
    <div class="am-cf am-padding">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">自定义回复</strong> / <small>订阅用户发送的消息内如果有您设置的关键字，即把您设置在此规则中回复的内容自动发送给订阅用户。</small></div>
    </div>

    <div class="am-g am-padding">
        <a type="button" class="am-btn am-btn-success create-btn"><span class="am-icon-plus"></span> 添加关键词</a>
    </div>



    <!--box-->
    <div id="create-new" class="am-g am-padding new-keyword-box" style="display: none">
<!--        <section>-->
<!--            <p style="padding: 0.5em">-->
<!--                新规则：-->
<!--                <input id="up_name" class="name-input" type="text" placeholder="请输入规则名称"/>-->
<!--                <i style="float: right;margin-right: 0.5em" class="brief-mode am-icon-chevron-down"></i>-->
<!--            </p>-->
<!--        </section>-->

        <section class="">
            <p class="section-title">新关键字：
                <input placeholder="请输入关键字" class="up_keyword name-input" type="text" />
<!--                <label data-am-popover="{content: '对方发送的内容与设置的关键字须完全一样，才会触发关键字回复，不能多一个字符也不能少一个字符。<br/>比如设置“123”，仅回复“123”才会触发关键字回复；<br/>若未勾选，则设置“123”，回复“1234”会触发;<br/>但回复不完整的关键字“12”则不会触发关键字回复。', trigger: 'hover'}" class="right-checkbox am-checkbox am-checkbox-inline"><input type="checkbox" value="" data-am-ucheck>全匹配</label>-->
                <i style="cursor:pointer;;float: right;margin-right: 0.5em" class="brief-mode am-icon-chevron-up"></i>

            </p>
<!--            <select class="add-keywords" multiple></select>-->

        </section>

        <section class="edit-section">
<!--      <p class="section-title">回复<label data-am-popover="{content: '只要粉丝命中关键字就会自动回复该规则内的所有回复；若未勾选，会随机回复', trigger: 'hover'}" class="right-checkbox am-checkbox am-checkbox-inline"><input type="checkbox" value="" data-am-ucheck>回复全部</label></p>-->
            <div class="btn-box">
                选择回复的信息类型：
                <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="1">纯文本</button>
                <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="2">单图文</button>
                <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="3">多图文</button>
                <a href="?_a=sp&_u=index.medialist" target="_blank" class="am-btn am-btn-warning am-btn-sm">
				<span class="am-icon-plus"></span> 新建素材</a>
            </div>
            <div class="reply-brief">
<!--                <div style="padding: 0" class="reply-section new-text-reply"></div>-->
<!--                <input type="text" placeholder="直接编辑回复信息"/>-->
            </div>
        </section>
        <section class="edit-section bottom-section" style="color: #818181">
<!--        文字（<span class="section-num1">0</span>），图片（<span class="section-num2">0</span>），文本素材（<span class="section-num3">0</span>）图文素材（<span class="section-num4">0</span>）-->
            <button style="margin-right: 1em" class="am-btn am-btn-success am-btn-sm save-btn">保存</button>
        </section>
        <!--******************************************************************************************************
        <section class="show-section bottom-section">
            <span class="show-title">关键字</span>
            adasd
        </section>
        <section class="show-section bottom-section">
            <span class="show-title">回复</span>
            文字（<span class="section-num1">0</span>），图片（<span class="section-num2">0</span>），文本素材（<span class="section-num3">0</span>）图文素材（<span class="section-num4">0</span>）
        </section>
        -->

        <section class="show-section bottom-section">
            <span class="show-title">回复</span>
            <span class="show-tip">未选择</span>
        </section>
    </div>

    <?php

    if(!empty($keywords)){
        foreach($keywords as $key){
            ?>
            <!--box-->
            <div class="am-g am-padding new-keyword-box" data-uid="<?php echo $key['uid'] ?>">
                <textarea data-uid="<?php if(!empty($key)) echo $key['data']['uid'] ?>" data-type="<?php echo $key['data']['media_type'] ?>" style="display: none"><?php echo json_encode($key['data']['content']); ?></textarea>
                <section>
                    <p class="section-title">关键字：
                        <input placeholder="请输入关键字" class="up_keyword name-input read-only" readonly type="text" <?php echo 'value='.$key['keyword']; ?> />
                        <i style="cursor:pointer;;float: right;margin-right: 0.5em" class="brief-mode am-icon-chevron-down"></i>
                    </p>
                </section>

                <section class="edit-section" style="display: none">
                    <div class="btn-box">
                        选择回复的信息类型：
                        <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="1">纯文本</button>
                        <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="2">单图文</button>
                        <button class="am-btn am-btn-secondary am-btn-sm selectBtn" data-type="3">多图文</button>
                        <a target="_blank" href="?_a=sp&_u=index.medialist" class="am-btn am-btn-warning am-btn-sm"><span class="am-icon-plus"></span> 新建素材</a>
                    </div>
                    <div class="reply-brief">

                    </div>
                </section>
                <section class="edit-section bottom-section" style="color: #818181 ;display: none">
                    <button class="am-btn am-btn-default am-btn-sm del-keyword" data-uid="<?php echo $key["uid"] ?>">删除</button>
                    <button style="margin-right: 1em" class="am-btn am-btn-success am-btn-sm save-btn">保存</button>
                </section>

                <section class="show-section bottom-section" style="display: block">
                    <span class="show-title">回复</span>
                    <span class="show-tip">
                        <?php
                        if(!empty($key['data']['media_type'])){
                            switch($key['data']['media_type']){
                                case 1:
                                    echo "纯文本";
                                    break;
                                case 2:
                                    echo "单图文";
                                    break;
                                case 3:
                                    echo "多图文";
                                    break;
                            }
                        }


                        ?>
                    </span>
                </section>
            </div>

    <?php
        }
    }

    ?>


</div>


<!--弹出选择框-->
<div class="am-modal am-modal-no-btn" tabindex="-1" id="select-box">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">
            <span class="select-title">Modal 标题</span>
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd select-box">
            <!--内容放这里--------->
            <div class="select-body"></div>
            <!--页码--------->
            <ul class="am-pagination select-page">

            </ul>
        </div>
    </div>
</div>
<!--删除确认框-->
<div class="am-modal am-modal-confirm" tabindex="-1" id="del-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">快马加鞭</div>
        <div class="am-modal-bd">
            你，确定要删除这条记录吗？
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>




<script>
    var keywords = <?php echo !empty($keywords) ? json_encode($keywords) : "null" ?>;
</script>


<?php
$extra_js = array(

    '/static/js/select2/js/select2.min.js',
    '/app/keywords/static/keywords.js',
    '/static/js/source_select.js',
    '/static/js/qqFaceData.js'
);
?>



