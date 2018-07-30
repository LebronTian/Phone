<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">全部入驻商家</strong> /
<small>共计 <?php echo $data['count'];?> 家</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shopbiz&_u=sp.addbiz" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加商家</a>
        <a target="_self"  href="?_a=shop&_u=admin" type="button" class="am-btn am-btn-default"><span class="am-icon-user"></span> 入驻商后台入口</a>
    </div>

    <div class="am-u-md-6">
    </div>
    <div class="am-u-md-3 am-cf">
        <div class="am-fr">
            <div class="am-input-group am-input-group-sm">
                <input type="text" class="am-form-field option_key" placeholder="商家名称" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn"  type="button">搜索</button>
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
                <input type="checkbox" class="ccheckall">
                <a href="javascript:;" class="am-text-danger am-text-lg delAll" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th class="table-title">编号</th>
            <th class="table-title">名称</th>
            <th class="table-image">logo图片</th>
            <th class="table-parent">商品数</th>
            <th class="table-parent">订单数</th>
            <th class="table-parent">商家优惠券</th>
            <th class="table-parent">分类</th>
            <th>联系人</th>
            <th>加V认证</th>
            <th>推荐</th>
            <th>审核</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$data["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($data["list"] as $p) {
        $html .='
        <tr '.($p['status']==2 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>'.$p['uid'].'</td>
            <td><a href="?_a=shopbiz&_u=sp.bizdetail&uid='.$p['uid'].'">
                <span class="template-title">'.$p['title'].'</span></a>
                <p style="margin:0">';
                $html.='
                </p>
            </td>
            <td><img src="'.$p['main_img'].'" style="max-width:100px;max-height:100px"/></td>
            <td><a href="?_a=shop&_u=sp.productlist&biz_uid='.$p['uid'].'">'.$p['product_number'].'(点击查看)</a></td>
            <td><a href="?_a=shop&_u=sp.orderlist&biz_uid='.$p['uid'].'">'.$p['order_number'].'(点击查看)</a></td>
            <td><a href="?_a=shopbiz&_u=sp.bizcoupon&biz_uid='.$p['uid'].'">'.$p['coupon_number'].'(点击查看)</a></td>
            <td>'.($p['type']).'</td>
            <td>'.$p['contact'].'<br>'.$p['phone'].'</td>
            <td><a class="paddv am-btn am-btn-xs '.($p["hadv"]==1 ? 'am-btn-warning">加V' : 'am-btn-default">-').'</a></td>
            <td><a class="paddrecommend am-btn am-btn-xs '.($p["hadrecommend"]==1 ? 'am-btn-secondary">推荐' : 'am-btn-default">-').'</a></td>
            <td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-success">通过' : ($p["status"]==0 ?'am-btn-default">审核中':'am-btn-danger">未通过')).'</a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=shopbiz&_u=sp.addbiz&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
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
    '/static/js/catlist_yhc.js',
    $static_path.'/js/bizlist.js?i=1',
);

?>
