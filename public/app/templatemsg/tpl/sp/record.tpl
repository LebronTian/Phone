<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">模板发送记录</strong> /<small></small></div>
</div>

<div class="am-u-sm-12">
    <table class="am-table am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>公众号</th>
            <th>发送对象</th>
            <th>发送内容</th>
            <th>发送时间</th>
            <th>发送状态</th>
        </tr>
        </thead>
        <tbody>
        <?php
        $status_color = array(
            0 => 'class="am-active"',
            1 => 'class="am-danger"',
            2 => 'class="am-danger"',
            3 => 'class="am-success"'
        );
        $status = array(
            0 => '发送中',
            1 => '用户拒收',
            2 => '非用户拒绝',
            3 => '发送成功'
        );

        if(!empty($template_msg_record)){
            if(empty($template_msg_record)||($template_msg_record['count']=="0")) {
                echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
            }
            else {
                $html = '';
                foreach($template_msg_record['list'] as $t){
                    $html.='
                    <tr '.($status_color[$t['status']]).'>
                        <td>'.$t['public_name'].'</td>
                        <td>'.((!empty($t['user']['name']))?$t['user']['name']:"").'</td>
                        <td>'.((!empty($even_arr[$t['even']]))?$even_arr[$t['even']]:"").'</td>
                        <td>'.date("Y-m-d h:i:s",$t['create_time']).'</td>
                        <td>'.$status[$t['status']].'</td>
                    </tr>
                    ';
                }
                echo $html;
            }
        }
        ?>
        </tbody>
    </table>
</div>
<div class="am-u-sm-12">
    <?php echo $pagination ?>
</div>
<script>
    var template_msg_record = <?php echo(!empty($template_msg_record)? json_encode($template_msg_record):"null")?>;
    console.log(template_msg_record);
    var even_arr = <?php echo(!empty($even_arr)? json_encode($even_arr):"null")?>;
    console.log(even_arr)
</script>
<?php
$extra_js =  array(
    //'/static/js/pagination-ul.js'
);
?>