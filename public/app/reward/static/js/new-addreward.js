$(document).ready(function(){

	//百度富编辑器初始化
    var ue = UE.getEditor('container');
    var text;
	
	//初始化日期插件
	$('.form-datetime').datetimepicker({
		format: 'yyyy-mm-dd hh:ii',
		language:  'zh-CN',
		autoclose: true
	});
	
	//获取url参数
	function getUrlParam(name) {  
	   var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
	   var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
	   if (r != null) return unescape(r[2]); return null; //返回参数值  
	}
	var r_uid = getUrlParam('r_uid'); 
	r_uid = parseInt(r_uid);
	var uid = getUrlParam('uid'); 
	uid = parseInt(uid);  
	
	//初始化模板选择
	// var selected_tpl = '';
 //    if(rewards&&rewards.tpl){
 //        selected_tpl = rewards.tpl;
 //    }
    // $('.tpl-container').selectTpl({
    //     //url:'?_a=shop&_u=api.get_tpls',
    //     url:'?_a=reward&_u=api.get_tpls',
    //     selected:selected_tpl
    // });

    //数值检测 不能为负值
    $('input[type="number"]').blur(function(){
    	if($(this).val() < 0){
    		$(this).val('');
    		showTip('err','请输入正确数值',2000);
    	}
    });

	//活动开始，结束日期
	$('#reward-step-one').click(function(){
		
		if(rewards){
			$('#status-id').val(rewards.status);
			$('#must-login-id').val(rewards.access_rule.must_login);
		}

		ue.ready(function(){
            text = ue.getContent();
        });

		var uid = $(this).prev().val();
		var start_time = $('.start-time').val();
		var end_time = $('.end-time').val();
		/*start_time = start_time.replace(/-/g,'/');
		end_time = end_time.replace(/-/g,'/');
		start_date = new Date(start_time);
		end_date = new Date(end_time);
		start_str = start_date.getTime()/1000;
		end_str = end_date.getTime()/1000;*/
		//console.log(start_str,end_str);
		start_str = transdate(start_time);
		end_str = transdate(end_time);
		//console.log(start_str,end_str);return;
		if(end_str<start_str){
			showTip('err','活动结束时间不能大于开始时间',3000);
			$('.end-time').val('');
			return;
		}
		var activity_title = $('.activity-title').val();
		var activity_introduce = text;
		var max_item = parseInt($('#max_item').val());
		var max_cnt = parseInt($('#max_cnt').val());
		var max_cnt_day = parseInt($('#max_cnt_day').val());
		var status = parseInt($('#status-id').val());
		var must_login = $('#must-login-id').val();
		var tpl = $('.tpl-container').data('dir');
		var img = $('#id_img').attr('src');
		var data = {
			title : activity_title,
			brief : activity_introduce,
			status : status,
			tpl : tpl,
			img : img,
			'access_rule' : {
                'must_login': must_login,
                'start_time': start_str,
                'end_time': end_str,
                'max_item': max_item,
                'max_cnt': max_cnt,
                'max_cnt_day': max_cnt_day
            }
		};
		var data1 = {
			title : activity_title,
			brief : activity_introduce,
			status : status,
			tpl : tpl,
			img : img,
			'access_rule' : {
                'must_login': must_login,
                'start_time': start_str,
                'end_time': end_str,
                'max_item': max_item,
                'max_cnt': max_cnt,
                'max_cnt_day': max_cnt_day
            },
           	uid : uid
		};
		console.log(data1);
		//if(typeof(tpl)!='undefined'){console.log('aaddd')}
		//console.log($('.tpl-container').data('dir'));
		// return;
		if( activity_title && activity_introduce && start_str && end_str && img && !uid && typeof(tpl)!='undefined') {
			$.post('?_a=reward&_u=api.addreward',data,function(ret){
				ret = $.parseJSON(ret);
				console.log(ret);
				if(ret.errno==0){
					showTip('','设置成功',1000);
					setTimeout(function(){
						window.location.href = '?_a=reward&_u=sp.addreward_3&r_uid='+ret.data;
					},500);
				}else{
					showTip('err','设置失败',3000);
				}
			});
		}else if( activity_title && activity_introduce && start_str && end_str && img && uid && typeof(tpl)!='undefined'){
			$.post('?_a=reward&_u=api.addreward',data1,function(ret){
				ret = $.parseJSON(ret);
				console.log('aaaa',ret);
				if(ret.errno==0){
					showTip('','设置成功',1000);
					setTimeout(function(){
						window.location.href = '?_a=reward&_u=sp.addreward_3&r_uid='+ret.data;
					},500);
				}else{
					showTip('err','设置失败',3000);
				}
			});
		}else{
			showTip('err','请填写完整内容再提交',2000);
			return;
		}

	});

	$('#reward-step-two').click(function(){

		//window.location.href = '?_a=reward&_u=sp.addreward_3';

	});

	$('#reward-step-three').click(function(){
		for(var i=1;i<$('.reward-setting').length;i++) {
			var uid = parseInt($('.reward-setting:eq('+i+')').find('input[type="hidden"]').val());
			var title = $('.reward-setting:eq('+i+')').find('input[type="text"]:eq(0)').val();
			var img = $('.reward-setting:eq('+i+')').find('img').attr('src');
			var total_cnt = parseInt($('.reward-setting:eq('+i+')').find('input[type="number"]:eq(0)').val());
			var weight = parseFloat($('.reward-setting:eq('+i+')').find('input[type="number"]:eq(1)').val())*100;
			var data = {
				title : title,
				total_cnt : total_cnt,
				img : img,
				weight : weight,
				r_uid : r_uid
			};
			var data1 = {
				title : title,
				total_cnt : total_cnt,
				img : img,
				weight : weight,
				r_uid : r_uid,
				uid : uid
			};
			/*console.log('000',data);
			console.log('111',data1);
			return;*/
			console.log(title)
			if(data.title && data.total_cnt && data.img && !uid){
				//console.log('data',data);return;
				$.post('?_a=reward&_u=api.addrewarditem',data,function(ret){
					ret = $.parseJSON(ret);
					console.log(ret);
					if(ret.errno==0){
						showTip('','设置成功',1000);
						setTimeout(function(){
							window.location.href = '?_a=reward&_u=sp.addreward_5&uid='+r_uid;
						},500);
					}
				});
			}else if(data1.title && data1.total_cnt && data1.img && data1.uid){
				//console.log('data1',data1);return;
				$.post('?_a=reward&_u=api.addrewarditem',data1,function(ret){
					ret = $.parseJSON(ret);
					console.log(ret);
					if(ret.errno==0){
						showTip('','设置成功',1000);
						setTimeout(function(){
							window.location.href = '?_a=reward&_u=sp.addreward_5&uid='+r_uid;
						},500);
					}
				});
			}else{
				showTip('err','请填写完整内容再提交',2000);
				return;
			}
		}
		//window.location.href = '?_a=reward&_u=sp.addreward_4';
	});

	$('#reward-step-four').click(function(){
		//window.location.href = '?_a=reward&_u=sp.addreward_5';
	});


	$('#reward-save-btn').on('click',function(){
		var status = $('#id_status').prop('checked') ? 0 : 1;
        var must_login = $('#id_must_login').prop('checked') ? true : false;
		var start_time = parseInt($('.start-time').attr('data-time'));
		var end_time = parseInt($('.end-time').attr('data-time'));
		var max_item = parseInt($('.other-setting:eq(2)').find('input[type="number"]').val());
		var max_cnt = parseInt($('.other-setting:eq(1)').find('input[type="number"]').val());
		var max_cnt_day = parseInt($('.other-setting:eq(0)').find('input[type="number"]').val());
		var win_rule_type=$('#id_win_rule_type').val();
		var share_title = $('#id-share-title').val();
		var business_info = $('#id-business-info').val();
		var tpl = $('#reward-tpl-id').val();
		
		switch (win_rule_type)
		{
			case "none":
				win_rule_data='';
				win_rule_type='';
			break;
			case "form":
				win_rule_data=$('#id_win_rule_form').val();
			break;
			case "url":
			var win_rule_data=$('#id_win_rule_url').val();
			break;
			
		}
		var data = {
			status : status,
			tpl : tpl,
			'access_rule' : {
                'must_login': must_login,
                'start_time': start_time,
                'end_time': end_time,
                'max_item': max_item,
                'max_cnt': max_cnt,
                'max_cnt_day': max_cnt_day
            },
            uid : uid,
            'win_rule':{
				'type':win_rule_type,
				'data':win_rule_data,
				'title':share_title,
				'info':business_info
			}
		};

		console.log(data);
		$.post('?_a=reward&_u=api.addreward',data,function(ret){
			ret = $.parseJSON(ret);
			console.log(ret);
			if(ret.errno==0){
				showTip('','设置成功',1000);
				setTimeout(function(){
					window.location.href = '?_a=reward&_u=sp';
				},500);
			}else{
				showTip('err','设置失败',3000);
			}
		});
	});


	

	//删除图片
	$('#delete-img').click(function(){
		$('#my-confirm').modal({
	        relatedTarget: this,
	        onConfirm: function(options) {
	          	$('.reward-img').find('img').attr('src','0');
				$('#detail-info-img').attr('src','0');
	        },
	        // closeOnConfirm: false,
	        onCancel: function() {
	         
	        }
		});
	});

	//奖品添加
	var index = $('.reward-setting').length-2;
	$('#add-award-btn').click(function(){
		if(index>8){
			showTip('err','最多添加8个奖项设置',3000);
			return;
		}
		var html = '';
		var award_text = '';
		var award_level = '';
		index++;
		console.log(index);
		html+='<div class="am-u-sm-12 reward-setting"><div class="am-u-sm-4">'
			+'<div class="am-u-sm-12" style="padding:0;"><input type="text" value="" placeholder="'
			+award_level
			+'"></div></div><div class="am-u-sm-2 select-img-bar"><img src="/app/reward/static/images/reward.png"><a href="javascript:;" class="imgBoxBtn" data-id="'
			+(index+1)
			+'">选择图片</a></div><div class="am-u-sm-2"><input type="number" value="1" placeholder=""></div><div class="am-u-sm-2 probability-input"><input type="number" value="1" placeholder=""><span>%</span></div>'
			+'<div class="am-u-sm-2 probability-input">'
			//+'<button class="am-btn am-btn-primary am-btn-xs">编辑</button><button class="am-btn am-btn-warning am-btn-xs">删除</button>'
			//+'<a href="javascript:;" class="delete_btn">删除</a>'
			+'</div></div>';
        $('.reward-setting:last').after(html);
	});

	//删除 奖品添加
	$(document).on('click','.reward-setting>a.delete_btn',function(){
		$(this).parent().remove();
	});

	//概率设置
	/*var index1 = 3;
	$('#add-probability-btn').click(function(){
		var length = $('.probability-setting').length;
		if(length>8){
			showTip('err','最多添加8个概率设置',3000);
			return;
		}
		var html = '';
		var probability_text = '';
		var probability_level = '';
		index1++;
		console.log(index);
		html+='<div class="am-u-sm-12 probability-setting"><div class="am-u-sm-6"><div class="am-u-sm-3" style="padding:0;line-height:40px;">'
			+probability_text
			+'</div><div class="am-u-sm-9" style="padding:0;"><div class="am-u-sm-10"><input type="number" value="" placeholder="'
			+probability_level
			+'"></div><div class="am-u-sm-2" style="line-height:41px;padding:0;text-align:left;">%</div></div></div><div class="am-u-sm-3">&nbsp;</div><div class="am-u-sm-3"><input type="number" value="" placeholder="2"></div><a href="javascript:;" class="delete_btn">删除</a></div>';
        $('.probability-setting:last').after(html);
	});*/

	//删除 概率设置
	/*$(document).on('click','.probability-setting>a.delete_btn',function(){
		$(this).parent().remove();
	});*/

	//奖项概率设置 图片选择
	$(document).on('mouseover','.reward-setting .select-img-bar',function(){
		$(this).find('a').show();
	});
	$(document).on('mouseleave','.reward-setting .select-img-bar',function(){
		$(this).find('a').hide();
	});

	//奖项删除
	$(document).on('click','.reward-setting>.probability-input>.delete-btn',function(){
		var uid = parseInt($(this).attr('data-uid'));
		var r_uid = parseInt($(this).attr('data-ruid'));
		var data = {uids:uid,r_uid:r_uid};
		console.log(data);
		$('#my-confirm-delete-rewarditem').modal({
	        relatedTarget: this,
	        onConfirm: function(options) {
	          $.post('?_a=reward&_u=api.delrewarditem',data,function(ret){
					ret = $.parseJSON(ret);
					console.log(ret);
					if(ret.errno==0){
						showTip('','删除成功',1000);
						setTimeout(function(){
							window.location.reload();	
						},1000);
					}
			  });
	        },
	        // closeOnConfirm: false,
	        onCancel: function() {
	          
	        }
	    });
	});


});

/*
将php的时间用js转换为时间戳
*/
function transdate(endTime){
    var date=new Date();
    date.setFullYear(endTime.substring(0,4));
    date.setMonth(endTime.substring(5,7)-1);
    date.setDate(endTime.substring(8,10));
    date.setHours(endTime.substring(11,13));
    date.setMinutes(endTime.substring(14,16));
    date.setSeconds(endTime.substring(17,19));
   // console.log(date);
    return Date.parse(date)/1000;
}


