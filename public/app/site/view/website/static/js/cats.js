var code;

$(document).ready(function(){

setTimeout(function(){

  if($('.cats_box').attr('data-type')=='list'){
  var div_num=$('.cats_box>div').length;
   if(div_num==1){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
   }
   if(div_num==2){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
    ajaxlist($('.cat2 .list_box_list ul'),$('.cat2').attr('data-uid'),0);
   }
   if(div_num==3){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
    ajaxlist($('.cat2 .list_box_list ul'),$('.cat2').attr('data-uid'),0);
    ajaxlist($('.cat3 .list_box_list ul'),$('.cat3').attr('data-uid'),0);
   }
   if(div_num==4){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
    ajaxlist($('.cat2 .list_box_list ul'),$('.cat2').attr('data-uid'),0);
    ajaxlist($('.cat3 .list_box_list ul'),$('.cat3').attr('data-uid'),0);
    ajaxlist($('.cat4 .list_box_list ul'),$('.cat4').attr('data-uid'),0);
   }
   if(div_num==5){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
    ajaxlist($('.cat2 .list_box_list ul'),$('.cat2').attr('data-uid'),0);
    ajaxlist($('.cat3 .list_box_list ul'),$('.cat3').attr('data-uid'),0);
    ajaxlist($('.cat4 .list_box_list ul'),$('.cat4').attr('data-uid'),0);
    ajaxlist($('.cat5 .list_box_list ul'),$('.cat5').attr('data-uid'),0);
   }
   if(div_num==6){
    ajaxlist($('.cat1 .list_box_list ul'),$('.cat1').attr('data-uid'),0);
    ajaxlist($('.cat2 .list_box_list ul'),$('.cat2').attr('data-uid'),0);
    ajaxlist($('.cat3 .list_box_list ul'),$('.cat3').attr('data-uid'),0);
    ajaxlist($('.cat4 .list_box_list ul'),$('.cat4').attr('data-uid'),0);
    ajaxlist($('.cat5 .list_box_list ul'),$('.cat5').attr('data-uid'),0);
    ajaxlist($('.cat6 .list_box_list ul'),$('.cat6').attr('data-uid'),0);
   }
}

},1000);


if($('.cats_box').attr('data-type')=='article'){
  $('.article_img').adipoli({
    'startEffect' : 'transparent',
    'hoverEffect' : 'boxRandom'
  });
}





});
if($('.cats_box').attr('data-type')=='list'){
if($('.footer_nav').attr('data-IE')==2){
  var div_num=$('.cats_box>div').length;
  if(div_num==1){
  cubeinit($('.cat1>#te-wrapper'));
  }
  if(div_num==2){
  cubeinit($('.cat1>#te-wrapper'));
  cubeinit($('.cat2>#te-wrapper'));
  }
  if(div_num==3){
  cubeinit($('.cat1>#te-wrapper'));
  cubeinit($('.cat2>#te-wrapper'));
  cubeinit($('.cat3>#te-wrapper'));
  }
  if(div_num==4){
  cubeinit($('.cat1>#te-wrapper'));
  cubeinit($('.cat2>#te-wrapper'));
  cubeinit($('.cat3>#te-wrapper'));
  cubeinit($('.cat4>#te-wrapper'));
  }
  if(div_num==5){
  cubeinit($('.cat1>#te-wrapper'));
  cubeinit($('.cat2>#te-wrapper'));
  cubeinit($('.cat3>#te-wrapper'));
  cubeinit($('.cat4>#te-wrapper'));
  cubeinit($('.cat5>#te-wrapper'));
  }
  if(div_num==6){
  cubeinit($('.cat1>#te-wrapper'));
  cubeinit($('.cat2>#te-wrapper'));
  cubeinit($('.cat3>#te-wrapper'));
  cubeinit($('.cat4>#te-wrapper'));
  cubeinit($('.cat5>#te-wrapper'));
  cubeinit($('.cat6>#te-wrapper'));
  }
}
else{
  var div_num=$('.cats_box>div').length;

  if(div_num==1)
  {
    $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img1').animate({width:'0px',height:'0px',left:'550',top:'273px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img1').animate({width:'1100px',height:'547px',left:'0px',top:'0px'},1000);
  });
  }
  if(div_num==2){
  $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img2').animate({width:'0px',height:'0px',left:'273px',top:'273px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img2').animate({width:'546px',height:'547px',left:'0px',top:'0px'},1000);
  });

   $('.cat2').mouseenter(function(){
    $('.cat2>.cat_img2').animate({width:'0px',height:'0px',left:'273px',top:'273px'},1000);
  });
  $('.cat2').mouseleave(function(){
    $('.cat2>.cat_img2').animate({width:'546px',height:'547px',left:'0px',top:'0px'},1000);
  });
  }

  if(div_num==3){
  $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img3').animate({width:'0px',height:'0px',left:'180px',top:'273px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img3').animate({width:'360px',height:'547px',left:'0px',top:'0px'},1000);
  });
  $('.cat2').mouseenter(function(){
      $('.cat2>.cat_img3').animate({width:'0px',height:'0px',left:'180px',top:'273px'},1000);
  });
  $('.cat2').mouseleave(function(){
    $('.cat2>.cat_img3').animate({width:'360px',height:'547px',left:'0px',top:'0px'},1000);
  });
  $('.cat3').mouseenter(function(){
      $('.cat3>.cat_img3').animate({width:'0px',height:'0px',left:'180px',top:'273px'},1000);
  });
  $('.cat3').mouseleave(function(){
    $('.cat3>.cat_img3').animate({width:'360px',height:'547px',left:'0px',top:'0px'},1000);
  });
  }
  if(div_num==4){
    $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img4').animate({width:'0px',height:'0px',left:'180px',top:'273px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img4').animate({width:'360px',height:'547px',left:'0px',top:'0px'},1000);
  });

   $('.cat2').mouseenter(function(){
    $('.cat2>.cat_img4').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat2').mouseleave(function(){
    $('.cat2>.cat_img4').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
    $('.cat3').mouseenter(function(){
      $('.cat3>.cat_img4').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat3').mouseleave(function(){
    $('.cat3>.cat_img4').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
   $('.cat4').mouseenter(function(){
    $('.cat4>.cat_img4').animate({width:'0px',height:'0px',left:'365px',top:'134px'},1000);
  });
  $('.cat4').mouseleave(function(){
    $('.cat4>.cat_img4').animate({width:'730px',height:'268px',left:'0px',top:'0px'},1000);
  });
  }
  if(div_num==5){
    $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img5').animate({width:'0px',height:'0px',left:'180px',top:'273px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img5').animate({width:'360px',height:'547px',left:'0px',top:'0px'},1000);
  });

   $('.cat2').mouseenter(function(){
    $('.cat2>.cat_img5').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat2').mouseleave(function(){
    $('.cat2>.cat_img5').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
    $('.cat3').mouseenter(function(){
      $('.cat3>.cat_img5').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat3').mouseleave(function(){
    $('.cat3>.cat_img5').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });

   $('.cat4').mouseenter(function(){
    $('.cat4>.cat_img5').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat4').mouseleave(function(){
    $('.cat4>.cat_img5').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
    $('.cat5').mouseenter(function(){
      $('.cat5>.cat_img5').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat5').mouseleave(function(){
    $('.cat5>.cat_img5').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });

  }
  if(div_num==6){
    $('.cat1').mouseenter(function(){
      $('.cat1>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat1').mouseleave(function(){
    $('.cat1>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });

   $('.cat2').mouseenter(function(){
    $('.cat2>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat2').mouseleave(function(){
    $('.cat2>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
    $('.cat3').mouseenter(function(){
      $('.cat3>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat3').mouseleave(function(){
    $('.cat3>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });

   $('.cat4').mouseenter(function(){
    $('.cat4>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat4').mouseleave(function(){
    $('.cat4>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
    $('.cat5').mouseenter(function(){
      $('.cat5>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat5').mouseleave(function(){
    $('.cat5>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });

   $('.cat6').mouseenter(function(){
    $('.cat6>.cat_img6').animate({width:'0px',height:'0px',left:'180px',top:'130px'},1000);
  });
  $('.cat6').mouseleave(function(){
    $('.cat6>.cat_img6').animate({width:'360px',height:'268px',left:'0px',top:'0px'},1000);
  });
  }
}
}












$('.btn_pre').click(function(){
  if($('.btn_list1').attr('id')=='list_isclick'){
    $('.first_ul').children('li:last-child').click();
  }
  else
  window.location.href='?_a=site&_u=index.cats&hides=1&cid='+$('#list_isclick').prev('li').attr('data-uid');
});
$('.btn_next').click(function(){
  if($('.first_ul').children('li:last-child').attr('id')=='list_isclick'){
    $('.btn_list1').click();
  }
  else
  window.location.href='?_a=site&_u=index.cats&cid='+$('#list_isclick').next('li').attr('data-uid');
});

window.onload=function(){
var hides=$('.footer_nav').attr('data-hides');
if(hides!=1)$('.cats_box').show();
}


if($('.cats_box').attr('data-type')=='article'){
  $('.cats_box>div').click(function(){
    var uid=$(this).attr('data-id');
    var link='?_a=site&_u=ajax.article&uid='+uid;
    $.getJSON(link,function(data){
        console.log(data.data);
        $('.content_brief').html(data.data.content);
        $('.brief_open').attr('data-id',data.data.uid);
        $('.box_title').text(data.data.title);
    });
      $('.brief_bg_box').attr('id','is-show');
      $('.brief_bg_box').show();
  })
}



$('.close_cat').click(function(){
  $('.cats_box').hide();
});
$('.know_more').click(function(){
  $('.cats_box').show();
})


$('.box_hide').live('click',function(){
    $('.slide_box').slideToggle();
    $(this).addClass('box_show');
    $(this).removeClass('box_hide');
    $('.toggle_box').children('img').attr('src','/app/site/view/eyeispc/static/images/top.png');
            setTimeout(function(){
          window.location.href='#footer_nav';
        },300);
  });
  $('.box_show').live('click',function(){
    $('.slide_box').slideToggle();
    $(this).addClass('box_hide');
    $(this).removeClass('box_show');
    $('.toggle_box').children('img').attr('src','/app/site/view/eyeispc/static/images/bottom.png')
  });



$('.list_box_list>ul>li').live('click',function(){
    var uid=$(this).attr('data-uid');
    var link='?_a=site&_u=ajax.article&uid='+uid;
    $.getJSON(link,function(data){
        console.log(data.data);
        $('.content_brief').html(data.data.content);
        $('.brief_open').attr('data-id',data.data.uid);
        $('.box_title').text(data.data.title);
    });
      $('.brief_bg_box').attr('id','is-show');
      $('.brief_bg_box').show();
});

$(' .list_page_nav ul li').live('click',function(){
  var pagenumber = parseInt($(this).text())-1;
  var ele = $(this).parent().parent().parent().siblings('.list_box_list').children('ul');
  var uid = $(this).parent().parent().parent().attr('data-id');
  ajaxlist(ele,uid,pagenumber);
});
$('.list_page_nav .page_first').live('click',function(){
  var pagenumber = parseInt($(this).text())-1;
  var ele = $(this).parent().siblings('.list_box_list').children('ul');
  var uid = $(this).parent().attr('data-id');
  ajaxlist(ele,uid,0);
});
$('.list_page_nav .page_last').live('click',function(){
  var ele = $(this).parent().siblings('.list_box_list').children('ul');
  var uid = $(this).parent().attr('data-id');
    ajaxlist(ele,uid,$(this).parent().attr('data-pagenum')-1);
});






function ajaxlist(elm,uid,apage){
  var html='';
  var link='?_a=site&_u=ajax.article_list&cat_uid='+uid+'&limit=12&page='+apage;
  $.getJSON(link,function(data){

    var pagenow=apage+1;
    var pagenum=Math.ceil(data.data.count/12);
    elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').children('li').remove();
    elm.parent().siblings('.list_page_nav').attr('data-pagenum',pagenum);
    if(pagenum<=7){
      for(var i=1;i<=pagenum;i++){
        if(i==pagenow)
            elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li class="now_page">'+i+'</li>');
        else
         elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li>'+i+'</li>');
      }  
    }
    if(pagenum>7){
        if(pagenow+3<=7){
          for(var i=1; i<=7;i++){
            if(i==pagenow)
            elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li class="now_page">'+i+'</li>');
            else
            elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li>'+i+'</li>');
          }
        }
        if(pagenow+3>7){
          if(pagenow+3>pagenum){
            for(var i=pagenum-6;i<=pagenum;i++){
              if(i==pagenow)
                elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li class="now_page">'+i+'</li>');
              else
              elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li>'+i+'</li>');
            }
          }


          if(pagenow+3<=pagenum)
          {
            for(var i=pagenow-3;i<=pagenow+3;i++){
              if(i==pagenow)
               elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li class="now_page">'+i+'</li>');
              else
               elm.parent().siblings('.list_page_nav').children('.page_box').children('ul').append('<li>'+i+'</li>');
            }
          }
        }
    }



    var data = data.data.list;
    console.log(data);
    $.each(data, function () {
      html+='<li data-uid="'
          +this.uid
          +'"><div class="small_list"><span>['
          +$.myTime.UnixToDate(this.create_time)
          +']</span>'
          +this.title
          +'</a></div><div class="large_list"><img src="'
          +this.image
          +'" style="float:left;"><div class="large_list_title" title="'
          +this.title
          +'">' 
          +this.title
          +'</div><div class="large_list_brief">'
          +this.digest
          +'</div></div></li>';
    });
    elm.children('li').remove();
    elm.append(html);
  });
}








