<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">客服服务</strong> / <small>总计 <?php echo $data['count']; ?> 条数据</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=site&_u=sp.addkefu" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加客服服务</a>

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
            <th class="table-title">名称</th>
            <th class="table-image">图片</th>
            <th class="table-parent">电话</th>
            <th class="table-parent">留言人数</th>
            <th>排序</th>
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
        <tr '.($p['status']==1? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>
                <span class="template-title">'.$p['title'].'</span>
                <p style="margin:0">';
                $html.='
                </p>
            </td>
            <td><img src="'.$p['image'].'" style="max-width:100px;max-height:100px"/></td>
            <td>'.$p['phone'].'</td>
            <td><a href="?_a=site&_u=sp.kefumsglist&kf_uid='.$p['msg_cnt'].'">'.$p['msg_cnt'].'</a></td>
            <td>'.$p['sort'].'</td>
            <td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">下线' : 'am-btn-success">上线').'</a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=site&_u=sp.addkefu&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
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
    $static_path.'/js/kefulist.js',
);

?>

