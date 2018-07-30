<div class="am-cf am-padding">
  <div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
  	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
   <strong class="am-text-default am-text-lg"><?php echo $reward['title'];?></strong> 的奖品
    /<small>总计 <?php echo $item['count'];?> 个</small></div>
</div>
<div class="am-padding">
<div class="am-u-md-2">
<a class="am-btn am-btn-success am-lg" href="?_a=reward&_u=sp.additem&r_uid=<?php echo $option['r_uid']; ?>">
<span class="am-icon-plus"></span> 添加奖品</a>
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
    <div class="am-modal-hd">删除奖品</div>
    <div class="am-modal-bd">
      确定要删除吗？
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
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-time">名称 <span class="am-icon-question-circle am-text-danger " data-am-popover="{content: '带 <span class=&quot;am-icon-gift am-text-primary&quot;></span> 标志的为虚拟奖品', trigger: 'hover focus'}"></span></th>
			<th class="table-img">图片</th>
			<th class="table-win_cnt">已中奖数/总奖品数</th>
			<th class="table-weight">中奖概率</th>
			<th class="table-sort">排序编号</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php

	if(!$item['list']) {
		echo '<tr class="am-danger"><td>请先创建一个奖品！</td></tr>';
	}
	else {
		$html = '';
		foreach($item['list'] as $f) {
			$html .= '<tr';
			$html .= ' data-id="'.$f['uid'].'">';
		//	$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td><td><a href="?_a=reward&uid='
		//			.$f['uid'].'">'.$f['title'].'</a></td>';
		//投票项 编号应该无需跳转
			$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
			$html .= '<td>';
			if(!empty($f['virtual_info'])) $html .= '<span class="am-icon-gift am-text-primary"></span> ';
			$html .= $f['title'].'</td>';
			$html .= '<td><img src="'.$f['img'].'" style="max-width:100px;max-height:100px;"></td>';
		//  $html .= '<td><a href="?_a=reward&_u=sp.recordlist&r_uid='.$f['r_uid'].'&i_uid='.$f['uid'].'">'.$f['win_cnt']
		//			.($f['win_cnt'] ? ' (点击查看)': '').'</a></td>';
		//数量只显示 无需跳转
			$html .= '<td>'.$f['win_cnt'].'/'.$f['total_cnt'].'</td>';
			$html .= '<td>'.($f['weight']/100).'%</td>';
			$html .= '<td>'.$f['sort'] 
					.'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					'<a href="?_a=reward&_u=sp.additem&i_uid='.$f['uid'].'&r_uid='.$f['r_uid'].
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


<div class="am-u-sm-12 change_page">
<?php
	echo $pagination;
?>
 <a href="?_a=reward&_u=sp"><button  class="am-btn am-btn-lg am-btn-primary">返回</button></a>
</div>

<?php
	echo '<script>var r_uid = '.(!empty($reward['uid']) ? $reward['uid'] : 0).';</script>';
	echo '<script>var sp_uid = '.(!empty($reward['sp_uid']) ? $reward['sp_uid'] : 0).';</script>';
	$extra_js = $static_path.'/js/item.js';
?>
