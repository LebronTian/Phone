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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo $form['title'];?></strong> 提交记录 / <small>总计 <?php echo $records['count'];?> 篇</small></div>
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
        <a data-am-popover="{content: '导出数据到excel格式文件', trigger: 'hover focus'}"
           class="am-btn  am-btn-secondary" href="?_a=form&_u=sp.recordlist_excel&f_uid=<?php echo $form['uid'];?>" target="_Blank"><span class="am-icon-file-excel-o"></span> 下载</a>
    </div>

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
            <th class="table-title">提交用户</th>
            <th class="table-parent">提交时间</th>
            <?php
            if($form_field) {
                $html = '';
                foreach($form_field as $f) {
                    switch($f['type']) {
                        case 'text':
                            $html .= ' <th class="th-field">字段('.$f['name'].')</th>';
                            break;
                        case 'text_multi':
                            $html .= ' <th class="th-field">字段('.$f['name'].')</th>';
                            break;
                        case 'file_img':
                            $html .= ' <th class="th-field">字段('.$f['name'].')</th>';
                            break;
                        default:
                            $html .= ' <th class="th-field">未知字段</th>';
                            break;
                    }
                }
                echo $html;
            }
            ?>
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
            foreach($records['list'] as $c) {
                $html .= '<tr';
                $html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
                    '<td>'.(empty($c['user']) ? '游客' : $c['user']['name']).'</td>'.
                    '<td>'.date('Y-m-d H:i:s', $c['create_time']).'</td>';

                if($form_field) {
                    foreach($form_field as $f) {
                        $cc = @(isset($c['data'][$f['id']]) ? $c['data'][$f['id']] : $c['data'][$f['name']]);
                        switch($f['type']) {
                            case 'text':
                                $html .= ' <td class="table-parent">'.htmlspecialchars($cc).'</td>';
                                break;
                            case 'text_multi':
                                $html .= ' <td class="table-parent">'.htmlspecialchars($cc).'</td>';
                                break;
                            case 'file_img':
                                $html .= ' <td class="table-parent"><img style="max-width:100px;max-height:100px;" src="'.$cc['url'].'"></td>';
                                break;
                            default:
                                $html .= ' <td class="table-parent">-</td>';
                                break;
                        }
                    }
                }

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
                $html .= '<a href="?_a=form&f_uid='.$c['f_uid'].'&uid='.$c['uid']
                    .'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-link"></span> 查看详情</a>';
                if(!empty($_REQUEST['_d']))
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
$extra_js = $static_path.'/js/recordlist.js';
?>
