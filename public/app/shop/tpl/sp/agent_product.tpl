<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商品列表</strong> /</div>
</div>

<div class="am-g am-padding">
	<button style="margin-left: 1em" class="am-btn am-btn-primary choose-cats">
		<?php
		if (requestInt('cat_uid'))
		{
			if (!empty($agent_products['list']['0']['cat']['title']))
			{
				echo $agent_products['list']['0']['cat']['title'];
			}
			else
			{
				echo "选择分类";
			}
		}
		else
		{
			echo "选择分类";
		}
		?>
	</button>
	<span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '暂时只支持【统一规格】的商品被代理', trigger: 'hover focus'}">缺少商品</span>
</div>

<div class="am-u-sm-12" style="min-height: 300px">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>

			<th class="table-title">商品名称</th>
			<th class="table-parent">商品分类</th>
			<th class="table-image">商品主图</th>
			<th class="table-price">原价格/成本价</th>
			<th>代理商可配置的价格区间</th>
			<th>最后修改时间</th>
			<th>是否允许代理</th>

			<th class="table-agent_ro_user_product">代理情况</th>
			<th class="table-set">操作</th>

		</tr>
		</thead>
		<tbody>
		<?php
		if (!$agent_products["list"])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($agent_products["list"] as $p)
			{
				$html .= '
        <tr ' . ($p['status'] == 1 ? "class='am-danger'" : "") . ' data-a_id="' . $p['a_uid'] . '" data-uid="' . $p['uid'] . '">

            <td>
                <a target="_blank" href="?_a=shop&_u=sp.productlist&uid=' . $p['uid'] . '" class="template-title">' . $p['title'] . '</a>
                <p style="margin:0">';

				$html .= '
                </p>
            </td>
            <td><span class="template-brief">' . (!empty($p['cat']) ? $p['cat']['title'] : "未分类") . '</span></td>
            <td><img src="' . $p['main_img'] . '&w=100&h=100" style="max-width:100px;max-height:100px"/></td>
            <td class="td_price">' . sprintf('%.2f', $p['price'] / 100) . '</td>

            <td>' . (isset($p['price_l']) ? sprintf('%.2f', $p['price_l'] / 100) . '' : '') . '~' . (isset($p['price_h']) ? sprintf('%.2f', $p['price_h']/100) . '' : '') . '</td>
            <td>' . (empty($p['a_modify_time']) ? '' : date('Y-m-d H:i:s', $p['a_modify_time'])) . '</td>
            <td><a class="pStatus am-btn am-btn-xs ' . (isset($p["a_status"]) ? ($p["a_status"] == 0 ? 'am-btn-success">是' : 'am-btn-danger">否') : 'am-btn-warning">未设置') . '</a></td>

            <td><a target="_blank" class="am-btn am-btn-primary" href="?_a=shop&_u=sp.agent_to_user_product&p_uid='.$p['uid'].'"><span>查看</span></a></td>
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <span href="?_a=shop&_u=sp.addagentproduct&uid=' . $p['a_uid'] . '" target="_blank"
                        ' . (isset($p["a_status"]) ?
						' class="am-btn am-btn-default am-btn-xs am-text-primary edit"><span class="am-icon-edit "></span> 编辑' :
						' class="am-btn am-btn-success am-btn-xs edit"><span class="am-icon-edit"></span> 添加') . '
                        </span>
                    </div>
                </div>
            </td>
        </tr>';
			}
			echo $html;
		}
		?>
		</tbody>
	</table>
</div>

<div class="am-u-sm-12">
	<?php
	echo $pagination;
	?>
</div>


<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">选择分类
			<a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
		</div>
		<div class="am-modal-bd">
			<div style="overflow: scroll;max-height: 40em">
				<a href="?_a=shop&_u=sp.agent_product">
					<button style="margin: 0.5em 0" class="am-btn am-btn-success">全部商品</button>
					<br></a>
				<select class="catList-yhc2"></select>
			</div>
		</div>
	</div>
</div>

<div class="margin-10 am-modal am-modal-confirm" tabindex="-1" id="EditAgentProduct">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">设置可被代理商品信息
			<a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
		</div>
		<div class="am-modal-bd am-form">
			<div class="am-g am-margin-top-sm agent_set_weight">
				<div class="am-u-sm-3 am-text-right">
					代理商可以设置的价格区间
				</div>
				<div class="am-u-sm-2 am-u-end am-text-right">
					<input type="number" placeholder="" min="0" class="price_l" value="">
				</div>
				<div class="am-u-sm-1 am-u-end">
					~
				</div>
				<div class="am-u-sm-2 am-u-end am-text-right">
					<input type="number" placeholder="" min="0" class="price_h" value="">
				</div>

				<div class="am-u-sm-1  am-text-right">
					<small>原价格</small>
				</div>
				<div class="am-u-sm-2  am-text-left">
					<span class="am-btn am-btn-primary product_price">0</span>
				</div>
			</div>
			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-3 am-text-right am-u-end">
					<strong class="am-text-lg">该商品的分红模式</strong>
				</div>
				<div class="am-u-sm-6  am-u-end">
					（可多选，红利直接叠加）
				</div>
				<div class="am-u-sm-2 am-u-end">
					&nbsp;
				</div>
				<div class="am-u-sm-2 am-text-left" style="visibility: hidden">
					<span class="am-btn am-btn-primary">0</span>
				</div>
			</div>
			<div class="am-g am-margin-top-sm agent_cost">
				<div class="am-u-sm-3 am-text-right">
					扣去成本为红利
				</div>
				<div class="am-u-sm-1 am-center am-text-right ">
					<input type="checkbox" name="">
				</div>
				<div class="am-u-sm-2 am-u-end">
					<input type="number" style="visibility: hidden">
				</div>
				<div class="am-u-sm-4 am-u-end">
					<small>红利=代理商设置的商品价格-供货商设置的商品价格</small>
				</div>
				<div class="am-u-sm-2  am-text-left">
					<span class="am-btn am-btn-primary product_cost">0</span>
				</div>
			</div>

			<div class="am-g am-margin-top-sm agent_paid_fee">
				<div class="am-u-sm-3 am-text-right">
					销售价格的固定百分比
				</div>
				<div class="am-u-sm-1 am-center am-text-right ">
					<input type="checkbox" name="">
				</div>
				<div class="am-u-sm-2 am-u-end">

					<input class="" type="number" max="100" min="0" step="0.01" value=""/>

				</div>
				<div class="am-u-sm-1 am-u-end am-text-left">
					%
				</div>
				<div class="am-u-sm-3 am-u-end">
					<small>红利=代理商设置的商品价格*设置百分百</small>
				</div>
				<div class="am-u-sm-2  am-text-left">
					<span class="am-btn am-btn-primary product_paid_fee">0</span>
				</div>
			</div>
			<div class="am-g am-margin-top-sm agent_bonus">
				<div class="am-u-sm-3 am-text-right">
					每个卖出商品给予固定佣金
				</div>
				<div class="am-u-sm-1 am-center am-text-right ">
					<input type="checkbox" name="">
				</div>
				<div class="am-u-sm-2 am-u-end">

					<input class="" type="number" min="0" step="0.01" value=""/>

				</div>
				<div class="am-u-sm-4 am-u-end">
					<small>红利=供货商设置的佣金*代理商卖出商品数 （单位：元）</small>
				</div>
				<div class="am-u-sm-2  am-text-left">
					<span class="am-btn am-btn-primary product_bonus">0</span>
				</div>
			</div>
			<div class="am-g am-margin-top-sm ">
				<div class="am-u-sm-6 am-u-end">
					&nbsp;
				</div>
				<div class="am-u-sm-4 am-u-end am-text-right">
					<small>代理的红利范围：</small>
				</div>
				<div class="am-u-sm-2  am-text-left">
					<span class="am-btn am-btn-primary sum_bonus">0</span>
				</div>
			</div>
			<div class="am-g am-margin-top-sm agent_bonus">
				<div class="EditAgentProduct_tips am-text-center"></div>
			</div>
		</div>

		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>


<?php

echo '<script>
                var catsAll = '.(!empty($cats)? json_encode($cats):"null").';
                var a_data = "'.$GLOBALS['_UCT']['ACT'].'";
        </script>';

$extra_js = array(
	'/static/js/catlist_yhc.js',
	$static_path . '/js/agentproduct.js',
	$static_path . '/js/catsSelect.js',
);

?>
