
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">链接</strong> / </div>
</div>

<div class="am-g am-padding">
    <div class="am-u-md-6">
        <?php if(!empty($_REQUEST['_d'])) { ?>
        <div class="am-fl am-cf">
            <a  href="?_a=sp&_u=index.addlink" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加</a>
        </div>
        <?php } ?>
    </div>
    <div class="am-u-md-3 am-cf">

        <div class="am-fr">
            <div class="am-input-group am-input-group-sm">
                <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>"placeholder="标题">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
            </div>
        </div>
    </div>
</div>
<div class="am-u-sm-12" style="min-height: 300px">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <th class="table-check">

            </th>
            <th>编号</th>
            <th>标题</th>
        </tr>
        </thead>
        <tbody>
        <?php
        		if(empty($data["list"])) {
        		    echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else{
        $html = '';

        foreach ($data['list'] as $p) {
        $html .= '<tr  data-id="'.$p['uid'].'"><td></td>';
            $html .= '<td>'.$p['uid'].'</td>';
            $html .= '<td><a target="_blank" href="'.$p['link'].'">'.$p['title'].'(点击跳转)</a></td>';
            if(!empty($_REQUEST['_d'])) {
            $html .= '
            <td><div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=sp&_u=index.addlink&uid='.$p['uid'].'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary">
                            <span class="am-icon-edit"></span> 编辑
                        </a>
                        <button class="am-btn am-btn-default am-btn-xs delBtn" data-id="'.$p['uid'].'">
                            <span class="am-icon-trash-o"></span> 删除
                        </button>
                    </div>
                </div></td>';
            }
            $html .= '</tr>';
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
	$extra_js = $static_path.'/js/links.js';
?>

