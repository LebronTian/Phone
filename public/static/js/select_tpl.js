/*
    参数：
    url
    option
    selected
*/
(function ($) {

    function check_mark(){
        var $check_mark = $('.am-btn-success').closest('.tpl-case').find('.tpl-checked-mark');
        $check_mark.show();
    }

    var defaults = {
        option:{limit:-1}//先不做翻页，有空补
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

                    if (t == 0 && j !=0) {
                        data = html1;
                    }
                    else if( j == 0 && t !=0){
                        data = html2;
                    }
                    else{
                        data = '<div class="tpl-choice" id="tpl_choice_mobile">'+html1+'</div><div class="tpl-choice" id="tpl_choice_pc">'+html2+'</div>';
                    }
                },
                error: function (ret) {
                    data =  '<p>数据错误</p>'
                }
            });
            return data
        }
        this.each(function () {
            var $this = $(this);
            var html = ajax();
            $this.append(html);
            $this.on('click','.select-tpl-btn', function () {
                $(this).closest('.tpl-container').find('.select-tpl-btn')
                    .addClass('am-btn-primary').removeClass('am-btn-success').text('选择此模板');
                $(this).addClass('am-btn-success').removeClass('am-btn-primary').text('已选择');
                $(this).closest('.tpl-container').find('.tpl-checked-mark').hide();
                $(this).closest('.tpl-case').find('.tpl-checked-mark').show();
                /**/
                var dir = $(this).closest('.tpl-case').data('dir');
                $(this).closest('.tpl-container').data('dir',dir)
            })
        })
        check_mark();
    }
})(jQuery);
