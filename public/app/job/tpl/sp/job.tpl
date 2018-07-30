<div class="am-cf am-padding">
	<div class="am-fl am-cf">
		<a href="?_a=job&_u=sp">
			<strong class="am-text-primary am-text-lg">我的任务</strong></a>
		<span class="am-icon-angle-right"></span>
	</div>
</div>


<!--	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php //echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
	</div>-->


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd"></div>
		<div class="am-modal-bd">

		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>

<div class="am-u-sm-12 fans_box">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>


			<?php
			if (!empty($_REQUEST['d']))
			{
				echo '<th class="table-check">
<input type="checkbox" class="ccheckall">
<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;">
<span class="am-icon-trash"></span></a>
</th>';
			}
			?>
			<th class="table-name">任务名称</th>
			<th class="table-public_name">运行公众号</th>
			<th class="table-dir">附属模块</th>
			<th class="table-create_time">创建时间</th>
			<th class="table-end_time">结束时间</th>
			<th class="table-status">状态</th>
			<!--			<th class="table-data">附带信息</th>-->
			<!--			<th class="table-data">返回信息</th>-->
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
		$status = array('待运行', '正运行', '失败了', '已运行', '已取消');
		$dir    = array('testJob'=>'测试任务',
						'mass' => '高级群发',
		                'default'=>'默认回复',
		                'welcome'=>'欢迎语',
		                'keywords'=>'自定义回复',
		                'mass_TimingJob' => '定时群发',
		                'Mass_Before_Timingjob' => '上传素材',
		                'SyncaAutoreplyJob'=>'同步自动回复');
		if (!$job['list'])
		{
			echo '<tr class="am-danger"><td>并没有任务在运行或待运行！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($job['list'] as $f)
			{
				$html .= '<tr';
				$html .= ' data-id="' . $f['uid'] . '">';

				if (!empty($_REQUEST['d']))
				{
					$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
				}
				$html .= '<td>' . $dir[$f['name']] . '</td>';
				$html .= '<td>' . (empty($f['public']['public_name']) ? '-' : $f['public']['public_name']) . '</td>';
				$html .= '<td>' . (isset($dir[$f['dir']]) ? ('<a href="?_a=' . $f['dir'] . '&_u=sp.job"> ' . $dir[$f['dir']] . '</a>') : '-') . '</td>';
				$html .= '<td>' . date('Y-m-d H:i', $f['create_time']) . '</td>';
				$html .= '<td>' . (empty($f['end_time']) ? '-' : date('Y-m-d H:i', $f['end_time'])) . '</td>';
				$html .= '<td>' . $status[$f['status'] - 1] . '</td>';
				//				$html .= '<td>' . $f['job_args']. '</td>';
				//				$html .= '<td>
				//							<div class="am-dropdown" data-am-dropdown="{boundary: \'.am-topbar\'}">
				//							<button class="am-btn am-btn-secondary am-dropdown-toggle " data-am-dropdown-toggle>' . count($f['job_args']) . '个
				//							<span class="am-icon-caret-down"></span>
				//							</button><ul class="am-dropdown-content " data-am-dropdown-toggle>';
				//				foreach ($f['job_args'] as $ak => $a)
				//				{
				//					$html .= '<li>' . $ak . ':' . (is_array($a)?'array':$a) . '</li>';
				//				}
				//				$html .= '</ul></div></td>';


				//				$html .= '<td>' . $f['job_callback'] . '</td>';


				if ($f['status'] == JobMod::STATUS_WAITING)
				{
					$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">' .
						'<button class="am-btn am-btn-default am-btn-xs am-text-danger ccancel" data-id="' . $f['uid'] .
						'"><span ></span>取消</button>'
						. '</div></td>';
				}
				else
				{
					if (!empty($_REQUEST['d']))
					{
						$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">' .
							'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="' . $f['uid'] .
							'"><span class="am-icon-trash-o"></span>删除</button>'
							. '</div></td>';
					}
					else
					{
						$html .= '<td></td>';

					}
				}
				$html .= '' . '</tr>';
			}
			echo $html;
		}
		?>
		</tbody>
	</table>
</div>


<div class="am-u-sm-12 change_page">
	<?php
	echo $pagination;
	?>
	<!--	<a href="?_a=job&_u=sp">-->
	<!--		<button class="am-btn am-btn-lg am-btn-primary">返回</button>-->
	<!--	</a>-->
</div>

<?php
echo '<script>var sp_uid = ' . (!empty($option['sp_uid']) ? $option['sp_uid'] : 0) . ';</script>';
$extra_js = $static_path . '/js/index.js';
?>
