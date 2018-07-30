<!-- <div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商品列表</strong> / <small>共<?php echo $products['count'];?> 件商品</small></div>
</div> -->
<style>
.template-title2 {
display:inline-block;
width:150px;
white-space:normal;
}
</style>

<div class="am-g am-padding">
    <div class="am-fl am-cf">
        <a  href="?_a=shop&_u=sp.addproduct" type="button" class="am-btn am-btn-success blue-self"><span class="am-icon-plus"></span> 添加商品</a>
        <button style="margin-left: 1em; margin-right: 2em;" class="am-btn am-btn-primary choose-cats" data-type="screen">
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
        <a type="button" id="download_excel" class="am-btn am-btn-success blue-self"><span class="am-icon-file-excel-o"></span> 导出库存表</a>
    </div>

	<div class="am-fr">
            <div class="am-form-inline">
              <div class="am-form-group short-btn100">
                <!-- php改接口 -->
                <!-- <select > -->
                <!--     <?php
                    
                    $html = '<option value="0"';
                    if (empty($option['a_uid']))
                    {
                        $html .= ' selected ';
                    }
                    $html .= '>全部商品</option>';
					if(!empty($agent_list))
                    foreach ($agent_list as $r)
                    {
                        $html .= '<option value="' . $r['uid'] . '"';
                        if ($option['a_uid'] == $r['uid'])
                        {
                            $html .= ' selected';
                        }
                        $html .= '>' . $r['name'] . '</option>';
                        $i++;
                    }
                    echo $html;
                    ?> -->
                   <!-- <option>全部商品</option>
                   <option><a href="http://47.106.118.134/?_easy=shop.sp.productlist&_u=sp.productlist&_a=shop&sort=13&status=0">下架商品</a></option>
                   <option><a href="http://47.106.118.134/?_easy=shop.sp.productlist&_u=sp.productlist&_a=shop&sort=13&status=1">上架商品</a></option> -->
 <!-- </select> -->         
                <select id = "status" data-am-selected>
                   <!--  <option selected>-----</option> -->
                    <option value="-1"<?php 
                    if($option['status'] == -1){
                        echo "selected"; 
                    }
                    


                    ?>>全部商品</option>
                    

                    <option value="0" <?php 
                    if($option['status'] == 0){
                        echo "selected"; 
                    }
                    


                    ?>>上架商品</option>
                    <option value="1" <?php 
                    if($option['status'] == 1){
                        echo "selected"; 
                    }
                    


                    ?>>下架商品</option>
                </select>    
                    
                    
                    
                   
                
                </div>
              <!-- php改接口 -->
              <div class="am-form-group short-btn100">
                <select data-am-selected="{btnSize: 'lg' }" class="option_agent fans-btn-self">
                    <?php
                    
                    $html = '<option value="0"';
                    if (empty($option['a_uid']))
                    {
                        $html .= ' selected ';
                    }
                    $html .= '>所有分组</option>';
					if(!empty($agent_list))
                    foreach ($agent_list as $r)
                    {
                        $html .= '<option value="' . $r['uid'] . '"';
                        if ($option['a_uid'] == $r['uid'])
                        {
                            $html .= ' selected';
                        }
                        $html .= '>' . $r['name'] . '</option>';
                        $i++;
                    }
                    echo $html;
                    ?>
                </select>
              </div>
               
              <div class="am-form-group">
                    <div class="am-form-group am-form-icon pro-input-self">
                        <i class="am-icon-search option_key_btn"></i>
                        <input type="search" class="am-form-field option_key" placeholder="搜索" value="<?php echo $option['key'];?>" style="padding-left: 30px!important;">
                      </div>
                </div>
            </div>               
        <!-- <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>"placeholder="商品名称搜索">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div> -->
              </div>

</div>

<div class="am-u-sm-12 pl0 pr0" style="min-height: 600px;">
    <table class="am-table am-table-striped am-table-hover table-main pro-table-self">
        <thead>
        <tr>
            <th class="table-check">
                <input type="checkbox" class="ccheckall" style="height: 12px;vertical-align: top;">
                <span style="margin-right: 5px;margin-left: 5px;">商品</span>
                <a href="<?php echo ($option['sort'] == SORT_PRICE ? this_url('sort', SORT_PRICE_DESC) : this_url('sort', SORT_PRICE)) ?>">价格 <?php echo ($option['sort'] == SORT_PRICE ? '&uarr;' : '&darr;') ?> </a>
            </th>
            <th class="table-parent">分类</th>
            <th>uid</th>
            <th><a href="###">库存</a></th>
            <th><a href="<?php echo ($option['sort'] == SORT_SALSE_COUNT ? this_url('sort', SORT_SALSE_COUNT_DESC) : this_url('sort', SORT_SALSE_COUNT)) ?>">总销量</a></th>
            <th>排序</th>
            <th>状态</th>
            <th>统计情况</th>
            <th><a href="<?php echo ($option['sort'] == SORT_CREATE_TIME ? this_url('sort', SORT_CREATE_TIME_DESC) : this_url('sort', SORT_CREATE_TIME)) ?>">创建时间</a></th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
            <tr></tr><!-- 毫无用处,纯粹为了隔开amazeui表格固定背景色 -->
        <?php
        $dtb_string = (!empty($dtb['status']))?'style="display:none"':'';
        if(!$products["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($products["list"] as $p) {
        $html .='
        <tr '.($p['status']==1 ? "class='am-danger'":"").' data-id="'.$p['uid'].'">
            <td class="am-text-truncate width200">
                <input type="checkbox" class="delCheck">
                <img src="'.$p['main_img'].'" style="width:54px;height:54px"/>
                <span class="template-title">'.$p['title'].'</span>
                <div class="price-bottom">&yen;'.($p['price']/100); $html .= '</div>
            </td>
            <!-- <td><img src="'.$p['main_img'].'" style="width:54px;height:54px"/></td>
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
            </td> -->
            <!-- <td>&yen;'.($p['price']/100);
			if(!empty($p['group_price'])) $html .= '<br><span class="am-btn-warning">团</span> &yen;'
				.($p['group_price']/100);
			
			$html .= '</td> -->
            <td><span class="template-brief">'.(!empty($p['cat']) ? $p['cat']['title']:"未分类").'</span></td>
            <td><span>'.$p['uid'].'</span></td> <!-- 原主图位置 -->
            <td>'.$p['quantity'].'</td>
            <td>'.$p['sell_cnt'].'</td>
            <td>'.$p['sort'].'</td>
            <td><button class="pStatus am-btn am-btn-xs '.($p["status"]==1 ? 'am-btn-danger">下架' : 'am-btn-success blue-self">上架').'</button></td>
            <td><a href="?_a=shop&_u=sp.visit_record&p_uid='.$p['uid'].'"><span class="am-icon-line-chart" ></span></a></td>
            <td>'.date("Y-m-d H:i:s",$p['create_time']).'</td>
            <td>
                        <a href="?_a=shop&_u=sp.addproduct&uid='.$p['uid'].'&page='.$option['page'].'" class="am-text-primary">
                            编辑
                        </a>
                        <a href="?_a=shop&_u=sp.adddistribution_product&p_uid='.$p['uid'].'" class="am-text-primary" '.$dtb_string.'>
                             分销设置
                        </a>
                        <a href="?_a=shop&_u=sp.add_comment&p_uid='.$p['uid'].'" class="am-text-primary" '.$dtb_string.'>
                         添加评论
                        </a>
                        <a class="am-text-primary delCopy" data-id="'.$p['uid'].'">
                             复制商品
                        </a>
                        <a class="am-text-danger delBtn" data-id="'.$p['uid'].'">
                             删除
                        </a>
            </td>
        </tr>';
        }
        echo $html;
        }
        ?>
        </tbody>
    </table>
</div>
<div class="am-u-sm-12 pl0 pr0 pro-btngroup-self">
    <div class="am-fl am-cf">
        <button class="am-btn am-btn-default time-btn choose-cats" data-type="change">改分组</button>
        <button class="am-btn am-btn-default time-btn pStatusall" data-status="1">下架</button>
        <button class="am-btn am-btn-default time-btn pStatusall" data-status="0">上架</button>
        <button class="am-btn am-btn-default time-btn delAll">删除</button>
        <button class="am-btn am-btn-default time-btn">更多</button>
    </div>
    <!-- 分页 -->
    <div class="am-u-sm-12">
        <?php
        echo $pagination;
        ?>
    </div>
</div>



<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <a href="?_a=shop&_u=sp.productlist"><button style="margin: 0.5em 0" class="am-btn am-btn-success">全部商品</button><br></a>
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
    '/spv3/shop/static/js/productlist.js',
    '/spv3/shop/static/js/catsSelect.js'
);

?>

                <script>
                $(function(){
                        $("#status").change(function(){
                        var val = $(this).val();
                        console.log(val);
                        window.location.href='/?_easy=shop.sp.productlist&_u=sp.productlist&_a=shop&status=' + val;
                    });
                })
                </script>

<script>
$('#download_excel').click(function(){
	var url = '?_a=shop&_u=sp.product_quantity_excel';
	window.location.href=url;
});

</script>

