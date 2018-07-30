<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">打印机列表</strong> /
<small>共计 <?php echo $data['count'];?> 台</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a style="display:none;" href="?_a=shop&_u=sp.addguguji" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加打印设备</a>
        <a  href="?_a=shop&_u=sp.addprinter" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加易联云打印</a>
    </div>
</div>

<div class="am-u-sm-12" style="min-height: 300px">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <th class="table-check">
                <input type="checkbox" class="ccheckall">
                <a href="javascript:;" class="am-text-danger am-text-lg delAll" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th class="table-title">编号</th>
            <th class="table-title">设备名称</th>
            <th class="table-image">设备编号</th>
            <th>创建</th>
            <th>状态</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$data["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($data["list"] as $p) {
        $html .='
        <tr '.($p['status']==0 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>'.$p['uid'].'</td>
            <td>
                <span class="template-title">'.$p['name'].'</span>
                <p style="margin:0">';
                $html.='
                </p>
            </td>
            <td>'.$p['memobirdid'].'</td>

            <td>'.date('Y-m-d H:i:s',$p['create_time']).'</td>
            <td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-success">使用' : 'am-btn-danger">禁用').'</a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=shop&_u=sp.addguguji&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
                            <span class="am-icon-edit"></span> 编辑
                        </a>
                        <button class="am-btn am-btn-default am-btn-xs am-text-danger delBtn" data-id="'.$p['uid'].'">
                            <span class="am-icon-trash-o"></span> 删除
                        </button>
                    </div>
                </div>
            </td>
        </tr>';
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
    '/static/js/catlist_yhc.js',
    $static_path.'/js/gugujilist.js',
);

?>
