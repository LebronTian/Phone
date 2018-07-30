<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">域名绑定</strong> / <small>将您的域名绑定到一个模块或页面</small></div>
</div>
  
<a class="am-btn am-btn-success am-lg" href="?_a=domain&_u=sp.adddomain"><span class="am-icon-plus"></span> 添加域名绑定</a>
<?php
/*
if($domains['list'])
foreach($domains['list'] as $d) {
	echo '<p>'.$d['domain'].' <a target="_blank" href="http://'.$d['domain'].'">预览</a>'.
		' <a href="?_a=domain&_u=sp.adddomain&uid='.$d['uid'].'">编辑</a>';
}		
*/
//$out_app_arr=arry('');
$ret=DomainMod::get_pluging_by_uid();
if($ret){
foreach($ret as $r)
{	
	$pluging_list[$r['dir'].'.index.index']=$r['name'];
}
$pluging_list['thirdlogin.index.qqproperty']='QQ登陆验证中';
$pluging_list['thirdlogin.index.wbproperty']='微博登陆验证中';
}
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除绑定域名</div>
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
			<th class="table-title">域名</th>
			<th class="table-title">绑定模块</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$domains['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($domains['list'] as $d) {
			$html .= '<tr';
			$html .= ' data-id="'.$d['uid'].'">';
			$html .= '<td class="table-check" ><input type="checkbox" class="ccheck"></td>'.
						'<td class="showerweima">'.$d['domain'].'';
            $html .= '<div class="wap_erweima" style="display: none;z-index:9999;position:absolute"><img 	style="width:120px;height:120px; max-width:none;  "
                        src="?_a=web&_u=index.qrcode&url=http%3A%2F%2F'.$d['domain'].'">
			<div>扫一扫手机浏览</div>
			</div>';
			$html .= ' <a target="_blank" href="http://'.$d['domain'].'">预览</a></td>';
			$html .='<td>'.(!empty($d['bind'])?(isset($pluging_list[$d['bind']])?$pluging_list[$d['bind']]:''):'').'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					'<a href="?_a=domain&_u=sp.adddomain&uid='.$d['uid'].
					'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>'.
					'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$d['uid'].
					'"><span class="am-icon-trash-o"></span> 删除</button>'
					.'</div></td>';

			$html .= ''.'</tr>';
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>



<?php
	$extra_js = $static_path.'/js/index.js';
?>
