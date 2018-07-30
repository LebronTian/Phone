<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>可视化界面</title>
		<!-- <link rel="stylesheet" type="text/css" href="/app/shop/static/modules/css/bootstrap.min.css" /> -->
		<link rel="stylesheet" type="text/css" href="/app/shop/static/modules/css/visualview.css" />
		<link rel="stylesheet" type="text/css" href="/app/shop/static/modules/css/swiper.min.css" />
	</head>

	<body>
		<div class="container-fluid fullpage" id="app" v-cloak>
			<div class="row clearfix fullpage">
				<div class="col-md-12 column fullpage overflow-h">
					<!--顶部导航栏开始-->
					<nav class="navbar navbar-static-top bargreen" role="navigation">
						<div>
							<!--向左对齐-->
							<ul class="nav navbar-nav navbar-left">
								<li v-for="item in leftnav">
									<a :href="item.url"><span class="glyphicon" :class="item.icon"></span> {{item.name}}</a>
								</li>
							</ul>

							<!--向右对齐-->
							<ul class="nav navbar-nav navbar-right">
								<li>
									<a href="?_a=sp&_u=index.xcxpagelist"><span class="glyphicon" class=""></span> 页面管理</a>
								</li>
								<li>
									<a @click="saveData('server')"><span class="glyphicon" class=""></span> 保存页面</a>
								</li>
								<li>
									<a @click="saveData('online')"><span class="glyphicon" class=""></span> 同步上线</a>
								</li>
							</ul>

						</div>
					</nav>
					<!--顶部导航栏结束-->
					<!--主功能区页面开始-->
					<div class="row clearfix fullpage main">
						<!--左侧模块插件开始-->
						<div class="col-xs-4 column fullpage">
							<div class="tabbable text-center fullpage main-left bgwhite" id="tabs-111">
								<ul class="nav nav-tabs bggreen">
									<li class="active">
										<a href="#panel-112" data-toggle="tab">功能插件</a>
									</li>
									<li>
										<a href="#panel-113" data-toggle="tab">营销插件</a>
									</li>
								</ul>
								<div class="tab-content scrollbar-style">
									<!--功能插件开始-->
									<div class="tab-pane fade in active" id="panel-112">
										<div class="plug-in draggable">
											<ul class="clearfix">
												<li v-for="item in componentPlugin" @click="add(item.component)">
													<img :src="item.src">
													<div v-text="item.name"></div>
												</li>
											</ul>
										</div>
									</div>
									<!--功能插件结束-->
									<!--营销插件开始-->
									<div class="tab-pane fade" id="panel-113">
										<div class="plug-in draggable">
											<ul class="list-unstyled list-inline clearfix">
												<li v-for="item in marketingPlugin" @click="add(item.component)">
													<img :src="item.src">
													<div>{{item.name}}</div>
												</li>
											</ul>
										</div>
									</div>
									<!--营销插件结束-->
								</div>
							</div>
						</div>
						<!--左侧模块插件结束-->
						<!--中部手机视图开始-->
						<div class="col-xs-4 column fullpage">
							<div class="main-center fullpage">
								<div class="app-view scrollbar-style">
									<div class="app-view-outer">
										<div class="app-view-inner">
											<!-- cctodo -->
											<div class="xcx-header text-center" :style="{background :xcxtab.backgroundColor}">
												<div class="xcx-header-title ellipsis">
													<p>{{basicInfo.pageTitle || basicInfo.xcxname}}</p>
												</div>
											</div>
											<!--new aad-->
											<div class="xcx-main scrollbar-style list-unstyled kefu-style" :style="{height: basicInfo.isxcxtab?'':'627px'}">

												<transition-group name="list-complete" tag="ul">
													<div class="list-complete-item sortable" v-for="(node, index) in nodes" v-dragging="{ list: nodes, item: node, group: 'node' }" :key="index">
														<div class="btn-group-seft">
															<button class="btn btn-success btn-xs" @click="editNode(index)">编辑</button>
															<button class="btn btn-danger btn-xs" @click="deleteNode(index)">删除</button>
														</div>
														<li :is="node.component" :nodedata="node.nodedata"></li>
													</div>
												</transition-group>
												<!-- 客服悬浮按钮 CSP 2018/06/05-->
												<div class="livechat-girl" v-if="contactInfo.show">
													<image :src="contactInfo.imgUrl ? contactInfo.imgUrl : contactInfo.defaultImgUrl" />
												</div>
											</div>

											<!--new aad-->
											<div class="xcx-footer" v-if="basicInfo.isxcxtab">
												<transition-group name="list-add" tag="ul" class="flex text-center">
													<li v-for="(item,index) in xcxtab.list" v-bind:key="item" @click="selecticon(index)" class="list-add-item sub">

														<div class="icon-img">
															<img :src="item.isActive ? item.selectedIconPath : item.iconPath " />
														</div>
														<p class="text" :style="{color:item.isActive ? xcxtab.selectedColor : xcxtab.color }" v-html="item.text"></p>
													</li>
												</transition-group>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--中部手机视图结束-->
						<!--右侧属性导航栏开始-->
						<div class="col-xs-4 column fullpage" style="padding-right: 0;">
							<div class="main-right bgwhite fullpage">
								<div class="tabbable fullpage" id="tabs-211">
									<ul class="nav nav-tabs bggreen text-center">
										<li class="active">
											<a href="#panel-212" data-toggle="tab">网站设置</a>
										</li>
										<li>
											<a href="#panel-214" data-toggle="tab">组件设置</a>
										</li>
										<li>
											<a href="#panel-213" data-toggle="tab">底部菜单</a>
										</li>
										<li>
											<a id="temp_center" href="#panel-215" data-toggle="tab">模版中心</a>
										</li>
									</ul>
									<div class="tab-content scrollbar-style">
										<!--网站设置开始-->
										<!-- new aad -->
										<div class="tab-pane fade in active" id="panel-212">
											<div class="title">
												顶部标题
											</div>
											<div class="xcx-title-input">
												输入标题:<input type="text" v-model="basicInfo.pageTitle" />
											</div>
											<div class="xcx-title-input">
												微页面名称(选填):<input type="text" v-model="basicInfo.xcxname" />
											</div>
											<div class="title">
												风格设置
											</div>
											<ul class="color-list">
												<li v-for="(item,index) in colorlist">
													<a class="btn" href="#" :style="{background: item.color}" @click="changecolor(index)"></a>
												</li>
											</ul>
											<!--new aad-->
											<div class="zdy-color">
												<span>自定义颜色：</span>
												<input type="color" name="xcxcolor" :value="xcxTab.backgroundColor" @change="inputcolor" />
											</div>

											<div class="title">客服按钮设置</div>
											<div class="">
												<ul class="clearfix">
													<li class="clearfix">
														<div class="checkbox-group">
															<input type="checkbox" v-model="contactInfo.show">
															<label for="checkbox">是否显示</label>
														</div>
														<div class="fl demoimg demoimgBig">
															<a @click="selectImg('contactImg')">
																<img :src="contactInfo.imgUrl ? contactInfo.imgUrl : contactInfo.defaultImgUrl" />
															</a>
														</div>
														<div class="box-right">
															<div class="input-group">
																<span class="input-group-btn">
																	<button @click="selectPath('contactLink')" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																<input v-model="contactInfo.link" placeholder="为空时默认跳转客服功能" type="text" class="form-control">
															</div>
														</div>
													</li>
												</ul>
											</div>
										</div>

										<div class="tab-pane fade" id="panel-214">
											<!--营销组件开始-->
											<transition :name="transitionname">
												<div class="tuandui zjbox" v-show="editedNode && editedNode.component == 'tuanDui'">
													<h3 class="text-center">团队</h3>
													<button @click="selectGood('book')" class="btn btn-default" type="button">选择一个预约团队</button>
													<a class="navToEdit" href="?_a=book&_u=sp.itemlist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑预约项目</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">
																			名称
																</span>
																	<input type="text" class="form-control" v-model="item.title">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			职务
																		</span>
																	<input type="text" class="form-control" v-model="item.job">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			标签1
																		</span>
																	<input type="text" class="form-control" v-model="item.tag1">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			标签2
																		</span>
																	<input type="text" class="form-control" v-model="item.tag2">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			标签3
																		</span>
																	<input type="text" class="form-control" v-model="item.tag3">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			预约价格
																		</span>
																	<input type="text" class="form-control" v-model="item.price">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			好评率
																		</span>
																	<input type="text" class="form-control" v-model="item.praiseNum">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			评论数
																		</span>
																	<input type="text" class="form-control" v-model="item.commentNum">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			已被约
																		</span>
																	<input type="text" class="form-control" v-model="item.bookNum">
																</div>
																<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">删除</button>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">删除</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="yuyue zjbox" v-show="editedNode && editedNode.component == 'yuYue'">
													<h3 class="text-center">预约</h3>
													<button @click="selectGood('book')" class="btn btn-default" type="button">选择一个预约项目</button>
													<a class="navToEdit" href="?_a=book&_u=sp.itemlist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑预约项目</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">名称</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">删除</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="chanpin zjbox" v-show="editedNode && editedNode.component == 'chanPin'">
													<h3 class="text-center">产品</h3>
													<button @click="selectGood('good')" class="btn btn-default" type="button">选择产品</button>
													<a class="navToEdit" href="?_easy=shop.sp.productlist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑产品</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">

															<div class="setting-cont">
																	<label>
																  <input type="checkbox" v-model="editedNode.nodedata.checkeda">
																  <div class="show-box"></div>
																  <span>模块间距</span>
																</label>
																<label>
																  <input type="checkbox" v-model="editedNode.nodedata.ohidden">
																  <div class="show-box"></div>
																  <span>{{ editedNode.nodedata.ohidden ? '显示' : '隐藏' }}销量</span>
																</label>
															</div>
															<div class="select-bs-self">
																<label>
																	选择的样式是:
																</label>
																<select v-model="editedNode.nodedata.selecteda" name="productstyle">
																    <option value="xcx_product">样式1</option>
																    <option value="xcx_producta">样式2</option>
																	<option value="xcx_productb">样式3</option>
																</select>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">
																			名称
																</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="gonggao zjbox" v-show="editedNode && editedNode.component == 'gongGao'">
													<h3 class="text-center">公告</h3>
													<button @click="selectGood('notice')" class="btn btn-default" type="button">选择公告</button>
													<a class="navToEdit" href="?_a=shop&_u=sp.radiolist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑公告</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">

															<div class="setting-cont">
																	<label>
																  <input type="checkbox" v-model="editedNode.nodedata.checkeda">
																  <div class="show-box"></div>
																  <span>模块间距</span>
																</label>
															</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">
																			内容
																</span>
																	<input type="text" class="form-control" :value="item.txt" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="pintuan zjbox" v-show="editedNode && editedNode.component == 'pinTuan'">
													<h3 class="text-center">拼团 <!-- <span class="imageSize-tips">(建议上传图片尺寸：360x190)</span> --></h3>
													<button @click="selectGood('group')" class="btn btn-default" type="button">选择拼团项目</button>
													<a class="navToEdit" href="?_a=shoptuan&_u=sp.productgrouplist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑拼团商品</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgSmall">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																	名称
																</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="miaosha zjbox" v-show="editedNode && editedNode.component == 'miaoSha'">xinwen
													<h3 class="text-center">秒杀 <!-- <span class="imageSize-tips">(建议上传图片尺寸：360x190)</span> --></h3>
													<button @click="selectGood('kill')" class="btn btn-default" type="button">选择秒杀项目</button>
													<a class="navToEdit" href="?_a=shopsec&_u=sp.productkilllist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑秒杀商品</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgSmall">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																	名称
																</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="kanjia zjbox" v-show="editedNode && editedNode.component == 'kanJia'">
													<h3 class="text-center">砍价 <!-- <span class="imageSize-tips">(建议上传图片尺寸：360x190)</span> --></h3>
													<button @click="selectGood('bargain')" class="btn btn-default" type="button">选择砍价项目</button>
													<a class="navToEdit" href="?_a=bargain&_u=sp" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑砍价商品</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgSmall">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																			名称
																</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="mendian zjbox" v-show="editedNode && editedNode.component == 'menDian'">
													<h3 class="text-center">门店地址 <span class="imageSize-tips">(建议上传图片尺寸：80x80)</span></h3>
													<ul class="clearfix" v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix">
															<div class="fl demoimg" @click="selectImg(-1)">
																<img :src="editedNode.nodedata.imgUrl" />
															</div>
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">
																			门店名称
																</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.title">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			营业时间
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.time">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			门店地址
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.address">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			联系电话
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.phone">
																</div>
																<!-- cctodo -->
																<div class="clearfix group-seft">
																	<div class="input-group">
																		<span class="input-group-addon">
																				纬度
																			</span>
																		<input type="text" class="form-control" v-model="editedNode.nodedata.lng">
																	</div>
																	<div class="input-group">
																		<span class="input-group-addon">
																				经度
																			</span>
																		<input type="text" class="form-control" v-model="editedNode.nodedata.lat">
																	</div>
																</div>
																<div class="btn-seft text-right">
																	<a href="http://lbs.qq.com/tool/getpoint/" target="_blank" class="btn btn-default" role="button" type="button">
																		坐标拾取器
																	</a>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="anniu zjbox" v-show="editedNode && editedNode.component == 'anNiu'">
													<h3 class="text-center">按钮组合 <span class="imageSize-tips">(建议上传图片尺寸：60x60)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg" @click="selectImg(idx)">
																<img :src="item.imgUrl" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																	名称
																</span>
																	<input type="text" class="form-control" v-model="item.title">
																</div>
																<!-- cctodo -->
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default" type="button">
																		删除
																	</button>
																</div>
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(idx)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input type="text" class="form-control" v-model="item.link" />
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="huodong zjbox" v-show="editedNode && editedNode.component == 'huoDong'">
													<h3 class="text-center">活动 <!-- <span class="imageSize-tips">(建议上传图片尺寸：360x190)</span> --></h3>
													<button @click="selectGood('exercise')" class="btn btn-default" type="button">选择活动项目</button>
													<a class="navToEdit" href="?_easy=form.sp.index&type=activity" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑活动</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgSmall">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																	名称
																</span>
																	<input type="text" class="form-control" :value="item.title" disabled>
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<!--营销组件结束-->

											<transition :name="transitionname">
												<div class="huadong zjbox" v-show="editedNode && editedNode.component == 'shiPin'">
													<h3 class="text-center">视频</h3>
													<div  v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
													<div class="box-right">
														<div class="input-group">
															<span class="input-group-btn">
															<button class="btn btn-default" type="button">
																填写视频链接
															</button>
														</span>
															<input type="text" class="form-control" v-model="editedNode.nodedata.vedioUrl">
														</div>
													</div>
												</div>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="fztw zjbox" v-show="editedNode && editedNode.component == 'fuZa'">
													<h3 class="text-center">复杂图文<span class="imageSize-tips"> (建议上传图片尺寸：200x200)</span></h3>
													<ul class="clearfix" v-if="editedNode">
														<div  v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix">
															<div class="fl demoimg">
																<a @click="selectImg(-1)">
																	<img :src="editedNode.nodedata.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-addon">
																			主标题
																</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.title1">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			副标题
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.title2">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			内容
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.keyword1">
																</div>
																<div class="input-group">
																	<span class="input-group-addon">
																			按钮名称
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.button">
																</div>
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(-1)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.link">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="duohang zjbox" v-show="editedNode && editedNode.component == 'duoHang'">
													<h3 class="text-center">多图文<span class="imageSize-tips"> (建议上传图片尺寸：375x300)</span></h3>
													<button @click="addItem" class="btn btn-default" type="button">
															添加
														</button>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg" >
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right mt0">
																<div class="input-group mt0">
																	<span class="input-group-addon">
																	标题
																</span>
																	<input type="text" class="form-control" v-model="item.title">
																</div>
																<!-- cctodo -->
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default" type="button">
																	删除
																</button>
																</div>
																<div class="input-group">
																	<span class="input-group-btn">
																	<button class="btn btn-default" type="button"  @click="selectPath(idx)">
																		选择链接
																	</button>
																</span>
																	<!-- cctodo -->
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="danhang zjbox" v-show="editedNode && editedNode.component == 'danHang'">
													<h3 class="text-center">单行图文<span class="imageSize-tips"> (建议上传图片尺寸：160x160)</span></h3>
													<ul class="clearfix" v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix">
															<div class="fl demoimg">
																<a @click="selectImg(-1)">
																	<img :src="editedNode.nodedata.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-addon">
																			标题
																		</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.title">
																</div>
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(-1)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input type="text" class="form-control" v-model="editedNode.nodedata.link">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<!-- cctodo -->
											<transition :name="transitionname">
												<div class="xinwen zjbox" v-show="editedNode && editedNode.component == 'xinWen'">
													<h3 class="text-center">新闻<!-- <span class="imageSize-tips"> (建议上传图片尺寸：100x100)</span> --></h3>
													<button @click="selectGood('news')" class="btn btn-default" type="button">选择新闻</button>
													<a class="navToEdit" href="?_easy=site.sp.articlelist" target="_blank">
														<button class="btn btn-default" type="button">添加/编辑新闻</button>
													</a>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<img :src="item.main_img" />
															</div>
															<div class="box-right mt0">
																<div class="input-group">
																	<span class="input-group-addon">
																			名称
																</span>
																	<input v-if="editedNode" type="text" class="form-control" :value="item.title">
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="sousuo" v-show="editedNode && editedNode.component == 'souSuo'">
													<h3 class="text-center">搜索</h3>
													<div  v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
													<div class="input-group">
														<span class="input-group-addon">
														标题
													</span>
														<input v-model="editedNode.nodedata.title" type="text" class="form-control">
													</div>
												</div>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="biaoti" v-show="editedNode && editedNode.component == 'biaoTi'">
													<h3 class="text-center">模块标题</h3>
													<div  v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<div class="style-set" v-if="editedNode.nodedata.moduleStyle">
																<ul class="clearfix">
																	<li class="fl">
																		<input class="style-set-input" type="" v-model="editedNode.nodedata.moduleStyle.fontSize">
																	</li>
																	<li class="fr">
																		<input type="range" min="12" max="30" v-model="editedNode.nodedata.moduleStyle.fontSize">
																	</li>
																</ul>
																<ul class="clearfix mb10">
																	<li class="fl">
																		<span>字体颜色：</span>
																		<input type="color" v-model="editedNode.nodedata.moduleStyle.textColor">
																	</li>
																	<li class="fr">
																		<span>背景颜色：</span>
																		<input type="color" v-model="editedNode.nodedata.moduleStyle.bgColor">
																	</li>
																</ul>
														</div>
													<div class="input-group">
														<span class="input-group-addon">
														标题
													</span>
														<input v-model="editedNode.nodedata.title" type="text" class="form-control">
													</div>
													</div>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="huadong zjbox" v-show="editedNode && editedNode.component == 'huaDong'">
													<h3 class="text-center">相册滑动<span class="imageSize-tips"> (建议上传图片尺寸：360x200)</span></h3>
													<button @click="addItem" class="btn btn-default" type="button">
													添加
												</button>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg" >
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
																<!-- cctodo -->
																<div class="btn-seft text-right"><button @click="deleteItem(idx)" class="btn btn-default" type="button">
																删除
															</button></div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="jiutu zjbox" v-show="editedNode && editedNode.component == 'jiuTu'">
													<h3 class="text-center">9幅图片<span class="imageSize-tips"> (建议上传图片尺寸：250x200)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgNormal">
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(idx)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="situ zjbox" v-show="editedNode && editedNode.component == 'siTu'">
													<h3 class="text-center">4幅图片<span class="imageSize-tips"> (建议上传图片尺寸：375x300)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg demoimgNormal">
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(idx)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="duotu zjbox" v-show="editedNode && editedNode.component == 'duoTu'">
													<h3 class="text-center">多图片广告<span class="imageSize-tips"> (建议上传图片尺寸：500x260,250x130)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg" >
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="santu zjbox" v-show="editedNode && editedNode.component == 'sanTu'">
													<h3 class="text-center">自由图三<span class="imageSize-tips"> (建议上传图片尺寸：宽度为250,高度自由)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="ertu zjbox" v-show="editedNode && editedNode.component == 'erTu'">
													<h3 class="text-center">自由图二<span class="imageSize-tips"> (建议上传图片尺寸：宽度为375，高度自由)</span></h3>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(item, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<a @click="selectImg(idx)">
																	<img :src="item.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="item.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="yitu zjbox" v-show="editedNode && editedNode.component == 'yiTuPreview'">
													<h3 class="text-center">预览图片<span class="imageSize-tips"> (建议上传图片尺寸：宽度为750，高度自由)</span></h3>
													<ul class="clearfix">
														<li class="clearfix" v-if="editedNode">
															<div class="checkbox-group">
																<input type="checkbox" v-model="editedNode.nodedata.checkeda">
																<label for="checkbox">模块间距</label>
															</div>
															<div class="fl demoimg demoimgBig">
																<a @click="selectImg(-1)">
																	<img :src="editedNode.nodedata.imgUrl" />
																</a>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="yitu zjbox" v-show="editedNode && editedNode.component == 'yiTu'">
													<h3 class="text-center">自由图一<span class="imageSize-tips"> (建议上传图片尺寸：宽度为750，高度自由)</span></h3>
													<ul class="clearfix">
														<li class="clearfix" v-if="editedNode">
															<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
															<div class="fl demoimg demoimgBig">
																<a @click="selectImg(-1)">
																	<img :src="editedNode.nodedata.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																		<button @click="selectPath(-1)" class="btn btn-default" type="button">
																			选择链接
																		</button>
																	</span>
																	<input v-model="editedNode.nodedata.link" type="text" class="form-control">
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="tubiao zjbox" v-show="editedNode && editedNode.component == 'tuBiao'">
													<h3 class="text-center">
														图标分类
														<span class="imageSize-tips"> (建议上传图片尺寸：100x100)</span>
													</h3>
													<button @click="addItem" class="btn btn-default" type="button">
													添加
												</button>
													<ul class="clearfix" v-if="editedNode && editedNode.nodedata.list">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(i, idx) in editedNode.nodedata.list">
															<div class="fl demoimg">
																<a @click="selectImg(idx)">
																	<img :src="i.imgUrl" />
																</a>
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-addon">
																	标题
																</span>
																	<input v-model="i.title" type="text" class="form-control">
																</div>
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="i.link" type="text" class="form-control">
																</div>
																<div class="btn-seft text-right">
																	<button @click="deleteItem(idx)" class="btn btn-default sub" type="button">
																	删除
																</button>
																</div>
															</div>
														</li>
													</ul>
												</div>
											</transition>

											<transition :name="transitionname">
												<div class="lunbo zjbox" v-show="editedNode && editedNode.component == 'lunBo'">
													<h3 class="text-center">轮播图<span class="imageSize-tips"> (建议上传图片尺寸：750x300)</span></h3>
													<button @click="addItem" class="btn btn-default" type="button">
													添加
												</button>
													<ul class="clearfix" v-if="editedNode">
														<div class="checkbox-group">
															<input type="checkbox" v-model="editedNode.nodedata.checkeda">
															<label for="checkbox">模块间距</label>
														</div>
														<li class="clearfix" v-for="(img, idx) in editedNode.nodedata.list">
															<div @click="selectImg(idx)" class="fl demoimg demoimgBig">
																<img :src="img.imgUrl" />
															</div>
															<div class="box-right">
																<div class="input-group">
																	<span class="input-group-btn">
																	<button @click="selectPath(idx)" class="btn btn-default" type="button">
																		选择链接
																	</button>
																</span>
																	<input v-model="img.link" type="text" class="form-control">
																</div>
																<div class="text-right"><button @click="deleteItem(idx)" class="btn-seft btn btn-default" type="button">
																删除
															</button></div>
															</div>
														</li>
													</ul>
												</div>
											</transition>
										</div>

										<!--组件设置结束-->


										<!--new aad-->
										<!--底部菜单开始-->
										<div class="tab-pane fade in" id="panel-213">
											<div class="text-center">
												<p >(如修改底部菜单，需保存后重新提交代码审核)</p>
												<a href="?_easy=sp.index.xiaochengxu" class="text-primary">点击跳转代码审核!</a>
											</div>
											<div class="text-color">
												<h3 class="title">
													底部菜单开启/关闭
												</h3>
												<div class="checkbox-group">
													<input type="checkbox" v-model="basicInfo.isxcxtab">
													<label for="checkbox">开启/关闭</label>
												</div>
											</div>
											<div class="text-color">
												<h3 class="title">
													字体颜色
												</h3>
												<ul class="clearfix">
													<li class="fl">
														<span>默认字体颜色：</span>
														<input type="color" name="textcolor" :value="xcxtab.color" @change="inputcolor" />
													</li>
													<li class="fr">
														<span>字体选中颜色：</span>
														<input type="color" name="selectedcolor" :value="xcxtab.selectedColor" @change="inputcolor" />
													</li>
												</ul>
											</div>
											<div class="other-set">
												<h3 class="title">
													其他设置
												</h3>
												<div class="zjbox">
													<button @click="addset" class="btn btn-default" type="button">
														添加
													</button>
													<!--  增加  使用默认设置   按钮  CSP-->
													<button @click="addMoRen" class="btn btn-default" type="button">
														使用默认设置
													</button>
													<transition-group name="list-add" tag="ul">
														<li class="list-add-item clearfix" v-for="(item, idx) in xcxtab.list" v-bind:key="item">
															<div class="input-group">
																<span class="input-group-addon">
																	标题
																</span>
																<input type="text" class="form-control" v-model="item.text">
															</div>
															<div class="input-group">
																<span class="input-group-btn">
																	<button class="btn btn-default" type="button"  @click="selectPath(idx, 'tab')">
																		选择跳转链接
																	</button>
																</span>
																<input v-model="item.pagePath" disabled="disabled" type="text" class="form-control">
															</div>
															<ul class="clearfix set-img">
																<li class="fl">
																	<span>默认图片</span>
																	<img class="tabbar-img" :src="item.iconPath" @click="selectImg(idx, 'tabDefault')" />
																</li>
																<li class="fr text-right">
																	<span>选中图片</span>
																	<img class="tabbar-img" :src="item.selectedIconPath" @click="selectImg(idx, 'tabSelected')" />
																</li>
															</ul>
															<div class="text-right">
																<button @click="deleteset(idx)" class="btn btn-default" type="button">
																	删除
																</button>
															</div>
														</li>

													</transition-group>
												</div>
											</div>
										</div>
										<!--底部菜单结束-->

										<!--模版中心开始-->
										<div class="tab-pane fade" id="panel-215">
											<div class="tabbable" id="tabs-924902">
												<ul class="nav nav-tabs temp-tab">
													<li class="active">
														<a href="#panel-72361" data-toggle="tab">模版中心</a>
														<div class="underline"></div>
													</li>
													<li>
														<a href="#panel-356293" data-toggle="tab">我的模版</a>
														<div class="underline"></div>
													</li>
												</ul>
												<div class="tab-content">
													<!--模版中心模版中心开始-->
													<div class="tab-pane fade in active" id="panel-72361">
														<div class="template-body">
															<div class="template-btns">
																<a class="btn" href="#">全部风格</a>
																<a class="btn" href="#">婚纱摄影</a>
																<a class="btn" href="#">电商</a>
																<a class="btn" href="#">门店</a>
																<a class="btn" href="#">美容</a>
																<a class="btn" href="#">拼团</a>
																<a class="btn" href="#">培训</a>
																<a class="btn" href="#">装修</a>
																<a class="btn" href="#">汽车</a>
																<a class="btn" href="#">砍价</a>
																<a class="btn" href="#">外卖</a>
																<a class="btn" href="#">KTV</a>
																<a class="btn" href="#">展示</a>
																<a class="btn" href="#">更多</a>
															</div>
															<ul class="clearfix">
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
															</ul>
															<div class="pagebar">
																<a>上一页</a>
																<span>1/4</span>
																<a>下一页</a>
															</div>

														</div>
													</div>
													<!--模版中心模版中心结束-->
													<!--模版中心我的模版开始-->
													<div class="tab-pane fade" id="panel-356293">
														<div class="template-body">
															<ul class="clearfix">
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
																<li>
																	<div class="image">
																		<img src="/app/shop/static/modules/images/tabbg.png">
																	</div>
																	<div class="name">拼好货小程序</div>
																	<div class="price"> <span>价格:</span>
																		<span class="money">0币</span></div>
																	<div class="action">
																		<a>预览</a>
																		<a>使用</a>
																	</div>
																</li>
															</ul>
															<div class="pagebar">
																<a>上一页</a>
																<span>1/4</span>
																<a>下一页</a>
															</div>
														</div>
													</div>
													<!--模版中心我的模版结束-->
												</div>
											</div>
										</div>
										<!--模版中心结束-->
									</div>
								</div>
							</div>
						</div>
						<!--右侧属性导航栏结束-->
					</div>
					<!--主功能区页面结束-->
				</div>
			</div>
			<!--模态框开始-->
			<!-- 图片选择模态框开始（Modal） -->
			<div v-show="modalimg.show" :transition="transition">
				<div class="modal imgModal" @click.self="clickMask('modalimg')">
					<div class="modal-dialog" :class="modalClass" v-el:dialog>
						<div class="modal-content">
							<div class="modal-header">
								<div name="header">
									<a type="button" class="close" @click="cancel('modalimg')">x</a>
									<h4 class="modal-title">
									  	<div name="title">
										{{modalimg.title}}
									  	</div>
								  	</h4>
								</div>
							</div>
							<div class="modal-body">
								<div class="madal-btn-group text-right">
									<!-- <input type="search" placeholder="搜索图片" class="form-control" /> -->
									<a href="?_a=sp&_u=index.imgmanage" target="_blank">
										<button type="button" class="btn btn-default">图片整理</button>
									</a>
									<button type="button" class="btn btn-default" @click="showmodal('modalimgweb')" v-if="modalimg.selectType === 'node'">网络图片</button>
									<button type="button" class="btn btn-default" v-if="modalimg.selectType === 'node'">上传图片</button>
									<input type="file" @change="uploadImg" value="" v-if="modalimg.selectType === 'node'" class="fileinput" multiple />
								</div>
								<p class="empty-tips" v-if="modalimg.imglist.length === 0">还没有图片，去上传几张吧</p>
								<ul class="clearfix scrollbar-style" id="imglist">
									<li v-for="(item,index) in modalimg.imglist" @click="selectpic(index)"><img :src="item.url" /><span :class="item.isImgselect ? imgselect : ''"></span>
										<p class="title text-center ellipsis">{{item.title}}</p>
									</li>
								</ul>
							</div>
							<div class="modal-footer">
								<div name="footer" class="text-right">
									<button type="button" :class="okClass" @click="ok('modalimg')">{{okText}}</button>
									<button type="button" :class="cancelClass" @click="cancel('modalimg')">{{cancelText}}</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-backdrop in"></div>
			</div>
			<!-- 图片选择模态框结束（Modal） -->

			<!--网络图片选择开始-->
			<div v-show="modalimgweb.show" :transition="transition">
				<div class="modal modalimgweb" @click.self="clickMask('modalimgweb')">
					<div class="modal-dialog" :class="modalClass" v-el:dialog>
						<div class="modal-content">
							<div class="modal-header">
								<div name="header">
									<a type="button" class="close" @click="cancel('modalimgweb')">x</a>
									<h4 class="modal-title">
                      <div name="title">
                        {{modalimgweb.title}}
                      </div>
                  </h4>
								</div>
							</div>
							<div class="modal-body">
								<div class="input-group">
									<span class="input-group-addon">地址：</span>
									<input type="text" class="form-control" v-model="modalimgweb.imgUrl" />
								</div>
								<div class="web-thumbnail">
									<img :src="modalimgweb.imgUrl" />
								</div>
							</div>
							<div class="modal-footer">
								<div name="footer" class="text-right">
									<button type="button" :class="modalimgweb.backClass" @click="goback">返回</button>
									<button type="button" :class="okClass" @click="ok('modalimgweb')">{{okText}}</button>
									<!-- <button type="button" :class="cancelClass" @click="cancel('modalimgweb')">{{cancelText}}</button> -->
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-backdrop in"></div>
			</div>
			<!--网络图片选择结束-->

			<!--选择链接开始-->
			<div v-show="modallink.show" :transition="transition">
				<div class="modal modallink" @click.self="clickMask('modallink')">
					<div class="modal-dialog" :class="modalClass" v-el:dialog>
						<div class="modal-content">
							<div class="modal-header">
								<div name="header">
									<a type="button" class="close" @click="cancel('modallink')">x</a>
									<h4 class="modal-title">
            					<div name="title">
              					{{modallink.title}}
            					</div>
        					</h4>
								</div>
							</div>
							<!-- cctodo -->
							<div class="modal-body scrollbar-style">
								<div v-for="(item,index) in modallink.linklist" @click="selectlink(index)">
									<div class="input-group">
										<span class="input-group-btn">
                        <button class="btn btn-default link-default link-name" :class="{linkactive:item.isActive}" type="button">
                        	{{item.name}}
                        </button>
                    </span>
										<input type="text" class="form-control" v-model="item.link" />
									</div>
									<p class="help-tips" v-text="item.tips"></p>
								</div>
							</div>
							<div class="modal-footer">
								<div name="footer" class="text-right">
									<button type="button" :class="okClass" @click="ok('modallink')">{{okText}}</button>
									<button type="button" :class="cancelClass" @click="cancel('modallink')">{{cancelText}}</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-backdrop in"></div>
			</div>
			<!--选择链接结束-->

			<!--选择产品开始-->
			<div v-show="modalproduct.show" :transition="transition">
				<div class="modal modalproduct" @click.self="clickMask('modalproduct')">
					<div class="modal-dialog" :class="modalClass" v-el:dialog>
						<div class="modal-content">
							<div class="modal-header">
								<div name="header">
									<a type="button" class="close" @click="cancel('modalproduct')">x</a>
									<h4 class="modal-title">
                      <div name="title">
                        {{modalproduct.title}}
                      </div>
                  </h4>
								</div>
							</div>
							<div class="modal-body">
								<p class="empty-tips" v-if="modalproduct.productlist.length === 0">还没有相关项目，去添加几个吧</p>
								<div v-else>
									<input type="search" class="form-control" placeholder="产品搜索">
									<ul class="clearfix scrollbar-style">
										<li v-for="(item, index) in modalproduct.productlist" @click="selectproduct(index)"><img :src="item.main_img" /><span :class="item.isProductselect ? productselect : ''"></span>
											<div class="title ellipsis">
												{{item.title}}
											</div>
										</li>
									</ul>
								</div>
							</div>
							<div class="modal-footer">
								<div name="footer" class="text-right">
									<button type="button" :class="okClass" @click="ok('modalproduct')">{{okText}}</button>
									<button type="button" :class="cancelClass" @click="cancel('modalproduct')">{{cancelText}}</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-backdrop in"></div>
			</div>
			<!--选择产品结束-->

			<!--模态框结束-->

		</div>

		<!-- 功能插件 -->
		<script type="text/x-template" id="lunBo">
			<div :class="{ modulegap:nodedata.checkeda, 'xcx_banner': true }">
				<swiper :options="nodedata.swiperOptionA">
					<!-- slides -->
					<swiper-slide v-for="item in nodedata.list">
						<img :src="item.imgUrl">
					</swiper-slide>
					<!-- Optional controls -->
					<div class="swiper-pagination" slot="pagination"></div>
				</swiper>
			</div>
		</script>
		<script type="text/x-template" id="tuBiao">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_tubiao': true }">
					<ul class="clearfix flex">
						<li class="sub" v-for="item in nodedata.list">
							<img :src="item.imgUrl" /><span>{{item.title}}</span>
						</li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="yiTuPreview">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_image': true }">
					<li>
						<img :src="nodedata.imgUrl" />
					</li>
				</div>
		</script>

		<script type="text/x-template" id="yiTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_image': true }">
					<li>
						<img :src="nodedata.imgUrl" />
					</li>
				</div>
		</script>
		<script type="text/x-template" id="erTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_imagetwo': true }">
					<ul class="clearfix ">
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="sanTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_imagethree': true }">
					<ul class="clearfix ">
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="duoTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_imagelist': true }">
					<ul class="clearfix ">
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="siTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_photo4': true }">
					<ul class="clearfix">
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="jiuTu">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_photo9': true }">
					<ul class="clearfix">
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="huaDong">
			<div :class="{ modulegap:nodedata.checkeda, 'swiper': true }">
				<swiper :options="nodedata.swiperOptionB">
					<swiper-slide v-for="item in nodedata.list">
						<img :src="item.imgUrl" />
					</swiper-slide>
				</swiper>
			</div>
		</script>
		<script type="text/x-template" id="biaoTi">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_title': true}" :style="{ color: nodedata.moduleStyle.textColor, fontSize: nodedata.moduleStyle.fontSize + 'px',backgroundColor: nodedata.moduleStyle.bgColor }">
					<div class="title2">{{nodedata.title}}</div>
				</div>
		</script>
		<script type="text/x-template" id="souSuo">
			<div :class="{ modulegap:nodedata.checkeda, 'xcx_search': true }">
				<div class="search"><span class="glyphicon glyphicon-search"></span>{{nodedata.title}}</div>
			</div>
		</script>
		<script type="text/x-template" id="xinWen">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_news': true ,'bgcolor':true }">
					<div v-if="nodedata.list && nodedata.list.length > 0">
						<div class="news" v-for="item in nodedata.list">
							<div class="lt">
								<div class="title">{{item.title}}</div>
								<div class="intro">{{item.digest}}</div>
								<div class="info"><span>{{(item.cat && item.cat.title) ? item.cat.title : '其它'}}</span><span>{{item.time}}</span></div>
							</div>
							<div class="rt"><img :src="item.main_img" /></div>
						</div>
					</div>
					<div v-else>
						<div class="news">
							<div class="lt">
								<div class="title">新闻标题</div>
								<div class="intro">新闻简介</div>
								<div class="info"><span>财经</span><span>2018-01-21</span></div>
							</div>
							<div class="rt"><img src="/app/shop/static/modules/images/demoimg/100-100.png" /></div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="danHang">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_imagetext': true , 'clearfix': true ,'bgcolor':true }">
					<div class="imagetext-img"><img :src="nodedata.imgUrl" /></div>
					<div class="imagetext-title ellipsis">{{nodedata.title}}</div>
					<div class="glyphicon glyphicon glyphicon-chevron-right imagetext-icon"></div>
				</div>
		</script>
		<script type="text/x-template" id="duoHang">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_phototitle': true,'bgcolor': true }">
					<ul>
						<li v-for="item in nodedata.list"><img :src="item.imgUrl" /><span>{{item.title}}</span></li>
					</ul>
				</div>
		</script>
		<script type="text/x-template" id="fuZa">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_fztw': true,'bgcolor': true }">
					<div class="fztw-img"><img :src="nodedata.imgUrl" /></div>
					<div class="fztw-detail">
						<div class="fztw-titleone ellipsis">{{nodedata.title1}}</div>
						<div class="fztw-titletwo ellipsis">{{nodedata.title2}}</div>
						<!-- <div class="fztw-titlethree ellipsis"><span>{{nodedata.keyword1}}</span><span>{{nodedata.text1}}</span></div>
						<div class="fztw-titlefour">
							<div class="ellipsis"><span>{{nodedata.keyword2}}</span><span>{{nodedata.text2}}</span></div>
						</div> -->
						<div class="fztw-titlethree ellipsis"><span>{{nodedata.keyword1}}</span></div>
					</div>
					<div class="fztw-btn">{{nodedata.button}}</div>
				</div>
		</script>
		<script type="text/x-template" id="shiPin">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_video': true }">
					<video :src="nodedata.vedioUrl" autoplay="autoplay" loop="loop"></video>
				</div>
		</script>

		<!-- 营销组件 -->
		<!-- cctodo -->
		<script type="text/x-template" id="huoDong">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_activity': true }">
					<div v-if="nodedata.list && nodedata.list.length > 0">
						<div class="activity" v-for="item in nodedata.list">
							<img :src="item.main_img" />
							<div class="name">{{item.title}}</div>
							<div class="title">
								<span class="hui ellipsis">￥{{item.price}}元</span><span class="date ellipsis">2000/01/01-深圳站</span>
							</div>
						</div>
					</div>
					<div v-else>
						<div class="activity">
							<img src="/app/shop/static/modules/images/demoimg/250-130.png" />
							<div class="name">活动时间：2018-01-18 至 2018-01-31</div>
							<div class="title">
								<span class="hui ellipsis">￥2000.00元</span><span class="date ellipsis">2018/01/18-深圳站</span>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="anNiu">
			<div :class="{ modulegap:nodedata.checkeda, 'xcx_button': true, 'bgcolor': true}">
				<ul class="clearfix">
					<li v-for="item in nodedata.list"><img :src="item.imgUrl" /><span class="ellipsis">{{item.title}}</span></li>
					<!-- <li><img src="/app/shop/static/modules/images/demoimg/100-100.png" /><span class="ellipsis">title</span></li> -->
				</ul>
			</div>
		</div>
		</script>
		<script type="text/x-template" id="menDian">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_mendian': true ,'bgcolor': true}">
					<div class="mendian">
						<div class="lt">
							<!-- <div class="iconfont  icon-shangcheng"></div> -->
							<img class="mendian-img" :src="nodedata.imgUrl">
						</div>
						<div class="rt">
							<div class="name">{{nodedata.title}}</div>
							<div class="time">营业时间:<span>{{nodedata.time}}</span></div>
						</div>
					</div>
					<div class="addr">
						<div class="lt"><img class="location-icon" src="/app/shop/static/modules/images/location.png"></img><span class="address ellipsis">{{nodedata.address}}</span></div>
						<div class="ct">|</div>
						<div class="rt"><img class="phone-icon" src="/app/shop/static/modules/images/phoneCall.png"></img>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="kanJia">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_kanjia': true }">
					<div v-if="nodedata.list && nodedata.list.length > 0">
						<div class="kanjia" v-for="item in nodedata.list">
							<div class="photo">
								<img :src="item.main_img" />
								<div class="bottom">
									<div class="lt"><span>最低砍价：¥ </span><span style="margin-right: 15rpx;font-size:36rpx;">{{item.price}}</span><span style="text-decoration:line-through">¥{{item.ori_price}}</span></div>
									<div class="rt">立即开砍</div>
								</div>
							</div>
							<!-- cctodo -->
							<div class="info">
								<div class="title">{{item.title}}</div>
								<div class="binfo">
									<p>仅剩<span>318天 08小时 08分钟 08秒</span></p>
								</div>
							</div>
						</div>
					</div>
					<div v-else>
						<div class="kanjia">
							<div class="photo"><img src="/app/shop/static/modules/images/demoimg/250-130.png" />
								<div class="bottom">
									<div class="lt"><span>最低砍价：¥ </span><span style="margin-right: 15rpx;font-size:36rpx;">35</span><span style="text-decoration:line-through">¥85</span></div>
									<div class="rt">立即开砍</div>
								</div>
							</div>
							<!-- cctodo -->
							<div class="info">
								<div class="title">微信小程序</div>
								<div class="binfo">
									<p>仅剩<span>318天 08小时 08分钟 08秒</span></p>
								</div>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="miaoSha">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_miaosha': true }">
					<div v-if="nodedata.list && nodedata.list.length > 0">
						<div class="miaosha" v-for="item in nodedata.list">
							<div class="photo">
								<img :src="item.main_img" />
								<!-- <div class="join_num">{{item.group_cnt}}人参团</div> -->
							</div>
							<div class="bview">
								<div class="name ellipsis">{{item.title}}</div>
								<div class="info">
									<div class="price">
										<div class="cost">¥{{item.price}}</div>
										<div class="discount">¥{{item.ori_price}}</div>
									</div>
									<div class="btns">
										<div class="num">秒杀时间{{item.group_cnt}}</div>
										<div class="pt">立即秒杀</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div v-else>
						<div class="miaosha">
							<div class="photo"><img src="/app/shop/static/modules/images/demoimg/250-130.png" />
								<!-- <div class="join_num">10人已经参团</div> -->
							</div>
							<div class="bview">
								<div class="name ellipsis">产品标题</div>
								<div class="info">
									<div class="price">
										<div class="cost">¥80</div>
										<div class="discount">¥100</div>
									</div>
									<div class="btns">
										<div class="num">秒杀时间：14:00</div>
										<div class="pt">立即秒杀</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="pinTuan">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_pintuan': true }">
					<div v-if="nodedata.list && nodedata.list.length > 0">
						<div class="pintuan" v-for="item in nodedata.list">
							<div class="photo">
								<img :src="item.main_img" />
								<!-- <div class="join_num">{{item.group_cnt}}人参团</div> -->
							</div>
							<div class="bview">
								<div class="name ellipsis">{{item.title}}</div>
								<div class="info">
									<div class="price">
										<div class="cost">¥{{item.price}}</div>
										<div class="discount">¥{{item.ori_price}}</div>
									</div>
									<div class="btns">
										<div class="num ellipsis">{{item.group_cnt}}人团</div>
										<div class="pt">去拼团</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div v-else>
						<div class="pintuan">
							<div class="photo"><img src="/app/shop/static/modules/images/demoimg/250-130.png" />
								<!-- <div class="join_num">10人已经参团</div> -->
							</div>
							<div class="bview">
								<div class="name ellipsis">产品标题</div>
								<div class="info">
									<div class="price">
										<div class="cost">¥80</div>
										<div class="discount">¥100</div>
									</div>
									<div class="btns">
										<div class="num ellipsis">20人团</div>
										<div class="pt">去拼团</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="chanPin">
				<div :class="[{'modulegap':nodedata.checkeda}, nodedata.selecteda,'clearfix' ,'bgcolor']">
					<div class="clearfix" v-if="nodedata.list && nodedata.list.length > 0">
						<div class="product" v-for="item in nodedata.list">
							<div class="product-img"><img :src="item.main_img" /></div>
							<div class="name">{{item.title}}</div>
							<div class="info">
								<!-- <div :class="['gouwu',{'ohidden': nodedata.ohidden}]">销量<span>{{item.sell_cnt}}</span></div> -->
								<div class="price">¥{{item.price}}</div>
								<!-- <div class="pay">
									<img src="app/shop/static/modules/images/shopcart.png">
								</div> -->
								<div :class="['sellCnt',{'ohidden': nodedata.ohidden}]">销量<span>{{item.sell_cnt}}</span></div>
							</div>
						</div>
					</div>
					<!-- cctodo -->
					<div class="clearfix" v-else>
						<div class="product">
							<div class="product-img"><img src="/app/shop/static/modules/images/demoimg/750-750.png" /></div>
							<div class="name">产品标题1</div>
							<div class="info">
							    <!-- <div :class="['gouwu' , {'ohidden': nodedata.ohidden}]">销量<span>321</span></div> -->
								<div class="price">¥324.34</div>
								<!-- <div class="pay">
									<img src="app/shop/static/modules/images/shopcart.png">
								</div> -->
								<div :class="['sellCnt' , {'ohidden': nodedata.ohidden}]">销量<span>321</span></div>
							</div>
						</div>
						<div class="product">
							<div class="product-img"><img src="/app/shop/static/modules/images/demoimg/750-750.png" /></div>
							<div class="name">产品标题1</div>
							<div class="info">
							    <!-- <div :class="['gouwu' , {'ohidden': nodedata.ohidden}]">销量<span>321</span></div> -->
								<div class="price">¥324.34</div>
								<!-- <div class="pay">
									<img src="app/shop/static/modules/images/shopcart.png">
								</div> -->
								<div :class="['sellCnt' , {'ohidden': nodedata.ohidden}]">销量<span>321</span></div>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="gongGao">
				<div :class="[{'modulegap':nodedata.checkeda}, 'xcx_gonggao' ,'bgcolor']">
					<div class="gonggao-img">
						<img src="/app/shop/static/modules/images/board.png">
					</div>
					<div class="gonggao-right">
						>
					</div>
					<div class="clearfix" v-if="nodedata.list && nodedata.list.length > 0">
							<swiper :options="nodedata.swiperOptionC">
								<!-- slides -->
								<swiper-slide v-for="item in nodedata.list">
									{{item.txt}}
								</swiper-slide>
							</swiper>
					</div>
					<div class="clearfix" v-else>
						<swiper :options="nodedata.swiperOptionC">
								<swiper-slide>
									公告1
								</swiper-slide>
								<swiper-slide>
									公告2
								</swiper-slide>
							</swiper>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="tuanDui">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_team': true }">
					<div class="clearfix" v-if="nodedata.list && nodedata.list.length > 0">
						<div class="team" v-for="item in nodedata.list">
							<div class="tview">
								<div class="face"><img :src="item.main_img" /></div>
								<div class="lt">
									<div class="name ellipsis">{{item.title}}</div>
									<div class="position">{{item.job}}</div>
								</div>
								<div class="rt">
									<div class="price"><span>¥</span>{{item.price}}</div>
									<div class="discount">预约特惠价格</div>
								</div>
							</div>
							<div class="bview">
								<div class="bv01">
									<div class="tags">
										<div class="tag">{{item.tag1}}</div>
										<div class="tag">{{item.tag2}}</div>
										<div class="tag">{{item.tag3}}</div>
									</div>
									<div class="yuyue">预约TA</div>
								</div>
								<div class="bv02 text-center"><span>好评率：{{item.praiseNum}}</span><span>评论数：{{item.commentNum}}</span><span>已被约：{{item.bookNum}}</span></div>
							</div>
						</div>
					</div>
					<div class="clearfix" v-else>
						<div class="team">
							<div class="tview">
								<div class="face"><img src="/app/shop/static/modules/images/demoimg/100-100.png" /></div>
								<div class="lt">
									<div class="name ellipsis"></div>
									<div class="position">职务</div>
								</div>
								<div class="rt">
									<div class="price"><span>¥</span>0.00</div>
									<div class="discount">预约特惠价格</div>
								</div>
							</div>
							<div class="bview">
								<div class="bv01">
									<div class="tags">
										<div class="tag">标签1</div>
										<div class="tag">标签2</div>
										<div class="tag">标签3</div>
									</div>
									<div class="yuyue">预约TA</div>
								</div>
								<div class="bv02 text-center"><span>好评率：0</span><span>评论数：0</span><span>已被约：0</span></div>
							</div>
						</div>
					</div>
				</div>
		</script>
		<script type="text/x-template" id="yuYue">
				<div :class="{ modulegap:nodedata.checkeda, 'xcx_yuyue': true }">
					<div class="clearfix" v-if="nodedata.list && nodedata.list.length > 0">
						<div class="xcx_public_container" v-for="item in nodedata.list">
							<div class="xcx_public_title">免费预约 - {{item.title}}</div>
							<div class="xcx_public_input"><input placeholder="请输入预约姓名" /><text class="star">*</text></div>
							<div class="xcx_public_input"><input placeholder="请输入预约手机号" /><text class="star">*</text></div>
							<div class="xcx_public_btn"><button class="btn">立即预约</button></div>
						</div>
					</div>
					<div class="clearfix" v-else>
						<div class="xcx_public_container">
							<div class="xcx_public_title">免费预约</div>
							<div class="xcx_public_input"><input placeholder="请输入预约姓名" /><text class="star">*</text></div>
							<div class="xcx_public_input"><input placeholder="请输入预约手机号" /><text class="star">*</text></div>
							<div class="xcx_public_btn"><button class="btn">立即预约</button></div>
						</div>
					</div>
				</div>
		</script>
		<script src="/app/shop/static/modules/js/jquery.min.js " type="text/javascript " charset="utf-8 "></script>
		<script src="/app/shop/static/modules/js/bootstrap.min.js " type="text/javascript " charset="utf-8 "></script>
		<script src="/app/shop/static/modules/js/vue.min.js " type="text/javascript " charset="utf-8 "></script>
		<script src="/app/shop/static/modules/js/vue-dragging.es5.js " type="text/javascript " charset="utf-8 "></script>
		<script src="/app/shop/static/modules/js/swiper.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="/app/shop/static/modules/js/vue-awesome-swiper.js" type="text/javascript" charset="utf-8"></script>
		<script src="/app/shop/static/modules/js/componentData.js" type="text/javascript" charset="utf-8"></script>
		<script src="/app/shop/static/modules/js/visualview.js" type="text/javascript" charset="utf-8"></script>

		<script type="text/javascript">
<?php
	if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
		$public_uid = WeixinMod::get_current_weixin_public('uid');
	}	
?>

var g_public_uid = <?php echo  $public_uid;?>;

<?php
//取最近编辑那个页面
if(isset($_GET['uid'])) {
	$uid = requestInt('uid');
} else {
	$uid = Dba::readOne('select uid from xiaochengxu_pages where sp_uid = '.
			AccountMod::get_current_service_provider('uid').
			' && status = 0 && sort < 999999 order by sort desc limit 1');
	if(!$uid) $uid = 0;
}
?>
			var pageId = <?php echo $uid; ?>;
		</script>
	</body>

</html>