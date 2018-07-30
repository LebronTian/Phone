<style>
    .brief-content{
        border: thin solid #ddd;
        padding: 0.5em;
    }
    #id_reply{
        min-height: 8em;
    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">留言详情</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            用户留言：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="brief-content"><?php if(!empty($message)) echo $message['brief'] ?></div>
        </div>
    </div>
    <?php
    if(!empty($message['replies'])){
        foreach($message['replies']['list'] as $reply){
            ?>
            <div class="am-g am-margin-top-sm">
                <div class="am-u-sm-2 am-text-right">
                    已回复：
                </div>
                <div class="am-u-sm-8 am-u-end">
                    <div class="brief-content"><?php echo $reply['brief'] ?></div>
                </div>
            </div>
    <?php
        }
    }
    ?>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            回复留言：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <textarea id="id_reply"></textarea>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-primary save-brief">保存</button>
        </div>
    </div>
</div>

<script>
    var message = <?php echo(!empty($message) ? json_encode($message):"null") ?>;//used
</script>

<?php
$extra_js = array(
    $static_path.'/js/edit_message.js',
);
?>
