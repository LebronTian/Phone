<?php #var_export($groups)?>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">店铺地址</strong> / <small>总计 <?php echo $address['count']; ?> 条数据</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-u-md-6">
        <div class="am-fl am-cf">
            <a  href="?_a=shop&_u=sp.addaddress" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加地址</a>
        </div>
        <!--<div class="am-fl am-cf">
            <a  href="?_a=shop&_u=sp.address_name" type="button" style="margin-left: 1em" class="am-btn am-btn-primary choose-cats">设置地址级别名称</a>
        </div>-->
    </div>


   <!-- <div class="am-u-md-3 am-cf">
        <div class="am-fr">
            <div class="am-input-group am-input-group-sm">
                <input type="text" class="am-form-field option_key" value="">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
            </div>
        </div>
    </div>-->

</div>



<?php
	//var_export($articles);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">删除地址</div>
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
                <a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th class="table-title">配送距离</th>
            <th class="table-title">地址</th>
            <th>经度</th>
            <th>纬度</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
            if(!$address['list']) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
            }
            else {
            $html = '';
            foreach($address['list'] as $a) {

            $html .= '<tr';
            $html .= ' data-id="'.$a['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>';
            $html .='<td>' .$a['address_data']['sendscope'].' 公里</td>';
            $html .='<td>' .$a['address_data']['address'].'</td>';
            $html .='<td>' .$a['address_data']['lng'].'</td>';
            $html .='<td>' .$a['address_data']['lat'].'</td>';
            $html .='<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
            $html .= '<a href="?_a=shop&_u=sp.addaddress&uid='.$a['uid']
                    .'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
            $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$a['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';

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
	$extra_js = $static_path.'/js/address.js';
?>
