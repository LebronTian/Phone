<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">海报列表</strong> /
<small>共计 <?php echo $data['count'];?> 个</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=qrxcx&_u=sp.photoset" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加小程序海报</a>
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
            <th>背景图</th>
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
        <tr '.($p['status']==2 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>'.$p['uid'].'</td>
            <td><img src="'.$p['photo_info']['img_url'].'" style="max-width:100px;max-height:100px"/></td>


            <td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-success">使用中' : ('am-btn-danger">未使用')).'</a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=qrxcx&_u=sp.photoset&copy_uid='.$p['uid'].'" class="am-btn am-btn-success am-btn-xs am-text-primary">
                            <span class="am-icon-copy"></span> 复制
                        </a>
                        <a href="?_a=qrxcx&_u=sp.photoset&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
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
    '/spv3/qrxcx/staic/js/photolist.js',
);

?>
