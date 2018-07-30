$(document).ready(function () {

    //全部事情也要在有分类的情况下进行
    if(typeof catsAll!="object"){
        return
    }
    if(catsAll.length==0){
        $(".choose-cats").text("没有分类").next().append("<a href='?_a=shop&_u=sp.catlist'>，请先添加商品分类</a>");
        return
    }
    /*分类选择弹出框*/
    $(".choose-cats").mouseenter(function () {
        $('#chooseCats').modal({
            closeViaDimmer:false,
            width:1000
        })
    });
    /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
    /*组成数据listData过程*/
    /*排序*/
    catsAll.sort(function (a,b) {
        return (parseInt(a.parent_uid)-parseInt(b.parent_uid))
    });

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

        if((badCats.length==0)||(time>5)){
            //console.log("不继续了",badCats.length,time);
            return badCats
        }else{
            //console.log("继续");
            time++;
            return checkBad(badCats,time);  //将没有的一级级往上传
        }
    }

    var noCats = checkBad(catsAll);
    //没有分类
    if(!(noCats.length==0)){
        var html='<span>其他分类：</span>';
        $.each(noCats, function () {
            html+='<section onclick="window.location.href=\'?_a=shop&_u=sp.addcat&uid='+this.uid+'\'">'+this.title+'</section>';
        });
        $(".noCats-box").append(html)
    }


    /**分类列表**************************************************************************/
    var catListData1 = {
        btnCss:{
            marginLeft:"1em"
        },
        firstTitleCss:{
            display:"none"
        },
        data: listData,
        func:{
            click: function () {
                var uid = $(this).data("uid");
                var puid = $(this).data("puid");
                if(typeof puid=="undefined"){                       //没有父级就是顶级，所以返回首页
                    window.location.href='/?_a=site&_u=sp.catlist';
                }else{                                              //有父级，没有下一级，就返回他的父级
                    window.location.href='/?_a=site&_u=sp.catlist&parent_uid='+puid
                }
            },
            mouseenter: function () {
                $(this).siblings("ul").css("background","#D3D3D3")
            },
            mouseleave: function () {
                $(this).siblings("ul").css("background","#eee")
            }
        }
    };
    $(".catList-yhc1").catList(catListData1);
    /****************************************************************************/
    var catListData2 = {
        btnCss:{
            marginLeft:"1em"
        },
        firstTitleCss:{
            display:"none"
        },
        data: listData,
        func:{
            click: function () {
                var uid = $(this).data("uid");
                window.location.href ='?_a=shop&_u=sp.productlist&cat_uid='+uid;
            },
            mouseenter: function () {
                $(this).siblings("ul").css("background","#D3D3D3")
            },
            mouseleave: function () {
                $(this).siblings("ul").css("background","#eee")
            }
        }
    };
    $(".catList-yhc2").catList(catListData2)

});
