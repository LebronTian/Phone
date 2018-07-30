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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($item['uid']) ? '编辑' : '添加')?>项目</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            项目名称
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
            所在门店
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_store_uids">
                <?php
                array_unshift($stores['list'], array('uid' => 0, 'name' => '无'));
                $store = !empty($item['store_uid']) ? $item['store_uid'] : 0;
                $html = '';
                foreach($stores['list'] as $p) {
                    $html .= '<option value="'.$p['uid'].'"';
                    if($store == $p['uid']) $html .= ' selected';
                    $html .= '>'.$p['name'].'</option>';
                }
                echo $html;
                ?>
            </select>
        </div>
    </div>

      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               项目价格:
               </div>
               <div class="am-u-sm-2 am-u-end">
                 <input type="text" id="id_price" <?php if(!empty($item['price']))
        echo 'value="'.($item['price']/100).'"';?>> 元
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
                <img id="id_img" src="<?php if(!empty($item['main_img'])) echo $item['main_img'];?>"  style="width:100px;height:100px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

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

    <div class="am-g am-margin-top-sm" style="margin-top:20px;display:none;">
        <div class="am-u-sm-2 am-text-right">
            领取限制
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group reward-limit-box">
                <p style="margin-bottom: 8px"><span style="margin-right: 10px" class="am-icon-lightbulb-o am-warning am-icon-sm"></span>不选择就代表不限制</p>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($item['rule']['max_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt" <?php if(!empty($item['rule']['max_cnt'])) echo 'value="'.$item['rule']['max_cnt'].'"';else echo 'style="display: none"';?>/>
                    每个用户最多允许领取多少张
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($item['rule']['max_cnt_day'])) echo 'checked';?>>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($item['rule']['max_cnt_day'])) echo 'value="'.$item['rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                    每个用户每天最多允许领取多少张
                </label>

            </div>
        </div>
    </div>




    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            项目详情
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
    $static_path.'/js/additem.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>

