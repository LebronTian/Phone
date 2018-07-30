<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>

<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">关键词列表</strong> / <small>通过关键词触发微信插件, 一个插件可以有多个触发词</small></div>
</div>


<div class="am-u-sm-12">
<table class="am-table am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-title">关键词</th>
			<th class="table-type">插件</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
          <tbody>
<?php
	if(!$data['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($data['list'] as $l) {
			$html .= '
            <tr';
			if(!$l['available']) {
				$html .= ' class="am-danger am-link-muted"';
			}
			$html .= '><td>';

			if($l['trigger_mode'] < 11) {
			$html .= '
              <select class="text-chosen" data-id="'.$l['uid'].'" style="width:360px;" multiple';
			if(!$l['available']) {
				$html .= ' disabled="disabled"';
			}
			$html .= '>';
			if($l['keywords']) {
				foreach($l['keywords'] as $ll) {
					$html .= '<option selected="selected">'.$ll.'</option>';
				}
			}
			$html .= '</select>';
			}
			else if($l['trigger_mode'] == 11){
				$html .= '<input type="text" class="am-form-field cpattern" data-value="'.$l['keywords'].'" value="'.$l['keywords']
						.'" style="width:360px;" data-id="'.$l['uid'].'" ';
				if(!$l['available']) {
					$html .= ' disabled="disabled"';
				}
				$html .= '/>';
			}

			$html .= '</td>
              <td><a target="_blank" href="?_a='.$l['dir'].'&_u=sp">'.$l['name'].'</a></td>
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs">';
			if($l['enabled']) { 
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger btn_enable" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 禁用</button>';
			}
			else {
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-success btn_enable" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 启用</button>';
			}
             $html .= '</div>
                </div>
              </td>
            </tr>
			';
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
					  '/static/js/select2/js/select2.min.js',
					  '/app/sp/static/js/keywordlist.js');
?>


