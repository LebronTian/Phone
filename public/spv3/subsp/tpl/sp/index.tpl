<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">员工帐号列表</strong> / </div>
</div>
<?php
#var_export($option);
#var_export($cats);
#var_export($data['list']);

$max_subsp_cnt = SpLimitMod::get_current_max_subsp_cnt();
?>

<style>
    .public-title{
        font-size: 1em;
        color: #696868;
    }
    .title-number{
        font-size: 1.5em;
    }

</style>

<div class="am-u-sm-12">
    <p class="public-title">
        <span style="color: #5eb95e" class="title-number"><?php echo $cnt ?></span>（已有的员工账号）
        /
        <span>&nbsp;<?php echo $max_subsp_cnt ?></span>（员工账号配额）
    </p>
    <a href="?_a=subsp&_u=sp.addsubsp"><button class="am-btn am-btn-secondary" <?php if($cnt>=$max_subsp_cnt) echo 'disabled'; ?>>
		添加员工账号</button></a>
    <a href="?_a=sp&_u=index.servicedetail&uid=6"><button class="am-btn am-btn-success">购买员工账号配额</button></a>

    <table class="am-table am-table-hover table-main pro-table-self cats-table-self">
        <thead>
        <tr>
            <!--<th class="table-check"><input type="checkbox"></th>-->
            <th class="table-title">名称</th>
            <th class="table-type">头像</th>
            <th class="table-date">添加时间</th>
			<th class="table-date">最近登陆时间</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$data) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }
        else {
            $html = '';
            foreach($data as $l) {
                $html .= '<tr><td><a href="?_a=subsp&_u=sp.addsubsp&uid='.$l['uid'].'">'.$l['name'].'</a></td>
              <td><img style="width:60px;height:60px" src="'.($l['avatar'] ? $l['avatar'] : '/static/images/null_avatar.png').'"></td>
              <td>'.date('Y-m-d H:i:s', $l['create_time']).'</td>
              <td>'.date('Y-m-d H:i:s', $l['last_time']).'</td>
              <td>
                  <div class="am-btn-group am-btn-group-xs">';
                $html .= '<a href="?copy_uid='.$l['uid'].'&_a=subsp&_u=sp.addsubsp" class="am-btn am-btn-success am-btn-xs"><span class="am-icon-copy"></span> 复制</a>';
                $html .= '<a href="?_a=subsp&_u=sp.addsubsp&uid='.$l['uid'].'" class="am-btn am-btn-default am-btn-xs"><span class="am-icon-edit"></span> 编辑</a>';
                if(1 || !empty($_REQUEST['_d'])) {
                    $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
                }
                $html .= '
                  </div>
              </td>
            </tr>
			';
            }
            echo $html;
        }
        ?>


        </tbody>
    </table>
</div>

<?php
$extra_js = $static_path.'/js/index.js';
?>

