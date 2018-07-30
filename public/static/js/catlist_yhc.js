/**
 * Created by Near on 2015/7/22.
 * 基于jQuery2.1无限分类渲染插件
 *
 * 作用：通过处理特定格式的数据，生成一个无限分类的下拉栏。能自定义样式，点击事件。
 *
 * 使用方法：
 * 1.引用jq2.1，本js文件。
 * 2.通过jq选择器渲染指定的元素 $(".catList-yhc").catList()
 * 3.必填参数：
 * *data:数组对象格式，例子：
 * [
 * {name:"A1",uid:"hahaha",images:"/asdasd"},
 * {name:"A2",child:[{name:"A2B1"},{name:"A2B2"},{name:"A2B3"}]},
 * {name:"A3",child:[{name:"A3B1"},{name:"A3B2",child:[{name:"A3B2C1"},{name:"A3B2C2"},{name:"A3B2C3"},{name:"A3B2C4"}]},{name:"A3B3"}]}
 * ]
 * name是分类的名字，child是这一类下面的分类。
 * 其余属性选填，如上例uid,images，填写将保存在标签的data属性中，供给click回调函数中使用。
 * 4.选填参数：
 * 一、样式
 * btnWord：按钮的文字。
 * btnCss：按钮的样式。样式用驼峰法写，例如：margin-top写成marginTop，下同。
 * titleCss：分类的样式。
 * active：有下分类时的样式。
 * ulCss：分类加上它的下分类的样式。
 * liCSS：分类包围样式。
 *
 * 二、回调函数
 * 回调函数统一写在func属性下
 * func:{
 *    click:function(){}    //点击事件
 *    dblclick:function(){} //双击事件
 * }
 *
 *
 */
(function ($) {

    //默认参数：
    var defaults = {
        btnWord:"选择分类",
        btnCss:{
            //background:"white",
            display:"inline-block",
            textAlign:"center",
            position:"relative",
            zIndex:"999"
        },
        titleCss:{
            padding:"0.6em 1.5em",
            display:"inline-block",
            border:"thin solid #ddd",
            background:"white",
            minWidth:"4em",
            cursor:"pointer",
            margin:"0 6px",
            color:"#777"
        },
        firstTitleCss:{
        },
        activeCss:{
            color:"white",
            background:"#5eb95e"
        },
        ulCss:{
            listStyleType:"none",
            margin:"0",
            padding:"0",
            verticalAlign:"middle",
            borderRadius:"10px",
            background:"#eee",
            paddingRight:"5px"
        },
        liCss:{
            textAlign:"left",
            margin:"6px 0"
        }
    };

    //并排时需要inline-block
    document.writeln("<style> .cly-ul{display:inline-block} </style>");     //机智的我啊！但又如此的蠢...

    //循环读取数据
    function loopsData(data,loop,settings){

        if(!loop) loop=0;                   //循环的层数，默认0

        var html = '<ul class="cly-ul" style="';

        //加载ul样式
        for(var objUl in settings.ulCss){

            var objNew = objUl.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

            html+=objNew+':'+settings.ulCss[objUl]+";"

        }

        html+='" data-loop="'+loop+'">';

        $.each(data, function () {

            if(!this.name) return;//如果传来空的对象时，没有name属性，然后就返回


            html+='<li class="cly-li" style="';

            //加载li样式
            for(var objLi in settings.liCss){

                var objNew = objLi.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                html+=objNew+':'+settings.liCss[objLi]+";"

            }

            html+='" ><p class="cly-p" ';

            //加载data数据
            for(var objD in this){

                if((objD=="child")||(objD=="name")) continue;

                html+="data-"+objD+"="+this[objD]+" ";

            }

            html+=' style="';

            //加载p样式
            for(var objT in settings.titleCss){

                var objNew = objT.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                html+=objNew+':'+settings.titleCss[objT]+";"

            }

            if(this.child){

                //加载active样式
                for(var objA in settings.activeCss){

                    var objNew = objA.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                    html+=objNew+':'+settings.activeCss[objA]+";"

                }

            }

            html+='">'+this.name+'</p>';

            if(this.child){

                html+=loopsData(this.child,loop+1,settings)

            }

            html+='</li>';

        });

        html+='</ul>';

        return html
    }


    //事件绑定
    function bindP(ele,func){

        /*自定义事件*/
        ele.click(function () {     //点击
            if(func.click){
                func.click.apply(this,null);
            }
        });

        ele.dblclick(function () {      //双击
            if(func.dblclick){
                func.dblclick.apply(this,null);
            }
        });

        ele.mouseenter(function () {    //mouseenter
            if(func.mouseenter){
                func.mouseenter.apply(this,null)
            }
        });

        ele.mouseleave(function () {    //mouseleave
            if(func.mouseleave){
                func.mouseleave.apply(this,null)
            }
        });

        if(!(ele.siblings("ul").length==0)){

            /*自定义事件：ul的事件*/
            ele.siblings("ul").mouseenter(function () {     //ul的mouseenter
                if(func.ulMouseenter){
                    func.ulMouseenter.apply(this,null)
                }
            });

            ele.siblings("ul").mouseleave(function () {     //ul的mouseleave
                if(func.ulMouseleave){
                    func.ulMouseleave.apply(this,null)
                }
            });

            //循环绑定
            ele.siblings("ul").children("li").each(function () {

                bindP($(this).children("p"),func);//改成开始判断

            })

        }

    }



    $.fn.catList = function (options) {    //插件名称catList

        var settings = $.extend(true,{},defaults, options);                 //合并数据

        this.hide();//隐藏原来的

        //console.log(settings.data,settings.data=="",typeof settings.data);  //醉了，空的数组==“”

        if((typeof settings.data !="object")||(settings.data.length==0)){         //不是数组或者空的话
            if(typeof settings.data=="undefined"){
                settings.btnWord = "数据缺失";            //没有填写的话
            }else{
                settings.btnWord = "数据错误或为空";       //填了的话
            }
        }

        this.each(function () {

            var $this = $(this);

            var btnHtml = '<div class="cly-open-btn" onselectstart="return false" style="';              //按钮HTML

            //加载按钮样式
            for(var obj in settings.btnCss){

                var objNew = obj.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                btnHtml+=objNew+':'+settings.btnCss[obj]+";"

            }

            btnHtml+=
                '">' +
                '<p style="';

            //加载p样式
            for(var objP in settings.titleCss){

                var objNew = objP.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                btnHtml+=objNew+':'+settings.titleCss[objP]+";"

            }
            //加载特殊的第一个p的样式
            for(var objFP in settings.firstTitleCss){

                var objNewF = objFP.replace(/([A-Z])/g,"-$1").toLowerCase();   //驼峰写法转换成-写法

                btnHtml+=objNewF+':'+settings.firstTitleCss[objFP]+";"

            }


            btnHtml+='color:black">'+settings.btnWord+'</p>' ;

            btnHtml+=loopsData(settings.data,0,settings);//循环数据

            btnHtml+=
                '</div>';

            $this.after(btnHtml);

            var clyBtn = $this.next();

            bindP(clyBtn.children("p"),settings.func);  //绑定事件

        })

    }

})(jQuery);