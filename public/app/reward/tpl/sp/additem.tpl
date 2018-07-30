<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<style type="text/css">
	.uploadify-button {
		line-height: 25px !important;
	}
</style>
<div class="am-cf am-padding">
	<div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
  	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
    <a href="?_a=reward&_u=sp.itemlist&r_uid=<?php echo $reward['uid'];  ?>"><strong class="am-text-primary am-text-lg"><?php echo $reward['title'];?> 的奖品</strong> </a>
	<span class="am-icon-angle-right"></span>
    <strong class="am-text-default am-text-lg"><?php  echo(!empty($item['uid']) ? '编辑奖品' : '添加奖品')?></strong>  <small></small></div>
</div>
<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            是否虚拟奖品
        </div>
        <div class="am-u-sm-8 am-u-end">
			<select id="id_virtual"></select>
        </div>
    </div>

	<hr>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             标题
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_title" placeholder="必填" <?php if(!empty($item['title'])) echo 'value="'.$item['title'].'"';?>>
       		     </div>
			</div>

  
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             封面图片
   		         </div>

               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
			  
				<button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
					<div id="idImgBox">
						<img id="id_img" src="<?php if(!empty($item['img'])) echo $item['img'];?>"  style="width:100px;height:100px;">
					</div>
				</div>
				<div class="am-u-sm-8 am-u-end">
       		    </div>
			</div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             奖品份数
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
					<input type="number" id="id_total_cnt"  min="0" placeholder="请填写奖品分数,0为不中奖" <?php if(!empty($item['total_cnt'])) echo 'value="'.$item['total_cnt'].'"';?>>
       		     <small>请填写奖品分数,0为不中奖</small>
				 </div>
				 
			</div>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             中奖概率
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
					<input type="number" id="id_weight" min="0" max="100" step="0.01" placeholder="请填写奖品中奖概率 0-100" <?php if(!empty($item['weight'])) echo 'value="'.($item['weight']/100).'"';?>>
       		     <small>0.00 ~ 100.00,0表示不中奖,1表示中奖概率为1%</small>
				 </div>
				 
			</div>
			<?php 
			
			$html='';
			$html .='<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             已中奖数
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<input type="text" id="id_win_cnt" placeholder="请填写已中奖数,一般为0"';
			if(!empty($item['win_cnt'])) 
			$html .='value="'.$item['win_cnt'].'"';
			$html .='></div></div>';
			if(!empty($_REQUEST['_d']))
			echo $html;
			?>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             序号
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
					<input type="number" id="id_sort"  <?php if(!empty($item['sort'])) echo 'value="'.$item['sort'].'"';?>>
       		     <small>根据序号从大到小排序</small>
				 </div>
				 
			</div>
			
			<div class="am-g am-margin-top-sm" style="margin-top:20px;">
				<div class="am-u-sm-2 am-text-right">
					介绍
				</div>              
				<!--文本编辑/-->

				<div class="am-u-sm-8 am-u-end">
					<script id="container" name="brief" type="text/plain" style="height:250px;"><?php if(!empty($item['brief'])) echo ''.$item['brief'].'';?></script>  
				</div>
			</div>
			
			<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
				<div class="am-u-sm-2 am-text-right">
					&nbsp;
				</div>
				<div class="am-u-sm-8 am-u-end">
				<p>
					<button class="am-btn am-btn-lg am-btn-primary save ">保存</button>
					<button style="margin-left: 0.5em" onclick="history.back()" class="am-btn am-btn-lg am-btn-primary">取消</button>
				</p>
				</div>
			</div>

</div>

<?php

	echo '<script>var uid = '.(!empty($item['uid']) ? $item['uid'] : 0).';</script>';
	echo '<script>var r_uid = '.(!empty($item['r_uid']) ? $item['r_uid'] : 0).';</script>';
	echo '<script>var g_virtual_info= '.(!empty($item['virtual_info']) ? json_encode($item['virtual_info']) : 'null').';</script>';
        $extra_js =  array( 

            '/static/js/ueditor/ueditor.config.js',
            '/static/js/ueditor/ueditor.all.js',
          '/app/reward/static/js/additem.js',
    );

?>

<script>
		seajs.use(['selectPic','selectVir'])
</script>


