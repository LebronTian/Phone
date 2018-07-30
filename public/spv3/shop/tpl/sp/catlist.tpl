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

    tbody .table-check span{
        margin-left: 15px!important;
        color: rgb(0,119,221);
    }
</style>

<!-- <div class="am-cf am-padding" onselectstart="return false">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分类管理</strong> / <small>共<?php echo count($cats);?>条数据</small></div>
</div>
<hr> -->

<div class="am-g">
	<div class="am-fl am-cf">
    <a  href="?_a=shop&_u=sp.addcat" type="button" class="am-btn am-btn-success blue-self">新建商品分组</a>
	</div>
<!--    <select class="catList-yhc"></select>-->
    <!-- <button style="margin-left: 1em" type="button" class="am-btn am-btn-primary choose-cats">
        选择分类
    </button> -->
    <div class="am-form-group am-fr am-cf mb0">
                    <div class="am-form-group am-form-icon pro-input-self mb0">
                        <i class="am-icon-search"></i>
                        <input type="search" class="am-form-field option_key" placeholder="搜索" style="padding-left: 30px!important;width: 110px;">
                    </div>
                </div>
    <div class="noCats-box"></div>
</div>

<?php
	//var_export($cats);
?>

<div class="am-u-sm-12 pl0 pr0" style="min-height: 600px">
<table class="am-table am-table-hover table-main pro-table-self cats-table-self">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger cdeleteall" style="margin-left:10px;color: #000"><span class="table-title">分类名称</span></a>
			</th>
			<th class="table-parent">父级分类</th>
			<!-- <th class="table-image">图片</th> -->
			<th class="table-order">排序</th>
			<th class="table-status">状态</th>
			<th><a href="<?php echo ($option['sort'] == SORT_CREATE_TIME ? this_url('sort', SORT_CREATE_TIME_DESC) : this_url('sort', SORT_CREATE_TIME)) ?>">创建时间</a></th>
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
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check am-text-truncate width200"><input type="checkbox" class="ccheck"><span>'.$c['title'].($c['title_en'] ? ' ('.$c['title_en'].')' : '').' ['.$c['uid'].']'.'</span></td><td>'.(!empty($c['parent_cat']['title']) ? $c['parent_cat']['title'] : '顶级').'</td><!-- <td><img src="'.$c['image'].'" style="max-width:100px;max-height:100px;"></td> --><td>'
					.$c['sort'].'</td><td>'.($c['status'] ? '<button data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</button>':
					'<button data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success blue-self">已显示</button>').
					'</td><td>';

			$html .= date("Y-m-d H:i:s",$c['create_time']);
			$html .= '</td><td>';		
			$html .= '<a href="?_a=shop&_u=sp.addcat&uid='.$c['uid']
				.'" target="_self" class="am-text-primary">编辑</a>';
			$html .= '<a class="am-text-danger cdelete" data-id="'.$c['uid'].'">删除</a>';
			$html .= '<a class="am-text-danger">链接</a>';
			
			$html .= '</td>'.'</tr>';
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<div class="am-u-sm-12 pl0 pr0 pro-btngroup-self">
    <div class="am-fl am-cf">
        <button class="am-btn am-btn-default time-btn cdeleteall">删除</button>
    </div>
    <!-- <div class="am-u-sm-12">
        <?php
        #echo $pagination;
        ?>
    </div> -->
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
        '/spv3/shop/static/js/catlist.js',
    );
?>
<script>
    var parents =<?php echo !empty($parents) ? json_encode($parents) : "null" ?>;
    var cats =<?php echo !empty($cats) ? json_encode($cats) : "null" ?>;
    var catsAll =<?php echo !empty($catsAll) ? json_encode($catsAll) : "null" ?>;
    console.log(catsAll)
</script>

