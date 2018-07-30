<?php include $tpl_path.'/header.tpl'; ?>
 <link rel="stylesheet" href="<?php echo $static_path?>/css/weui.min.css">
 <link rel="stylesheet" href="<?php echo $static_path?>/css/style.css">
 <body>
	<header class="color-main vertical-box">
	    <span class="header-title">充值详情</span>
	    <div class="header-left vertical-box">
	        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
	    </div>
	</header>
	<article>
	    <div class="weui_msg">
		    <div class="weui_icon_area"><i class="weui_icon_success weui_icon_msg"></i></div>
		    <div class="weui_text_area">
		        <h2 class="weui_msg_title">充值成功</h2>
		    </div>
		    
		</div>
		<div class="weui_cells">
            <div class="weui_cell">
            	<div class="weui_cell_ft">银行卡</div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p class="text-right">中国银行 <span>尾号4563</span></p>

                </div>
            </div>
            <div class="weui_cell">
            	<div class="weui_cell_ft">金额</div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p class="text-right"> <span>￥10.00</span></p>

                </div>
            </div>
        </div>
		
		 <a href="javascript:;" class="weui_btn weui_btn_warn" onclick="window.location.href='/?_easy=vipcard.single.index.cash'" >完成</a>

	</article>
</body>


<?php include $tpl_path.'/footer.tpl'; ?>