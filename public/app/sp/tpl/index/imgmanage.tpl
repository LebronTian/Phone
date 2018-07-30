
<!--<style style="display: block;padding: 1em" contenteditable="">-->
<!--    #test{color:blue}-->
<!--</style>-->
<style>
    /*系统图片-start*/
    .systemBtn{
        position: absolute;
        top: 52px;
        right: 171px;
    }
    .systemPicBox{
        background: white;
        height: 500px;
        width: 1000px;
        position: fixed;
        top: 0;left: 0;right: 0;bottom: 50px;
        margin: auto;z-index: 9999;
    }
    .btn-content{ background: white;padding: 0.75em; position: relative;z-index: 200}
    .returnBtn{margin-left: 5px}
    .closeBtn{
        float: right;
    }
    .system-left-box{
        position: absolute;
        top: 0;left: 0;z-index: 100;
        width: 9em;
        height: 100%;
        padding-top: 4em;
        overflow-x: hidden;
        overflow-y: scroll;
    }
    .blue-slide::-webkit-scrollbar {
        width:10px;
        height:10px;
    }
    .blue-slide::-webkit-scrollbar-button    {
        background-color:white;
    }
    .blue-slide::-webkit-scrollbar-track     {
        background:white;
    }
    .blue-slide::-webkit-scrollbar-track-piece {
        /*background:url(http://www.lyblog.net/wp/wp-content/themes/mine/img/stripes_tiny_08.png);*/
    }
    .blue-slide::-webkit-scrollbar-thumb{
        background:rgb(59, 180, 242);
        /*border-radius:4px;*/
    }
    .blue-slide::-webkit-scrollbar-corner {
        background:white;
    }
    .blue-slide::-webkit-scrollbar-resizer  {
        background:white;
    }

    .system-right-box{
        position: absolute;
        top: 0;left: 0;z-index: 50;
        height: 100%;width: 100%;
        /*background: #a5d8a5;opacity: 0.5;*/
        padding-top: 4em;
        padding-left: 9em;
    }
    .system-pic-type{
        padding-left: 1em;
    }
    .type-title-li{
        border-left: 3px solid rgb(59, 180, 242);
        font-size: 16px;
        font-weight: bold;
        padding-left: 0.7em;
        margin: 0.5em 0;
    }
    .system-type-li{
        padding: 0.5em;
        position: relative;
        cursor: pointer;
    }
    .system-type-li:hover{
        -webkit-transform:scale(1.1,1.1);	/* Safari and Chrome */

        background-color: #19a7f0;
        color: white;
        text-align: center;
        left: -7px;
        -webkit-transition:background-color 300ms ease-out,border-color 300ms ease-out
    }
    .active-type-li{
        background-color: #19a7f0;
        color: white;
        text-align: center;
        left: -7px;
    }
    .system-pic-ul{
        overflow-x:hidden ;
        overflow-y:scroll;
        height: 21em;
        margin-right: 13px;
    }
    .system-pic-li{
        float: left;
        padding: 0.5em;
        background-color: #eee;
        border: thin solid #e2e2e2;
        margin-right: 0.5em;
        margin-bottom: 0.5em;
        cursor: pointer;
        position: relative;
    }
    .system-pic-img{
        height: 9em;
        min-width: 3em;
    }
    .system-bottom-btn{
        padding-top: 1px;
        border-top: 1px solid #e2e2e2;
        position: relative;
    }
    .chose-pic-shadow{
        display: none;
        position: absolute;
        top: 0;left: 0;z-index: 100;
        width: 100%;height: 100%;
        background-color: rgba(0,0,0,.5);
        line-height: 10em;
        text-align: center;
    }
    .pic-chose-icon{
        color: white;
        font-size: 300%;
    }
    .chosePic .chose-pic-shadow{
        display: block;
    }
    .system-pic-chose-btn{
        position: absolute;
        top: 19px;right: 13px;z-index: 99;
    }
    /*系统图片-end*/
    .clearfix:after { content: ".";display: block;height: 0;clear: both;visibility: hidden; }
    .clearfix {*zoom:1;}
    /**/
    .type-box-ul{
        padding:0
    }
    .type-add-li{
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .type-red-li{
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .img-box-ul{
        padding: 0.5em;
    }
    .img-box-li img{
        float: left;
        height: 10em;
        width:10em;
        margin: 10px;
    }
    .movepic {
        float: left;
        /* color: red; */
        margin: 75px 10px 0px 0px;
        z-index: 9;
        cursor:pointer;
    }
    .delpic {
        float: left;
        /* color: red; */
        margin: 75px 10px 0px 0px;
        z-index: 9;
        cursor:pointer;
    }
    .am-dropdown .am-dropdown-content li {
        cursor:pointer;
    }
</style>
<link rel="stylesheet" href="/static/css/datatable/amazeui.datatables.min.css">

<div class="am-dropdown" id="movelist" data-am-dropdown>
    <!--<button class="am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle>下拉列表 <span class="am-icon-caret-down"></span></button>-->
    <ul class="am-dropdown-content">
        <li class="am-dropdown-header" disabled>移动到</li>
    </ul>
</div>

<div class="am-cf am-padding" >
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">图片管理</strong> / <small></small></div>
</div>
<div class="am-padding am-g">
    <button id="imgUpload" class="imgUpload am-btn am-btn-success" style="margin-left: 2.1em;margin-bottom: 12px">上传图片</button>
    <div class="am-u-sm-12">
        <aside class="type-box am-u-sm-2">
            <ul class="type-box-ul">
                <li class="type-title-li">图片类别</li>
                <li class="type-add-li"><i class="am-icon-plus"></i></li>
                <li class="type-red-li"><i class="am-icon-minus"></i></li>
            </ul>
        </aside>
        <div class="img-box am-u-sm-10">
            <ul class="img-box-ul">
            </ul>
            <table class="am-table am-table-bordered" id="my-table"></table>
        </div>
    </div>
</div>

<!--添加分类-->
<div class="am-modal am-modal-prompt" tabindex="-1" id="my-prompt">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">添加分类</div>
        <div class="am-modal-bd">
            请输入分类的名称
            <input type="text" class="am-modal-prompt-input">
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>提交</span>
        </div>
    </div>
</div>

<?php
$extra_js = array(
    '/app/form/view/bigidea/static/js/plupload.full.min.js',
    '/static/css/datatable/amazeui.datatables.min.js',
    '/app/sp/static/js/imgmanage.js',
);
?>
