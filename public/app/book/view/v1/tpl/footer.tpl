<div class="weui_tabbar" style="position:fixed">
    <a href="?_a=book&_u=index.index" class="weui_tabbar_item
		<?php if($GLOBALS['_UCT']['ACT'] == 'index') echo ' weui_bar_item_on';?>">
        <p class="weui_tabbar_label"><span class="fa fa-home fa-2x"></span><br>首页</p>
    </a>
    <a href="?_a=book&_u=index.activity_list" class="weui_tabbar_item
		<?php if($GLOBALS['_UCT']['ACT'] == 'activity_list') echo ' weui_bar_item_on';?>">
        <p class="weui_tabbar_label"><span class="fa fa-star-half-o fa-2x"></span><br>活动</p>
    </a>
    <a href="?_a=book&_u=index.store_list" class="weui_tabbar_item
		<?php if($GLOBALS['_UCT']['ACT'] == 'store_list') echo ' weui_bar_item_on';?>">
        <p class="weui_tabbar_label"><span class="fa fa-map-marker fa-2x"></span><br>门店</p>
    </a>
    <a href="?_a=book&_u=index.user" class="weui_tabbar_item
		<?php if($GLOBALS['_UCT']['ACT'] == 'user') echo ' weui_bar_item_on';?>">
        <p class="weui_tabbar_label"><span class="fa fa-user fa-2x"></span><br>我的</p>
    </a>
</div>

