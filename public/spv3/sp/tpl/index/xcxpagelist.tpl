<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">小程序微页面</strong> / </div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.visualview&uid=-1" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 新增页面</a>
        <small>(最多可编辑5个微页面)</small>
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
            <th>编辑时间</th>
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
        		    	$html .= '<td class="showerweima">'.$p['uid'];
						if($p['sort'] == 999999) $html .= ' <a class="am-btn-warning">首页</a>';

$html .= '<div class="wap_erweima" style="display: none;z-index:9999;position:absolute"><img style="width:120px;height:120px; max-width:none;  " src2="?_u=xiaochengxu.qrcode&path=page%2Fclass%2Fpages%2Fcustom%2Fcustom%3Fuid%3D'.$p['uid'].'&type=0&public_uid='.$p['public_uid'].'">';

						$html .= '</td>';
        		    	$html .= '<td><a>'.$p['title'].'</a></td>';
        		    	$html .= '<td>';
						$public = WeixinMod::get_weixin_public_by_uid($p['public_uid']);
						$html .= ($public['public_name']);
						$html .= '</td>';
        		    	$html .= '<td>'.date('Y-m-d H:i:s', $p['modify_time']).'</td>';
            			$html .= '<td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">禁用' : 'am-btn-success">显示').'</a></td>';
        		    	$html .= '
        		    		<td>
                                <div class="am-btn-toolbar">
        		    		    <div class="am-btn-group am-btn-group-xs">
        		    		        <a href="?_a=shop&_u=sp.visualview&uid='.$p['uid'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary">
        		    		            <span class="am-icon-edit"></span> 编辑
        		    		        </a>
        		    		        <button class="am-btn am-btn-default am-btn-xs delBtn" data-id="'.$p['uid'].'">
        		    		            <span class="am-icon-trash-o"></span> 删除
        		    		        </button>
                                    <a href="?_a=shop&_u=sp.visualview&copyUid='.$p['uid'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary">
                                        <span class="am-icon-copy"></span> 复制
                                    </a>
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
	$extra_js = '/spv3/sp/static/js/xcxpagelist.js';
?>

