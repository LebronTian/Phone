<!doctype html>
<html data-framework="vue">
<head>
  <meta charset="utf-8">
  <title>可视化编辑</title>
  <!-- <link rel="stylesheet" href="node_modules/todomvc-common/base.css"> -->
  <link rel="stylesheet" href="/app/shop/static/modules/index.css">
  <style> [v-cloak] { display: none; } </style>
</head>
<body>
	<section class="custom-layout">
	  <section class="node-lib">
	    <header class="node-lib__title">组件库</header>
	    <main class="node-type-box">
	      <button v-for="btn in addBtns" class="addNode-btn" :key="btn.id" @click="addNode(btn.id)">{{btn.title}}</button>
	    </main>
	    <footer class="">
	    	<h2 class="preview-qrcode-title">预览二维码</h2>
	    	<h4>保存数据后打开微信扫一扫，即可预览生成页面</h4>
	    	<img class="preview-qrcode" :src="qrcode">
	    </footer>
	  </section>
	  <section class="preview">
	    <img src="/app/shop/static/pic/phone-head.jpg" class="phone-head">
	    <div class="preview-content-box">
	    	<div v-for="(node, index) in nodes"
			    	 v-dragging="{ list: nodes, item: node, group: 'node' }"
	           :key="index"
	    	     :class="[node.edited ? 'node-item__selected' : '']">

		      <div :class="[node.id, 'node-item']"
		           :style="{ width: node.styles.width.value + '%', height: node.styles.height.value == 'auto' ? '' : (node.styles.height.value/2 + 'px'), marginLeft: node.styles.marginLeft.value/2 + 'px', marginTop:node.styles.marginTop.value/2 + 'px', borderRadius: node.styles.borderRadius.value + '%', opacity: node.styles.opacity.value, borderStyle: node.styles.borderStyle.value, borderWidth: node.styles.borderWidth.value/2 + 'px', borderColor: node.styles.borderColor.value, }"
		           @click="editNodeTap(node)">		        
			        <button class="removeBtn" @click.stop="removeNode(node)"></button>
		      </div>
	      </div>

	    </div>
	  </section>
	  <section class="nodeDetail">
	    <div data-am-widget="tabs" class="am-tabs am-tabs-default" style="width: 100%;">
	        <ul class="am-tabs-nav am-cf">
	            <li class="am-active"><a href="[data-tab-panel-0]">组件数据</a></li>
	            <li class=""><a href="[data-tab-panel-1]">组件样式</a></li>
	        </ul>
	        <div class="am-tabs-bd" style="overflow: visible;">
	            <div data-tab-panel-0 class="am-tab-panel am-active">
	              <div class="edit-box" v-if="editedNode && editedNode.settings && editedNode.settings.length > 0">
		              <strong class="am-text-primary am-text-lg style-item-title" style="line-height: 3em;">{{editedNode.title}}</strong>
	                <section class="nodeData-item">
	                  <ul class="nodeData-prop-box">
	                    <li class="nodeData-prop" v-for="setting in editedNode.settings">
	                      <label class="nodeData-title">{{setting.title}}：</label>
	                      <!-- <input id="switch-state" type="checkbox" checked> -->
	                      <!-- <input class="nodeData-cont" v-model="setting.value"> -->
	                      <input v-if="setting.type == 'checkbox'" type="checkbox" v-model="setting.value" :checked="setting.value">
	                      <input v-else-if="setting.type == 'number'" class="number-input" type="number" min="0" v-model="setting.value">
	                      <input v-else-if="setting.type == 'string'" class="nodeData-cont" v-model="setting.value">
	                      <!-- <te v-else-if="setting.type == 'string'" class="nodeData-cont" v-model="setting.value"> -->
                      	<textarea v-else-if="setting.type == 'textarea'" class="nodeData-cont" v-model="setting.value"></textarea>
	                    </li>
	                  </ul>
	                </section>
	              </div>
	              <div class="edit-box" v-if="editedNode && editedNode.list && editedNode.list.length > 0">
	                <section class="nodeData-item" v-for="nodeData in editedNode.list">
	                  <ul class="nodeData-prop-box">
	                    <li v-for="prop in nodeData" class="nodeData-prop">
	                      <label class="nodeData-title">{{prop.title}}：</label>
	                      <input class="nodeData-cont" v-model="prop.data">
	                    </li>
	                  </ul>
	                  <button class="removeBtn removeDataBtn" @click="removeNodeData(nodeData)"></button>
	                </section>
	                <footer class="" v-if="editedNode.item && editedNode.item.length > 0">
	                  <button class="addNodeData" @click="addNodeData">添加{{editedNode.title}}数据</button>
	                </footer>
	              </div>
	              <div class="emptyData" v-else>
	                无数据
	              </div>
	            </div>
	            <div data-tab-panel-1 class="am-tab-panel ">
	              <!-- <input type="" name=""> -->
	              <div class="edit-box" v-if="editedNode && editedNode.styles">
		              <section class="style-item">
		              	<strong class="am-text-primary am-text-lg style-item-title">尺寸</strong>
		              	<!-- <main> -->
		              		<label class="style-subtitle">宽度(%):</label>
			                <input class="number-input" type="number" min="0" v-model="editedNode.styles.width.value">
			                <label class="style-subtitle" v-show="editedNode.styles.height.value !== 'auto'">高度:</label>
			                <input class="number-input" type="number" min="0"  v-show="editedNode.styles.height.value !== 'auto'" v-model="editedNode.styles.height.value">
		              	<!-- </main> -->
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.itemWidth || !!editedNode.styles.itemHeight">
		              	<strong class="am-text-primary am-text-lg style-item-title">导航项尺寸</strong>
		              		<label class="style-subtitle">宽度:</label>
			                <input class="number-input" type="number" min="0" v-model="editedNode.styles.itemWidth.value">
			                <label class="style-subtitle">高度:</label>
			                <input class="number-input" type="number" min="0" v-model="editedNode.styles.itemHeight.value">
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.itemMarginTop">
		              	<strong class="am-text-primary am-text-lg style-item-title">导航项边距</strong>
		                <!-- <label class="style-subtitle">左边距:</label> -->
		                <!-- <input class="number-input" type="number" v-model="editedNode.styles.marginLeft.value"> -->
		                <label class="style-subtitle">上边距:</label>
		                <input class="number-input" type="number" v-model="editedNode.styles.itemMarginTop.value">
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.itemFontSize || !!editedNode.styles.itemColor">
		              	<strong class="am-text-primary am-text-lg style-item-title">导航项文字</strong>
	              		<label class="style-subtitle">文字颜色:</label>
		                <input class="number-input" type="color" v-model="editedNode.styles.itemColor.value">
		                <label class="style-subtitle">文字大小:</label>
		                <input class="number-input" type="number" min="0" v-model="editedNode.styles.itemFontSize.value">
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.imgWidth || !!editedNode.styles.imgHeight">
		              	<strong class="am-text-primary am-text-lg style-item-title">导航图片尺寸</strong>
		              		<label class="style-subtitle">宽度:</label>
			                <input class="number-input" type="number" min="0" v-model="editedNode.styles.imgWidth.value">
			                <label class="style-subtitle">高度:</label>
			                <input class="number-input" type="number" min="0" v-model="editedNode.styles.imgHeight.value">
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.color || !!editedNode.styles.fontSize">
		                <strong class="am-text-primary am-text-lg style-item-title">文字</strong>
		                <label class="style-subtitle">文字颜色:</label>
		                <input class="number-input" type="color" v-model="editedNode.styles.color.value">
		                <label class="style-subtitle">文字大小:</label>
		                <input class="number-input" type="number" min="0" v-model="editedNode.styles.fontSize.value">
		              </section>
		              <section class="style-item" v-if="!!editedNode.styles.textIndent || !!editedNode.styles.textAlign">
										<strong class="am-text-primary am-text-lg style-item-title">文字排版</strong>
			              <label class="style-subtitle">文字缩进:</label>
		                <input class="number-input" type="number" v-model="editedNode.styles.textIndent.value">
		                <label class="style-subtitle">文字对齐方式:</label>
		                <select data-am-selected="{btnWidth: '6em', btnSize: 'sm', btnStyle: 'secondary'}" v-model="editedNode.styles.textAlign.value">
										  <option value="left" :selected="editedNode.styles.textAlign.value == 'left'">左对齐</option>
										  <option value="center" :selected="editedNode.styles.textAlign.value == 'center'">居中</option>
										  <option value="right" :selected="editedNode.styles.textAlign.value == 'right'">右对齐</option>
										</select>
									</section>
		              <section class="style-item" v-if="!!editedNode.styles.backgroundColor">
		                <strong class="am-text-primary am-text-lg style-item-title">背景颜色</strong>
		                <input class="number-input" type="color" v-model="editedNode.styles.backgroundColor.value">
		              </section>
		              <section class="style-item">
		                <strong class="am-text-primary am-text-lg style-item-title">边距</strong>
		                <label class="style-subtitle">左边距:</label>
		                <input class="number-input" type="number" v-model="editedNode.styles.marginLeft.value">
		                <label class="style-subtitle">上边距:</label>
		                <input class="number-input" type="number" v-model="editedNode.styles.marginTop.value">
		              </section>
		              <section class="style-item">
		                <strong class="am-text-primary am-text-lg style-item-title">圆角</strong>
		                <!-- <label></label> -->
		                <input class="number-input" type="number" max="50" min="0" v-model="editedNode.styles.borderRadius.value" style="margin-right: 5px;">%
		              </section>
		              <section class="style-item">
		                <strong class="am-text-primary am-text-lg style-item-title">透明度</strong>
		                <!-- <label></label> -->
		                <input class="number-input" type="number" max="1" min="0" v-model="editedNode.styles.opacity.value" step="0.1">
		              </section>
		              <section class="style-item style-border-box">
		                <strong class="am-text-primary am-text-lg style-item-title">边框</strong>
		                <main>
		                	<section class="border-style-item">
		                		<label class="style-subtitle">边框样式:</label>
				                <select data-am-selected="{btnWidth: '6em', btnSize: 'sm', btnStyle: 'secondary'}" v-model="editedNode.styles.borderStyle.value">
												  <option value="none" :selected="editedNode.styles.borderStyle.value == 'none'">无边框</option>
												  <option value="solid" :selected="editedNode.styles.borderStyle.value == 'solid'">实线</option>
												  <option value="dashed" :selected="editedNode.styles.borderStyle.value == 'dashed'">虚线</option>
												  <option value="dotted" :selected="editedNode.styles.borderStyle.value == 'dotted'">点状</option>
												  <option value="double" :selected="editedNode.styles.borderStyle.value == 'double'">双线</option>
												</select>
		                	</section>
		                	<section class="border-style-item">
		                		<label class="style-subtitle">边框宽度:</label>
				                <input class="number-input" type="number" min="0" v-model="editedNode.styles.borderWidth.value">
		                	</section>
			                <section class="border-style-item">
			                	<label class="style-subtitle">边框颜色:</label>
				                <input class="number-input" type="color" v-model="editedNode.styles.borderColor.value">
			                </section>
			                
		                </main>
		              </section>
		            </div>
	              <div class="emptyData" v-else>
	                无数据
	              </div>
	            </div>
	        </div>
	    </div>
	    <footer class="footer-btns">
	    	<button class="saveBtn" @click="saveData">保存</button>
		    <!-- <button class="saveBtn" @click="preview">预览</button> -->
	    </footer>
	  </section>
	</section>
	<script type="text/javascript">
		var g_public_uid = <?php echo WeixinMod::get_current_weixin_public('uid'); ?>;
	</script>

	<?php
	$extra_js =  array(
	    '/app/shop/static/modules/vue.js',
	    '/app/shop/static/modules/vue-dragging.es5.js',
	    '/app/shop/static/modules/nodeData.js',
	    '/app/shop/static/modules/app.js',
	);
	?>

</body>
</html>

