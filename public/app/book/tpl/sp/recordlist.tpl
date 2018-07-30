<style>
.am-btn-white {
	background-color: white !important;
	border: 1px dotted gray;
}
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">预约记录</strong> / <small>总计 <?php echo $data['count']; ?> 条数据</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-3">
		<button class="am-btn am-btn-success am-btn-warning beditall am-icon-eye am-icon-edit" >查看模式</button>

		<div class="am-form-group am-fr ">
			<span id="color_sign">根据标记查看</span> ：<div class="am-dropdown" data-am-dropdown>
			<button class="am-btn <?php 
				$sp_remarks = array(
					-1 => 'am-btn-white',
					1 => 'am-btn-default',
					2 => 'am-btn-danger',
					3 => 'am-btn-success',
					4 => 'am-btn-primary',
				);
				echo (isset($sp_remarks[$option['sp_remark']]) ? $sp_remarks[$option['sp_remark']] : 'am-btn-white');
			?>
			am-dropdown-toggle" data-am-dropdown-toggle></button>
			<ul class="am-dropdown-content csp_remarks" style="min-width:34px !important; cursor:pointer;">
				<li class="am-btn-white"   sp="-1">&nbsp;</li>
				<li class="am-btn-default" sp="1">&nbsp;</li>
				<li class="am-btn-danger"  sp="2">&nbsp;</li>
				<li class="am-btn-success" sp="3">&nbsp;</li>
				<li class="am-btn-primary" sp="4">&nbsp;</li>
			</ul>
			</div>
		   
		</div>
	</div>
 
	<div class="am-u-md-3 ">
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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除记录</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>


<div class="am-u-sm-12" style="min-height: 300px">
    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <th class="table-check">
                <input type="checkbox" class="ccheckall">
                <a href="javascript:;" class="am-text-danger am-text-lg delAll" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
            </th>
            <th class="table-title">项目</th>
            <th>门店</th>
            <th>时间</th>
            <th>信息</th>
            <th>标记</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$data["list"]) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }else {
        $html = '';
        foreach($data["list"] as $p) {
        $html .='
        <tr data-id="'.$p['uid'].'">
            <td><input type="checkbox" class="delCheck"></td>
            <td>
                <span class="template-title">'.($p['book']['title']).'</span>
                <p style="margin:0">';
                $html.='
                </p>
            </td>
            <td>'.(!empty($p['book']['store']) ? $p['book']['store']['name'] : '').'</td>
            <td>'.date('Y-m-d H:i:s', $p['create_time']).'</td>
			<td>';
			if(!empty($p['data'])) foreach($p['data'] as $k => $v) 
			$html.= $k.':'.$v.'</br>';
			$html .= '</td>';
			$html .='<td> <div class="am-dropdown" data-am-dropdown><button class="am-btn ';
			$html .=isset($sp_remarks[$p['sp_remark']]) ? $sp_remarks[$p['sp_remark']] : 'am-btn-white';

			$html .=' am-dropdown-toggle" data-am-dropdown-toggle></button>'.
				'<ul class="am-dropdown-content csp_remark" style="min-width:34px !important; cursor:pointer;">'.
					'<li class="am-btn-white" sp="-1">&nbsp;</li>'.
					'<li class="am-btn-default" sp="1">&nbsp;</li>'.
					'<li class="am-btn-danger"  sp="2">&nbsp;</li>'.
					'<li class="am-btn-success" sp="3">&nbsp;</li>'.
					'<li class="am-btn-primary" sp="4">&nbsp;</li>'.
				'</ul>'.
				'</div>';
			if($p['order']) {
				if($p['order']['paid_time']) {
					$html .= '<br>'.date('Y-m-d H:i:s', $p['order']['paid_time']).'已支付';
				} else {
					$html .= '<br><span class="am-text-danger">待支付&yen;'.($p['order']['paid_fee']/100).'</span>';
				}
			}
			$html .= '</td>';
			$html .= '
            <td>
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <a style="display:none;" href="?_a=book&_u=sp.addrecord&uid='.$p['uid'].'" class="am-btn am-btn-default am-btn-xs am-text-primary">
                            <span class="am-icon-edit"></span> 编辑
                        </a>
                        <button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$p['uid'].'">
                            <span class="am-icon-trash-o"></span> 删除
                        </button>
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

<?php
	echo '<script>g_b_uid='.(isset($book['uid']) ? $book['uid'] : 0).';</script>';
$extra_js = array(
    $static_path.'/js/recordlist.js',
);

?>

