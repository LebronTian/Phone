<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">秒杀商品列表</strong> / <small>共<?php echo $products['count'];?> 件商品</small></div>
</div>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.addproduct" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加商品</a>
    <button style="margin-left: 1em" class="am-btn am-btn-primary choose-cats">
        <?php
        if(requestInt('cat_uid')){
            if(!empty($products['list']['0'])){
                echo $products['list']['0']['cat']['title'];
            }else{
                echo "选择分类";
            }
        }else{
            echo "选择分类";
        }
        ?>
    </button>
    </div>

	<div class="am-u-md-3 am-end am-fr">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>"placeholder="商品名称搜索">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
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
            <th class="table-title">名称</th>
            <th class="table-title">价格</th>
            <th class="table-parent">分类</th>
            <th class="table-image">主图</th>
            <th>库存</th>
            <th>销量</th>
            <th>排序</th>
            <th>状态</th>
            <th>统计情况</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        $dtb_string = (!empty($dtb['status']))?'style="display:none"':'';
        if(!$products["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($products["list"] as $p) {
        $html .='
        <tr '.($p['status']==1 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>
                <span class="template-title">'.$p['title'].'</span>
                <p style="margin:0">';

            $bit = $p['info'];
            for($i=0;$i<10;$i++){
                if(pow(2,$i) == ($bit&pow(2,$i)) ){

                    switch($i){
                        case 1;
                            break;
                        case 2;
                            break;
                        case 3;
                            break;
                        case 4;
                            break;
                        case 5;
                            $html.='<img data-am-popover=\'{content:"秒杀",trigger:"hover"}\' style="width: 30px" src="/app/shop/static/images/miaosha.png"/>';
                    break;
                            break;
                        case 6;
                            $html.='<img data-am-popover=\'{content:"热销",trigger:"hover"}\' style="width: 30px" src="/app/shop/static/images/hot_sale.png"/>';
                            break;
                        case 7;
                            $html.='<img data-am-popover=\'{content:"推荐",trigger:"hover"}\' style="width: 25px" src="/app/shop/static/images/recommend.png" />';
                            break;

                    }

                }
            }

                $html.='
                </p>
            </td>
            <td>&yen;'.($p['price']/100);
			if(!empty($p['group_price'])) $html .= '<br><span class="am-btn-warning">团</span> &yen;'
				.($p['group_price']/100);
			
			$html .= '</td>
            <td><span class="template-brief">'.(!empty($p['cat']) ? $p['cat']['title']:"未分类").'</span></td>
            <td><img src="'.$p['main_img'].'" style="max-width:100px;max-height:100px"/></td>
            <td>'.$p['quantity'].'</td>
            <td>'.$p['sell_cnt'].'</td>
            <td>'.$p['sort'].'</td>
            <td><a class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">下架' : 'am-btn-success">上架').'</a></td>
            <td><a href="?_a=shop&_u=sp.visit_record&p_uid='.$p['uid'].'"><span class="am-icon-line-chart" ></span></a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a href="?_a=shop&_u=sp.addproduct&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
                            <span class="am-icon-edit"></span> 编辑
                        </a>
                        <a href="?_a=shop&_u=sp.adddistribution_product&p_uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary" '.$dtb_string.'>
                            <span class="am-icon-gear"></span> 分销设置
                        </a>
                        <a href="?_a=shop&_u=sp.add_comment&p_uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary" '.$dtb_string.'>
                        <span class="am-icon-comment"></span> 添加评论
                        </a>
                        <button class="am-btn am-btn-default am-btn-xs am-text-primary delCopy" data-id="'.$p['uid'].'">
                            <span class="am-icon-copy"></span> 复制商品
                        </button>
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


<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <a href="?_a=shop&_u=sp.productkilllist"><button style="margin: 0.5em 0" class="am-btn am-btn-success">全部商品</button><br></a>
                <select class="catList-yhc2"></select>
            </div>
        </div>
    </div>
</div>

<?php

echo '<script>var products = '.json_encode($products).' ;
                var catsAll = '.(!empty($cats)? json_encode($cats):"null").';
                   var a_data = "'.$GLOBALS['_UCT']['ACT'].'";
        </script>';

$extra_js = array(
    '/static/js/catlist_yhc.js',
    $static_path.'/js/productkilllist.js',
    $static_path.'/js/catsSelect.js',
);

?>
