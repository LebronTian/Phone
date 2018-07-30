<?php //var_export($products) ?>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分销商品列表</strong> / </div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.adddistribution_product" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加商品设置</a>
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
            <th class="table-title">商品名称</th>
            <th>购买者佣金</th>
            <th>购买者上级佣金</th>
            <th>购买者上上级佣金</th>
            <th>购买者上上上级佣金</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$products["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($products["list"] as $p) {
            $p['product']['title'] = empty($p['product']['title'])?'':$p['product']['title'];
        $html .='
        <tr '.($p['status']==1 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>
                <span class="template-title">'.$p['product']['title'].'</span>
                <p style="margin:0"></p></td>';

            for($i =0;$i<=3;$i++){
                $html.='<td>'.(!isset($p['rule_data'][$i][0])?'':sprintf('%.2f',$p['rule_data'][$i][0]/100)).'+&yen;'.(!isset($p['rule_data'][$i][1])?'':sprintf('%.2f',$p['rule_data'][$i][1]/100)).'</td>';
            }
               // $html.='<td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">下架' : 'am-btn-success">上架').'</a></td>';

            $html.='<td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=shop&_u=sp.adddistribution_product&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
                            <span class="am-icon-edit"></span> 编辑
                        </a>
                        <button class="am-btn am-btn-default am-btn-xs am-text-danger delBtn" data-id="'.$p['uid'].'">
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

<div class="am-u-sm-12">
    <?php
	echo $pagination;
    ?>
</div>

<?php

$extra_js = array(
    $static_path.'/js/distribution_productlist.js',
);

?>
