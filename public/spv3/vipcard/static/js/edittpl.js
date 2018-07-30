$(function () {
    $(".saveBtn").click(function () {
        var tpl_data_image = {};
        var tpl_data_string = {};
        var bw =tpl_datas.back_ground.size[0];
        var bh =tpl_datas.back_ground.size[1];
        console.log(bw,bh);
        var error =0;
        $('.image-section').each(function (index) {
            var key = $(this).find('.image_title').data('keys');

            tpl_data_image[key] = {};
            var w =parseInt($(this).find('.image_s_w').val());
            var h =parseInt($(this).find('.image_s_h').val());
            var x = parseInt($(this).find('.image_p_x').val());
            var y = parseInt($(this).find('.image_p_y').val());
            var l = parseInt($(this).find('.image_l').val());
            tpl_data_image[key]['path']='';
            tpl_data_image[key]['size']=[w,h];
            tpl_data_image[key]['point']=[x,y];
            tpl_data_image[key]['l']=l;
            if((w+x>bw) || (h+y)>bh)
            {

                error = "第"+(index+1)+"张图片 尺寸和大小设置超出背景";
            }
            if(w <0 ||h <0||x <0||y <0)
            {
                error = "第"+(index+1)+"张图片 尺寸和大小数值请设置一个正整数";
            }
        });
        if(error!=0)
        {
            showTip("err", "保存失败"+error, "1000");
            return;
        }
        var error =0;
        $('.string-section').each(function (index) {
            var key = $(this).find('.string_title').data('keys');
            tpl_data_string[key] = {};
            var s = parseInt($(this).find('.string_s').val());
            var c = $(this).find('.string_c').val();
            var x = parseInt($(this).find('.string_p_x').val());
            var y = parseInt($(this).find('.string_p_y').val());
            var b = parseInt($(this).find('.string_b').val());
            c = '#'+c;
            tpl_data_string[key]['content']='';
            tpl_data_string[key]['color']= c.colorRgb();
            tpl_data_string[key]['size']=s;
            tpl_data_string[key]['point']=[x,y];
            tpl_data_string[key]['bold']=b;
            if(x <0||y <0 || s<=0)
            {
                error = "第"+index+"个字段 坐标、字体大小数值请设置一个正整数";
            }
        });
        if(error!=0)
        {
            showTip("err", "保存失败"+error, "1000");
            return;
        }
        var  tpl_data ={
            "back_ground":tpl_datas.back_ground,
            "image":tpl_data_image,
            "string":tpl_data_string,
        }
        console.log(tpl_data);
        //return;
        data =
        {
            uid:uid,
            "data":tpl_data
        }

        $.post("?_a=vipcard&_u=api.edittpl", data, function (ret) {
            ret = $.parseJSON(ret);
            console.log(ret)
            if (ret.errno == 0) {
                showTip("", "保存成功", "1000");
                setTimeout(function () {
                    window.location.href='?_a=vipcard&_u=sp.edittpl&uid='+ret.data;
                }, 1000);
            }
        })
    })
    ;
});
//十六进制颜色值域RGB格式颜色值之间的相互转换
//http://blog.csdn.net/haiqiao_2010/article/details/8533611
//-------------------------------------
//十六进制颜色值的正则表达式
var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function(){
    var that = this;
    if(/^(rgb|RGB)/.test(that)){
        var aColor = that.replace(/(?:||rgb|RGB)*/g,"").split(",");
        var strHex = "#";
        for(var i=0; i<aColor.length; i++){
            var hex = Number(aColor[i]).toString(16);
            if(hex === "0"){
                hex += hex;
            }
            strHex += hex;
        }
        if(strHex.length !== 7){
            strHex = that;
        }
        return strHex;
    }else if(reg.test(that)){
        var aNum = that.replace(/#/,"").split("");
        if(aNum.length === 6){
            return that;
        }else if(aNum.length === 3){
            var numHex = "#";
            for(var i=0; i<aNum.length; i+=1){
                numHex += (aNum[i]+aNum[i]);
            }
            return numHex;
        }
    }else{
        return that;
    }
};

//-------------------------------------------------

/*16进制颜色转为RGB格式*/
String.prototype.colorRgb = function(){
    var sColor = this.toLowerCase();
    if(sColor && reg.test(sColor)){
        if(sColor.length === 4){
            var sColorNew = "#";
            for(var i=1; i<4; i+=1){
                sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));
            }
            sColor = sColorNew;
        }
        //处理六位的颜色值
        var sColorChange = [];
        for(var i=1; i<7; i+=2){
            sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));
        }
        //2015年11月24日17:19:00 xb改了 转成数组
        //return "RGB(" + sColorChange.join(",") + ")";
        return sColorChange;
    }else{
        return sColor;
    }
};