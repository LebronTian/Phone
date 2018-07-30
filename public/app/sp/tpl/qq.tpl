<?php return;?>
    <div class="contact_qq_box">
      <a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=407761858&site=qq&menu=yes"><img border="0" src="http://wpa.qq.com/pa?p=2:407761858:53" alt="联系我们" title="联系我们"/></a>
      <!-- <a href="?_a=sp&_u=index.register">
        <img border="0" src="/app/web/static/images/free.png" alt="免费试用" title="免费试用">
      </a> -->
    <div class="left_box" data-type="0">
    <a title="查看在线客服" href="javascript:void(0);"><img src="/app/sp/static/images/open_qq.png"></a>
    </div>
      <button  class="free_btn">
        <!-- <img border="0" src="/app/web/static/images/free.png" alt="免费试用" title="免费试用"> -->
        免费试用
      </button>
    </div>
    
<style>
  .contact_qq_box{position:absolute;right:0;top:200px;z-index:1000;background-color:#F76A7A}
  .contact_qq_box>a{display:none}
  .contact_qq_box>a>img{margin-top:22px;height:136px}
  .contact_qq_box>.left_box{width:34px;float: left;position: relative;z-index: 1;margin-top: 21px;height: 160px;text-align:center;}
  .free_btn{height: 136px; width: 84px;margin-top: 21px;margin-right:5px;background: rgba(255,255,255,0.5); border-radius: 4px; padding: 0 5px; border: none;color: #333333;}
</style>

<script>
  $('.contact_qq_box>.left_box').click(function(){
  if($(this).attr('data-type')!='')
  {
    $(this).attr('data-type','');
    $(this).children('a').attr('title','关闭在线客服');
    $(this).children('a').children('img').attr('src','/app/sp/static/images/close_qq.png');
  }
  else{
    $(this).attr('data-type','0');
    $(this).children('a').attr('title','查看在线客服');
    $(this).children('a').children('img').attr('src','/app/sp/static/images/open_qq.png');
  }
  $('.contact_qq_box>a').toggle();
});
</script>


<!-- <div id="floatTools" class="rides-cs" style="height:208px;">
  <div class="floatL">
    <a style="display:block" id="aFloatTools_Show" class="btnOpen" title="查看在线客服" style="top:20px" href="javascript:void(0);">展开</a>
    <a style="display:none" id="aFloatTools_Hide" class="btnCtn" title="关闭在线客服" style="top:20px" href="javascript:void(0);">收缩</a>
  </div>
  <div id="divFloatToolsView" class="floatR" style="display: none;height:198px;width: 110px;">
    <div class="cn">
      <ul>
        <li><a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=2529270756&site=qq&menu=yes"><img style="display:inline-block;width:100%;" border="0" src="http://wpa.qq.com/pa?p=2:2529270756:53" alt="点击这里给我发消息" title="点击这里给我发消息"/></a> </li>
        <li><a target="_blank" class="free-btn" href="?_a=sp&_u=index.register">免费试用</a> </li>
      </ul>
    </div>
  </div>
</div> -->

<style type="text/css">
  /*QQ在线咨询*/
  /*.free-btn{ 
    display: inline-block; 
    width: 100%; 
    height: 30px; 
    line-height: 25px; 
    text-align: center; 
    font-size: 14px;
    color: #d9eef7;
    border: solid 1px #0076a3;
    background: #0095cd;
    background: -webkit-gradient(linear, left top, left bottom, from(#00adee), to(#0078a5));
  }
  .rides-cs {  font-size: 12px; background-color: #F76A7A; position: fixed; top: 200px; right: 0px; _position: absolute; z-index: 9999; border-radius:6px 0px 0 6px;}
  .rides-cs .floatL { width: 36px; float:left; position: relative; z-index:1;height: 181px;}
  .rides-cs .floatL a { font-size:0; text-indent: -999em; display: block;}
  .rides-cs .floatR { width: 130px; float: left; padding: 5px; overflow:hidden;}
  .rides-cs .floatR .cn {margin-top:5px;}
  .rides-cs .cn .titZx{ font-size: 14px; color: #333;font-weight:600; line-height:24px;padding:5px;text-align:center;}
  .rides-cs .cn ul {padding:0px;}
  .rides-cs .cn ul li span { color: #777;}
  .rides-cs .cn ul li a{color: #FFF;}
  .rides-cs .cn ul li a:hover{ color: #FFF;}
  .rides-cs .cn ul li img { vertical-align: middle;}
  .rides-cs .btnOpen, .rides-cs .btnCtn {  position: relative; z-index:9; top:25px; left: 0;  background-image: url(/app/shop/view/ugoods/static/images/shopnc.png); background-repeat: no-repeat; display:block;  height: 146px; padding: 8px;}
  .rides-cs .btnOpen { background-position: -410px -5px;}
  .rides-cs .btnCtn { background-position: -450px -5px;}
  .rides-cs ul li.top { border-bottom: solid #ACE5F9 1px;}
  .rides-cs ul li.bot { border-bottom: none;}*/
</style>

<script type="text/javascript">
  //qq在线咨询
/*$(document).ready(function(){

    $("#aFloatTools_Show").click(function(){
        $('#divFloatToolsView').animate({width:'show',opacity:'show'},100,function(){$('#divFloatToolsView').show();});
        $('#aFloatTools_Show').hide();
        $('#aFloatTools_Hide').show();              
        });
    $("#aFloatTools_Hide").click(function(){
        $('#divFloatToolsView').animate({width:'hide', opacity:'hide'},100,function(){$('#divFloatToolsView').hide();});
        $('#aFloatTools_Show').show();
        $('#aFloatTools_Hide').hide();  
    });

});*/
</script>








