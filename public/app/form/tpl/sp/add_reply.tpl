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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">回复</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            用户提问：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="brief-content"><?php if(!empty($reply)) echo $reply['content'] ?></div>

        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            回复：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <textarea id="id_reply" data-uid="<?php echo isset($reply['reply_son']['uid'])?$reply['reply_son']['uid']:'' ?>"><?php echo isset($reply['reply_son']['content'])?$reply['reply_son']['content']:'' ?></textarea>
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
    var reply = <?php echo(!empty($reply) ? json_encode($reply):"null") ?>;//used
</script>

<?php
$extra_js = array(
    $static_path.'/js/add_reply.js',
);
?>
