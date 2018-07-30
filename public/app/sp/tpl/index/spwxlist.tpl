<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">绑定微信号</strong> / 
<small>绑定微信号以后，您可以使用扫码登陆，接收微信通知等功能</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=sp&_u=index.addspwx" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加绑定</a>
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
            <th>昵称</th>
            <th>头像</th>
            <th>时间</th>
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
	$su_uid = Dba::readOne('select su_uid from weixin_fans where open_id = "'.addslashes($p['open_id']).'"');
	$su = Dba::readRowAssoc('select uid, name, avatar from service_user where uid = '.$su_uid);
                        $html .= '<tr  data-id="'.$p['open_id'].'"><td><input type="checkbox" class="delCheck" /></td>';
        		    	$html .= '<td>'.$su['name'].'</td>';
        		    	$html .= '<td><img width=64 height=64 src="'.$su['avatar'].'"></td>';
        		    	$html .= '<td>'.date('Y-m-d H:i:s', $p['create_time']).'</td>';
        		    	$html .= '
        		    		<td><div class="am-btn-toolbar">
        		    		    <div class="am-btn-group am-btn-group-xs">
        		    		        <a href="?_a=sp&_u=index.addspwx&open_id='.$p['open_id'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary">
        		    		            <span class="am-icon-trash-o"></span> 编辑
        		    		        </a>
        		    		        <button class="am-btn am-btn-default am-btn-xs delBtn" data-id="'.$p['open_id'].'">
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
	$extra_js = $static_path.'/js/spwxlist.js';
?>

