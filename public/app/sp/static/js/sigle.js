
$(function(){

	//标题栏输入
	$('.s_frm_input_tit').keyup(function(){
		$('.s_title').text($(this).val());
		if($(this).val()==""){
			$('.s_title').text('标题');
		}
	})

	$('.s_frm_input_author').keyup(function(){
		
	})

	$('.s_frm_input_link').keyup(function(){
		
	})


	//摘要栏输入
	$('.s_frm_textarea').keyup(function(){
		$('.s_appmsg_desc').text($(this).val());
	})



	$('#s_codeImgBox .delete_img').click(function(){
		$('#s_codeImgBox').find('img').attr('src','');
		$('#s_codeImgBox').hide();
		$('.s_fm_h').css('height','95px');
        $('.s_appmsg_thumb_wrp').find('img').attr('src','');
	})


})

	