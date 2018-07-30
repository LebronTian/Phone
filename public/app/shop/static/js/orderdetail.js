$(document).ready(function () {

    //$('.my-tab').find('a').on('open.tabs.amui', function() {
    //});
    //
    //$('.my-tab').find('a').on('opened.tabs.amui', function() {
    //});
    //
    ///**地图**************************************************************/
    //var map = new BMap.Map("chef-map");          // 创建地图实例
    //var geoc = new BMap.Geocoder();
    //var point = new BMap.Point(order.chef.lng,order.chef.lat);
    //map.centerAndZoom(point,16);
    //map.disableScrollWheelZoom();
    //map.addControl(new BMap.NavigationControl());//左侧伸缩控件
    //geoc.getLocation(point, function (rs) {
    //   var opts = {
    //       width:200,
    //       height:100,
    //       title:"地址：",
    //       enableCloseOnClick:false
    //   };
    //    var infoWindow = new BMap.InfoWindow(rs.address,opts);
    //    map.openInfoWindow(infoWindow,point)
    //});


    /*
    var geoc = new BMap.Geocoder();
    var marker;                         //贯穿全文的标记！！
    if(parseInt(order.chef.lat)==0){
        map.centerAndZoom("深圳市", 13);                 // 初始化地图，设置中心点坐标和地图级别
    }else{
        var point = new BMap.Point(chef.lng, chef.lat);  // 创建点坐标
        map.centerAndZoom(point, 15);                 // 初始化地图，设置中心点坐标和地图级别
        if(marker){
            map.removeOverlay(marker);
        }
        marker = new BMap.Marker(point);
        map.addOverlay(marker);
    }
    map.addControl(new BMap.NavigationControl());//左侧伸缩控件
    map.enableScrollWheelZoom();   //启用滚轮放大缩小，默认禁用
    map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用*/

    //修改快递信息
    $('.cdodelivery').click(function(){
        var uid = order_data.uid;
        //do_delivery(uid);
        $('#my-confirm-delivery').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                do_delivery(uid);
            },
            onCancel: function() {
            }
        });
    });

    function do_delivery(uid) {
        var kuaidi = $('#id_courier_name').val();
        if(kuaidi==-1){
            kuaidi = $('#id_courier_name2').val()
        }
        var delivery_info = {
            '快递单号':   $('#id_courier_no').val(),
            '快递公司': kuaidi
        };

        var data = {uid: uid, delivery_info:delivery_info};
        console.log(data);
        $.post('?_a=shop&_u=api.edit_delivery', data, function(ret){
            ret = $.parseJSON(ret);
            console.log(ret);
	    window.location.reload();

        });
    }

	$('#id_print').click(function(){
		$("#id_print_area").jqprint({ operaSupport: false});
	});

});
