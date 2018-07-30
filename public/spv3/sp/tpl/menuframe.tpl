	<!--左则导航菜单2-->
  <div class="conter-left2 float-left qckslt" style="z-index:4">
  	
    <div class="conter-left2-div">
	<div id="id_conter_left2">
	</div>
    	<div style="height:50px;"></div>
    </div>
    
    <!--展开收起--> <div class="kzlst zy-zk"><span class="iconfont icon-zhankaisanjidaohang16"></span></div> <!--/展开收起-->
    
  </div>
  <!--/左则导航菜单2-->  

	<!--中间-->
	<div class="conter-right zhicwl-hxgaolr">
		<div class="conter-right-header public-hearder" id="id_where_am_i">
<script>
function update_where_am_i() {
var _on1_url = $('.inye.on a').attr('href');
var _on1_name = $('.inye.on a samp').text();
var _on2_url = $('.conter-left2-div .on a').attr('href');
var _on2_name = $('.conter-left2-div .on samp').text();
console.log(_on2_url, _on2_name);
$('#id_where_am_i').html('<a href="'+_on1_url+'">'+_on1_name+
						'</a> &gt <a href2="'+_on2_url+'">'+_on2_name+'</a>');
}
$('#id_logout').click(function(){
if(!confirm('确定要退出系统吗?')) return;
window.location.href="?_a=sp&_u=index.logout";
});
</script>
		</div>
		<div class="conter-right-body">
			<?php
	if(!empty($view_path)) {
		$_file = (is_array($view_path) ? array_pop($view_path) : $view_path);
		if(file_exists($_file)) {
			include($_file);
		}
		else {
			echo 'warning! tpl file not found!!! '.substr($_file, strlen(UCT_PATH));
		}
	}
?>
		</div>
	</div>
	<!--/中间-->

