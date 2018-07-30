// 刷新时判断当前元素是否在浏览器可视范围内
$(document).ready(function(){
  var myTop1 = $(document).scrollTop()+420;
  var myTop2 = $("#div1").offset().top;
  if( myTop2 <= myTop1){
    loadJsCss("/app/web/static/css/loadCss.css", "css") //打开页面时浏览器动态的加载css 文件
  };
})

// 判断当前元素是否在浏览器可视范围

// 在head中添加文件链接
function loadJsCss(filename, filetype){
  if (filetype=="js")
  {
    var fileref=document.createElement('script')//创建标签
    fileref.setAttribute("type","text/javascript")//定义属性type的值为text/javascript
    fileref.setAttribute("src", filename)//文件的地址
  }
  else if (filetype=="css")
  { 
    var fileref=document.createElement("link")
    fileref.setAttribute("rel", "stylesheet")
    fileref.setAttribute("type", "text/css") 
    fileref.setAttribute("href", filename)
  }
  if (typeof fileref!="undefined")
  {
    document.getElementsByTagName("head")[0].appendChild(fileref)
  }
} 


// 返回浏览器的可视区域位置 
function getClient(){ 
  var l, t, w, h; 
  l = document.documentElement.scrollLeft || document.body.scrollLeft; 
  t = document.documentElement.scrollTop || document.body.scrollTop; 
  w = document.documentElement.clientWidth; 
  h = document.documentElement.clientHeight; 
  return { left: l, top: t, width: w, height: h }; 
} 

// 返回待加载资源位置 
function getSubClient(p){ 
  var l = 0, t = 0, w, h; 
  w = p.offsetWidth; 
  h = p.offsetHeight; 
  while(p.offsetParent){ 
  l += p.offsetLeft; 
  t += p.offsetTop; 
  p = p.offsetParent; 
  } 
  return { left: l, top: t, width: w, height: h }; 
} 

// 判断两个矩形是否相交,返回一个布尔值 
function intens(rec1, rec2){ 
  var lc1, lc2, tc1, tc2, w1, h1; 
  lc1 = rec1.left + rec1.width / 2; 
  lc2 = rec2.left + rec2.width / 2; 
  tc1 = rec1.top + (rec1.height-500 )/ 2 ; 
  tc2 = rec2.top + rec2.height / 2 ; 
  w1 = (rec1.width + rec2.width) / 2 ; 
  h1 = (rec1.height + rec2.height) / 2; 
  return Math.abs(lc1 - lc2) < w1 && Math.abs(tc1 - tc2) < h1 ; 
} 

var div1 = document.getElementById("div1"); 
window.onscroll = function(){ 
var prec1 = getClient(); 
var prec2 = getSubClient(div1); 
if (intens(prec1, prec2)) { 
return("true"); 
} 
}; 

// 比较某个子区域是否呈现在浏览器区域 
function jiance(arr, prec1, callback){ 
  var prec2; 
  for (var i = arr.length - 1; i >= 0; i--) { 
    if (arr[i]) { 
    prec2 = getSubClient(arr[i]); 
    if (intens(prec1, prec2)) { 
    callback(arr[i]); 
    // 加载资源后，删除监测 
    delete arr[i]; 
     } 
    } 
  } 
} 

// 检测目标对象是否出现在客户区 
function autocheck(){ 
var prec1 = getClient(); 
jiance(arr, prec1, function(obj){ 
// 加载资源... 
// alert(obj.innerHTML); 
loadJsCss("/app/web/static/css/loadCss.css", "css") //打开页面时浏览器动态的加载css 文件
}) 
} 

// 子区域一 
var d1 = document.getElementById("div1"); 
// 子区域二
var d2 = document.getElementById("div2"); 
// 需要按需加载区域集合 
var arr = [d1, d2]; 
window.onscroll = function(){ 
// 重新计算 
　　autocheck(); 
} 
window.onresize = function(){ 
// 重新计算 
autocheck(); 
} 

// 判断浏览器类型
$(document).ready(function(){
  function myBrowser(){
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera"
    }; //判断是否Opera浏览器
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //判断是否Firefox浏览器
    if (userAgent.indexOf("Chrome") > -1){
        return "Chrome";
 }
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //判断是否Safari浏览器
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
        return "IE";
    }; //判断是否IE浏览器
}
//以下是调用上面的函数
var mb = myBrowser();
// if ("IE" == mb) {

//     alert("我是 IE");
// }

switch(mb)
{
  case "FF":
    break;
  case "Chrome":
    break;
  case "Opera":
    break;
  default:
    $("#step_1").html('<img src="/app/web/static/images/cooperate/step_1.png">');
    $("#step_2").html('<img src="/app/web/static/images/cooperate/step_2.png">');
    $("#step_3").html('<img src="/app/web/static/images/cooperate/step_3.png">');
    $("#step_4").html('<img src="/app/web/static/images/cooperate/step_4.png">');
    $("#step_5").html('<img src="/app/web/static/images/cooperate/step_5.png">');
}

})


