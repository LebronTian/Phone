<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>
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
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id" <?php if(!empty($product['uid'])) echo 'data-id="'.$product['uid'].'"'; ?>>
        <strong class="am-text-primary am-text-lg">  <?php echo(!empty($product) ? '编辑' : '添加')?>团购商品</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>

<hr>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
           商品uid 
        </div>
        <div class="am-u-sm-2 am-u-end">
<?php
if(!empty($product)) {
		echo $product['title'].' <img style="width:180px; height: 95px;" src="'.$product['main_img'].
		'"><input  id="id_uid" style="display:none;" value="'.$product['uid'].'">';
}
else {
	echo '<div style="width: 80%;float:left;"><input type="text" id="id_uid" ></div>';
}
?>
        </div>
    </div>


    <div class="am-g am-margin-top-sm" <?php if($hide) echo ' style="display:none;"';?>>
        <div class="am-u-sm-2 am-text-right">
            团购价
        </div>
        <div class="am-u-sm-2 am-u-end">
            <div style="width: 80%;float:left;">
                <input type="text" id="groupPrice" placeholder="选填, 拼团价格" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['group_price']/100).'"';?>>
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
                <input type="text" id="groupCnt" placeholder="选填" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($product)) echo'value="'.($product['group_cnt']).'"';?>>
            </div>
            <div class="price-yuan">
                人
            </div>
        </div>
    </div>
<hr>

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

<?php
    $extra_js = array(
        $static_path.'/js/addproduct.js',
        );
?>
<script>
    //seajs.use(['selectPic', 'selectVir']);
</script>
