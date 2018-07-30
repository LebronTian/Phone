<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">服务商城</strong> / <small>总计  <?php echo $data['count'];?> 个</small></div>
</div>

<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
          <div class="am-btn-toolbar am-fl">
            <div class="am-btn-group am-btn-group-lg">
            </div>

            <div class="am-form-group am-margin-left am-fl">
            </div>
        </div>
    </div>
    </div>

	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
        </div>
      </div>
</div>

<!-- 头部工具栏 end -->
<?php
#var_export($option);
#var_export($data['list']);
?>
<style>
	.am-img-thumbnail {
		max-width: 174px;
		max-height: 174px;
	}
</style>


<ul class="am-avg-md-4 am-avg-lg-4 am-margin">
<?php
	if(!$data['list']) {
		echo '<li class="am-danger"><td>暂无数据！</li>';
	}
	else {
		$html = '';
		foreach($data['list'] as $l) {
			$html .= '
      <li>
		<a href="?_a=sp&_u=index.servicedetail&uid='.$l['uid'].'">
        <img class="am-img-thumbnail am-img-bdrs" src="'.$l['thumb'].'" alt="">
		</a>
          <div class="gallery-title"><strong>'.$l['name'].'</strong></div>
          <div class="gallery-desc">';
			$html .= '</div>
      </li>
			';
		}
		echo $html;
	}
?>
</ul>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	//$extra_js = $static_path.'/js/pluginstore.js';
?>
