<head>
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
    <style type="text/css">
        .reward-limit-box .am-ucheck-icons{
            top:10px;
        }
        .reward-limit-box label{
            height: 46px;
            line-height: 41px;
        }
        .reward-limit-box input[type='number']{
            display: inline-block;
            width: 8em;
            text-align: center;
        }

    </style>
</head>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($item['uid']) ? '编辑' : '添加')?>客服服务</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            客服服务名称
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="id_title" <?php if(!empty($item['title'])) echo 'value="'.$item['title'].'"';?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
           归类
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_type" <?php if(!empty($item['type'])) echo 'value="'.$item['type'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
           标签
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_tags" <?php if(!empty($item['tags'])) echo 'value="'.$item['tags'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
           电话
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_phone" <?php if(!empty($item['phone'])) echo 'value="'.$item['phone'].'"';?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            图片
        </div>

        <div class="am-u-sm-9">
            <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                <input type="file" name="file" id="file_upload"/>

            </form> -->
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
            <div>
                <img id="id_img" src="<?php if(!empty($item['image'])) echo $item['image'];?>"  style="width:100px;height:100px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

	<hr/>
	<div class="am-g am-margin-top-sm">
    	 <div class="am-u-sm-2 am-text-right">
	     服务评分
   	     </div>
         <div class="am-u-sm-2 am-u-end">
           <input type="text" id="id_serve_point" <?php if(isset($item['serve_point'])) echo 'value="'.$item['serve_point'].'"';?>>
			<small></small>
         </div>
	</div>

	<div class="am-g am-margin-top-sm">
    	 <div class="am-u-sm-2 am-text-right">
	     服务人数
   	     </div>
         <div class="am-u-sm-2 am-u-end">
           <input type="text" id="id_serve_count" <?php if(isset($item['serve_count'])) echo 'value="'.$item['serve_count'].'"';?>>
			<small></small>
         </div>
	</div>

	<div class="am-g am-margin-top-sm">
    	 <div class="am-u-sm-2 am-text-right">
	     服务级别 
   	     </div>
         <div class="am-u-sm-2 am-u-end">
           <input type="text" id="id_serve_level" <?php if(isset($item['serve_level'])) echo 'value="'.$item['serve_level'].'"';?>>
			<small></small>
         </div>
	</div>


	<hr/>

	<div class="am-g am-margin-top-sm">
    	 <div class="am-u-sm-2 am-text-right">
	     排序
   	     </div>
         <div class="am-u-sm-2 am-u-end">
           <input type="text" id="id_sort" <?php if(isset($item['sort'])) echo 'value="'.$item['sort'].'"';?>>
			<small>从大到小排序</small>
         </div>
	</div>

	<div class="am-g am-margin-top-sm">
    	 <div class="am-u-sm-2 am-text-right">
	     状态
   	     </div>
         <div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
           <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($item['status'])) echo 'checked';?>>
			显示</label>
         </div>
	</div>


    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            简介
        </div>
        <!--文本编辑/-->

        <div class="am-u-sm-8 am-u-end">
            <script id="container" name="content" type="text/plain" style="height:250px;"><?php if(!empty($item['brief'])) echo ''.$item['brief'].'';?></script>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
        </div>
    </div>

</div>

<?php
echo '<script>var g_uid = '.(!empty($item['uid']) ? $item['uid'] : 0).';</script>';
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',
    $static_path.'/js/addkefu.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>

