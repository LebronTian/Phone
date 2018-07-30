<style type="text/css">
	/*.company_info{
		font-family: "Microsoft Yahei";
		color: #6b6b6b;
		width: 1000px;
		margin: 20px auto 0;
		padding-bottom: 60px;
		text-align: center;
	}
	.company_name{
		font-size: 16px;
		line-height: 24px;
	}
	.company_address{
		font-size: 14px;
	}*/
	.footer{
		width: 1080px;
		height: 200px;
		margin: 100px auto 0;
		overflow: hidden;
	}
	.comp{
		width: 460px;
		height: 200px;
		float: left;
	}
	.comp_logo{
		display: block;
		width: 118px;
		height: 30px;
		margin: 18px auto;
	}
	.comp_code{
		display: block;
		width: 138px;
		height: 138px;
		margin: 0 auto;
	}
	.comp_info{
		width: 620px;
		height: 100%;
		float: left;
	}
	.comp_info h3{
		width: 300px;
		height: 50px;
		margin-top: 20px;
		font-size: 18px;
		color: #666;
		border-bottom: 1px solid #ccc;
		line-height: 50px;
		font-weight: 400;
	}
	.comp_detail{
		width: 620px;
		margin-top: 30px;
	}
	.comp_detail li{
		width: 620px;
		height: 18px;
		margin-bottom: 15px;
	}
	.comp_detail li span{
		font-size: 14px;
		line-height: 18px;
		color: #333;
	}
	.comp_detail li i{
		display: inline-block;
		background: url('app/site/view/buffalo/static/images/footer_icon.png') no-repeat;
		width: 18px;
		height: 18px;
	}
</style>
	<div class="footer">
		<div class="comp">
			<img src="app/site/view/buffalo/static/images/footer_logo.png" class="comp_logo">
			<img src="app/site/view/buffalo/static/images/footer_code.png" class="comp_code">
		</div>
		<div class="comp_info">
			<h3>Address Info</h3>
			<ul class="comp_detail">
				<li>
					<i style="background-position: 0 2px"></i>
					<span>深圳市南山区蛇口工业六路创新谷</span>
				</li>
				<li>
					<i style="background-position: 0 -32px"></i>
					<span>0755-36300086</span>
				</li>
				<li>
					<i style="background-position: 0 -62px"></i>
					<span>65553666@qq.com</span>
				</li>
			</ul>
		</div>
	</div>
<!-- <div class="company_box" id="footer">
	<div class="company_info">
	  <p class="company_name"><?php echo $site['brief'];?></p>
	  <p class="company_address">- <?php echo $site['location'];?> -</p>
	</div>
</div> -->
</body>
</html>