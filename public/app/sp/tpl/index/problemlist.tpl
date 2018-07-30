
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">常见问题</strong> / </div>
</div>

<div class="am-g am-padding">

    <div class="am-u-md-6">
        <div class="am-fl am-cf">
            <a  href="?_a=sp&_u=index.addproblem" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加</a>
        </div>
        <div class="am-form-group am-margin-left am-fl">
            <select data-am-selected="{btnSize: 'lg' }" class="option_type">
                <?php

                $html = '<option value="0"';
                if($option['type']==0) $html .= ' selected ';
                $html .= '>所有问题</option>';

                foreach($types as  $c) {
                $html .= '<option value="'.$c.'"';
                var_dump($c);
                if($option['type'] == $c) $html .= ' selected';
                $html .= '>'.$c.'</option>';
                }
                echo $html;
                ?>
            </select>
        </div>
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
            <th>问题标题</th>
            <th>分类</th>
            <th>排序</th>
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
        $html .= '<tr  data-id="'.$p['uid'].'"><td><input type="checkbox" class="delCheck" /></td>';
            $html .= '<td>'.$p['uid'].'</td>';
            $html .= '<td>'.$p['title'].'</td>';
            $html .= '<td>'.(!empty($p['type'])?$p['type']:'-').'</td>';
            $html .= '<td>'.$p['sort'].'</td>';
            //$html .= '<td>'.htmlspecialchars(mb_substr(strip_tags($p['content']), 0, 20, 'utf-8')).'...</td>';
            $html .= '<td>'.date('Y-m-d H:i:s', $p['create_time']).'</td>';
            $html .= '
            <td><div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=sp&_u=index.addproblem&uid='.$p['uid'].'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary">
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
	$extra_js = $static_path.'/js/problemlist.js';
?>

