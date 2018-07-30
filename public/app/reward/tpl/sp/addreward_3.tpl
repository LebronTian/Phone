<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/app/reward/static/css/new-reward.css">

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
	<strong class="am-text-default am-text-lg"><?php echo(!empty($reward['uid']) ? '编辑抽奖' : '添加抽奖')?></strong> <small></small></div>
</div>

<div class="am-padding" style="padding-top:0;">
  <ul class="step-status-bars">
    <?php 
        if(!empty($reward)){
            $html = '';
            $html.='<li class=""><a href="?_a=reward&_u=sp.addreward_1&uid='.$reward['uid'].'">基本设置</a></li><li class="active"><a href="?_a=reward&_u=sp.addreward_3&r_uid='.$reward['uid'].'">奖项/概率设置</a></li>';
            if($item['count']!='0'){
                $html.='<li class=""><a href="?_a=reward&_u=sp.addreward_5&uid='.$reward['uid'].'">其他设置</a></li>';    
            }else{
                $html.='<li class="disabled">其他设置</li>';
            }
            echo $html;
            
        }else{
            echo '<li class=""><a href="?_a=reward&_u=sp.addreward_1">基本设置</a></li>
                  <li class="active"><a href="?_a=reward&_u=sp.addreward_3">奖项/概率设置</a></li>
                  <li class="disabled">其他设置</li>';
        }
    ?>
  </ul>
</div>

<div class="am-form  data-am-validator ">
    
    <div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
      <div class="am-modal-dialog">
        <div class="am-modal-hd"></div>
        <div class="am-modal-bd">
          你，确定要删除这张图片吗？
        </div>
        <div class="am-modal-footer">
          <span class="am-modal-btn" data-am-modal-cancel>取消</span>
          <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
      </div>
    </div>

    <div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-delete-rewarditem">
      <div class="am-modal-dialog">
        <div class="am-modal-bd">
          你，确定要删除这条奖项吗？
        </div>
        <div class="am-modal-footer">
          <span class="am-modal-btn" data-am-modal-cancel>取消</span>
          <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
      </div>
    </div>

    <!-- 新抽奖流程 -->
    <!-- 奖项设置 start -->
    <div class="am-u-sm-12" style="width:100%;">
        <h1 style="text-align:center;">奖项/概率 设置</h1>
        <div class="am-u-sm-12 reward-setting" style="background-color:#f1f1f1;padding:5px 0;border:1px solid #DDDDDD;">
            <div class="am-u-sm-4">
                <p>奖项名称 <span class="am-icon-question-circle am-text-danger " data-am-popover="{content: '带 <span class=&quot;am-icon-gift am-text-primary&quot;></span> 标志的为虚拟奖品', trigger: 'hover focus'}"></span></p><p>（<span class="must-input">*</span>不能超过50个字）</p>
            </div>

            <div class="am-u-sm-2">
                <p>图片</p>
            </div>

            <div class="am-u-sm-2">
                <p>奖品数量</p><p>（<span class="must-input">*</span>）</p>
            </div>
            <div class="am-u-sm-2">
                <p>概率</p><p>（<span class="must-input">*</span>0.00 ~ 100，0表示不中奖，1表示中奖概率为1%）</p>
            </div>
           
            <div class="am-u-sm-2">
                <p>操作</p>
            </div>
        </div>
        <div class="am-u-sm-12 reward-setting">
            <input type="hidden" value="<?php echo (!empty($item['list'][0]['uid']) ? $item['list'][0]['uid'] : '') ?>">
            <div class="am-u-sm-4">
                <!-- <div class="am-u-sm-3" style="padding:0;line-height:40px;">奖项一</div> -->
                <div class="am-u-sm-12 reward-name" style="padding:0;">
                    <?php 
                        if(!empty($item['list'][0]['virtual_info'])){
                            echo '<span class="am-icon-gift am-text-primary"></span>';
                        }
                    ?>
                    <input type="text" value="<?php echo (!empty($item['list'][0]['title']) ? $item['list'][0]['title'] : '') ?>" placeholder="">
                </div>
            </div>
            <div class="am-u-sm-2 select-img-bar">
                <img src="<?php echo (!empty($item['list'][0]['img']) ? $item['list'][0]['img'] : '/app/reward/static/images/reward.png') ?>">
                <a href="javascript:;" class="imgBoxBtn" data-id="1">选择图片</a>
            </div>
            
            <div class="am-u-sm-2">
                <input type="number" value="<?php echo (!empty($item['list'][0]['total_cnt']) ? $item['list'][0]['total_cnt'] : '0') ?>" placeholder="">
            </div>
            <div class="am-u-sm-2 probability-input">
                <input type="number" value="<?php echo (!empty($item['list'][0]['weight']) ? ($item['list'][0]['weight'])/100 : '0') ?>" placeholder="">
                <span>%</span>
            </div>
            
            <div class="am-u-sm-2 probability-input">
            <?php 
                if(!empty($item['list'][0])){
                    echo '<button class="am-btn am-btn-primary am-btn-xs" 
                                onclick="window.location.href=\'?_a=reward&_u=sp.additem&n_uid=1&i_uid='.$item['list'][0]['uid'].'&r_uid='.$item['list'][0]['r_uid'].'\'">编辑</button>
                    <button class="am-btn am-btn-warning am-btn-xs delete-btn" 
                    data-uid="'.$item['list'][0]['uid'].'" data-ruid="'.$item['list'][0]['r_uid'].'">删除</button>';
                }
            ?>
            </div>
        
        </div>
        <div class="am-u-sm-12 reward-setting">
            <input type="hidden" value="<?php echo (!empty($item['list'][1]['uid']) ? $item['list'][1]['uid'] : '') ?>">
            <div class="am-u-sm-4">
                <!-- <div class="am-u-sm-3" style="padding:0;line-height:40px;">奖项一</div> -->
                <div class="am-u-sm-12 reward-name" style="padding:0;">
                    <?php 
                        if(!empty($item['list'][1]['virtual_info'])){
                            echo '<span class="am-icon-gift am-text-primary"></span>';
                        }
                    ?>
                    <input type="text" value="<?php echo (!empty($item['list'][1]['title']) ? $item['list'][1]['title'] : '') ?>" placeholder="">
                </div>
            </div>
            <div class="am-u-sm-2 select-img-bar">
                <img src="<?php echo (!empty($item['list'][1]['img']) ? $item['list'][1]['img'] : '/app/reward/static/images/reward.png') ?>">
                <a href="javascript:;" class="imgBoxBtn" data-id="2">选择图片</a>
            </div>
            
            <div class="am-u-sm-2">
                <input type="number" value="<?php echo (!empty($item['list'][1]['total_cnt']) ? $item['list'][1]['total_cnt'] : '0') ?>" placeholder="">
            </div>
            <div class="am-u-sm-2 probability-input">
                <input type="number" value="<?php echo (!empty($item['list'][1]['weight']) ? ($item['list'][1]['weight'])/100 : '0') ?>" placeholder="">
                <span>%</span>
            </div>
            <div class="am-u-sm-2 probability-input">
                <?php 
                    if(!empty($item['list'][1])){
                        echo '<button class="am-btn am-btn-primary am-btn-xs" onclick="window.location.href=\'?_a=reward&_u=sp.additem&n_uid=1&i_uid='.$item['list'][1]['uid'].'&r_uid='.$item['list'][1]['r_uid'].'\'">编辑</button>
                    <button class="am-btn am-btn-warning am-btn-xs delete-btn" 
                        data-uid="'.$item['list'][1]['uid'].'" data-ruid="'.$item['list'][1]['r_uid'].'">删除</button>';
                    }
                ?>
            </div>
        </div>
        <div class="am-u-sm-12 reward-setting">
            <input type="hidden" value="<?php echo (!empty($item['list'][2]['uid']) ? $item['list'][2]['uid'] : '') ?>">
            <div class="am-u-sm-4">
                <!-- <div class="am-u-sm-3" style="padding:0;line-height:40px;">奖项一</div> -->
                <div class="am-u-sm-12 reward-name" style="padding:0;">
                    <?php 
                        if(!empty($item['list'][2]['virtual_info'])){
                            echo '<span class="am-icon-gift am-text-primary"></span>';
                        }
                    ?>
                    <input type="text" value="<?php echo (!empty($item['list'][2]['title']) ? $item['list'][2]['title'] : '') ?>" placeholder="">
                </div>
            </div>
            <div class="am-u-sm-2 select-img-bar">
                <img src="<?php echo (!empty($item['list'][2]['img']) ? $item['list'][2]['img'] : '/app/reward/static/images/reward.png') ?>">
                <a href="javascript:;" class="imgBoxBtn" data-id="3">选择图片</a>
            </div>
            
            <div class="am-u-sm-2">
                <input type="number" value="<?php echo (!empty($item['list'][2]['total_cnt']) ? $item['list'][2]['total_cnt'] : '0') ?>" placeholder="">
            </div>
            <div class="am-u-sm-2 probability-input">
                <input type="number" value="<?php echo (!empty($item['list'][2]['weight']) ? ($item['list'][2]['weight'])/100 : '0') ?>" placeholder="">
                <span>%</span>
            </div>
            <div class="am-u-sm-2 probability-input">
                <?php 
                    if(!empty($item['list'][2])){
                        echo '<button class="am-btn am-btn-primary am-btn-xs" onclick="window.location.href=\'?_a=reward&_u=sp.additem&n_uid=1&i_uid='.$item['list'][2]['uid'].'&r_uid='.$item['list'][2]['r_uid'].'\'">编辑</button>
                    <button class="am-btn am-btn-warning am-btn-xs delete-btn" 
                    data-uid="'.$item['list'][2]['uid'].'" data-ruid="'.$item['list'][2]['r_uid'].'">删除</button>';
                    }
                ?>
            </div>
        </div>
        <?php 
            if(!empty($item['list'])) {
                $html = '';
                if($item['count'] > 3){
                    for( $i=3; $i<$item['count']; $i++ ) {
                        $html.= '<div class="am-u-sm-12 reward-setting">
                                    <input type="hidden" value="'.$item['list'][$i]['uid'].'">
                                    <div class="am-u-sm-4"> 
                                        <div class="am-u-sm-12 reward-name" style="padding:0;">';
                                        if(!empty($item['list'][$i]['virtual_info'])){
                                            $html.='<span class="am-icon-gift am-text-primary"></span>';
                                        }
                                        $html.='<input type="text" value="'.$item['list'][$i]['title'].'" placeholder="">
                                        </div>
                                    </div>
                                    <div class="am-u-sm-2 select-img-bar">
                                        <img src="'.$item['list'][$i]['img'].'">
                                        <a href="javascript:;" class="imgBoxBtn" data-id="'.($i+1).'">选择图片</a>
                                    </div>
                                    <div class="am-u-sm-2">
                                        <input type="number" value="'.$item['list'][$i]['total_cnt'].'" placeholder="">
                                    </div>
                                    <div class="am-u-sm-2 probability-input">
                                        <input type="number" value="'.($item['list'][$i]['weight']/100).'" placeholder="">
                                        <span>%</span>
                                    </div>
                                    <div class="am-u-sm-2 probability-input">
                                        <button class="am-btn am-btn-primary am-btn-xs" 
                                                onclick="window.location.href=\'?_a=reward&_u=sp.additem&n_uid=1&i_uid='.$item['list'][$i]['uid'].'&r_uid='.$item['list'][$i]['r_uid'].'\'">编辑</button>
                                        <button class="am-btn am-btn-warning am-btn-xs delete-btn" 
                                        data-uid="'.$item['list'][$i]['uid'].'" data-ruid="'.$item['list'][$i]['r_uid'].'">删除</button>
                                    </div>
                                </div>';
                    }
                    echo $html;
                }
            }
        ?>
        <div style="clear:both;"></div>
        <p style="text-align:center;"><button type="button" style="width:235px;" class="am-btn am-btn-success" id="add-award-btn">添加一项</button></p>
        <p style="text-align:center;">
            <button type="button" class="am-btn am-btn-primary" id="reward-step-three">下一步，其他设置</button>
            <button type="button" class="am-btn am-btn-default" onclick="window.history.back()" id="back-step-two">返回</button>
        </p>
    </div>
    <!-- 奖项设置 end -->
    
    
	
	
	<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>

	 


</div>
<script type="text/javascript">
    var items = <?php echo (!empty($item) ? json_encode($item) : 'null') ?>;
    var rewards = <?php echo (!empty($reward) ? json_encode($reward) : 'null') ?>;
    seajs.use(['selectPic']);
</script>

<?php
	echo '<script>
        var g_uid = '.(!empty($reward['uid']) ? $reward['uid'] : 0).';
            </script>';
        $extra_js =  array( 

		    '/static/js/select2/js/select2.min.js',
            '/static/js/ueditor/ueditor.config.js',
            '/static/js/ueditor/ueditor.all.js', 

            
          '/app/reward/static/js/addreward.js',
          '/static/js/select_tpl.js',
          '/static/js/amazeui.datetimepicker.min.js',
          '/app/reward/static/js/new-addreward.js',
          '/app/reward/static/js/select-t.js'
    );

?>

