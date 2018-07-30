<div class="am-cf am-padding">
  <div class="am-fl am-cf">
  <a href="?_a=reward&_u=sp">
  <strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
  / <small>总计 <?php echo $rewards['count'];?> 个</small></div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除抽奖</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-1">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除抽奖</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-tabs" data-am-tabs>
  <ul class="am-tabs-nav am-nav am-nav-tabs">
    <li><a href="#tab1">普通方式</a></li>
    <li class="am-active"><a href="#tab2">快捷方式</a></li>
  </ul>

  <div class="am-tabs-bd">
    <div class="am-tab-panel am-fade" id="tab1">
      	<div class="am-padding">
<a class="am-btn am-btn-success am-lg" href="?_a=reward&_u=sp.addreward"><span class="am-icon-plus"></span> 创建抽奖</a>

</div>



<div class="am-u-sm-12 fans_box">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">活动名称 </th>
			<th class="table-title">编号 </th>
			<th class="table-set">奖品管理 <span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '添加或编辑奖品', trigger: 'hover focus'}"></span></th>
			<th class="table-title">图片</th>
			<th class="table-time">创建时间</th>
			<th class="table-time">中奖情况<span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '中奖数/抽奖数', trigger: 'hover focus'}"></span></th>
			<th class="table-time">统计图表</th>
			<th class="table-time">状态</th>
			<th class="table-set">操作</th>
			
		</tr>
	</thead>
	<tbody style="min-height:400px">
<?php
	if(!$rewards['list']) {
		echo '<tr class="am-danger"><td>请先创建一个抽奖!</td></tr>';
	}
	else {
		$html = '';
		foreach($rewards['list'] as $f) {
			$html .= '<tr';
			if($f['status']) {
				$html .= ' class="am-danger "';
			}

			$html .= ' data-id="'.$f['uid'].'">';
			$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td><td class="showerweima2"  style="position:relative">
			<a target="_self" href="http://'.parse_url(DomainMod::get_app_url('reward', ""), PHP_URL_HOST).'?_a=reward&r_uid='
						.$f['uid'].'">'.$f['title'].'</a>';
			$html .= '<div class="wap_erweima" style="display: none;z-index:9999;position:absolute"><img style="width:120px;height:120px; max-width:none;  " src="?_a=reward&_u=index.qrcode&r_uid='.$f['uid'].'">
				      <div>扫一扫手机浏览</div>
			          </div></td>';
			
			$html .= '<td >'.$f['uid'].'</td><td><a href="?_a=reward&_u=sp.itemlist&r_uid='.$f['uid'].
					 '" target="_self" class="am-btn am-btn-secondary am-btn-xs "><span class="am-icon-gift"></span> 奖品设置</a></td>';
			$html .= '<td><img src="'.$f['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$html .= '<td>'.date('Y-m-d H:i:s', $f['create_time']).'</td>';
			$html .= '<td><a href="?_a=reward&_u=sp.recordlist&r_uid='.$f['uid'].'">'.$f['win_cnt']
						.'/'.$f['record_cnt'].'(点击查看)'.'</a></td>';
						
			$html .= '<td><a href="?_a=reward&_u=sp.activitydata&r_uid='.$f['uid'].'"><span class="am-icon-line-chart" ></span></a></td>';			
			$html .= '<td data-uid="'.$f['uid'].'">'.($f['status'] ? 
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>')
					.'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					'<a href="?_a=reward&_u=sp.addreward&uid='.$f['uid'].
					'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>'.
					'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$f['uid'].
					'"><span class="am-icon-trash-o"></span> 删除</button>'
					.'</div></div></td>';
			
			$html .= ''.'</tr>';
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<div class="am-u-sm-12 change_page"  style="margin-bottom: 30px;">
<?php
	echo $pagination;
?>
</div>
    </div>
    <div class="am-tab-panel am-fade am-in am-active" id="tab2">
      	<div class="am-padding">
<a class="am-btn am-btn-success am-lg" href="?_a=reward&_u=sp.addreward_1"><span class="am-icon-plus"></span> 创建抽奖</a>

</div>

<div class="am-u-sm-12 fans_box">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<!-- <th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th> -->
			<th class="table-title">活动名称 </th>
			<th class="table-title">编号 </th>
			<th class="table-set">奖品管理 <span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '添加或编辑奖品', trigger: 'hover focus'}"></span></th>
			<!-- <th class="table-title">图片</th> -->
			<th class="table-time">创建时间</th>
			<th class="table-time">中奖情况<span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '中奖数/抽奖数', trigger: 'hover focus'}"></span></th>
			<th class="table-time">统计图表</th>
			<th class="table-time">状态</th>
			<th class="table-set">操作</th>
			
		</tr>
	</thead>
	<tbody style="min-height:400px">
<?php
	if(!$rewards['list']) {
		echo '<tr class="am-danger"><td>请先创建一个抽奖!</td></tr>';
	}
	else {
		$html = '';
		foreach($rewards['list'] as $f) {
			$html .= '<tr';
			// if($f['status']) {
			// 	$html .= ' class="am-danger "';
			// }

			// $html .= ' data-id="'.$f['uid'].'">';
			$html .= '<td class="table-check"></td><td class="showerweima2"  style="position:relative">
			<a target="_self" href="http://'.parse_url(DomainMod::get_app_url('reward', ""), PHP_URL_HOST).'?_a=reward&r_uid='
						.$f['uid'].'">'.$f['title'].'</a>';
			$html .= '<div class="wap_erweima" style="display: none;z-index:9999;position:absolute"><img style="width:120px;height:120px; max-width:none;  " src="?_a=reward&_u=index.qrcode&r_uid='.$f['uid'].'">
				      <div>扫一扫手机浏览</div>
			          </div></td>';
			$html .= '<td>'.$f['uid'].'</td><td><a href="?_a=reward&_u=sp.addreward_3&r_uid='.$f['uid'].
					 '" target="_self" class="am-btn am-btn-primary am-btn-xs "><i class="am-icon-edit"></i> 奖项设置</a></td>';
			//$html .= '<td><img src="'.$f['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$html .= '<td>'.date('Y-m-d H:i:s', $f['create_time']).'</td>';
			$html .= '<td><a href="?_a=reward&_u=sp.recordlist&r_uid='.$f['uid'].'">'.$f['win_cnt']
						.'/'.$f['record_cnt'].'(点击查看)'.'</a></td>';
						
			$html .= '<td><a href="?_a=reward&_u=sp.activitydata&r_uid='.$f['uid'].'"><span class="am-icon-line-chart" ></span></a></td>';			
			$html .= '<td data-uid="'.$f['uid'].'">'.($f['status'] ? 
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>')
					.'</td>';
			$html.='<td><button class="am-btn am-btn-primary am-btn-xs" onclick="window.location.href=\'?_a=reward&_u=sp.addreward_1&uid='.$f['uid'].'\'"><i class="am-icon-edit"></i> 编辑</button><button class="am-btn am-btn-warning am-btn-xs delete-btn" data-uid="'.$f['uid'].'"><i class="am-icon-trash"></i> 删除</button></td>';
			
			$html .= ''.'</tr>';
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<div class="am-u-sm-12 change_page"  style="margin-bottom: 30px;">
<?php
	echo $pagination;
?>
</div>
    </div>
  </div>
</div>
  

<script type="text/javascript">
    var rewards = <?php echo (!empty($rewards) ? json_encode($rewards) : 'null') ?>;
</script>



<?php
	$extra_js = $static_path.'/js/index.js';
?>
