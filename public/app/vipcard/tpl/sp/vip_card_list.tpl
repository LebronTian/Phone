<div class="am-cf am-padding">
	<div class="am-fl am-cf">
		<a href="?_a=reward&_u=sp">
			<strong class="am-text-primary am-text-lg">会员卡列表</strong></a>
		<span class="am-icon-angle-right"></span>
		/
		<small>总计 <?php echo $vip_card_list['count']; ?> 条记录</small>
	</div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
		<div class="am-form-group am-margin-left am-fl">
			<select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
				$status_arr = array('0' => '通过', '1' => '等待审核', '2' => '不通过');
				$html       = '<option value="-1"';
				if (!isset($option['status']))
				{
					$html .= ' selected ';
				}
				$html .= '>全部状态</option>';

				foreach ($status_arr as $sk => $sv)
				{
					$html .= '<option value="' . $sk . '"';
					if (isset($option['status'] ) && $option['status'] == $sk)
					{
						$html .= ' selected';
					}
					$html .= '>' . $sv . '</option>';
				}
				echo $html;
				?>
			</select>
		</div>
	</div>
	<div class="am-u-md-3 ">
		<div class="am-input-group am-input-group-sm " style="width: 100%">
			<input type="text" class="am-form-field option_card_id"
			       value="<?php echo empty($option['card_id']) ? '' : $option['card_id']; ?>" placeholder="会员卡号">
		</div>

	</div>
	<div class="am-u-md-3 ">
		<div class="am-input-group am-input-group-sm" style="width: 100%">
			<input type="text" class="am-form-field option_key"
			       value="<?php echo empty($option['key']) ? '' : $option['key']; ?>" placeholder="姓名、资料                                                    等">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button" >搜索</button>
                </span>
		</div>

	</div>

</div>


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">删除会员卡</div>
		<div class="am-modal-bd">
			确定要删除吗？
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>
<div class="am-modal am-modal-confirm" tabindex="-1" id="my-refresh">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">刷新会员卡</div>
		<div class="am-modal-bd">
			确定要刷新会员卡吗？
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>
<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<?php
			$html = '';
			$html = '<th style="min-width: 95px"><input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
				<a href="javascript:;" class="am-text-primary am-text-lg crerefreshall" style="margin-left:10px;"><span class="am-icon-refresh"></span></a>
				</th>';
			if (!empty($vip_card_set['connent']))
			{

				foreach ($vip_card_set['connent'] as $c_key => $c_set)
				{
					$html .= '<th class="table-' . $c_key . '">' . (empty($c_set['title']) ? '木设置名称' : $c_set['title']) . '</th>';
				}
			}
			$html .= '<th>领卡时间</th>';
			$html .= '<th>头衔(折)</th>';
			$html .= '<th>审核</th>';
			$html .= '<th>会员卡/粉丝信息</th>';
//			if (!empty($_REQUEST['_d']))
//			{
				$html .= '<th>操作</th>';

//			}

			echo $html;
			?>


		</tr>
		</thead>
		<tbody>
		<?php
		if (!$vip_card_list['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($vip_card_list['list'] as $vip_card_su)
			{
				$html .= '<tr data-uid="' . $vip_card_su['uid'] . '"">';
				$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
				foreach ($vip_card_su['connent'] as $c)
				{
					$html .= '<td>';
					if ((mb_stripos($c['value'], '?_a=upload&_u=index.out&uidm=') !== false) ||
						(mb_stripos($c['value'], 'http://wx.qlogo.cn/') !== false)
					)
					{
						$html .= '<img style="max-width:100px;max-height:100px;" src="' . $c['value'] . '">';
					}
					else
					{
						$html .= $c['value'];
					}
					$html .= '</td>';
				}
				$html .= '<td>' . date('Y-m-d H:i:s', $vip_card_su['create_time']) . '</td>';
				$html .= '<td>' . $vip_card_su['rank'].'('.($vip_card_su['rank_discount']/10). ')</td>';
				$html .= '<td><select data-am-selected="{btnSize: \'sm\' ,btnWidth: \'100px\'}" class="option_check">';
				foreach ($status_arr as $sk => $sv)
				{
					$html .= '<option value="' . $sk . '"';
					if ($sk== $vip_card_su['status'])
					{
						$html .= ' selected';
					}
					$html .= '>' . $sv . '</option>';
				}
				$html .='</select></td>';
				$html .= '<td><span class="am-btn am-btn-default card_url" data-card_url="' . $vip_card_su['card_url'] . '">查看</span>';
				$html .= '<a target="_self" class="am-btn am-btn-primary " href="?_a=su&_u=sp.fansdetail&uid=' . $vip_card_su['su_uid'] . '">详情</a></td>';
//				if (!empty($_REQUEST['_d']))
//				{
					$html .= '<td>';
				$html .='<span target="_self" class="am-btn am-btn-primary refresh" data-su_uid="' . $vip_card_su['su_uid'] . '">刷新</span>';

				$html .='<span target="_self" class="am-btn am-btn-danger cdelete" data-id="' . $vip_card_su['uid'] . '">删除</span>';
					$html .= '</td>';
//				}
				$html . '</tr>';
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


<?php
$extra_js = array(
	'/app/vipcard/static/js/vip_card_list.js',
);
?>
