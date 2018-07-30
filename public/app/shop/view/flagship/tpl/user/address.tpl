<?php include $tpl_path.'/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo $static_path?>/css/detail_font.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/makeorder.css">
<header class="color-main vertical-box">
    <span class="header-title">收货地址</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="address-article btn-footer-margin">
    <?php
    if(!empty($address)){
        foreach ($address as $a) {
            ?>
            <section class="linear-section margin-top-section margin-top-section last-liner-section" data-uid="<?php echo $a['uid'] ?>">
                <div class="select-address linear-address-section border-box">
                    <p class="big-text">
                        <span class="fa fa-user" style="font-size: 1.3em;"></span><span class="address-user"><?php echo $a['name'] ?></span>
                        <span class="fa fa-mobile fa-2x" style="position: relative;top: 2px;"></span><?php echo $a['phone'] ?></p>
                    <p class="small-text tips-font">
                        <?php
                        $full_address='';
                        if(!empty($a['province'])) $full_address.=$a['province'];
                        if(!empty($a['city'])) $full_address.=$a['city'];
                        if(!empty($a['town'])) $full_address.=$a['town'];
                        if(!empty($a['address'])) $full_address.=$a['address'];
                        echo $full_address;
                        ?>
                    </p>
                </div>
                <span class="address-delete vertical-box">
	                <kk class="fa  fa-trash-o fa-2x"></kk>
                </span>
                <span class="func-btn linear-right vertical-box">
	                <kk class="fa  fa-edit fa-2x"></kk>
                </span>
            </section>
    <?php
        }
    }
    else{
        ?>
        <p class="margin-top big-text white-tips-font" style="text-align: center">还没有地址，添加一个吧</p>
    <?php
    }
    ?>
</article>
<footer class="btn-footer footer-one-btn">
    <button class="color-primary big-text" onclick="window.location. href='?_a=shop&_u=user.addaddress'">新增收货地址</button>
</footer>

<?php include $tpl_path.'/footer.tpl'; ?>
<script type="text/javascript" charset="utf-8" ></script>
<script>
    var addressType = <?php echo(!empty($type)? json_encode($type):"null")?>;
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            /*选择模式的地址列表*/
            seajs.use('jquery_cookie', function () {
                /*添加后刷新缓存*/
                var freshen_data = $.cookie('freshen_add_data');
                if(freshen_data=='true'){
                    $.cookie('freshen_add_data','false');
                    window.location.reload()
                }
                if(addressType=='select'){
//                  $('.address-article .func-btn').hide();
                    $('.address-article .select-address').click(function () {
                        var uid = $(this).parent().data('uid');
                        $.post('?_a=shop&_u=ajax.add_address',{uid:uid}, function (ret) {
                            /*记录刷新标志*/
                            $.cookie('freshen_data','true');
                            history.back()
                        })
                    })
                }
            });
        })
    });
    $('.address-article .linear-right.func-btn').on('click',function(){
    	location.href="?_a=shop&_u=user.addaddress&uid="+$(this).parent().data('uid')
    })
    $('.address-delete').on('click',function(){
    	if(confirm('确定删除选中地址吗？')){
    		var address_uid=$(this).parent().data('uid');
    		var data={
    			uids:address_uid,
    		};
    		$.post('?_a=shop&_u=ajax.delete_address',data,function(ret){
    			ret=JSON.parse(ret);
    			if(ret.errno =='0'){
    				location.reload();
    			}else{
    				alert('error');location.reload();
    			}
    		})
    	}
    })
</script>
</body>
</html>
