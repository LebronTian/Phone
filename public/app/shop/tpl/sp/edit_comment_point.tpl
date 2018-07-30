<style>
    .brief-content{
        border: thin solid #ddd;
        padding: 0.5em;
    }
    #id_reply{
        min-height: 8em;
    }
</style>

<div class="am-padding">
    <strong class="am-text-primary am-text-lg">评论积分设置 /</strong>
</div>
<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            文字评论积分设置：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="number" min="0" step="5" name="text_point" class="text" placeholder="不填默认为0" value=<?php echo $text_point; ?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            带图评论积分设置：
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="number" min="0" step="5" name="img_point" class="img" placeholder="不填默认为0" value=<?php echo $img_point; ?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-8 am-u-end am-u-sm-offset-2">
            <button class="am-btn am-btn-secondary keep" type="submit">保存</button>
        </div>
    </div>
</div>
<!-- <div class="am-form">
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
 -->
     <!--    <button type="button"
        class="am-btn am-btn-primary" id="aa">
        Alert
        </button> --> 

<div class="am-modal am-modal-alert" tabindex="-1" id="my-alert">
  <div class="am-modal-dialog">
    <!-- <div class="am-modal-hd"></div> -->
    <div class="am-modal-bd">
      
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn">确定</span>
    </div>
  </div>
</div>
<script>
$(document).ready(function(){
    $('.keep').click(function(){
        var text_p = $('.text').val();
        var img_p = $('.img').val();
        $.post("/?_a=shop&_u=sp.do_edit_comment_point",{text_point:text_p,img_point:img_p},function(res){
            // alert(res);
            if(res === false){
                $('.am-modal-bd').text('设置失败');
                $('#my-alert').modal('open');
            } else{
                $('.am-modal-bd').text('设置成功');
                $('#my-alert').modal('open');

            }

        });

    });  
});
</script>
<?php
$extra_js = array(
    $static_path.'/js/edit_comment.js',
);
?>
