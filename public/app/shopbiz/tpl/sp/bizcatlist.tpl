<style>
    .noCats-box{
        margin-left: 4em;
        padding: 0.7em 0;
        display: none;
    }
    .noCats-box section{
        display: inline-block;
        padding: 10px;
        border: thin solid #ddd;
        margin-right: 0.5em;
        background: #ffffff;
        cursor: pointer;
    }
    .admin-content #chooseCats{
        max-height: 700px;
    }
</style>

<div class="am-cf am-padding" onselectstart="return false">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商家分类</strong> / </div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=shopbiz&_u=sp.addbizcat" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加分类</a>
	</div>
<!--    <select class="catList-yhc"></select>-->


    <div class="noCats-box"></div>
</div>

<?php
	//var_export($cats);
?>

<div class="am-u-sm-12" style="min-height: 300px">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">分类名称</th>
			<th class="table-image">图片</th><th class="table-order">排序</th><th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$cats) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($cats as $c) {
			$html .= '<tr';
			if($c['status']) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.
					$c['title'].($c['title_en'] ? ' ('.$c['title_en'].')' : '').'</td><td><img src="'.$c['image'].'" style="max-width:100px;max-height:100px;"></td><td>'
					.$c['sort'].'</td><td>'.($c['status'] ? '<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
					'<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>').
					'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=shopbiz&_u=sp.addbizcat&uid='.$c['uid']
				.'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>

<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <select class="catList-yhc"></select>
            </div>
        </div>
    </div>
</div>

<?php
	$extra_js = array(
        '/static/js/catlist_yhc.js',
        $static_path.'/js/bizcatlist.js',
    );
?>
<script>
    var cats =<?php echo !empty($cats) ? json_encode($cats) : "null" ?>;

</script>

