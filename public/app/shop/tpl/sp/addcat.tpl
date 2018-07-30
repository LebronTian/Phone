
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($cat['uid']) ? '编辑分类' : '添加分类')?></strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            名称
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_title" <?php if(!empty($cat['title'])) echo 'value="'.$cat['title'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            英文名称
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="id_title_en" <?php if(!empty($cat['title_en'])) echo 'value="'.$cat['title_en'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            父级分类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="select-cat"></div>
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
            <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" id="search_pic" style="border: 1px solid #CCC;width: 130px;height: 32px;background-color: #0E90D2;color: #FFF;font-size: 14px;">从图片库选择</button>
            <div id="idImgBox">
                <img id="id_img" <?php if(!empty($cat['image'])) echo 'src="'.$cat['image'].'"';?> style="width:64px;height:64px;">
            </div>
			建议图片大小  64*64
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            排序
        </div>
        <div class="am-u-sm-1 am-u-end">
            <input type="text" id="id_sort" <?php if(isset($cat['sort'])) echo 'value="'.$cat['sort'].'"';?>>
            <small>从大到小排序</small>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($cat['status'])) echo 'checked';?>>
                显示到网站</label>
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

<script>
    var catsAll=<?php echo(!empty($parents)) ? json_encode($parents) : "null" ?>;
    var parentCat=<?php echo(!empty($parent)) ? json_encode($parent) : "null" ?>;
    seajs.use(['selectPic']);
</script>

<?php
echo '<script>var g_uid = '.(!empty($cat['uid']) ? $cat['uid'] : 0).';</script>';
$extra_js =  array(
    '/app/shop/static/js/addcat.js',
    '/static/js/catlist_yhc.js'
);
?>
