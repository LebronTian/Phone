
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
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">活动管理</strong> / </div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=shop&_u=sp.addactivity" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加活动</a>
	</div>
<!--    <select class="catList-yhc"></select>-->

    <div class="noCats-box"></div>
</div>


<div class="am-u-sm-12" style="min-height: 300px">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
            <th class="table-check">
                <input type="checkbox" class="ccheckall">
                <a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th class="table-title">活动名称</th>
            <th class="table-status">活动图片</th>

            <th class="table-image">活动开始时间</th>
            <th class="table-order">活动结束时间</th>
            <th class="table-set">操作</th>
        </tr>
    </thead>
    <tbody>
<?php

    if(!$act) {
        echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
    }
    else {
        $html = '';
        foreach($active as $c) {
            $html .= '<tr';
            $html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.
                    $c['title'].'</td><td><img src="'.$c['act_img'].'" style="max-width:100px;max-height:100px;"></td>';
            //$html .= '<td>'.htmlspecialchars(mb_substr($c['content'], 0, 20, 'utf-8')).'...</td>';
            $html.='<td>'.$c['start_time'].'</td><td>'.$c['end_time'].
                    '</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
            $html .= '<a href="?_a=shop&_u=sp.addactivity&uid='.$c['uid']
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
<div class="am-u-sm-12">
    <?php
	echo $pagination;
?>
</div>

<?php


$extra_js = array(
        '/static/js/catlist_yhc.js',
        $static_path.'/js/activitylist.js',
        $static_path.'/js/catsSelect.js',
);

?>



