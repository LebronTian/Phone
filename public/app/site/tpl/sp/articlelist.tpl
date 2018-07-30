
<?php 
	// var_dump($articles);
?>
<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">文章管理</strong> / <small>总计 <?php echo $articles['count'];?> 篇</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
    <a  href="?_a=site&_u=sp.addarticle" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加文章</a>
	</div>
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '<option value="0"';
					if($option['cat_uid']==0) $html .= ' selected ';
					$html .= '>所有分类</option>';
					
					foreach($cats as  $c) {
					$html .= '<option value="'.$c['uid'].'"';
					if($option['cat_uid'] == $c['uid']) $html .= ' selected';
					$html .= '>'.$c['title'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
        </div>

	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div>

</div>

<?php
	//var_export($articles);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除文章</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">文章标题</th>
			<th class="table-parent">分类</th>
			<th class="table-image">图片</th><th class="table-order">排序</th>
			<th class="table-time">编辑时间</th><th class="table-cnt">阅读数</th><th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$articles['list']) {
		echo $articles['list'];
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($articles['list'] as $c) {
			$html .= '<tr';
			if($c['status']) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.
					$c['title'].'</td><td>'.(!empty($c['cat']['title']) ? $c['cat']['title'] : '未分类').'</td><td><img src="'.$c['image'].'" style="max-width:100px;max-height:100px;"></td><td>'
					.$c['sort'].'</td><td>'.date('Y-m-d H:i:s', $c['modify_time']).'</td><td>'.$c['click_cnt'].'</td><td>'
					.($c['status'] ? '<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
					'<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>').
					'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=site&_u=sp.addarticle&uid='.$c['uid']
				.'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>
    


<?php
$extra_js = array(
    $static_path.'/js/articlelist.js',
);
?>
