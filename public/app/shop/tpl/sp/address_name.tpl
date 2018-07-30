<?php #var_export($groups)?>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">修改地址级别名称</strong></div>
</div>

<div class="am-g am-padding">


</div>



<?php
	//var_export($address[0]);
?>


<div class="am-u-sm-12">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <th class="table-title">地址级</th>
            <th class="table-title">地址级名称</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
            if(!$address) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
            }
            else {
            $html = '';

            for($i = 0;$i<3;$i++){

            $html .= '<tr>';
            $html .='<td id="level'.$i.'">' .$address[$i]['level'].'</td>';
            $html .='<td><input type="text" id="address'.$address[$i]['level'].'" value="' .$address[$i]['address'].'"></td>';

            $html .='<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
                        $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-primary cupdate" data-id="'.$address[$i]['level'].'"></span> 确认修改</button>';
                        $html .= '</div></div></td>'.'</tr>';

            }
            echo $html;
            }
        ?>
        </tbody>
    </table>
</div>


<?php

	$extra_js = $static_path.'/js/address_name.js';
?>
