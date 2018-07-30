
$(function(){
var classify_width


$(document).ready(function(){
    classify_width=$('.classify_detail').children('ul').children('li').css('width');
    $('.classify_detail').css('right',-parseInt(classify_width)+'px');
});

    var html = "";
    html+='<div class="share_box"><div><div class="share_img" >'
        +'<img id="tenxun" src="/app/site/view/eyeis/static/images/tengxun.png">'
        +'</div><div class="share_img"><img id="qqzone"'
        +'src="/app/site/view/eyeis/static/images/qqzone.png"></div>'
        +'<div class="share_img"><img id="renren" '
        +'src="/app/site/view/eyeis/static/images/renren.png"></div>'
        +'<div class="share_img"><img id="sina" '
        +'src="/app/site/view/eyeis/static/images/sina.png"></div>'
        +'<div class="share_img"><img id="weixin" '
        +'src="/app/site/view/eyeis/static/images/weixin.png"></div>'
        +'<div class="share_img"><img id="wxline" '
        +'src="/app/site/view/eyeis/static/images/wxline.png"></div></div>'
        +'<button class="cancel_share">取&nbsp;&nbsp;&nbsp;消</button></div>';
    $('body').append(html);
    var img_width= $('.share_img').css('width');
    $('.share_img').css('height',img_width/2);
    var num=parseInt($('.share_img').length);
    share_height = parseInt(img_width)/2*Math.ceil(num/4)+50;
    $('.share_box').css('height',share_height+'px');
    $('.share_box').css('bottom','-'+share_height+'px');



$('.cancel_share').click(function(){
    $('.share_box').animate({bottom:-share_height},300);
    });


$('.all_share').click(function(){
          $('.share_box').animate({bottom:0},300);
        var title = $(this).attr("data-title");
        var link = window.location.protocol + '//' + window.location.host + $(this).attr('data-url');
        var img = $(this).attr('data-img');

        if(img.substring(0,4)!="http")
            var img = window.location.protocol + '//' + window.location.host + img;
        console.log(img)
        do_share({url: link, title: title, pic: img});
    });

function do_share(data) {
        var shareUrl = {
            sina : 'http://service.weibo.com/share/share.php?url={url}&title={title}&pic={pic}',
            renren : 'http://widget.renren.com/dialog/share?resourceUrl={url}&srcUrl={url}&title={title}&pic={pic}',
            tenxun : 'http://share.v.t.qq.com/index.php?c=share&a=index&url={url}&title={title}&pic={pic}',
            qqzone : 'http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url={url}&pics={pic}&title={title}'
        };
        console.log(data);
        for(var sns in shareUrl){
            $("#"+sns).click(function(){
                sns = $(this).attr("id");
                var url = shareUrl[sns];
                for(var k in data){
                    var re = new RegExp("{"+k+"}","g");
                    url = url.replace(re, encodeURIComponent(data[k]));
                }
                console.log(url)
                window.location.href = url;
            });
        }
    }

$('.un_click').click(function(){
    console.log(classify_width);
    $('.classify_detail').animate({right:parseInt($('.classify_detail').css('right'))==0 ? -parseInt(classify_width) : 0},300);
});



});




