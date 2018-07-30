<link rel="stylesheet" href="/app/shop/static/css/muuri.css"/>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">首页编辑</strong> / <small></small></div>
</div>
<style>
    .content{
        cursor: move;
    }
    .board-column {
        position: static;
    }
</style>

<div class="am-form">
    <div style="width: 50%;left: 0;float: left">
    <section class="muuri-index">

        <div class="board" style="min-height: 500px;">
            <div class="board-column">
                <!--<div class="board-column-header">test</div>-->
                <div class="board-column-content">
                    <?php if(!empty($data)){
                    foreach($data['mks'] as $val){
                    ?>
                    <div class="board-item">
                        <div class="board-item-content">
                            <div class="content">
                                <div class="mks" data-mk="<?php echo $val ?>"><img src="/app/shop/static/images/<?php echo $val; ?>.png"></div>
                            </div>
                            <div class="card-remove"><span class="am-icon-close"></span></div></div></div>
                    <?php
                    }
                    } ?>
                </div>
            </div>

        </div>

    </section>
    </div>

    <div class="am-g am-margin-top-sm" style="width: 40%;float: left">

        <div class="am-u-sm-6 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-success add-item
" data-class="ss">搜索栏</button></p>
            <p><button class="am-btn am-btn-lg am-btn-success add-item" data-class="lb">轮播栏</button></p>
            <p><button class="am-btn am-btn-lg am-btn-success add-item" data-class="gg">公告栏</button></p>
            <p><button class="am-btn am-btn-lg am-btn-success add-item" data-class="dh">导航栏</button></p>
            <p><button class="am-btn am-btn-lg am-btn-success add-item" data-class="cp">产品栏</button></p>
            <p><button class="am-btn am-btn-lg am-btn-primary save-set" data-uid="<?php if(!empty($data)) echo $data['uid']; ?>">保存</button></p>
        </div>
    </div>

</div>
<script src="/static/js/velocity.min.js"></script>
<script src="/static/js/hammer.min.js"></script>
<script src="/static/js/muuri.js"></script>
<?php
$extra_js =  array(
    '/app/shop/static/js/muuri_set.js',
    '/app/shop/static/js/index_view.js',
);
?>


