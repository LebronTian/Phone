<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<!-- <link rel="stylesheet" href="/spv3/shop/static/css/addproduct.css"/> -->
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
    #main-img {
    max-height:200px;
    }
	.price-yuan{
	float:left;
	margin-left:15px;
	line-height:30px;
	}
	.sel-addr,.sel-addr select,.sel-addr input{
	display:inline !important;
	}
    .addproduct-self{
        font-size: 14px;
    }
    .addproduct-self .am-text-right,
    .addproduct-self .price-yuan{
        line-height: 38px;
    }
    .long-input{
        width: 500px;
        height: 38px!important;
        line-height: 38px!important;
        border-radius: 4px!important;
    }
    .mid-input{
        width: 220px;
        height: 38px!important;
        line-height: 38px!important;
        border-radius: 4px!important;
    }
    .short-input{
        width: 100px;
        height: 38px!important;
        line-height: 38px!important;
        border-radius: 4px!important;
    }
    #id_virtual~div,#id_virtual~div button{
        width: 220px!important;
    }
    #id_virtual~div button{
        height: 38px!important;
    }
</style>
<div class="am-cf am-padding" style="display:none;">
    <div class="am-fl am-cf" id="edit-id" <?php if(!empty($product['uid'])) echo 'data-id="'.$product['uid'].'"'; ?>>
        <strong class="am-text-primary am-text-lg">  <?php echo(!empty($product) ? '编辑' : '添加')?>商品</strong> /
    </div>
</div> 
<div class="am-form am-form-horizontal addproduct-self" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品名称
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="long-input" type="text" id="product_title" placeholder="选填" minlength="1" <?php if(!empty($product)) echo 'value="'.$product['title'].'"'; ?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            备注标签
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input class="mid-input" type="text" placeholder="如 店长推荐" id="title_second" placeholder="选填" minlength="1" <?php if(!empty($product['title_second'])) echo 'value="'.$product['title_second'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品编码
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input class="mid-input" type="text" id="product_code" placeholder="选填" class="js-pattern-number" <?php if(!empty($product['product_code'])) echo 'value="'.$product['product_code'].'"'; ?>>
            <small>填写数字或字母，可用于商品的搜索</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" <?php if(empty($_GET['_d'])) echo 'style="display:none;"';?>>
        <div class="am-u-sm-2 am-text-right">
            商家编号
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input class="long-input" type="text" id="biz_uid" placeholder="选填" class="js-pattern-number" <?php if(!empty($product['biz_uid'])) echo 'value="'.$product['biz_uid'].'"'; ?>>
            <small>商家编号用于多商家入驻</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <!-- <div class="am-u-sm-2 am-text-right">
            归属分类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-inline">
                <div class="am-form-group">
                    <div class="am-dropdown" data-am-dropdown>
                      <button class="am-selected-btn am-btn am-dropdown-toggle am-btn-default mid-input"><span class="am-selected-status am-fl">所有分组</span><i class="am-selected-icon am-icon-caret-down"></i>  </button>
                      <ul class="am-dropdown-content">
                        <li><a href="#">快乐的方式不只一种</a></li>
                      </ul>
                    </div>
                </div>
                <button class="am-btn am-btn-secondary fans-btn-self" type="button">新建分类</button>
            </div>
        <small>选择分类，可用于本平台商品的分类检索</small>
        </div> -->
        <div class="am-u-sm-2 am-text-right">
            归属分类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div><button style="vertical-align: baseline" class="am-btn am-btn-primary choose-cats" data-uid="<?php echo (!empty($product['cat']) ? $product['cat']['uid']:"") ?>"><?php echo (!empty($product['cat']) ? $product['cat']['title']:"选择分类") ?></button></div>
            <small>选择分类，可用于本平台商品的分类检索</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            基础服务
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select class="basic-services am-modal-prompt-input" multiple style="width:50%;height: 38px;">
                <?php
                if(!empty($product['bas_services'])){
                    foreach($product['bas_services'] as $v){
                        echo '<option selected>'.$v.'</option>';
                       }
                  }
                ?>
            </select>
            <br/><small style="text-align: left">填基础服务，例如：七天无理由退换。输入一个后按回车键标识。</small>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            排序
        </div>
        <div class="am-u-sm-8 am-u-end" style="width: 120px">
            <input class="short-input" type="number" id="product_sort" placeholder="选填" <?php if(!empty($product)) echo 'value="'.$product['sort'].'"'; ?>>
            <small style="white-space: nowrap">填正整数，从大到小排序</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right" style="line-height: unset;">
            标记
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group mb0">
                <!--
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="0"> 不货到付款
                </label>
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="1"> 不包邮
                </label>
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="2"> 不开发票
                </label>
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="3"> 不保修
                </label>
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="4"> 不退换货
                </label>
                <label class="am-checkbox-inline">
                    <input type="checkbox" name="searchInfo" value="5"> 不是新品
                </label>-->
                <label class="am-checkbox-inline" <?php if(empty($_GET['_d'])) echo 'style="display:none;"';?>
						style="padding-top: 0;line-height:28px;">
                    <input style="margin-top: 7px" type="checkbox" name="searchInfo" value="5" id="miaosha"> 秒杀
                </label>
                <label class="am-checkbox-inline ml0" style="padding-top: 0;line-height:28px;">
                    <input style="margin-top: 7px" type="checkbox" name="searchInfo" value="6"> 热销
                </label>
                <label class="am-checkbox-inline" style="padding-top: 0;line-height:28px;">
                    <input style="margin-top: 7px" type="checkbox" name="searchInfo" value="7"> 推荐
                </label>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" id="ms_set"  style="display: none">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>

        <div class="am-u-sm-8 am-u-end">
            <div style="margin-bottom: 10px">
                <?php if(!isset($product['kill_time']['start_time'])&&(!empty($product))){
                $product['kill_time']['start_time'] = 0;
            } ?>

                <input class="am-animation-slide-left" style="width: 16em ;" type="datetime-local" id="ms_start_time" value="<?php if(!empty($product['kill_time'])) echo date('Y-m-d',$product['kill_time']['start_time']).'T'.date('H:i',$product['kill_time']['start_time']) ?>">
                <small>秒杀开始时间</small>
            </div>
            <div>
                <?php if(!isset($product['kill_time']['end_time'])&&(!empty($product))){
                $product['kill_time']['end_time'] = 0;
            } ?>
                <input class="am-animation-slide-left" style="width: 16em;" type="datetime-local"  id="ms_end_time" value="<?php if(!empty($product['kill_time'])) echo date('Y-m-d',$product['kill_time']['end_time']).'T'.date('H:i',$product['kill_time']['end_time'])?>">
                <small>秒杀结束时间</small>
            </div>


        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            虚拟商品
        </div>
        <div class="am-u-sm-2 am-u-end">
				<!--<small>0表示需要填写收货地址电话等信息</small>-->
            <select id="id_virtual"></select>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品原价
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input class="mid-input" type="text" id="oriPrice" placeholder="必填" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['ori_price']/100).'"';?>>
            </div>
            <div class="price-yuan">
                元
            </div>
            <small style="white-space: nowrap">展示在商品列表封面，商品吊牌价、销售指导价</small>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品售价
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input class="mid-input" type="text" id="proPrice" placeholder="必填" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['price']/100).'"';?>>
            </div>
            <div class="price-yuan">
                元
            </div>
            <small style="white-space: nowrap">展示在商品列表封面，用户最终的购买价格</small>
        </div>
    </div>

<hr>
<div <?php if(empty($_GET['_d'])) echo 'style="display:none;"';?> >
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            团购价
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input class="mid-input" type="text" id="groupPrice" placeholder="选填, 拼团价格" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['group_price']/100).'"';?>>
            </div>
            <div class="price-yuan">
                元
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            成团人数
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input class="mid-input" type="text" id="groupCnt" placeholder="选填" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['group_cnt']).'"';?>>
            </div>
            <div class="price-yuan">
                人
            </div>
        </div>
    </div>
<hr>
</div>

    <!--等做积分兑换再做好看点吧-。--->
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            赠送积分
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input class="mid-input" type="text" id="back_point" placeholder="选填，请输入正整数" pattern="^[0-9]+(.[0-9]{1,100})?$" <?php if(!empty($product)&&(!($product['back_point']=="0"))) echo 'value="'.$product['back_point'].'"' ?> >
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right" style="line-height:unset;">
            规格
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-radio" style="float: left;padding-top: 0">
                <label>
                    <input type="radio" name="standard-radio" value="1" checked>统一规格
                </label>
            </div>
            <div class="am-radio" style="float: left;padding-top: 0">
                <label>
                    <input type="radio" name="standard-radio" value="2">特殊规格
                    <?php
                    $agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']);
                    if (!empty($agent_set) && empty($agent_set['status']) && (in_array($shop['tpl'],AgentMod::get_agent_tpl_array())))
                    {
                    echo '<span class="am-icon-question-circle am-text-danger" data-am-popover="{content: \'暂时只支持【统一规格】的商品被代理\', trigger: \'hover focus\'}">提示</span>';
                    }
                    ?>

                </label>
                <small>（请不要使用特殊符号命名分类）</small>
            </div>

        </div>
    </div>

    <!--统一规格*************************************************************-->
    <div class="am-g am-margin-top-sm select-standard" id="standard1">
        <div class="am-u-sm-2 am-text-right">
            库存
        </div>
        <div class="am-u-sm-8 am-u-end" style="width: 160px">
            <div style="width: 88px;float:left;">
                <input class="short-input" type="text" id="proQuantity" placeholder="必填" minlength="1" pattern="^[0-9]\d*$" >
            </div>
            <div class="price-yuan">
                件
            </div>
        </div>
    </div>
    <!--特殊规格**************************************************************************************-->
    <div class="am-g am-margin-top-sm select-standard" id="standard2" style="display: none">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-success am-btn-sm am-icon-plus add-sku" style="margin-bottom: 5px">&nbsp;添加规格</button>
            <button class="am-btn am-btn-success am-btn-sm am-icon-refresh refresh-sku" style="margin-bottom: 5px">&nbsp;重新添加</button>
            <table class="am-table am-table-striped am-table-hover am-table-bordered am-table-radius sku-table">
                <thead>
                <tr>
                    <th id="thead-mark">售价（元）</th>
                    <th>原价（元）</th>
                    <th>库存（件）</th>
                    <th>小图标</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            商品参数
        </div>
        <div class="am-u-sm-8 am-u-end extra-content">
            <button class="am-btn am-btn-secondary am-btn-sm am-icon-plus add-extra-info">&nbsp;添加参数</button>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            货物所在地
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="sel-addr">
                <select class="sel-country short-input">
                    <option>国家</option>
                    <option>中国</option>
                    <option>俄罗斯</option>
                    <option>加拿大</option>
                    <option>德国</option>
                    <option>意大利</option>
                    <option>新加坡</option>
                    <option>法国</option>
                    <option>澳大利亚</option>
                    <option>美国</option>
                    <option>英国</option>
                    <option>韩国</option>
                </select>
            </div>
            <div class="sel-addr" style="display: none">
                <select class="sel-prov short-input">
                    <option data-sort="0">省份</option>
                </select>
            </div>
            <div class="sel-addr" style="display: none">
                <select class="sel-city short-input">
                </select>
            </div>
            <div class="sel-addr" style="display: none">
                <select class="sel-town short-input">
                    <option>地区</option>
                </select>
            </div>
            <div class="sel-addr" style="width: auto;display: none">
                <input class="sel-street mid-input" type="text" placeholder="详细街道(选填)"/>
            </div>


        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            运费
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-radio" style="float: left">
                <label>
                    <input type="radio" name="deli-radio" value="1" checked>卖家承担运费（包邮）
                </label>
            </div>
            <div class="am-radio" style="float: left">
                <label>
                    <input type="radio" name="deli-radio" value="2">买家承担运费
                </label>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" id="delivery-select" style="display: none">
        <div class="am-u-sm-2 am-text-right">
            运费模板
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group template-left">
                <select id="template-select" data-am-loading="{loadingText: '加载中...'}">

                </select>
                <span class="am-form-caret"></span>
            </div>
            <a href="/?_a=shop&_u=sp.deliverytemplate" target="_blank"><button class="am-btn am-btn-success am-btn-sm am-icon-plus add-template">&nbsp;添加管理模板</button></a>
            <button class="am-btn am-btn-success am-btn-sm am-icon-refresh refresh-template">&nbsp;刷新模板</button>
        </div>
    </div>


    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            商品主图
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary buttonImg1"  style="height: 32px!important;" data-addr="#main-img-src" data-func="mainImg">从图片库选择</button>
            <input id="main-img-src" type="hidden" <?php if(!empty($product)) echo'src="'.$product['main_img'].'"'; ?>/>
            <div id="main-img-box" style="margin: 10px 0">
                <?php if(!empty($product)) echo'<img id="main-img" src="'.$product['main_img'].'"/> '; ?>
            </div>
			<small>建议图片尺寸 750*750</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            更多图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary"  style="height: 32px!important;" data-addr="#more-img-src" data-func="moreImg">从图片库选择</button>
            <input id="more-img-src" type="hidden"/>
            <div id="more-img-box" style="margin: 10px 0;overflow: hidden">
                <?php
                if(!empty($product['images'])){
                    foreach($product['images'] as $img){
                        echo'<div class="more-img-content"><img class="more-img" src="'.$img.'"/><span class="am-icon-trash del-img"></span></div>';
                        }
                   }
                ?>
            </div>
            <small>建议图片尺寸 750*750</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            视频链接

        </div>
        <div class="am-u-sm-8 am-u-end">
            <input class="mid-input" type="text" id="video_url" placeholder="选填" minlength="1" <?php if(!empty($product['video_url'])) echo 'value="'.$product['video_url'].'"'; ?>>
			<small>如何获取视频地址？<a href="https://portal.qiniu.com/signup?code=3lbctxu2kd45u" target="_blank">免费上传视频到七牛云存储</a></small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            修改销量
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input class="mid-input" type="number" id="id_sell_cnt" placeholder="选填" minlength="1" <?php if(!empty($product['sell_cnt'])) echo 'value="'.$product['sell_cnt'].'"'; ?>>
        </div>
    </div>

    <!--等做积分兑换再做好看点吧-。--->
    <!--<div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            其他信息
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div style="width: 80%;float:left;">
                <input type="text" id="else_info" placeholder="选填"  <?php if(!empty($product['else_info'])) echo 'value="'.$product['else_info'].'"' ?> >
            </div>
        </div>
    </div>-->
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            商品详情
        </div>
        <div class="am-u-sm-8 am-u-end">
            <script id="product-content" name="content" type="text/plain" style="height:250px">
            </script>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            关联商品

        </div>
        <div class="am-u-sm-8 am-u-end">
            <input class="mid-input" type="text" id="product_uids" placeholder="选填" minlength="1" <?php if(!empty($product['product_uids'])) echo 'value="'.$product['product_uids'].'"'; ?>>
            <small>输入关联商品uid，以英文逗号(,)隔开</small>
        </div>
    </div>
    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right" style="line-height: unset;">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end" >
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="1" data-am-ucheck>
                暂不上架
            </label>
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="0" data-am-ucheck>
                立即上架（请确认商品价格，商品名称已填写无误）
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveProduct">保存</button>
        </div>
    </div>
</div>

<!--添加规格模拟弹窗************-->
<div class="am-modal am-modal-prompt" tabindex="-1" id="sku-prompt">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">添加规格</div>
        <div class="am-modal-bd">
            <input type="text" class="am-modal-prompt-input prompt-type" placeholder="请输入规格类别">
            <p style="margin: 0;margin-bottom: 20px"><small style="text-align: left">填规格类别，例如：颜色，尺寸</small></p>

            <select class="new-sku am-modal-prompt-input" multiple style="width:80%;margin-top: 10px">
            </select>
            <br/><small style="text-align: left">填详细分类，例如：红色，蓝色。输入一个分类后按回车键标识，最多10个</small>
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <button class="am-modal-btn sku-btn-up disable-btn" disabled="disabled" data-am-modal-confirm>提交</button>
        </div>
    </div>
</div>

<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <select class="catList-yhc"></select>
            </div>
        </div>
    </div>
</div>

<?php

    echo '<script>var g_virtual_info= '.(!empty($product['virtual_info']) ? json_encode($product['virtual_info']) : 'null').';</script>';

    echo '
    <script>
    var edit_product = '.json_encode($product).' ;
    var page = '.json_encode($page).' ;
    var catsAll = '.(!empty($parents) ? json_encode($parents):'[]').';
    var a_data = "'.$GLOBALS['_UCT']['ACT'].'";
//    var catsAll = [];
    </script>';

    $extra_js = array(
        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',

        '/static/js/select2/js/select2.min.js',
        '/static/js/catlist_yhc.js',


        '/spv3/shop/static/js/district-all.js',

        '/spv3/shop/static/js/addproduct.js?1',
        '/spv3/shop/static/js/addinfo.js',
        '/spv3/shop/static/js/catsSelect.js'
        );
?>
<script>
    seajs.use(['selectPic', 'selectVir']);
</script>
