/*
    参数：
    url
    option
    selected
*/

function check_mark(){
    var $check_mark = $('.am-btn-success').closest('.tpl-case').find('.tpl-checked-mark');
    $check_mark.show();
}

define(function (require,exports,module) {

    require('private/selectTpl/select-tpl.css');

    (function ($) {
        var defaults = {
            option:{limit:-1}
        };
        $.fn.selectTpl = function (options) {
            var settings = $.extend(true,{},defaults, options);
            if(!settings.url){
                return
            }
            if(settings.selected){
                this.data('dir',settings.selected)
            }

            function ajax(page){
                if(page) settings.option['page']=page;
                var data = '';
                $.ajax({
                    url: settings.url,
                    data: settings.option,
                    dataType: 'json',
                    async:false,
                    success: function (ret) {
                        console.log(ret);
                        var html1 = '';
                        var html2 = '';
                        var html = '';
                        var list_length = ret.data['count'];
                        var j=0;
                        var t=0;
                        for(var i=0; i<list_length; i++){   
                            var img_array = ret.data['list'][i]['thumb'].split(',');
                            var tpl_type = ret.data['list'][i]['type'];
                            if(tpl_type =="tpl_mobile"){
                                // console.log(i);
                                html1+=
                                '<section class="tpl-case" data-dir="'+ret.data['list'][i]['dir']+'">' + 
                                '<div class="tpl-img"><img src="'+img_array[0]+'">' + 
                                '<div class="tpl-checked-mark">' + 
                                '<div class="checked_bg"></div>' +
                                '<i class="am-icon-gittip"></i></div>' +
                                '<div class="tpl-intro"><h4 class="tpl-case-title">'+ret.data['list'][i]['name']+'</h4>'

                                if((settings.selected)&&(settings.selected==ret.data['list'][i]['dir'])){
                                    html1+= '<button class="select-tpl-btn am-btn am-btn-success am-btn-xs">已选择</button> ' ;
                                }
                                else{
                                    html1+= '<button class="select-tpl-btn am-btn am-btn-primary am-btn-xs">选择此模板</button> ' ;
                                }
                                if (j%3==0) {
                                    html1+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_r1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_r2"><img src="'+img_array[2]+'"></div></section>'
                                }
                                else if(j%3==1){
                                    html1+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_l1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_r1"><img src="'+img_array[2]+'"></div></section>'
                                }
                                else if(j%3==2){
                                    html1+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_l1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_l2"><img src="'+img_array[2]+'"></div></section>'
                                }
                                j++;
                                // console.log("j:"+j);

                            }
                            else if(tpl_type =="tpl"){
                                // console.log(i);
                                html2+=
                                '<section class="tpl-case" data-dir="'+ret.data['list'][i]['dir']+'">' + 
                                '<div class="tpl-img"><img src="'+img_array[0]+'">' + 
                                '<div class="tpl-checked-mark">' + 
                                '<div class="checked_bg"></div>' +
                                '<i class="am-icon-gittip"></i></div>' +
                                '<div class="tpl-intro"><h4 class="tpl-case-title">'+ret.data['list'][i]['name']+'</h4>'

                                if((settings.selected)&&(settings.selected==ret.data['list'][i]['dir'])){
                                    html2+= '<button class="select-tpl-btn am-btn am-btn-success am-btn-xs">已选择</button> ' ;
                                }
                                else{
                                    html2+= '<button class="select-tpl-btn am-btn am-btn-primary am-btn-xs">选择此模板</button> ' ;
                                }
                                if (t%3==0) {
                                    html2+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_r1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_r2"><img src="'+img_array[2]+'"></div></section>'
                                }
                                else if(t%3==1){
                                    html2+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_l1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_r1"><img src="'+img_array[2]+'"></div></section>'
                                }
                                else if(t%3==2){
                                    html2+=
                                    '</div>'+
                                    '<div class="tpl-case-desc"><div>'+ret.data['list'][i]['brief']+'</div></div></div>'+
                                    '<div class="case_img_l1"><img src="'+img_array[1]+'"></div>'+
                                    '<div class="case_img_l2"><img src="'+img_array[2]+'"></div></section>'
                                }
                                t++;

                               
                            }
                        }
                        // $.each(ret.data.list, function () {
                        //     var img_array = this.thumb.split(',');
                        //     html+=
                        //         '<section class="tpl-section" data-dir="'+this.dir+'"> ' +
                        //         '<div class="tpl-cover"> ' +
                        //         '<img class="tpl-cover-img" data-img="'+this.thumb+'" src="'+img_array[0]+'"> ' +
                        //         '</div> ' +
                        //         '<p class="tpl-title">'+this.name+'</p> ' +
                        //         '<div class="tpl-desc">'+this.brief+'</div> ' +
                        //         '<div class="tpl-bottom"> ' ;

                        //     if((settings.selected)&&(settings.selected==this.dir)){
                        //         html+= '<button class="select-tpl-btn am-btn am-btn-default am-btn-xs">已选择</button> ';
                        //     }
                        //     else{
                        //         html+= '<button class="select-tpl-btn am-btn am-btn-primary am-btn-xs">选择</button> ';
                        //     }
                        //     html+=
                        //         '</div> ' +
                        //         '</section>';
                        // });
                        if (t == 0 && j !=0) {
                            data = html1;
                        }
                        else if( j == 0 && t !=0){
                            data = html2;
                        }
                        else{
                            data = 
                            // '<input checked id="one" name="tabs" type="radio">'+
                            // '<label for="one" id="choice_mobile">移动端</label>'+
                            // '<input id="two" name="tabs" type="radio" value="Two">'+
                            // '<label for="two" id="choice_pc">PC端</label><div class="tpl-choices">'+
                            // '<div class="tpl-choice" id="tpl_choice_mobile">'+
                            // html1+
                            // '</div><div class="tpl-choice" id="tpl_choice_pc">'+
                            // html2+
                            // '</div></div>';
                            '<div class="choices_box"><span id="one" data="check" class="choices">移动版</span><span id="two" class="choices">PC版</div>'+
                            '<div class="tpl-choices">'+
                            '<div class="tpl-choice" id="tpl_choice_mobile">'+
                            html1+
                            '</div><div class="tpl-choice" id="tpl_choice_pc">'+
                            html2+
                            '</div></div>';
                        }
                    },
                    error: function (ret) {
                        data =  '<p>数据错误</p>'
                    }
                });
                return data;


            }


            this.each(function () {
                var $this = $(this);
                var html = ajax();
                $this.append(html);
                $this
                    /*选择按钮*/
                    .on('click','.select-tpl-btn', function () {
                        $(this).closest('.tpl-container').find('.select-tpl-btn')
                            .addClass('am-btn-primary').removeClass('am-btn-success').text('选择此模板');
                        $(this).addClass('am-btn-success').removeClass('am-btn-primary').text('已选择');
                        $(this).closest('.tpl-container').find('.tpl-checked-mark').hide();
                        $(this).closest('.tpl-case').find('.tpl-checked-mark').show();
                        /**/
                        var dir = $(this).closest('.tpl-case').data('dir');
                        $(this).closest('.tpl-container').data('dir',dir);
                    })
                    /*点击图片预览*/
                    // .on('click','.tpl-cover-img', function () {
                    //     var img_all = $(this).data('img');
                    //     var img_array = img_all.split(',');
                    //     var html = '';
                    //     $.each(img_array, function () {
                    //         html+='<img src="'+this+'">';
                    //     });
                    //     $('.gallery-container').html(html).pureview().children().eq(0).trigger('click');
                    // })
            });
           
        check_mark();
        }
    })(jQuery);

    $('.tpl-container').each(function () {
        var $this = $(this);
        $this.selectTpl({
            url:$this.data('url'),
            selected:$this.data('selected')
        });
    })

    function check(){
        var check_one = $("#one").attr("data");
        var check_two = $("#two").attr("data");
        if(check_one == "check"){
            $("#one").attr("style","background:#ececec");
        }
        if(check_two == "check"){
            $("#one").attr("style","background:#ececec");
        }
    }
    check();

    function addBgColor(){
        $("#one").click(function(){
            var tpl_choice_1_height = $('#tpl_choice_mobile').height();
            // console.log("1:"+tpl_choice_1_height);
            $('.tpl-choices').height(tpl_choice_1_height);
            $("#one").attr("style","background:#ececec");
            $("#two").attr("style","");
            $("#tpl_choice_pc").hide();
            $("#tpl_choice_mobile").show();
        });
        $("#two").click(function(){
            var tpl_choice_2_height = $('#tpl_choice_pc').height();
            // console.log("1:"+tpl_choice_2_height);
            $('.tpl-choices').height(tpl_choice_2_height);
            $("#two").attr("style","background:#ececec");
            $("#one").attr("style","");
            $("#tpl_choice_mobile").hide();
            $("#tpl_choice_pc").show();
        });
    }
    addBgColor();
});
