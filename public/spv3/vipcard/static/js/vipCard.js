$(document).ready(function() {
	$(".submit").on("click", function() {
		var cardname, discountnum, scorenum, notice, phonenum, shopname, bgcolor,data;
		var checkall = []; /*放所有选中的checkbox*/

		//		这两个选择图片要处理
		var shoplogo = $("#shoplogo").attr("src");
		var backgroundimage = $("#backgroundImage").val();
		//		这两个选择图片要处理

		
		shopname = $("#shopname").val();
		cardname = $("#cardname").val();
		bgcolor = $("#bgcolor").val();
		discountnum = $("#discountnum").val();
		scorenum = $("#scorenum").val();
		notice = $("#notice").val();
		phonenum = $("#phonenum").val();

		$.each($('input:checkbox:checked'), function() {
			checkall.push($(this).val());
		});
		console.log(checkall)

		if(cardname == "") {
			alert("请输入会员卡名称");
		} else if(cardname == "") {
			alert("请输入会员卡名称");
		} else if(notice == "") {
			alert("请输入使用须知");
		} else {
//			写入所有需要的数据

		if(!$('#discount').prop('checked')) discountnum=10;
		if(!$('#first_point').prop('checked')) scorenum=0;

		var update =  {
			'rank_rule': {'1': {'rank_name': cardname, 'rank_discount': discountnum*10}},
			'ui_set': {'back_ground': {'path': backgroundimage, 'color': bgcolor},
					'other_rule': {
						'baoyou': $('#mail').prop('checked') ? 1 : 0,
						'youhuiquan': $('#coupon').prop('checked') ? 1 : 0,
						'first_point': scorenum,
						'readme': notice,
						'phone': phonenum,
					}
			} 

		}

			$.post(
				"?_a=vipcard&_u=api.save_card_spv3",
				{'data': update},
				function(result) {
					console.log(result);
					alert("保存成功！")
				}
			);
		}
	});

	//	选择才可以输入
	function adddisable(a, b) {
		$(a).on("click", function() {
			if($(a).is(':checked')) {
				$(b).removeAttr("disabled");
			} else {
				$(b).attr("disabled", "disabled")
			}
		});
	}
	adddisable('#score', '#scorenum');
	adddisable('#discount', '#discountnum');
	adddisable('#backgroundColor', '#bgcolor');
	adddisable('#backgroundImage', '#selectimg');

});
