<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/favlist.css">
<header class="color-main vertical-box">
    <span class="header-title">我的收藏</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <span id="favlist-edit">编辑</span>
    </div>
</header>
<div class="container">
	<div class="favlist-list">
		<div class="favlist-list-a">
			<div class="no-list hide">
				您还没有收藏任何商品。
			</div>
			<script type="text/tpl" id="favlist-list">
				<a href="javascript:;" data-uid="{{=it.uid}}">
					<div class="favlist-list-edit hide">
						<i class="fa fa-circle-o"></i>
						<i class="fa fa-check-circle-o hide"></i>
					</div>
					<div class="bw90">
						<div class="favlist-list-aL" onclick="location.href='?_a=shop&_u=index.product&uid={{=it.product.uid}}'">
							<img src="{{=it.product.main_img}}" alt="" />
						</div>
						<div class="favlist-list-aR">
							<div class="favlist-list-title line2" onclick="location.href='?_a=shop&_u=index.product&uid={{=it.product.uid}}'">
								{{=it.product.title}}
							</div>
							<div class="favlist-list-RB">
								<span class="favlist-list-price c-red"><span class="small-text">&yen; </span><span>{{=it.product.price/100}}</span></span>
								<span class="favlist-list-del big-text c-red" data-uid = "{{=it.uid}}">删除商品</span>
							</div>
						</div>
					</div>
				</a>
			</script>
		</div>
	</div>
	<div class="favlist-all-del hide">
		取消收藏所选商品
	</div>
</div>


<?php include $tpl_path.'/footer.tpl'; ?>
<script src="/static/js/doT.min.js"></script>
<script>
	$('.favlist-list-a').on('click','.favlist-list-del',function(){
		var this_uid=$(this);
		if(confirm('确定要删除该商品吗？')){
			$.get('?_a=shop&_u=ajax.delete_fav',{uids:this_uid.data('uid')},function(ret){
				this_uid.parents('a').slideUp(1000,function(){
					$(this).remove();
				})
			})
		}
	})
	
	$('#favlist-edit').click(function(){
		if($(this).text() =='编辑'){
			$('.favlist-list-edit').css('display','flex');
			$('.bw90').css('width','90%');
			$(this).text('完成');
			$('.favlist-all-del').show();
		}else{
			$('.favlist-list-edit').hide();
			$('.bw90').css('width','100%');
			$(this).text('编辑');
			$('.favlist-all-del').hide();
		}
	})
	$('.favlist-all-del').click(function(){
		var list_uid=[];
		$('.favlist-list-a>a').each(function(ii,i){
			var uids=$(i).data('uid');
			if($(i).find('.favlist-list-edit').hasClass('selected')){
				list_uid.push(uids);
			}
		});
		if(list_uid==''){alert('请选择删除商品！');return}
		if(confirm('确定操作？')){
			$.get('?_a=shop&_u=ajax.delete_fav',{uids:list_uid},function(ret){
				ret=JSON.parse(ret);console.log(ret)
				if(ret.errno == 0){
					location.reload();
//		 			$('.favlist-list-edit').hide();
//					$('.bw90').css('width','100%');
//					$('#favlist-edit').text('编辑');
//					$('.favlist-all-del').hide();
				}else{
					alert('errno')
				}
			})
		}
	})

	$('.favlist-list-a').on('click','.favlist-list-edit',function(){
		$(this).find('.hide').removeClass('hide').siblings().addClass('hide');
		$(this).toggleClass('selected');
	})
/*接口*/
	function init(){
		var g_dot = doT.template($('#favlist-list').html());
		$.post('?_a=shop&_u=ajax.favlist',function(ret){
			ret = $.parseJSON(ret);
				if(ret.data.list != ''){
				$.each(ret.data.list, function (ii, i) {
					$('.favlist-list-a').append(g_dot(i));
				});
				}else{
					$('.no-list').show();
				}
		})
	};
	init();
</script>
</body>
</html>