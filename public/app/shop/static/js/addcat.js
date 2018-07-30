$('.save').click(function(){
	var title = $('#id_title').val();
	var title_en = $('#id_title_en').val();
	var parent_uid = $(this).data("uid");
	var image = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var uid = g_uid;
	
	var data = {uid:uid,title:title,title_en:title_en,parent_uid:parent_uid,image:image,sort:sort,status:status};
	$.post('?_a=shop&_u=api.addcat', data, function(ret){
		console.log(ret);
		window.location.href='?_a=shop&_u=sp.catlist&parent_uid='+parent_uid;
	});
});

   $('#search_pic').click(function(event){
      event.preventDefault();
   });

/*yhc*/
$(document).ready(function () {
    /*父级处理*/
    var btnWord = "选择分类";
    if(!(parentCat==null)){
        btnWord = parentCat.title
    }


    /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
    /*组成数据listData过程*/
    /*排序*/
   if(!catsAll =='null'){
	   	catsAll.sort(function (a,b) {
	   	    return (parseInt(a.parent_uid)-parseInt(b.parent_uid))
	   	});
   }

    var listData = [];

    //data:试匹配的数组，obj：需要匹配的对象
    function loopListData(data,obj){
        var puid = obj.parent_uid;
        var uid = obj.uid;
        if(data[puid]){
            //匹配到的话
            if(!data[puid]["child"]) data[puid]["child"]=[];    //判断有没有，没有就设定为数组
            data[puid]["child"][uid]={name:obj.title,uid:obj.uid,puid:obj.parent_uid};
            return true;                //匹配成功返回真
        }else{
            var status_success = false;
            //匹配不成功的话
            $.each(data, function () {
                if(this.child){
                    var now_status = loopListData(this.child,obj);   //往下一层匹配,记录状态
                    if(!status_success){                            //要判断状态是否已经在前面记录了
                        status_success=now_status
                    }
                }
            });
            return status_success
        }
    }
    /*！！自检测自循环功能！！！！！！！！！！*/
    function checkBad(cats,time){
        if(!time) time=0;   //默认值
        var badCats = [];
        if(cats != null){
        $.each(cats, function () {
            if(this.parent_cat){
                var status = loopListData(listData,this);
                if(!status){
                    badCats.push(this);         //挑出坏的
                }
            }else{
                listData[this.uid]={name:this.title,uid:this.uid,puid:this.parent_uid};
            }
        });
        }

        if((badCats.length==0)||(time>5)){
            console.log("不继续了",badCats.length,time)
        }else{
            console.log("继续");
            time++;
            checkBad(badCats,time)
        }
    }
    checkBad(catsAll);


    console.log(listData);
    $(".select-cat").catList({
        btnWord:btnWord,
        ulCss:{
            display:"none"
        },
        data:listData,
        func:{
            click: function () {
                var parent = $(this).parent();
                if(parent.hasClass("cly-open-btn")){
                    parent.find("ul").toggle()
                }else{
                    var text = $(this).text();
                    var uid = $(this).data("uid");
                    $(".save").data("uid",uid);
                    $(".cly-open-btn").find("ul").toggle();
                    $(".cly-open-btn").children("p").text(text)
                }
            },
            mouseenter: function () {
                $(this).siblings("ul").css("background","#D3D3D3")
            },
            mouseleave: function () {
                $(this).siblings("ul").css("background","#eee")
            }
        }
    })

});