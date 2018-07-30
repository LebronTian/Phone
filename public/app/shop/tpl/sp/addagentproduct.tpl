<div class="am-cf am-padding">
	<div class="am-fl am-cf" id="edit-id">
		<strong class="am-text-primary am-text-lg"> 选择要给该<span
				class="am-btn am-btn-success"><?php echo $agent['user']['name']; ?></span>代理添加的商品</strong> /
	</div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>

	<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
		<div class="am-u-sm-1 am-text-left">
			<a class="am-btn am-btn-primary" href="?_a=shop&_u=sp.agent_to_user_product">返回</a>
		</div>
		<!--			<div class="am-u-sm-4 am-text-left am-u-end">-->
		<!--				<span-->
		<!--					class="am-btn am-btn-primary">选择要给该--><?php //echo '</span><span class="am-btn am-btn-success">' . $agent['user']['name'] . '</span><span class="am-btn am-btn-primary">'; ?>
		<!--					代理添加的商品</span>-->
		<!--			</div>-->
	</div>
	<div class="am-u-sm-12">
		<table class="am-table am-table-striped am-table-hover table-main">
			<thead>
			<tr>

				<th class="table-title">商品名称</th>
				<th class="table-parent">商品分类</th>
				<th class="table-image">商品主图</th>
				<th class="table-price">原价格/成本价</th>
				<th>可配置的价格区间</th>
				<th>是否允许代理</th>
				<th>最后修改时间</th>
				<th class="table-check">
					<input type="checkbox" class="ccheckall">
				</th>
			</tr>
			</thead>
			<tbody>
			<?php
			if (!$agent_products["list"])
			{
				echo '<tr class="am-danger"><td>没有符合条件的商品！</td></tr>';
			}
			else
			{
				$html = '';
				foreach ($agent_products["list"] as $p)
				{
					$html .= '
        <tr data-a_id="' . $p['a_uid'] . '" data-uid="' . $p['uid'] . '">

            <td>
                <a target="_blank" href="?_a=shop&_u=sp.productlist&uid=' . $p['uid'] . '" class="template-title">' . $p['title'] . '</a>
                <p style="margin:0">';

					$html .= '
                </p>
            </td>
            <td><span class="template-brief">' . (!empty($p['cat']) ? $p['cat']['title'] : "未分类") . '</span></td>
            <td><img src="' . $p['main_img'] . '&w=100&h=100" style="max-width:100px;max-height:100px"/></td>
            <td>' . sprintf('%.2f', $p['price'] / 100) . '</td>

            <td>' . (isset($p['price_l']) ? sprintf('%.2f', $p['price_l']  / 100) . '' : '') . '~' . (isset($p['price_h']) ? sprintf('%.2f', $p['price_h']/ 100) . '' : '') . '</td>

            <td><span class="pStatus am-btn am-btn-xs ' . (isset($p["a_status"]) ? ($p["a_status"] == 0 ? 'am-btn-success">是' : 'am-btn-danger">否') : 'am-btn-warning">未设置') . '</span></td>
            <td>' . (empty($p['a_modify_time']) ? '' : date('Y-i-d H:m:s', $p['a_modify_time'])) . '</td>

            <td class="table-check"><input type="checkbox" class="ccheck"></td>

        </tr>';
				}
				echo $html;
			}
			?>
			</tbody>
		</table>
		<div class="am-u-sm-12">
			<?php
			echo $pagination;
			?>
		</div>
		<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
			<div class="am-u-sm-8 am-u-end">
				<button class="am-btn am-btn-secondary" id="savebtn">保存</button>
			</div>
		</div>
	</div>
</div>


<?php

echo '
    <script>
            var a_uid = ' . (!empty($agent) ? $agent['uid'] : "null") . ';
    </script>';

$extra_js = array(

	$static_path . '/js/addagentproduct.js',

);
?>
