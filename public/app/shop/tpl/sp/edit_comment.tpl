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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">评论详情</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            用户评论：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="brief-content"><?php if(!empty($comment)) echo $comment['brief'] ?></div>
<?php
if(!empty($comment['images'])) {
//var_export($comment['images']);
foreach($comment['images'] as $img) {
echo '<img src="'.$img.'" style="max-width:200px;max-height:200px;">';
}
}
?>
        </div>
    </div>
    <?php
    if(!empty($comment['replies'])){
        foreach($comment['replies']['list'] as $reply){
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
    var message = <?php echo(!empty($comment) ? json_encode($comment):"null") ?>;//used
</script>

<?php
$extra_js = array(
    $static_path.'/js/edit_comment.js',
);
?>
