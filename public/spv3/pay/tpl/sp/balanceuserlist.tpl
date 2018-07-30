<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">所有用户</strong> / <small>总计 <?php echo $users['count'];?> 名</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6 am-cf">
	</div>
	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div>

</div>



<?php
	//var_export($fans);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除分类</div>
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
			</th>
			<th class="table-title">用户</th>
			<th class="table-image">头像</th>
			<th class="table-time">加入时间</th>
			<th class="table-gender">余额(元)</th>
			<th class="table-gender">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$users['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($users['list'] as $f) {
			$html .= '<tr';
			if(0) {
				$html .= ' class="am-danger "';
			}

			$html .= ' data-id="'.$f['uid'].
					'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td><a href="?_a=su&_u=sp.fansdetail&uid='
					.$f['uid'].'">'.($f['name'] ? $f['name'] : $f['account']).'</td>'
					.'<td><img src="'.$f['avatar'].'" style="max-width:100px;max-height:100px;"></td>'
					.'<td>'.($f['create_time'] ? date('Y-m-d H:i:s', $f['create_time']) : '-').'</td>'
					.'<td>&yen; '.($f['cash_remain']/100).'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-success ccharge" data-id="'.$f['uid'].'"><span class="am-icon-flash"></span> 充值</button>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger ctransfer" data-id="'.$f['uid'].'"><span class="am-icon-flash"></span> 提现</button>';
			$html .= '</div></div></td>'.'</tr>';
		}
		echo $html;
	}
?>
<style>
	.admin-content{overflow: auto;}
	.change_page{min-height: 250px}
	.am-btn {padding: 0.3em 0.5em}
	.apart_team {margin-right: 20px;}
	.apart_team > ul {min-width:160px;}
	.apart_team > ul > li > a {padding:6px 20px;cursor:pointer}
	.apart_team > ul > li > a:hover {background-color: #0a6999;color:white;}
	.apart_team .am-dropdown-toggle {cursor:pointer;width: 160px}


</style>


	</tbody>
</table>
</div>


<div class="am-u-sm-12 change_page">
<?php
	echo $pagination;
?>
</div>

<script>
//    var optionData = <?php echo(!empty($option)? json_encode($option):"null")?>;
//   var fansData = <?php echo(!empty($fans)? json_encode($fans):"null")?>;
//   console.log(fansData);
</script>
<?php
	$extra_js = $static_path.'/js/balanceuserlist.js';
?>
