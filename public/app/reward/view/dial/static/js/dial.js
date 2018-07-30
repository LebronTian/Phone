window.onload = function(){

 	$("#loading_box").hide();

	// 判断浏览器与文档高度，确定height属性
	function check_height(){
		var $w_height = $(window).height();//浏览器高度
		var $d_height = $(document).height();//文档高度
		// console.log("浏览器高度:"+$w_height);
		// console.log("文档高度:"+$d_height);
		$(".else_show").height($d_height);
		$(".share_to_off").height($d_height);
		var d_minus_w = $d_height - $w_height; //文档高度 - 浏览器高度
		if(d_minus_w <= 0){
			$(".body").height($d_height);
		}
		else if(d_minus_w > 0 && d_minus_w < 50){
			$(".body").attr("style","height:100%;background-size:100% 100%");
		}
		else if(d_minus_w >= 50){
			$(".body").attr("style","height:auto;background-size:100% auto");

		}
	}
	check_height();


	// 获奖栏滚动动画
	setInterval(function(){  
		$(".reward_box").find("ul").animate({  
			marginTop : "-3.5rem"
		},1500,function(){  
			$(this).css({marginTop : "0rem"}).find("li:first").appendTo(this);  
		});  
	},1500);


	// 获奖用户名隐藏部分字符
	var $honor_spans = $(".reward_box_i > ul > li").find("span:first");
	var span_counts = $honor_spans.length;
	for(var i=0; i<span_counts; i++){
		var honor_username = $honor_spans.eq(i).text();
		var encode_name = string_encode(honor_username);
		$honor_spans.eq(i).text(encode_name);
	}


	// 隐藏字符函数（偶数隐4 奇数隐3）
	function string_encode(str){
		var len = str.length;
		switch (len){
			case 0: return "*";
			case 1: return "*";
			case 2: return str.substr(0,1) + "*";
			case 3: return str.substr(0,1) + "*" + str.substr(2);
			case 4: return str.substr(0.1) + "**" + str.substr(3);
			default:
				if (len%2 == 0){
					var pre_len = (len-4)/2;
					var re_len = (len+4)/2;
					return str.substr(0,pre_len) + "****" + str.substr(re_len);
				}else{
					var pre_len = (len-3)/2;
					var re_len = (len+3)/2;
					return str.substr(0,pre_len) + "***" + str.substr(re_len);
				};
		}
	}

	// 判断活动日期
	function getLocalTime(nS) {
		var test = new Date(parseInt(nS) * 1000);  
	    var $_year = test.getFullYear();  
	    var $_month = parseInt(test.getMonth())+1;  
	    var $_day = test.getDate();
	    var $_hour = test.getHours();
	    var $_minute = test.getMinutes();  
	    var $_f_date =  $_year +"年"+$_month+"月"+$_day+"日"+$_hour+"时"+$_minute+"分";
	    return $_f_date;
	}
	 
	var $start_time_int = $(".start_time").text();    
	var $end_time_int = $(".end_time").text();
	// console.log("活动开始时间："+$start_time_int);  
	// console.log("活动结束时间："+$end_time_int);  
	var reward_start_time = getLocalTime($start_time_int);
	var reward_end_time = getLocalTime($end_time_int);
	console.log("开始："+reward_start_time);
	console.log("结束："+reward_end_time);
	if(reward_start_time != "" || reward_end_time != "" ){
		$(".time_note").show();
		if (reward_start_time !="" ) {
			$(".start_p").show();
			$(".start_time").text(reward_start_time);
		}
		else{
			$(".start_p").hide();
		}
		if (reward_end_time !="") {
			$(".end_p").show();
			$(".end_time").text(reward_end_time);
		}
		else{
			$(".end_p").hide();
		}
	}
	else{
		$(".time_note").hide();
	}
	var current_time = new Date();
	var lTime =parseInt(current_time/1000);//秒级
	// console.log(current_time);
	// console.log("当前时间："+lTime);

	$("#stare_play").click(function(){
		// $(".share_play").find("a").removeAttr("href");
		if ( $start_time_int != "" && lTime < $start_time_int ){
			console.log("未开始");
			$(".share_play").find("a").removeAttr("href");
			alert("活动尚未开始！");
		}
        else if ( $end_time_int != "" && lTime >= $end_time_int){
			console.log("已结束");
			$(".share_play").find("a").removeAttr("href");
			alert("活动已经结束！");
		}
		else{
			var url = $(".share_play").find("a").attr("href");
			// alert(url);
			window.location.href = url;
		}

	})
	

	// 设置中奖图片
    function setPrizePic(){
    	var $prize_pic = $('.prize_pic');
    	var pic_height = $prize_pic.height();
     	var pic_width = $prize_pic.width();
     	console.log(pic_height);	
     	console.log(pic_width);
     	if(pic_height>=pic_width){
     		$prize_pic.height('100%');
     		$prize_pic.width('auto');
     		$prize_pic.css('padding-top',0);
     	}else{
     		$prize_pic.width('100%');
     		var box_height = $('.prize_pic_box').height();
     		var padding_top = (box_height - pic_height)/2;
     		$prize_pic.css('padding-top',padding_top);
     	}
    }


	// 获取原奖项数,判断转盘上奖项总数
  	var item_num = item_count;
  	var b = item_num % 2;
    if (b == 0) {
    	item_num = item_num + 2;
    }else{
    	item_num = item_num + 1;
    }


    // 设置扇形旋转角度
	var num = item_num;
	var angle = 360/num;

	function rotate_angle(){
		var $rotateLis = $(".rotate").find("li");
		var $rotateAs = $rotateLis.find("a");
		var rotateT = 0;
		for (var i = 0; i < num; i++){			
			rotateLi = angle*i;
			skewLi = (90-angle);
			skewA = -skewLi;
			rotateA = skewA/2;
			var transformLi = "rotate(" + rotateLi + "deg) skew(" + skewLi +"deg)";
			$rotateLis.eq(i).css({"transform":transformLi,"-webkit-transform":transformLi});
			var transformA = "skew(" + skewA + "deg) rotate(" + rotateA +"deg)";
			$rotateAs.eq(i).css({"transform":transformA,"-webkit-transform":transformA});
		};
		
	};
	rotate_angle();


	// 转盘动画
	var bRotate = false;
	var rotateFn = function (awards, angles, txt){
		var $prize = $("#prize");
		var $showPage = $("#showPage");
		var $showPage_false = $("#showPage_false");
		bRotate = !bRotate;
		$('#rotate').stopRotate();
		$('#rotate').rotate({
			angle:0,
			animateTo:angles+1800,
			duration:7000,
			callback:function (){
				if (txt == "谢谢参与"){
					var $getPrizeFalseMusic = document.getElementById("getPrizeFalseMusic");
 					$getPrizeFalseMusic.play();
					$showPage_false.show(); //谢谢参与 则显示未中奖页面
				}else{

					var $getPrizeMusic = document.getElementById("getPrizeMusic");
 					$getPrizeMusic.play();
					$prize.text(txt);
					$showPage.show(); //有奖项 则显示中奖页面
				};				
				bRotate = !bRotate;				
			}
		})
	};


	// 
	function timer(time) {
	    var btn = $(".pointer");
	    btn.attr("disabled", true);  //按钮禁止点击
	    var hander = setInterval(function() {
	        if (time <= 0) {
	            clearInterval(hander); //清除倒计时
	            btn.val("发送动态密码");
	            btn.attr("disabled", false);
	            return false;
	        }else {

	        }
	    }, 1000);
	}
	
	//调用方法
	

	

	// 获取抽奖次数及当前用户抽奖次数数据
	var max_cnt = $('.dial_limit').attr('data-cnt')*1; //总限制次数
	var max_cnt_day = $('.dial_limit').attr('data-cnt-day')*1; //每天限制次数
	var current_cnt = cnt_info['user_max_cnt']*1; //当前次数
	var current_cnt_day = cnt_info['user_max_cnt_day']*1; //当天当前次数
	var user_can_max_cut = cnt_info['user_rule']['max_cnt']*1;
	var user_can_max_cut_day = cnt_info['user_rule']['max_cnt_day']*1;
	console.log("总限制次数:"+max_cnt);
	console.log("每天限制次数:"+max_cnt_day);
	if (max_cnt < user_can_max_cut) {
		max_cnt = user_can_max_cut;
	}
	if (max_cnt_day < user_can_max_cut_day) {
		max_cnt_day = user_can_max_cut_day;
	}
	console.log("分享后总限制次数:"+max_cnt);
	console.log("分享后每天限制次数:"+max_cnt_day);
	console.log("当前次数:"+current_cnt);
	console.log("当天当前次数:"+current_cnt_day);

	 
	// 无限制抽奖次数
	var $pointer = $(".pointer");
	function dial_limit_hide(){
		if (max_cnt == 0 && max_cnt_day == 0){
			$('.dial_limit').hide();
			$pointer.click(function(){
				click_rotate();
			});
		}
	}
	dial_limit_hide();


    // 根据限制进行数据反馈和抽奖函数
    function count_reward(){
    	var $limit_num = $(".limit_num");
    	// 限制当前抽奖总次数 不限每天次数
		if (max_cnt_day <=0 && max_cnt > 0){		
			var left_cnt = max_cnt - current_cnt; //剩余次数
			if (left_cnt<=0) {
				left_cnt = 0;
			}
			else{
				left_cnt = left_cnt;
			}
			$limit_num.text(left_cnt); 
			
			$pointer.click(function (){
				if ($pointer.attr("clicking") != "yes"){
					if( left_cnt > 0){
						$pointer.attr("clicking","yes");
						left_cnt = left_cnt - 1;
						$limit_num.text(left_cnt);	
						click_rotate();	
						setTimeout(function(){
						$pointer.removeAttr("clicking");
					},8000);
					}else{
						alert("您的抽奖次数已用完!");
					}
				}
			});
		}

		// 限制每天次数 不限制总次数
		if (max_cnt <=0  && max_cnt_day > 0){		
			var left_cnt = max_cnt_day - current_cnt_day; //剩余次数
			if (left_cnt<=0) {
				left_cnt = 0;
			}
			else{
				left_cnt = left_cnt;
			}
			$limit_num.text(left_cnt); 
			
			$pointer.click(function (){
				if ($pointer.attr("clicking") != "yes") {
					if( left_cnt > 0){
						$pointer.attr("clicking","yes");
						left_cnt = left_cnt - 1;
						$limit_num.text(left_cnt);	
						click_rotate();
						setTimeout(function(){
							$pointer.removeAttr("clicking");
						},8000);			
					}else{
						alert("今天的抽奖次数已用完,明天好运继续!");
					}

				}
				
			});
		}


		//限制总次数 同时限制每天次数
		if (max_cnt > 0 && max_cnt_day > 0){
			var s = max_cnt - current_cnt;
			var t = max_cnt_day - current_cnt_day;
			console.log("总次数-当前次数:"+s);	
			console.log("每日限次数-今天次数:"+t);
			// $limit_num.text(left_cnt);
			if(s <= max_cnt_day && s<=t){
				if(t<=0){
					var left_cnt = 0;
					$limit_num.text(left_cnt);
					$pointer.click(function(){
						alert("今天的抽奖次数已用完!");
					})
				}
				else{
					var left_cnt = s; //剩余次数
					// console.log("1今天还能转:"+left_cnt);
					if (left_cnt<=0) {
						left_cnt = 0;
					}
					else{
						left_cnt = left_cnt;
					}
					$limit_num.text(left_cnt); 
					$pointer.click(function (){
						if ($pointer.attr("clicking") != "yes"){
							if( left_cnt > 0){
								$pointer.attr("clicking","yes");
								left_cnt = left_cnt - 1;
								$limit_num.text(left_cnt);	
								click_rotate();
								setTimeout(function(){
									$pointer.removeAttr("clicking");
								},8000);
							}else{
								alert("您的抽奖次数已用完！");
							}
						}
						
					});
				}
				

			}
			else{
				var left_cnt_day = max_cnt_day - current_cnt_day; //剩余次数
				var left_cnt = max_cnt - current_cnt_day; //剩余次数
				console.log("2今天还能转:"+left_cnt_day); 
				$limit_num.text(left_cnt_day);
				$pointer.click(function (){
					if ($pointer.attr("clicking") != "yes"){
						if( left_cnt_day > 0){
							$pointer.attr("clicking","yes");
							left_cnt_day = left_cnt_day - 1;
							$limit_num.text(left_cnt_day);
							click_rotate();
							setTimeout(function(){
								$pointer.removeAttr("clicking");
							},8000);
						}
						else if( left_cnt_day <= 0 && left_cnt > 0){ 
							$limit_num.text(0);
							alert("今天的抽奖次数已用完,好运明天继续!")
						}
						else{
							$limit_num.text(0);
							alert("您的抽奖次数已用完!")
						}
					}
				});
			}
		}
    }

    count_reward();
    
	
    // 点击按钮旋转函数
    function click_rotate(){
    	var item = 0;
		if(bRotate)return;
		var r_uid=$('.container').attr('data-ruid');
	 	var link='?_a=reward&_u=ajax.doreward&r_uid='+r_uid;
	  	var datas = [];		  
	  	$.post(link,datas,function(data){
		  	var reg=$.parseJSON(data);
     		console.log(reg.data);
     			reg['errno']
     		if(reg['data']!='' && reg['data']['item']!=''){
     		 	item = $('.rotate').find('.item_uid_'+reg['data']['item']['uid']).attr("id");
     		 	var prize_pic_src = reg['data']['item']['img'];
     		 	$(".prize_pic").attr("src",prize_pic_src);
     		 	// console.log(prize_pic_src);
     		 	item =parseInt(item.replace(/prize_/,'') );   
     		 	
     		 }else{
 	     		 item = num;	
     		 }
     		 if(reg['data']!='' && reg['data']['uid']!=''){
     		 	uid = reg['data']['uid'];
     		 	$("#get_prize").attr("data-uid",uid);
     		 	// console.log(uid);
 		 	}


	     	var $musicBox = document.getElementById("musicBox");
	 		$musicBox.play();
	 		var txt1 = $("#prize_"+item).text();
			var angle1 = 450 - angle*(2*item-1)/2;
			rotateFn(item, angle1, txt1);
		});

    }

	// 点击未中奖页面，当前页面隐藏
	$("#showPage_false").click(function(){
		$(this).hide();
	});


	// 活动介绍
	$("#activity").click(function(){
		$("#activity_show").show();
	});

	$("#activity_off").click(function(){
		$("#activity_show").hide();
	});


	// 商家介绍
	$("#agency").click(function(){
		$("#agency_show").show();
	});

	$("#agency_off").click(function(){
		$("#agency_show").hide();
	});


	// 查看我的奖品
	$("#checkprize").click(function(){
		$("#checkprize_show").show();
	});

	$("#checkprize_off").click(function(){
		$("#checkprize_show").hide();
	});


	// 分享到朋友圈
	$("#share_to").click(function(){
		$("#share_to_off").show();
	});

	$("#share_to_off").click(function(){
		$(this).hide();
	});


	// // 确认是否放弃领奖
	// $(".giveup_no").click(function(){//返回领奖
	// 	$(".giveup").hide();
	// 	$("#form_show").show();
	// });

	// $(".giveup_yes").click(function(){//确认放弃领奖
	// 	$(".giveup").hide();
	// });


	//设置中奖后动作
	function set_reward_way(){
		var way = $('.info_info').attr('data-type');
		// console.log(way);
		switch(way){
			case "1":
				$("#showPage").hide();//无动作
				break;
			case "form":
				$("#showPage").hide();
				$("#form_show").show();//填写表单
				break;
			case "url":
				var jumplink = $(".input_box0").find("div").text();
				if(jumplink.charAt(0) == "/"){
					var url = location.href.replace(/\/\?_a=(.*)/g,jumplink);
				}
				else{
					var url = jumplink;
				}
				window.location.href= url;//跳转链接
		}
	}

	$("#get_prize").on('click', function(){
		set_reward_way();
	});


	// 关闭中奖页面
	$("#prize_off").click(function(){
		$("#showPage").hide();
	});


	// 放弃领奖
	$(".btn_submit_no").click(function(){
		$("#form_show").hide();
	});


	// 提交表单
	$('.btn_submit').click(function(){
		var uid = $("#get_prize").attr("data-uid");
		// console.log("提交表单:"+uid);
	    var info=[];
	    $.each($('.info_info input'),function(event){
	      if($.trim($(this).val())=='')
	      {
	        alert('请填写完整的个人资料');
	        return false;
	        event.stopPropagation();
	      }
	      info.push($(this).val());
	    });
	    for(var i in info)
	    var reg={uid:uid,data:info};
		// console.log(reg);
	    $.post('?_a=reward&_u=ajax.set_win_info',reg,function(obj){ 
	      obj=$.parseJSON(obj);
	      if(obj.errno==0){
	        alert('提交成功，请耐心等待奖品...');
	        $('#form_show').hide();
	        get_user_record();
	      }
	    });
	});


	// 点击我的奖品
	$("#checkprize").click(function(){
		get_user_record();
	});
		

	// 获取当前用户列表
	function get_user_record(){
		var r_uid=$('.container').attr('data-ruid');
	 	var link='?_a=reward&_u=ajax.get_user_record_list&r_uid='+r_uid;
	  	var datas = {'no_remark':0,
	  	'limit':-1};
		  
	  	$.post(link,datas,function(data){
		  	var re=$.parseJSON(data);
		  	// console.log(re.data);
		  	var re_len = re.data['list'].length;
	 		// console.log(re.data['list'].length);
	 		var re_list = re.data.list;
	 		var $html="";
	 		var $myprize_intro = $("#myprize_intro");
	 		if (re_len ==0) {
	 			$myprize_intro.find("div").html("无中奖纪录");
	 		}else{
 				$.each(re_list,function(){
 					$html+='<a class="getprize_intro" data-uid="'+this.uid+'" data-form="'+this.data+'"><h4>'+this.item.title+'</h4><img src="'+this.item.img+'"></a>'	
 				
 				});
	 			$myprize_intro.find("div").html($html);
	 			$(".getprize_intro").bind("click",function(){
	 				var uid = $(this).attr("data-uid");
	 				var data_e = $(this).attr("data-form");
	 				console.log(data_e);
	 				if(data_e == ""){
	 					console.log("这个商品的uid:"+ uid);
	 					$("#get_prize").attr("data-uid",uid);
						set_reward_way();
	 					
	 				}else{
	 					alert("您已领取过该奖品!");
	 				}
				})
	 		}	
		});
	}


};





