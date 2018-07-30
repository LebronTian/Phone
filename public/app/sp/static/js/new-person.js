$(function() {
    
    /*
        首次登陆调用
    */
    if(visitData == null||visitData == 0){
    //if($.cookie('visit') == null||$.cookie('visit') == 0){
    //    $.cookie('visit','1',{ expires:365 });
        console.log(visitData);
        newPerson();
        $.get('?_a=sp&_u=api.set_visit', function(ret){
            console.log(ret);
        });
    }
    
    /*
        点击新手引导再次调用
    */
    $('.newPerson').click(function(){
        newPerson();
    }); 
    
    function newPerson(){
        $('body').pagewalkthrough({ 
            name: 'introduction', 
            steps: [{ 
               popup: { 
                   content: '#walkthrough-1', 
                   type: 'modal' 
               } 
            }, { 
                wrapper: '#header_bar', 
                popup: { 
                    content: '#walkthrough-2', 
                    type: 'tooltip', 
                    position: 'bottom' 
                } 
            }, { 
                wrapper: '#slider_bar', 
                popup: { 
                    content: '#walkthrough-3', 
                    type: 'tooltip', 
                    position: 'right' 
                } 
            }, { 
                wrapper: '.RegularlyCont', 
                popup: { 
                    content: '#walkthrough-4', 
                    type: 'tooltip', 
                    position: 'bottom' 
                } 
            }, { 
                wrapper: '.ApplyBar', 
                popup: { 
                    content: '#walkthrough-5', 
                    type: 'tooltip', 
                    position: 'top' 
                } 
            }] 
        }); 
     
        // Show the tour 
        $('body').pagewalkthrough('show'); 
    }

}); 