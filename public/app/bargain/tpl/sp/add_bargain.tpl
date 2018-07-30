
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/static/css/select_tpl.css">

<style type="text/css">

    .am-checkbox{
        margin-top: 3px;
    }
    .time-label{
        height: 46px;
        line-height: 41px;
    }
    .time-label .am-ucheck-icons{
        top: 10px;
    }
    .time-label input[type='datetime-local']{
        display: inline-block;
    }
    .form-limit-box .am-ucheck-icons{
        top:10px;
    }
    .form-limit-box label{
        height: 46px;
        line-height: 41px;
    }
    .form-limit-box input[type='number']{
        display: inline-block;
        width: 8em;
        text-align: center;
    }

    .select2-search__field{
        padding:2px!important
    }

    .am-checkbox {
        padding-bottom:15px!important
    }

</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="?_a=form&_u=sp">
            <strong class="am-text-primary am-text-lg">砍价详情</strong></a>
        <span class="am-icon-angle-right"></span>
        <strong class="am-text-default am-text-lg"><?php echo(!empty($data['uid']) ? '编辑详情' : '添加砍价')?></strong> <small></small>
    </div>
</div>

<div class="am-form  data-am-validator ">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_title" placeholder="必填" <?php if(!empty($data['title'])) echo 'value="'.$data['title'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            关联商品uid
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_p_uid" placeholder="必填" <?php if(!empty($data['product_info']['p_uid'])) echo 'value="'.$data['product_info']['p_uid'].'"';?>>
            <small>商品需无特殊规格</small>
        </div>

    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            图片
        </div>

        <div class="am-u-sm-9">
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
            <div id="idImgBox">
                <img id="id_img" <?php if(!empty($data['product_info']['img'])) echo 'src="'.$data['product_info']['img'].'"';?> style="width:360px;height:190px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_status" data-am-ucheck <?php  if(empty($data['status'])) echo 'checked';?>>
                是否开启</label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            截至时间
        </div>

        <div class="am-u-sm-8 am-u-end">

            <input class="am-animation-slide-left" style="width: 16em;" type="datetime-local"
                   id="id_end_time" value="<?php echo (isset($data['rule']['end_time'])&&(!empty($data['rule']['end_time'])))?date('Y-m-d',$data['rule']['end_time']).'T'.date('h:i',$data['rule']['end_time']):'' ?>">
            允许提交的时间，不填代表不限制

        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            产品份数
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="am-u-sm-2" type="number" id="id_all_quantity" placeholder="填写申请砍价份数"  <?php if(!empty($data['all_quantity'])) echo 'value="'.($data['all_quantity']).'"';?>/>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            剩余份数
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="am-u-sm-2" type="number" id="id_quantity" placeholder="剩余砍价份数"  <?php if(!empty($data['quantity'])) echo 'value="'.($data['quantity']).'"';?>/>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            原价
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="am-u-sm-2" type="number" id="id_ori_price" placeholder="填写原价，单位元"  <?php if(!empty($data['ori_price'])) echo 'value="'.(sprintf('%.2f', $data['ori_price'] / 100)).'"';?>/>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            最低价
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="am-u-sm-2" type="number" id="id_lowest_price" placeholder="填写最低价，单位元"  <?php if(!empty($data['lowest_price'])) echo 'value="'.(sprintf('%.2f', $data['lowest_price'] / 100)).'"';?>/>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            可砍次数
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input class="am-u-sm-2" type="number" id="id_times"  placeholder="填写须砍次数" <?php if(!empty($data['rule']['times'])) echo 'value="'.($data['rule']['times']).'"';?>/>
            <small>(次,0代表不限制)</small>
        </div>


    </div>


    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            详情
        </div>
        <!--文本编辑/-->

        <div class="am-u-sm-8 am-u-end">
            <script id="container" name="info" type="text/plain" style="height:250px;"><?php if(!empty($data['info'])) echo ''.$data['info'].'';?></script>
        </div>
    </div>



    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <button class="am-btn am-btn-lg am-btn-primary save">保存</button>
                <button style="margin-left: 0.5em" onclick="history.back()" class="am-btn am-btn-lg am-btn-primary">取消</button>
            </p>
        </div>
    </div>

</div>

<script>
    var data =<?php echo(!empty($data)? json_encode($data):"null") ?>;
    console.log(data)
</script>

<?php

echo '<script>

        var g_uid = '.(!empty($data['uid']) ? $data['uid'] : 0).';

            </script>';
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',

    '/app/bargain/static/js/addbargain.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>
