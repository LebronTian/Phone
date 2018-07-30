  $(function(){
  //绑定输入框，这里只能 是ID
   $("#cityName").keydown(function(event){
    event=document.all?window.event:event;
    if((event.keyCode || event.which)==13){
     theLocation();
    }
   }); 
})

	// 百度地图API功能
	var new_lng;
	var new_lat;
	var new_poi;
	var old_lat = $('#allmap').attr('data-lat');
	var old_lng = $('#allmap').attr('data-lng');

    var map = new BMap.Map('allmap');
    if(old_lng!="" && old_lat!="")
    	var poi = new BMap.Point(old_lng,old_lat);
    else
    	var poi = new BMap.Point(113.923938,22.500348);
    var html = "";
    html+='<div style="position:absolute;left:0;top:0;width:220px;height:100px;'
    	+'"><div id="r-result"><div style="float:left">'+
    	'城市定位: </div><input id="cityName" type="text" style="width:100px; '
    	+'float:left;height:28px;" /><input class="btn_check" type="button" value="查询" '
    	+'onclick="theLocation()" style="background-color:white;border:thin solid black"/></div></div>';
    $('#allmap').append(html);
    map.centerAndZoom(poi, 16);
    map.enableScrollWheelZoom();
    var geoc = new BMap.Geocoder(); 


    var marker = new BMap.Marker(poi); //创建marker对象
	map.addOverlay(marker);

    map.addEventListener("click", function(e){

    	var pt = e.point;
		geoc.getLocation(pt, function(rs){
			var addComp = rs.addressComponents;
			var mapaddress = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
			$('#address').attr('value',mapaddress);
		});  

	    new_poi = new BMap.Point(e.point.lng,e.point.lat);
	    map.removeOverlay(marker);
	    marker = new BMap.Marker(new_poi); //创建marker对象
		map.addOverlay(marker);
		new_lat = e.point.lat;
		new_lng = e.point.lng;
    });
});

function theLocation(){
		var city = document.getElementById("cityName").value;
		if(city != ""){
			map.centerAndZoom(city,11);      // 用城市名设置地图中心点
		}
	}



$('.save').click(function(){
	var more_info = {latitude:new_lat,longitude:new_lng};
	var location = $('#address').val();
	var brief = $('#company').val();
	
	more_info = JSON.stringify(more_info);
	var data = {more_info:more_info,location:location,brief:brief};
	console.log(data);
	$.post('?_a=site&_u=api.set', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
});

