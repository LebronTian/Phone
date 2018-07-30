
/* 引用这个JS之前 必须引用这两个文件             
'http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ',
            '/static/js/baidumap/SearchInfoWindow_min.js',
同时外部需要一个ID为address的input输入框
*/




$(function(){


var html = '';
html+='<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">'
    +'<div class="am-modal-dialog"><div class="am-modal-footer">'
    +'<span class="handinput" style="display: table-cell!important;padding: 0 5px;'
    +'height: 44px;-webkit-box-sizing: border-box!important;box-sizing: border-box!important;'
    +'font-size: 1.6rem;line-height: 44px;text-align: center;color: #0e90d2;display: block;'
    +'word-wrap: normal;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;'
    +'cursor: pointer;border-bottom: 1px solid #dedede">手动选址</span><span class="mapcheck" '
    +'style="display: table-cell!important;padding: 0 5px;height: 44px;'
    +'-webkit-box-sizing: border-box!important;box-sizing: border-box!important;font-size: 1.6rem;'
    +'line-height: 44px;text-align: center;color: #0e90d2;display: block;word-wrap: normal;'
    +'text-overflow: ellipsis;white-space: nowrap;overflow: hidden;cursor: pointer;'
    +'border-left: 1px solid #dedede;border-bottom: 1px solid #dedede">'
    +'地图选址</span></div>'
    +'<div class="hand_box" style="height:250px"><div style="margin-top:150px;">'
    +'<form><select class="select" name="province" id="s1"><option></option>'
    +'</select><select class="select" name="city" id="s2"><option></option>'
    +'</select><select class="select" name="town" id="s3"><option></option></select></form>'
    +' </div><div style="margin-top: 20px"><input type="text" id="tip" size="50" value="" style="border: 1px solid #CCC;"/>'           
    +'</div></div><div class="map_box" style="display:none">'    
    +'<div id="allmap" data-lat="" data-lng = "" style="height:400px"></div>'
    +'<div style="margin-top: 10px"><input type="text" id="tip" size="50"  value=""; style="border: 1px solid #CCC;"/></div>'
    +'<div style="margin-top: 10px"><input type="text" placeholder="纬度" id="lat" size="20"  value="" style="border: 1px solid #CCC;"/><input type="text" placeholder="经度" id="lng" size="20"  value="" style="border: 1px solid #CCC;margin-left: 10px"/></div>'
    +'</div><div class="am-modal-footer">'
    +'<span class="am-modal-btn" data-am-modal-cancel style="border-top: 1px solid #dedede">取消</span>'        
    +'<span class="am-modal-btn" data-am-modal-confirm style="border-top: 1px solid #dedede">确定</span>'
    +'</div></div></div>';
$('body').append(html);
setup();promptinfo();
/*地址点击
    $('#address').on('click', function() {
        $('#my-confirm').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                var address = $('#tip').val();
                $('#address').val(address);
            },
            onCancel: function() {
            }
        });
    });

*/
    /*地址点击*/

    $('#address').on('click', function() {

        $('#my-confirm').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                var address = $('#tip').val();
                var p_lng = $('#lng').val();
                var p_lat = $('#lat').val();
                $('#address').val(address);

                baidutotengxun(p_lng,p_lat);
            },
            onCancel: function() {
                console.log('>>>>> onCancel');
            }
        });
    });
    /*手动选择*/
    $('.handinput').click(function(){
        $('.map_box').hide();
        $('.hand_box').children('div').children('input').attr('id','tip')
        $('.hand_box').show();
    });
    /*地图选择*/
    $('.mapcheck').click(function(){
        $('.hand_box').hide();
        $('.hand_box').children('div').children('input').attr('id','')
        $('.map_box').show();
    });
    //绑定输入框，这里只能 是ID
    $(document).on('keydown','#cityName',function(event){
      event=document.all?window.event:event;
        if((event.keyCode || event.which)==13){
            theLocation();
        }
    })
    $(document).on('click','.btn_check',function(){
      theLocation();
    })

  // 百度地图API功能
  var address=$('#address').val();
  if(address){
  var link='http://api.map.baidu.com/geocoder/v2/?address='+address+'&output=json&ak=O2TlUoWwlRSpccEMM2Kr5fpZ&callback=showLocation';
  $.ajax({
        url: link,
        type: 'GET',
        dataType: 'JSONP',//here
        success: function (data) {
          var reg = data.result.location;
          //console.log(reg);
          $('#allmap').attr('data-lat',reg.lat);
          $('#allmap').attr('data-lng',reg.lng);
        }
    });
  }
//http://lbs.qq.com/webservice_v1/guide-convert.html
function baidutotengxun(lng,lat){
    //http://apis.map.qq.com/ws/coord/v1/translate?locations=39.12,116.83;30.21,115.43&type=3&key=ISDBZ-PNXCF-HUTJL-N3TM3-T3RQQ-ABFU7
    var data = {lng:lng,lat:lat}
    $.post('?_a=sp&_u=index.replay_bd_tx',data,function(obj){
        obj = $.parseJSON(obj);
        if(obj.errno==0){
            var point = obj['data']['locations'][0];
            console.log(point);
            $('#p_lng').val(point['lng']);
            $('#p_lat').val(point['lat']);
        }else{
            return false;
        }
    })
}
var theLocation;
function initAddressMap(){
  var new_lng;
  var new_lat;
  var new_poi;
  var old_lat = $('#allmap').attr('data-lat');
  var old_lng = $('#allmap').attr('data-lng');


    var map = new BMap.Map('allmap');
    if(old_lng!="" && old_lat!=""){
      new_lng=old_lng;
      new_lat=old_lat;
    }
    else{
      new_lng="113.76687";
      new_lat="22.742563";
    }
    var poi = new BMap.Point(new_lng,new_lat)
    var html = "";
    html+='<div style="position:absolute;left:0;top:0;width:220px;height:100px;'
      +'"><div id="r-result"><div style="float:left">'+
      '城市定位: </div><input id="cityName" type="text" style="width:100px; '
      +'float:left;height:25px;" /><input class="btn_check" type="button" value="查询" '
      +' style="background-color:white;'
      +'border:thin solid black;margin-top:-5px"/></div></div>';
    $('#allmap').append(html);
    var mk_ct_lng=parseFloat(new_lng)-0.02;
    var mk_ct_lat=parseFloat(new_lat)+0.015;
    console.log(mk_ct_lng+'----'+mk_ct_lat);
    map.centerAndZoom(new BMap.Point(mk_ct_lng,mk_ct_lat),15);
    map.enableScrollWheelZoom();
    var geoc = new BMap.Geocoder();
    var marker = new BMap.Marker(poi); //创建marker对象
    map.addOverlay(marker);
    marker.enableDragging();


    map.addEventListener("click", function(e){
    var pt = e.point;
    geoc.getLocation(pt, function(rs){
      var addComp = rs.addressComponents;
      var mapaddress = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
      $('#tip').attr('value',mapaddress);
      $('#lng').attr('value',pt.lng);
      $('#lat').attr('value',pt.lat);
    });

    new_poi = new BMap.Point(e.point.lng,e.point.lat);
    map.removeOverlay(marker);
    marker = new BMap.Marker(new_poi); //创建marker对象
    marker.enableDragging();
    marker.addEventListener("dragend", function(e){
        var pt = e.point;
    geoc.getLocation(pt, function(rs){
      var addComp = rs.addressComponents;
      var mapaddress = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
      $('#tip').attr('value',mapaddress);
    });

    });
    map.addOverlay(marker);

    new_lat = e.point.lat;
    new_lng = e.point.lng;
    });

    marker.addEventListener("dragend", function(e){
        var pt = e.point;
    geoc.getLocation(pt, function(rs){
      var addComp = rs.addressComponents;
      var mapaddress = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
      $('#address').attr('value',mapaddress);
    });
    });
    theLocation = function(){
    var city = document.getElementById("cityName").value;
    if(city != ""){
        map.centerAndZoom(city,11);      // 用城市名设置地图中心点
    }
}
}
    initAddressMap();
});
      
        