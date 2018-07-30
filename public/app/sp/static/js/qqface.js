$(function(){
	$('.emotion').qqFace({
		id : 'facebox', 
		assign:'saytext', 
		path:'/app/sp/static/images/arclist/'	//表情存放的路径
	});
	$('.com_form').on('click','td',function(){
		var reg = /\[(.*?)\]/gi; 
		var str = $("#saytext").val();
		var tmp = str.match(reg);
		$("#show").append(replace_mo(str));
		$("#saytext").val('');
		if (tmp) {
                for (var i = 0; i < tmp.length; i++) {
                    //console.log(tmp[i]); // 保留中括号
                    //alert(tmp[i].replace(reg, "$1")); // 不保留中括号
                    console.log(data[tmp[i]]['code']);
                }
            } 
	})

});
//查看结果
function replace_mo(str){
	str = str.replace(/\</g,'&lt;');
	str = str.replace(/\>/g,'&gt;');
	str = str.replace(/\n/g,'<br/>');
	str = str.replace(/\[mo_([0-9]*)\]/g,'<img src="/app/sp/static/images/arclist/$1.gif" border="0" />');
	return str;
}






