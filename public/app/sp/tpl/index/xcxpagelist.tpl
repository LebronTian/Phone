<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">小程序拖拽页</strong> / </div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.index_view&uid=-1" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 新增页面</a>
    </div>
</div>
<div class="am-u-sm-12" style="min-height: 300px">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <th class="table-check">
                <input type="checkbox" class="dcheckall">
                <a href="javascript:;" class="am-text-danger am-text-lg delAll" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th>编号</th>
            <th>页面名称</th>
            <th>所属小程序</th>
            <th>创建时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        	<?php 
        		if(empty($data["list"])) {
        		    echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        		}else{
        		    $html = '';

        		    foreach ($data['list'] as $p) {
                        $html .= '<tr  data-id="'.$p['uid'].'"><td><input type="checkbox" class="delCheck" /></td>';
        		    	$html .= '<td>'.$p['uid'].'</td>';
        		    	$html .= '<td><a>'.$p['title'].'</a></td>';
        		    	$html .= '<td>'.($p['public_uid']).'<td>';
        		    	$html .= '<td>'.date('Y-m-d H:i:s', $p['create_time']).'</td>';
            			$html .= '<td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">禁用' : 'am-btn-success">显示').'</a></td>';
        		    	$html .= '
        		    		<td><div class="am-btn-toolbar">
        		    		    <div class="am-btn-group am-btn-group-xs">
        		    		        <a href="?_a=shop&_u=sp.index_view&uid='.$p['uid'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary">
        		    		            <span class="am-icon-edit"></span> 编辑
        		    		        </a>
        		    		        <button class="am-btn am-btn-default am-btn-xs delBtn" data-id="'.$p['uid'].'">
        		    		            <span class="am-icon-trash-o"></span> 删除
        		    		        </button>
        		    		    </div>
        		    		</div></td></tr>	
        		    	';
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
	$extra_js = $static_path.'/js/xcxpagelist.js';
?>

