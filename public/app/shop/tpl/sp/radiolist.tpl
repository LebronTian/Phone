<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">广播编辑</strong> / </div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.addradio" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加广播</a>
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
            <th>广播标题</th>
            <th>时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        		if(empty($documents["list"])) {
        		    echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else{
        $html = '';

        foreach ($documents['list'] as $p) {
        $html .= '<tr  data-id="'.$p['uid'].'"><td><input type="checkbox" class="delCheck" /></td>';
            $html .= '<td>'.$p['title'].'</td>';
            //$html .= '<td>'.htmlspecialchars(mb_substr($p['content'], 0, 20, 'utf-8')).'...</td>';
            $html .= '<td>'.date('Y-m-d H:i:s', $p['create_time']).'</td>';
            $html .= '
            <td><div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=shop&_u=sp.addradio&uid='.$p['uid'].'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary">
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
	$extra_js = $static_path.'/js/radiolist.js';
?>

