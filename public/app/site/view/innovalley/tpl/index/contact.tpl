<?php 
include $tpl_path.'/header.tpl';

#var_export($site);
?>


<div class="content">
<div class="contact_content">
    <div class="company_detail">
        <p>公司地址：<span><?php if(!empty($site['location'])) echo $site['location']; else echo '深圳市南山区蛇口工业六路9号创新谷'  ?></span></p>
        <p>地铁：<span>蛇口线水湾站C出口，步行约10分钟</span></p>
        <p>公交：<span>招商发展中心站，可乘坐113、K113、328、329、M241、机场10</span></p>
    </div>

    <div class="company_contact">
        <?php if(!empty($site['phone'])) echo '<p>电话：<span>'.$site['phone'].'</span></p>' ;?>
        
    </div>

    <div class="company_map">

            <div id="map"></div>
           <div class="cube">
                <img src="/app/site/view/innovalley/static/image/cube.png">
            </div>
    </div>
    <div class="last_img"><img src="/app/site/view/innovalley/static/image/title.png"></div>
</div>
</div>
<footer class="footer">
  <div class="am-container">
    <p><?php if(!empty($site['location'])) echo $site['location']; else echo '深圳市南山区蛇口工业六路9号创新谷'  ?></p>
  </div>
</footer>

<script src="/app/site/view/innovalley/static/js/jquery.min.js"></script>
<script src="/app/site/view/innovalley/static/js/amazeui.min.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/style.js"></script>
 <script type="text/javascript">
    //创建和初始化地图函数：
    function initMap(){
      createMap();//创建地图
      setMapEvent();//设置地图事件
      addMapControl();//向地图添加控件
      addMapOverlay();//向地图添加覆盖物
    }
    function createMap(){ 
      map = new BMap.Map("map"); 
      map.centerAndZoom(new BMap.Point(<?php if(!empty($site['more_info'])) echo $site['more_info']['longitude'].','.$site['more_info']['latitude']; else echo '113.924227,22.500268'; ?>),16);
    }
    function setMapEvent(){
      map.enableScrollWheelZoom();
      map.enableKeyboard();
      map.enableDragging();
      map.enableDoubleClickZoom()
    }
    function addClickHandler(target,window){
      target.addEventListener("click",function(){
        target.openInfoWindow(window);
      });
    }
    function addMapOverlay(){
      var markers = [
        {content:"",title:"<?php if(!empty($site['title'])) echo $site['title']; else echo '深圳优创智投科技有限公司'; ?>",imageOffset: {width:-46,height:-21},position:{<?php if(!empty($site['more_info'])) echo 'lat:'.$site['more_info']['latitude'].',lng:'.$site['more_info']['longitude']; else echo 'lat:22.500426,lng:113.923958'; ?>}}
      ];
      for(var index = 0; index < markers.length; index++ ){
        var point = new BMap.Point(markers[index].position.lng,markers[index].position.lat);
        var marker = new BMap.Marker(point,{icon:new BMap.Icon("http://api.map.baidu.com/lbsapi/createmap/images/icon.png",new BMap.Size(20,25),{
          imageOffset: new BMap.Size(markers[index].imageOffset.width,markers[index].imageOffset.height)
        })});
        var label = new BMap.Label(markers[index].title,{offset: new BMap.Size(25,5)});
        var opts = {
          width: 200,
          title: markers[index].title,
          enableMessage: false
        };
        var infoWindow = new BMap.InfoWindow(markers[index].content,opts);
        marker.setLabel(label);
        addClickHandler(marker,infoWindow);
        map.addOverlay(marker);
      };
    }
    //向地图添加控件
    function addMapControl(){
      var navControl = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:0});
      map.addControl(navControl);
    }
    var map;
      initMap();
  </script>
</body>
</html>