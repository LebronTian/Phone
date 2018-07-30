<?php
	$this_ctl = include UCT_PATH.'app/sp/tpl/macro_this.tpl';
	if(!($option['f_uid'] = requestInt('f_uid')) || 
		!($form = FormMod::get_form_by_uid($option['f_uid'])) ||
		!($form['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
		//没有指定一个表单,跳转到表单列表
		$GLOBALS['_UCT']['ACT'] = 'index';
		echo '<script>window.location.href="?_a=form&_u=sp";</script>';
		return;
	}
	$form_field = $this_ctl->get_form_show_field($form);

	$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');	
	$option['sp_remark'] = requestInt('sp_remark', -1);
	$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
	$option['page'] = requestInt('page');
	$option['limit'] = requestInt('limit', 10);

	$records = FormMod::get_form_record_list($option);
	$pagination = uct_pagination($option['page'], ceil($records['count']/$option['limit']), 
			'?_a=form&_u=sp.srecordlist&f_uid='.$option['f_uid'].'&key='.$option['key']
			.'&sp_remark='.$option['sp_remark'].'&limit='.$option['limit'].'&page=');

?>

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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo $form['title'];?></strong> 提交记录 / <small>总计 <?php echo $records['count'];?> 条</small></div>
</div>

<?php

#var_export($records);
/*
if($records['list'])
foreach($records['list'] as $r) {
	echo '<p>'.(empty($r['user']) ? '游客' : $r['user']['name']).'('.$r['user_ip'].') <a href="?_a=form&f_uid='.$r['f_uid'].'&uid='.$r['uid'].'">查看详情数据</a></p>';
}
*/
?>

<div class="am-g am-padding">
    <div class="am-u-md-6">
        <div class="am-fl am-cf">
        </div>
        <div class="am-form-group am-fl">
            颜色标记: <div class="am-dropdown" data-am-dropdown>
                <button class="am-btn <?php
                $sp_remarks = array(
                    0 => 'am-btn-default',
                    1 => 'am-btn-danger',
                    2 => 'am-btn-success',
                    3 => 'am-btn-primary',
                );
                echo (isset($sp_remarks[$option['sp_remark']]) ? $sp_remarks[$option['sp_remark']] : 'am-btn-white');
                ?>
				am-dropdown-toggle" data-am-dropdown-toggle></button>
                <ul class="am-dropdown-content csp_remarks" style="min-width:34px !important; cursor:pointer;">
                    <li class="am-btn-white"   sp="-1">&nbsp;</li>
                    <li class="am-btn-default" sp="0">&nbsp;</li>
                    <li class="am-btn-danger"  sp="1">&nbsp;</li>
                    <li class="am-btn-success" sp="2">&nbsp;</li>
                    <li class="am-btn-primary" sp="3">&nbsp;</li>
                </ul>
            </div>
            </select>
        </div>

    </div>
	

        <div class="am-form-group am-margin-left am-fl">
			收款总额：&yen; <?php
				$sql = 'select sum(form_record_order.paid_fee) from form_record join form_record_order on form_record.uid = form_record_order.r_uid where form_record.f_uid = '
						.$option['f_uid'].' && form_record_order.paid_time > 0';

				echo Dba::readOne($sql)/100;
			?>
        </div>
	
<!--
	<div class="am-form-group am-margin-left am-fl">
		<button data-am-popover="{content: '导出当前数据到excel格式文件', trigger: 'hover focus'}" class="am-btn am-btn-lg am-btn-secondary" id="id_download"><span class="am-icon-file-excel-o"></span> 下载</button>
	</div>
-->

    <div class="am-u-md-3 am-cf">
        <div class="am-fr">
            <div class="am-input-group am-input-group-sm">
                <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
            </div>
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
            <th class="table-check">
                <input type="checkbox" class="ccheckall">

                <?php
                if(!empty($_REQUEST['_d']))
                    echo '
				<a href="javascript:;" class="am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
				&nbsp;&nbsp;|&nbsp;&nbsp;
				';
                ?>
                <a href="javascript:;" class="am-text-lg ceditall" style=""><span class="am-icon-edit"></span></a>
            </th>
            <th class="table-title">姓名</th>
            <th class="table-parent">提交时间</th>
            <th class="table-parent">手机号码</th>
            <th class="table-parent">身份证</th>
            <th class="table-parent">付款时间</th>
            <th class="table-image">标记</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$records['list']) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }
        else {
            $html = '';
			uct_use_app('su');
            foreach($records['list'] as $c) {
                $html .= '<tr';
                $html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
                    //'<td>'.(empty($c['user']) ? '游客' : $c['user']['name']).'</td>'.
                    '<td>'.@($c['data'][0]).'</td>'.
                    '<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>'.
                    '<td>'.@$c['data'][1].'</td>'.
                    '<td>'.@$c['data'][2];

					$html .= '</td>'.
                    '<td>'.(!empty($c['order']['paid_time']) ? date('Y-m-d H:i:s', $c['order']['paid_time']).' (&yen;'.($c['order']['paid_fee']/100).')' : '-').'</td>';


                $html .= '<td>'.'<div class="am-dropdown" data-am-dropdown>
  <button class="am-btn '
                    .(isset($sp_remarks[$c['sp_remark']]) ? $sp_remarks[$c['sp_remark']] : 'am-btn-white')
                    .' am-dropdown-toggle" data-am-dropdown-toggle></button>
  <ul class="am-dropdown-content csp_remark" data-uid="'.$c['uid'].'" style="min-width:34px !important; cursor:pointer;">
    <li class="am-btn-default" sp="0">&nbsp;</li>
    <li class="am-btn-danger"  sp="1">&nbsp;</li>
    <li class="am-btn-success" sp="2">&nbsp;</li>
    <li class="am-btn-primary" sp="3">&nbsp;</li>
  </ul>
</div>'.
                    '</td>'.
                    '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
                #$html .= '<a href="?_a=form&f_uid='.$c['f_uid'].'&uid='.$c['uid']
                #    .'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-link"></span> 查看详情</a>';
                if(!empty($_REQUEST['_d']) || empty($c['order']['paid_time']))
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
echo '<script>g_f_uid='.$form['uid'].';</script>';
$extra_js = $static_path.'/js/sp.srecordlist.js';
?>
