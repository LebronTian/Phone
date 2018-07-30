
$(document).ready(function(){
    var nav_num = $('.first_ul').find('.first_li').length;
    var li_width = parseInt(948/nav_num);
    $('.first_li').css({'width':li_width+'px'});
    

});


  var cheight=$(window).height();
  if(cheight<694){
    $('.main_content').css('margin','0');
  }
  else{
    var halflight = (cheight-693-20)/2;
    $('.main_content').css('margin-top',halflight+'px');
    $('.main_content').css('margin-bottom',halflight+'px');

  }

$('.search_box').focus(function(){
        $(this).css('border','thin solid #2CBAEA');
      $('.search_pic').css({'border':'thin solid #2CBAEA','border-left':'0'});
});

$('.search_box').blur(function(){
      $(this).css('border','thin solid #E0DFDD');
      $('.search_pic').css({'border':'thin solid #E0DFDD','border-left':'0'});
});

$('.search_pic').click(function(){
    var key = $('.search_box').val();
    if($.trim(key)!="")
      window.location.href="?_a=site&_u=index.search&key="+key;
    else
      alert('搜索内容不能为空');
});


$('.btn_weixin').click(function(){
    if($('.header_box').find('.btn_login').length)
    {
      $('.login_bg_box').show();
      return;
    }

    var cheight=$(window).height();
    $('.message_box').css('margin',(cheight-300)/2+'px auto');
    $('.message_bg').show();
});
$(".message_box").click(function (e) { 
e.stopPropagation();//阻止事件向上冒泡 
}); 
$('.message_bg').click(function(){
    $('.message_bg').hide();
  })

$('.btn_erweima').mouseenter(function(){
    $(this).attr('src','/app/site/view/website/static/images/blue_erweima.png')
    $('.erweima_pic').slideToggle();
});
$('.btn_erweima').mouseleave(function(){
    $(this).attr('src','/app/site/view/website/static/images/pink_erweima.png')
    $('.erweima_pic').slideToggle();
})



$('.first_li').click(function(){
  if($(this).attr('data-uid')=='')
    window.location.href='?_a=site&_u=index.index&hides=2';
  else
    window.location.href='?_a=site&_u=index.cats&cid='+$(this).attr('data-uid');
})

$('.slide_btn_box>a').click(function(){
  $('.slide_btn_box>a').removeClass('btn_isclick');
  $(this).addClass('btn_isclick');
});


$('.detail_list ul li:first-child').children('.large_list').show();
$('.detail_list ul li:first-child').children('.small_list').hide();
$('.list_box_list ul li:first-child').children('.large_list').show();
$('.list_box_list ul li:first-child').children('.small_list').hide();

$('.detail_list ul li').mouseenter(function(){
  $(this).siblings('li').children('.large_list').hide();
  $(this).siblings('li').children('.small_list').show();
  $(this).children('.large_list').show();
  $(this).children('.small_list').hide();
});

$('.list_box_list ul li').live('mouseenter',function(){
  $(this).siblings('li').children('.large_list').hide();
  $(this).siblings('li').children('.small_list').show();
  $(this).children('.large_list').show();
  $(this).children('.small_list').hide();
});

$('.brief_close').click(function(){
      $('.brief_bg_box').attr('id','is-hide');
      $('.brief_bg_box').css('display','none');
   });

$('.brief_open').click(function(){
    var article_id=$(this).attr('data-id'); 
    window.open('?_a=site&_u=index.article&cid='+article_id);
});

$('.mobile_index').mouseenter(function(){
  $('.wap_erweima').slideToggle();
});
$('.mobile_index').mouseleave(function(){
  $('.wap_erweima').slideToggle();
});


$('.detail_list ul li').click(function(){
  window.open($(this).attr('data-src'));
});

$('.btn_register').click(function(){
    $('.rg_link').click();
  $('.login_bg_box').show();

});

(function($) {
    $.extend({
        myTime: {
            /**
             * 当前时间戳
             * @return <int>        unix时间戳(秒)  
             */
            CurTime: function(){
                return Date.parse(new Date())/1000;
            },
            /**              
             * 时间戳转换日期              
             * @param <int> unixTime    待时间戳(秒)              
             * @param <bool> isFull    返回完整时间(Y-m-d 或者 Y-m-d H:i:s)              
             * @param <int>  timeZone   时区              
             */
            UnixToDate: function(unixTime, isFull, timeZone) {
                if (typeof (timeZone) == 'number')
                {
                    unixTime = parseInt(unixTime) + parseInt(timeZone) * 60 * 60;
                }
                var time = new Date(unixTime * 1000);
                var ymdhis = "";
                ymdhis += time.getUTCFullYear() + "-";
                ymdhis += (time.getUTCMonth()+1) + "-";
                ymdhis += time.getUTCDate();
                if (isFull === true)
                {
                  if(time.getUTCHours()<10)
                    ymdhis += " 0" + time.getUTCHours() + ":";
                  else
                  ymdhis += " " + time.getUTCHours() + ":";
                  if(time.getUTCMinutes()<10)
                  ymdhis += "0"+time.getUTCMinutes() + ":";
                  else
                    ymdhis += time.getUTCMinutes() + ":";
                  if(time.getUTCSeconds()<10)
                  ymdhis += "0"+time.getUTCSeconds();
                  else
                    ymdhis += time.getUTCSeconds();
                }
                return ymdhis;
            }
        }
    });
})(jQuery);



$('.box_hide').live('click',function(){
  $('.back_top').show();
});
$('.box_show').live('click',function(){
  $('.back_top').hide();
});

$('.btn_login').click(function(){
  var account=$('.account').val();
  var password=$('.password').val();
  if($.trim(account)==''){
    alert('账号不能为空');
    return;
  }
  if($.trim(password)==''){
    alert('密码不能为空');
    return;
  }
  var data = {account:account,password:password}
        $.post('?_a=su&_u=ajax.login', data, function(ret){
            ret =JSON.parse(ret);
            console.log(ret);
            if(ret.errno==0){
                window.location.reload();
            }else{
                alert("账号或者密码填写错误");
                $('.account').attr('value','');
                $('.password').attr('value','');
            }
        });

});


$('.btn_cancel').live('click',function(){
  $.get('?_a=su&_u=index.logout');
  window.location.reload();
});




function Save() {
        if ($(".rmb_user").is(":checked")) {
            var str_account = $("#account").val();
            $.cookie("rmbUser", "true", { expires: 7 }); //存储一个带7天期限的cookie
            $.cookie("account", str_account, { expires: 7 });
        }
        else {
            $.cookie("rmbUser", "false", { expire: -1 });
            $.cookie("username", "", { expires: -1 });
        }
    };
  //判断是否记住密码
    $(document).ready(function(){
    if ($.cookie("rmbUser") == "true"){
        $("#ck_rmbUser").attr("checked", true);
        $("#account").val($.cookie("account"));
        }
});

$('#login_btn').click(function(){
  var account=$('#account').val();
  var password=$('#password').val();
  if($.trim(account)==''){
    $('#account').val('');
    $('#account').attr('placeholder','账号不能为空');
    return;
  }
  if($.trim(password)==''){
    $('#password').val('');
    $('#password').attr('placeholder','用户名不能为空');
    alert('密码不能为空');
    return;
  }
  var data = {account:account,password:password}
        $.post('?_a=su&_u=ajax.login', data, function(ret){
            ret =JSON.parse(ret);
            console.log(ret);
            if(ret.errno==0){
                $('.header_input ').remove();
                $('.btn_login').remove();
                $('.btn_register').remove();
                $('.qq').remove();
                $('.sina').remove();
                $('.header_title').after('<div class="header_input ">欢迎您 '+account+'</div><button class="btn_cancel">退出</button>');
                $('.login_bg_box').hide();
                var status=$('.login_bg_box').attr('data-from');
                if(status=='1'){
                  $('.toggle_box').click();
                }
            }else{
                alert("账号或者密码填写错误");
                $('.account').attr('value','');
                $('.password').attr('value','');
            }
        });

})

$('.rg_btn').click(function(){
    var account=$('.rg_account').val();
    var password=$('.rg_psd').val();
    var repassword=$('.rg_repsd').val();
    var phone=$('.rg_phone').val();
    var email=$('.rg_email').val();

    if($.trim(account)=='')
    {
      $('.rg_account').val('');
      $('.rg_account').attr('placeholder','用户名不能为空');
      return;
    }
    if($.trim(password)=='')
    {
      $('.rg_psd').val('');
      $('.rg_psd').attr('placeholder','密码不能为空');
      return;
    }
    if($.trim(repassword)=='')
    {
      $('.rg_repsd').val('');
      $('.rg_repsd').attr('placeholder','密码不能为空');
      return;
    }
    if(password!=repassword){
      $('.rg_repsd').val('');
      $('.rg_repsd').attr('placeholder','2次输入的密码必须相同');
      return;
    }
    var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
    if(!reg.test($('.rg_phone').val())){
      $('.rg_phone').val('');
      $('.rg_phone').attr('placeholder','请输入合法手机号码');
      return;
    }
    if($.trim(email)==''){
      $('.rg_email').val('');
      $('.rg_email').attr('placeholder','邮箱不能为空');
    }
    var data={
      account:account,
      password:password,
    }
    
    $.post('?_a=su&_u=ajax.register',data,function(obj){
        obj = $.parseJSON(obj);
        console.log(obj);
        if(obj.errno == 0){
          var data = {account:account,password:password};
        $.post('?_a=su&_u=ajax.login', data, function(ret){
            ret =JSON.parse(ret);
            console.log(ret);
            if(ret.errno==0){
                $('.header_input ').remove();
                $('.btn_login').remove();
                $('.btn_register').remove();
                $('.qq').remove();
                $('.sina').remove();
                $('.header_title').after('<div class="header_input ">欢迎您 '+account+'</div><button class="btn_cancel">退出</button>');
                $('.login_bg_box').hide();
            }
          });
        }else{
          alert('注册失败');
          //window.location.reload();
          return false;
        }
      })

});







  $('#account').focus(function(){
    $('.ac_pic').css('border-color','#2cbaea');
    $(this).css('border-color','#2cbaea');
  });
  $('#account').blur(function(){
    $('.ac_pic').css('border-color','#D4D4D4');
    $(this).css('border-color','#D4D4D4');
  });
  $('#password').focus(function(){
    $('.psd_pic').css('border-color','#2cbaea');
    $(this).css('border-color','#2cbaea');
  });
  $('#password').blur(function(){
    $('.psd_pic').css('border-color','#D4D4D4');
    $(this).css('border-color','#D4D4D4');
  });
    $('.verify_code').focus(function(){
    $(this).css('border-color','#2cbaea');
  });
  $('.verify_code').blur(function(){
    $(this).css('border-color','#D4D4D4');
  });
  $('.rg_link').click(function(){
    $('.login_box').hide();
    $('.register_box').show();
  });


$('.login_close').click(function(){
  if($('.header_box').find('.btn_login').length>0)
    $('.brief_close').click();
  $('.login_bg_box').hide();
});





$('.search_box').keydown(function(event){
    if(event.keyCode==13){ 
$(".search_pic").click(); 
} 
});

