$(function()
{
	var g_cur_id = '';
	var g_cfg = {
		id_set_qrcode: {img: '/static/images/uctoo_xcx.jpg'},
		id_set_avatar: {img: '/static/images/null_avatar.png'},
		id_set_nickname: {img: '/static/images/uctoo_.jpg'}
	};

	$('.cset').click(function(){
		var id = $(this).attr('id');
		if(g_cur_id == id) return;
		g_cur_id = id;
		$('.jcrop-vline').css({background: '#ffffff url("'+g_cfg[g_cur_id].img+'") no-repeat'});
		var val = $('#' + g_cur_id).val();
		if(val && (val = $.parseJSON(val))) {
            jcrop_api.setSelect([
                parseInt(val.x)/pic_real_width*boxWidth,
                parseInt(val.y)/pic_real_height*boxHeight,
                (parseInt(val.x)/pic_real_width*boxWidth + parseInt(val.w)/pic_real_width*boxWidth),
                (parseInt(val.y)/pic_real_height*boxHeight + parseInt(val.h)/pic_real_height*boxHeight)
            ]);
		}

		//console.log('kkkkkk' + id);
	});

    /**图片截取功能启动+预览*************************************************************************/
    // Create variables (in this scope) to hold the API and image size
    var jcrop_api;


    /*Jcrop启动*/
    var pic_real_width, pic_real_height;   //原图长宽，用作判断预览盒子大小和缩放比
    var boxWidth,boxHeight;   //原图长宽，用作判断预览盒子大小和缩放比
    if($(".justforselect").attr("src")!='')
    {
        $('.imgBoxBtn').hide();

        $(".justforselect")
            .attr("src",$(".justforselect").attr("src"))
            .load(
            function(){
                pic_real_width = this.width  // Note: $(this).width() will not
                pic_real_height = this.height // work for in memory images.
                check_back_ground(this.width,this.height);
                back_ground_load();

            }
        );
        $('.imgBoxBtn').show();
    }

    $(document).on('click', '.select_box .selete_btn', function() {
        var oldImg = $(".pic-chose").children("img"); // Get my img elem
        $(".justforselect") // Make in memory copy of image to avoid css issues
            .attr("src", oldImg.data("src"))
            .load(
            function(){
                pic_real_width = this.width;   // Note: $(this).width() will not
                pic_real_height = this.height; // work for in memory images.
                check_back_ground(this.width,this.height);
                back_ground_load();
            }
        );
    });

    function back_ground_load() {
        if($(".justforselect").attr("src")=='') return;
        $("#id_back_ground") // Make in memory copy of image to avoid css issues
            .attr("src", $(".justforselect").attr("src"));
        if(pic_real_width>800){
            //boxWidth = 800;
            //boxHeight = pic_real_height*800/pic_real_width;
            alert('警告！图片宽度超过800px！');
            $("#id_back_ground").css({
                cssText:"width:800px;height:auto"
            });
        }else if(pic_real_height<260){
            //boxWidth = pic_real_width*260/pic_real_height;
            //boxHeight = 260;
            alert('警告！图片高度低于260px！');
            $("#id_back_ground").css({
                cssText:"width:auto;height:260px"
            });
        }else{
            //boxWidth = pic_real_width;
            //boxHeight = pic_real_height;
            $("#id_back_ground").css({
                cssText:"width:"+pic_real_width+"px;height:auto"
            });
        }
        boxWidth =$("#id_back_ground").width();
        boxHeight  =$("#id_back_ground").height();
        //console.log(boxWidth,boxHeight);
        //console.log(pic_real_width,pic_real_height);
        /*启动！！！！！！*/
        if (jcrop_api != undefined) {
            jcrop_api.destroy();
        }
        $('#id_back_ground').Jcrop({
            onChange: updatePreview,
            onSelect: updatePreview,
            //aspectRatio: 1,
            boxWidth: boxWidth,
            boxHeight: boxHeight,
            bgOpacity: 1,
        }, function () {
            // Store the API in the jcrop_api variable
            jcrop_api = this;
            jcrop_api.setImage($(".justforselect").attr("src"));
            //console.log({
            //    x: $('#id_position_x').val(),
            //    y: $('#id_position_y').val(),
            //    w: $('#id_position_w').val(),
            //    h: $('#id_position_h').val()
            //});
			/*
            console.log( [
                pic_real_width*boxWidth,
                pic_real_height*boxHeight,
            ]);
            console.log( [
                parseInt($('#id_position_x').val())/pic_real_width*boxWidth,
                parseInt($('#id_position_y').val())/pic_real_height*boxHeight,
                (parseInt($('#id_position_x').val())/pic_real_width*boxWidth + parseInt($('#id_position_w').val())/pic_real_width*boxWidth),
                (parseInt($('#id_position_y').val())/pic_real_height*boxHeight + parseInt($('#id_position_h').val())/pic_real_height*boxHeight)
            ]);
			*/
            jcrop_api.setSelect([
                parseInt($('#id_position_x').val())/pic_real_width*boxWidth,
                parseInt($('#id_position_y').val())/pic_real_height*boxHeight,
                (parseInt($('#id_position_x').val())/pic_real_width*boxWidth + parseInt($('#id_position_w').val())/pic_real_width*boxWidth),
                (parseInt($('#id_position_y').val())/pic_real_height*boxHeight + parseInt($('#id_position_h').val())/pic_real_height*boxHeight)
            ]);
            //jcrop_api.setSelect([
            //    parseInt($('#id_position_x').val()),
            //    parseInt($('#id_position_y').val()),
            //    (parseInt($('#id_position_x').val()) + parseInt($('#id_position_w').val())),
            //    (parseInt($('#id_position_y').val()) + parseInt($('#id_position_h').val()))
            //]);


        });

    }

    function check_back_ground(width,height)
    {
        if(0 && width*height*3*1.7>maxmem/2)
        {
            showTip("err", '图片尺寸太大了，选张小一点的吧', 3000);
            $("#id_back_ground").attr("src",'')
            $(".justforselect").attr("src",'')
            return false;
        }
    }

    function updatePreview(c) {
        if (parseInt(c.w) > 0) {
            $('.jcrop-vline').css({
                cssText: 'width:' + c.w / jcrop_api.getScaleFactor()[0] + 'px !important',
                height: c.h / jcrop_api.getScaleFactor()[1] + 'px',
                background: '#ffffff url("'+g_cfg[g_cur_id || 'id_set_qrcode']['img']+'") no-repeat',
                'background-size': 'contain',
                opacity: 1
            });
        }

        $('#id_position_x').val(jcrop_api.tellSelect().x);
        $('#id_position_y').val(jcrop_api.tellSelect().y);
        $('#id_position_w').val(jcrop_api.tellSelect().w);
        $('#id_position_h').val(jcrop_api.tellSelect().h);

		var val = {x: jcrop_api.tellSelect().x, y: jcrop_api.tellSelect().y, w: jcrop_api.tellSelect().w, h: jcrop_api.tellSelect().h};
		$(g_cur_id ? '#'+g_cur_id : '#id_set_qrcode').val(JSON.stringify(val));
		

        //console.log(jcrop_api.getScaleFactor());
        //console.log(jcrop_api.tellSelect().x/jcrop_api.tellScaled().x);
        //console.log(jcrop_api.getBounds(),boxWidth);
        //console.log(pic_real_width,boxWidth);
    };

    /***********************************************
     * 提交保存按钮
     * */
    $('#save-btn').click(function () {
        var position = {
            x: parseInt($('#id_position_x').val()),
            y: parseInt($('#id_position_y').val()),
            w: parseInt($('#id_position_w').val()),
            h: parseInt($('#id_position_h').val())
        };
        var data = {
			photo_info: {
				img_url: $(".justforselect").attr('src')
				//,qrcode: position
			},
            uid: g_uid
        };
        data['public_uid'] = $('#id_public').val();
        var val = $('#id_path').val();
        if(!val){
            showTip("err", '请填写小程序码路径', 3000);
            return;
        }
        data['photo_info']['xcxpath'] = val;

		var val = $('#id_set_qrcode').val();
		if(val && (val = $.parseJSON(val))) {
			data['photo_info']['xcxcode'] = val;
		}
		val = $('#id_set_avatar').val();
		if(val && (val = $.parseJSON(val))) {
			data['photo_info']['avatar'] = val;
		}
		val = $('#id_set_nickname').val();
		if(val && (val = $.parseJSON(val))) {
			data['photo_info']['nickname'] = val;
		}

		val = $('#id_set_nickcolor').val();
		if(val) {
			data['photo_info']['nickcolor'] = val;
		}

		data['photo_info']['nickname_center'] = $('#id_nickname_center').prop('checked') ? 1 : 0;
		data['photo_info']['avatar_round'] = $('#id_avatar_round').prop('checked') ? 1 : 0;
        console.log(data);
	

        $.post('?_a=qrxcx&_u=api.addxcxposter', data, function (obj) {
            obj = $.parseJSON(obj);
            if (obj.errno == 0) {
                showTip("", "提交成功", 1000);
                setTimeout("window.location.href = '?_a=qrxcx&_u=sp.photolist'",800);
            } else {
                showTip("err", obj.errstr, 1000);
                return false;
            }

        });
    });

});





