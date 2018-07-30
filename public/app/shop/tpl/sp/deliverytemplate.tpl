

<style>
    .template-brief{
        word-wrap: break-word;
        display: block;
        max-width: 500px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }
    .template-title{
        display: block;
        max-width: 145px;
        overflow: hidden;
        text-overflow: ellipsis;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">运费模板</strong> / <small>运费模板就是为一批商品设置同一个运费。当您需要修改运费的时候，这些关联商品的运费将一起被修改。</small>
    </div>
</div>


<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.addtemplate" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加模板</a>
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
            <th class="table-title">模板名称</th>
            <th class="table-parent">模板描述</th>
            <th class="table-image">模板类型</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$deliveries) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
            $html = '';
            foreach($deliveries as $d) {
                $html .= 
                    '<tr data-id="'.$d['uid'].'">
                        <td><input type="checkbox" class="delCheck"></td>
                        <td><span class="template-title">'.$d['title'].'</span></td>
                        <td><span class="template-brief">'.$d['brief'].'</span></td>
                        <td>'.(!!$d['valuation']==1 ? '特殊运费':'统一运费').'</td>
                        <td>
                            <div class="am-btn-toolbar">
                                <div class="am-btn-group am-btn-group-xs">
                                    <a href="?_a=shop&_u=sp.addtemplate&uid='.$d['uid'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary">
                                        <span class="am-icon-edit"></span> 编辑
                                    </a>
                                    <button class="am-btn am-btn-default am-btn-xs am-text-danger delBtn" data-id="'.$d['uid'].'">
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



<?php
#var_export($deliveries);

echo '<script> var deliveries = '.json_encode($deliveries).';</script>';


$extra_js = array(

        $static_path.'/js/deliverytemplate.js'

);

?>

