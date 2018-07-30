<div class="btn_guide" style="position:absolute;right:10px;top:50px;"><a href="javascript:;">建站引导</a></div>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">微官网</strong> / <small></small></div>
</div>

<div class="am-padding am-g">
	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list ">
      <li><a href="?_a=site&_u=sp.articlelist" class="am-text-success"><span class="am-icon-btn am-icon-file-text"></span><br>文章总数<br>
			<?php echo $cnts['total_article_cnt'];?></a></li>
      <li><a href="javascript:;" class="am-text-warning"><span class="am-icon-btn am-icon-briefcase"></span><br>文章阅读数<br>
			<?php echo $cnts['total_click_cnt'];?></a></li>
      <li><a href="?_a=site&_u=sp.messagelist" class="am-text-danger"><span class="am-icon-btn am-icon-recycle"></span><br>留言数<br>
			<?php echo $cnts['total_msg_cnt'];?></a></li>
    </ul>
</div>

<div class="am-g am-padding" <?php if(empty($_GET['_d'])) echo 'style="display:none;"'; ?> >
	<div class="am-u-md-4">
	手机扫一扫,访问 <a target="_blank" href="<?php echo DomainMod::get_app_url('site');?>" >
	<?php echo $site['title'] ? $site['title'] : '微官网'; ?></a>
	<br/>
	<?php if(empty($site['status']))echo '<img style="width:220px;height:220px;" src="?_a=site&_u=index.qrcode&site_uid='.$site['uid'].'">'; ?>
	</div>

<?php
if(!empty($_REQUEST['_d']) ||
	(strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3))) {
?>
	<div class="am-u-md-8">
	您还可以
	<br/><br/>
	<span class="am-icon-info-circle"></span> 把微官网设置到 <a href="?_a=menu&_u=sp">微信菜单</a><br/>
	<span class="am-icon-info-circle"></span> 为微官网添加 <a href="?_a=keywords&_u=sp">微信关键词</a><br/>
	<span class="am-icon-info-circle"></span> <a href="?_a=mass&_u=sp">推文章</a> 告知粉丝<br/>
	</div>
<?php }?>
</div>


    <div id="walkthrough-content">
        <div id="walkthrough-1">
            <h3>欢迎使用微官网建站引导</h3>
            <p>点击下一步了解更多...</p>
        </div>

        <div id="walkthrough-2">
            点击这里，在里面选择一个网站模板～
        </div>

        <div id="walkthrough-3">
            点击这里，填写网站信息，例如网站名称必填、联系电话、logo等～
        </div>

        <div id="walkthrough-4">
            点击这里，添加2～4张轮播图片为宜～
        </div>

        <div id="walkthrough-5">
            点击这里，添加分类，分类最多只有二级，请按需进行合理分类～
        </div>
        <div id="walkthrough-6">
            点击这里，添加文章，将文章放在各个分类下面，分类下面最好不要分类和文章混搭。尽量分类下面全是文章或者全是分类，再在子分类下面加文章～
        </div>
    </div>


<?php
  $extra_js = array(
    '/app/site/static/js/jquery.pagewalkthrough.min.js',
    '/app/site/static/js/tplguide.js',
  );

?> 
<script>
    var visitData = <?php echo(!empty($visit))? json_encode($visit):"null" ?>
</script>

