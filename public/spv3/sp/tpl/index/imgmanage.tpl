
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
        cursor: pointer;
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
        color: rgb(51,51,51)!important;
        font-size: 12px!important;
        text-align: left;
        background-color: #f8f8f8;
        min-height: 300px;
    }
    .img-box{
        border-left: 1px solid #f3f3f3;
    }

    /*.movepic {
        float: left;
        margin: 75px 10px 0px 0px;
        z-index: 9;
        cursor:pointer;
    }
    .delpic {
        float: left;
        margin: 75px 10px 0px 0px;
        z-index: 9;
        cursor:pointer;
    }*/
    .am-dropdown .am-dropdown-content li {
        cursor:pointer;
    }
    .imgmanage-self .header-title{
        height: 32px;
        line-height: 32px;
        font-size: 16px;
    }
    .imgmanage-self .type-box-ul{
        color: rgb(51,51,51)!important;
        font-size: 12px!important;
        text-align: left;
        background-color: #f8f8f8;
        min-height: 300px;
    }
    .imgmanage-self .type-box-ul li.system-type-li:hover{
        background-color: #fff;
        background-color: #fff;
    }
    .imgmanage-self .type-box-ul div,
    .imgmanage-self .type-box-ul a{
        display: block;
        position: relative;
        margin: 0 auto;
        max-width: 84px;
        padding-top: 10px;
        padding-bottom: 10px;
    }
    .imgmanage-self a{
        color: rgb(51,51,51);
        cursor: pointer;
    }
    .imgmanage-self .type-add-li,
    .imgmanage-self .type-red-li{
        max-width: 84px;
        height: 28px;
        margin: 0 auto;
        margin-bottom: 8px!important;
        color: rgb(51,51,51);;
        border: 1px solid #ddd;
        border-radius: 2px;
        text-align: center;
        line-height: 26px;
        cursor: pointer;
    }
    .imgmanage-self .type-add-li{
        margin-top: 20px;
    }
    .imgmanage-self .type-add-li i,
    .imgmanage-self .type-red-li i{
        margin-right: 5px!important;
    }

    .imgmanage-self .system-type-li p{
        position: absolute;
        right: 0;
        top: 10px;
    }
    .active-type-li{
        background-color: #fff;
        color: rgb(51,51,51);
    }
    .imgmanage-nav{
        margin-top: 15px;
        padding-top: 10px;
        padding-bottom: 10px;
        padding-left: 5px;
        background-color: #f8f8f8;
    }
    .imgmanage-nav a{
        margin-left: 20px;
        color: rgb(153,153,153);
    }
    /*.img-box-ul{
        padding: 0.5em;
    }
    .img-box-li img{
        float: left;
        height: 10em;
        width:10em;
        margin: 10px;
        border:1px solid #ddd;
        cursor:pointer;
    }*/
    .img-box-ul{
        max-height: 590px;
        overflow: hidden;
    }

    .img-box-ul li{
        margin-right: 20px;
        margin-bottom: 20px;
    }
    .img-box-li img{
        width: 132px;
        height: 132px;
    }
    .img-box-li .img-title{
        margin-top: 5px;
        margin-bottom: 5px;
        font-size: 12px;
    }
    .img-box-li .img-title .ccheck{
        margin-right: 5px;
    }
    .img-box-ul a{
        color: rgb(51,51,51)!important;
        margin-right: 5px;
    }
    .imgmanage-self input[type=checkbox]{
        height: 12px;
        vertical-align: top;
    }
    .imgmanage-self .img-title{
        width: 132px;
        white-space:nowrap; 
        overflow:hidden; 
        text-overflow:ellipsis;
    }
    .imgmanage-self .img-control a:not(:last-child){
        color: rgb(0,153,252)!important;
    }
    .imgmanage-self .pro-btngroup-self{
        margin-top: 15px;
        padding-top: 8px;
        padding-bottom: 8px;
        padding-left: 5px;
        background-color: #f8f8f8;
    }
    .imgmanage-self .time-btn{
        padding: 0 5px;
        border-radius: 3px;
        font-size: 12px;
        color: rgb(51,51,51);
    }
    .imgmanage-self .time-btn .am-form-group{
        height: 20px;
    }
    .imgmanage-self .pagination-self{
        height: 20px;
        width: 40px;
        margin-top: -20px;    
        border: 1px solid #dcdcdc!important;
    }
</style>
<link rel="stylesheet" href="/static/css/datatable/amazeui.datatables.min.css">

<div class="am-dropdown" id="movelist" data-am-dropdown>
    <!--<button class="am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle>下拉列表 <span class="am-icon-caret-down"></span></button>-->
    <ul class="am-dropdown-content">
        <li class="am-dropdown-header" disabled>移动到</li>
    </ul>
</div>

<!-- <div class="am-cf am-padding" >
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">图片管理</strong> / <small></small></div>
</div> -->
<div class="am-padding am-g imgmanage-self">
    <div class="am-u-sm-12 pd0">
        <!-- <aside class="type-box am-u-sm-1" style="padding:0;">
            <ul class="type-box-ul">
                <li class="type-title-li">图片类别</li>
                <li class="type-add-li"><i class="am-icon-plus"></i></li>
                <li class="type-red-li"><i class="am-icon-minus"></i></li>
            </ul>
        </aside> -->
        <aside class="type-box am-u-sm-1" style="padding:0;">
            <ul class="type-box-ul" style="overflow-y: auto;max-height: 600px;">
                <li class="type-title-li" style="display: none;"></li>
                <li class="type-add-li"><i class="am-icon-plus"></i>添加分组</li>
                <li class="type-red-li"><i class="am-icon-minus"></i>删除分组</li>
            </ul>
        </aside>
        <div class="img-box am-u-sm-11">

            <div class="imgmanage-header am-cf">
                <div class="am-fl header-title">
                    未分组
                </div>
                <div class="am-fr">
                  <button id="imgUpload" class="imgUpload am-btn am-btn-success blue-self"><span class="am-icon-upload"></span> 上传图片</button>
                </div>
            </div>
            <div class="imgmanage-nav">
                <ul class="am-cf">
                    <li class="am-fl"><input type="checkbox" class="ccheckall">全选</li>
                    <li class="am-fl"><a href="javascript:;" class="all_move">修改分组</a></li>
                    <li class="am-fl"><a href="javascript:;" class="cdeleteall">删除</a></li>
                </ul>
            </div>
            <ul class="img-box-ul am-cf" style="overflow-y: auto;">
            </ul>
            <!-- 添加分页 -->
            <!-- <div class="am-u-sm-12 pl0 pr0 pro-btngroup-self">
                <div class="am-u-sm-12">
                    <?php
                    #echo $pagination;
                    ?>
                </div>
            </div>  -->
            <table class="am-table am-table-bordered" id="my-table" style="display: none;"></table>
        </div>
    </div>
</div>
<div class="am-modal am-modal-prompt" tabindex="-1" id="my-prompt">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">添加分类</div>
        <div class="am-modal-bd">
            请输入分类的名称
            <input type="text" class="am-modal-prompt-input" style="margin-right: 8px;">
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>提交</span>
        </div>
    </div>
</div>
<!-- <div class="am-modal am-modal-prompt" tabindex="-1" id="rename-prompt">
    <div class="am-modal-dialog">
        <div class="am-modal-bd">
            请输入新的名称
            <input id="filename" type="text" class="am-modal-prompt-input" style="margin-right: 8px;">
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>提交</span>
        </div>
    </div>
</div> -->
<!--添加分类-->
<!-- <div class="am-modal am-modal-prompt" tabindex="-1" id="my-prompt">
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
</div> -->
<div class="am-modal am-modal-confirm" tabindex="-1" id="rename-prompt">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">请输入新的名称</div>
    <div class="am-modal-bd">
      <input id="filename" type="text" class="am-modal-prompt-input">
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
    </div>
  </div>
</div>
<?php
$extra_js = array(
    '/app/form/view/bigidea/static/js/plupload.full.min.js',
    '/static/css/datatable/amazeui.datatables.min.js',
    '/spv3/sp/static/js/imgmanage.js',
);
?>
