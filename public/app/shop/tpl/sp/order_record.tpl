<style>
    .am-btn-white {
        background-color: white !important;
        border: 1px dotted gray;
    }
    .th-field {
        color: gray;
    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">货单统计</strong>  / <small>总计 <?php echo count($res2);?> 篇</small></div>
</div>

<?php

//var_export($option);

?>

<div class="am-g am-padding">
    <div class="am-padding  am-cf">
        <div class="am-u-sm-3 am-margin-left am-u-end">
            <button type="button" class="am-btn am-btn-default am-margin-right" id="my-start">开始日期</button>
		<span
                id="my-startDate"><?php echo date('Y-m-d', (empty($option['start_time']) ? time() : $option['start_time'])) ?></span>
        </div>
        <div class="am-u-sm-3 am-margin-left am-u-end">
            <button type="button" class="am-btn am-btn-default am-margin-right" id="my-end">结束日期</button>
		<span
                id="my-endDate"><?php echo date('Y-m-d', (empty($option['end_time']) ? time() : $option['end_time'])) ?></span>
        </div>
        <div class=" am-margin-left am-u-sm-3 am-u-end">
            <span class="am-btn am-btn-primary btn_show">查看</span>
        </div>
        <div class="am-form-group am-margin-left am-fl">
            <a data-am-popover="{content: '导出数据到excel格式文件', trigger: 'hover focus'}"
               class="am-btn  am-btn-secondary" id="download_excel" target="_self"><span class="am-icon-file-excel-o"></span> 下载</a>
        </div>
    </div>

</div>



<?php
//var_export($articles);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">删除记录</div>
        <div class="am-modal-bd">
            确定要删除吗？
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
        </div>
    </div>
</div>

<div class="am-u-sm-12">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>

            <th class="table-title">商品名</th>
            <th>规格</th>
            <th>数量</th>


        </tr>
        </thead>
        <tbody>
        <?php
        if(!$res2) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }
        else {
            $html = '';
            foreach($res2 as $k => $v) {
                $html .= '<tr data-id="'.$k.'">';

                $html .=  '<td>'.$v['title'].'</td><td>'.$v['sku_uid'].'</td>';
            $html .=  '<td>'.$v['quantity'].'</td>';

                $html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';

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
   //echo $pagination;
    ?>
</div>

<script>
    $(function() {
        var startDate = new Date($('#my-startDate').text());
        var endDate = new Date($('#my-endDate').text());
        $('#my-start').datepicker().
        on('changeDate.datepicker.amui', function(event) {
            if (event.date.valueOf() > endDate.valueOf()) {
                showTip("err","结束日期应大于开始日期",1000);
            } else {

                startDate = new Date(event.date);
                $('#my-startDate').text($('#my-start').data('date'));
            }
            $(this).datepicker('close');
        });

        $('#my-end').datepicker().
        on('changeDate.datepicker.amui', function(event) {
            if (event.date.valueOf() < startDate.valueOf()) {
                showTip("err","结束日期应大于开始日期",1000);
            } else {

                endDate = new Date(event.date);
                $('#my-endDate').text($('#my-end').data('date'));
            }
            $(this).datepicker('close');
        });
    });
    $('.btn_show').click(function(){


        var start_time = new Date($('#my-startDate').text());
        var end_time = new Date($('#my-endDate').text());
        start_time = start_time.getTime()/1000;
        end_time = end_time.getTime()/1000;
        var url = '?_a=shop&_u=sp.order_record';
//        console.log(start_time);

        if(start_time!=undefined) url+='&start_time='+start_time;
        if(end_time!=undefined) url+='&end_time='+end_time;

        window.location.href=url;

    });

    $('#download_excel').click(function(){
        var start_time = new Date($('#my-startDate').text());
        var end_time = new Date($('#my-endDate').text());
        start_time = start_time.getTime()/1000;
        end_time = end_time.getTime()/1000;
        var url = '?_a=shop&_u=sp.order_record_excel';
//        console.log(start_time);//order_record_excel

        if(start_time!=undefined) url+='&start_time='+start_time;
        if(end_time!=undefined) url+='&end_time='+end_time;

        window.location.href=url;

    });

</script>
