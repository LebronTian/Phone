   //创建和初始化地图函数：
  function initMap(string){
  var map = new BMap.Map(string);
  var point = new BMap.Point(114.114511,22.548500);
  var marker = new BMap.Marker(new BMap.Point(114.116262,22.547264));  // 创建标注
  map.addOverlay(marker);              // 将标注添加到地图中
  map.centerAndZoom(point, 18);
}



