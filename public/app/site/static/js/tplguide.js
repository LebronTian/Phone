$(function() {
    
    /*
        首次登陆调用
    */
    if(typeof visitData != 'undefined' && (visitData == null||visitData == 0)){
    //if($.cookie('site_visit') == null||$.cookie('site_visit') == 0){
    //    $.cookie('site_visit','1',{ expires:365 });
        newGuide();
        $.get('?_a=sp&_u=api.set_visit&app=site', function(ret){
            console.log(ret);
        });
    }
    
    /*
        点击新手引导再次调用
    */
    $('.btn_guide').click(function(){
        newGuide();
    }); 
    
    function newGuide(){
        $('body').pagewalkthrough({ 
            name: 'introduction', 
            steps: [{ 
               popup: { 
                   content: '#walkthrough-1', 
                   type: 'modal' 
               } 
            }, { 
                wrapper: '#collapse-nav2>li:eq(2)', 
                popup: { 
                    content: '#walkthrough-2', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            }, { 
                wrapper: '#collapse-nav2>li:eq(0)', 
                popup: { 
                    content: '#walkthrough-3', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            }, { 
                wrapper: '#collapse-nav1>li:eq(2)', 
                popup: { 
                    content: '#walkthrough-4', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            }, { 
                wrapper: '#collapse-nav1>li:eq(0)', 
                popup: { 
                    content: '#walkthrough-5', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            },{ 
                wrapper: '#collapse-nav1>li:eq(1)', 
                popup: { 
                    content: '#walkthrough-6', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            }] 
        }); 
     
        // Show the tour 
        $('body').pagewalkthrough('show'); 
    }

}); 
