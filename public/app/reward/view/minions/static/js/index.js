  window.onload=function(){
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
    $('.minion1').attr('id','minion_show');
    setTimeout(function(){func()},1000)
    function func(){
 //     $('body').append('<audio autoplay="autoplay" id="media" src="/app/reward/view/minions/static/images/drop.mp3"></audio>');
      $('.minion2').attr('id','minion_show2');
      setInterval("$('.minion2').css({'bottom':'30px'})",1000);
    }
    setInterval("$('.open_box').attr('id','box_show');$('.open_box').css({'top':'50px'})",2000);
    setInterval("$('.open').attr('id','open_rotate')",3000);
  }
	$('.open').click(function(){
    var r_uid=$(this).attr('data-ruid')
		window.location.href="?_a=reward&_u=index.active&r_uid="+r_uid;
});