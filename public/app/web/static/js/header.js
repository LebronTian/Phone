$(document).ready(function(){

	$('.headNav').find('.select_li').hover(function(){
		$(this).children('.select_menu').show();
	},function(){
		$(this).children('.select_menu').hide();
	});

	function getUrlParam(name) {  
	   var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
	   var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
	   if (r != null) return unescape(r[2]); return null; //返回参数值  
	}  
	var part=getUrlParam('part');
	//console.log(part);
	if(part=="1"){
		console.log('llllll')
		$('.partnership_link').children('a').css('color','#0e90d2');
		$('#footer_bar,.foot_info').css('background-color','#f1f1f1');
	}

	var about=getUrlParam('about');
	console.log(joinus);
	if(about=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.about').css('color','#0e90d2');
	}

	var joinus=getUrlParam('joinus');
	if(joinus=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.joinus').css('color','#0e90d2');
	}

	var contact=getUrlParam('contact');
	if(contact=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.contact').css('color','#0e90d2');
	}

	var statement=getUrlParam('statement');
	if(statement=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.statement').css('color','#0e90d2');
	}

	var operate=getUrlParam('operate');
	if(operate=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.operate').css('color','#0e90d2');
	}

	var open_project=getUrlParam('open_project');
	if(open_project=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.open_project').css('color','#0e90d2');
	}

	var private_clouds=getUrlParam('private_clouds');
	if(private_clouds=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.private_clouds').css('color','#0e90d2');
	}

	var community=getUrlParam('community');
	if(community=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.community').css('color','#0e90d2');
	}

	var business_work=getUrlParam('business_work');
	if(business_work=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.business_work').css('color','#0e90d2');
	}

	var project=getUrlParam('project');
	if(project=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.project').css('color','#0e90d2');
	}

	var promote=getUrlParam('promote');
	if(promote=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.promote').css('color','#0e90d2');
	}

	var fund=getUrlParam('fund');
	if(fund=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.fund').css('color','#0e90d2');
	}

	var partner=getUrlParam('partner');
	if(partner=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.partner').css('color','#0e90d2');
	}

	var help=getUrlParam('help');
	if(help=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.help').css('color','#0e90d2');
	}

	var develop_document=getUrlParam('develop_document');
	if(develop_document=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.develop_document').css('color','#0e90d2');
	}

	var support=getUrlParam('support');
	if(support=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.support').css('color','#0e90d2');
	}

	var exhibition=getUrlParam('exhibition');
	if(exhibition=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.exhibition').css('color','#0e90d2');
	}

	var marketing=getUrlParam('marketing');
	if(marketing=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.marketing').css('color','#0e90d2');
	}

	var industry=getUrlParam('industry');
	if(industry=="1"){
		console.log('llllll')
		$('.meb_nav_box').find('a.industry').css('color','#0e90d2');
	}

	var customer = getUrlParam('customer');
	if(customer=='1'){
		$('.customer_link').children('a').css('color','#0e90d2');
	}

});