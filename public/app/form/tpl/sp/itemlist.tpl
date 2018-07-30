<div class="am-cf am-padding">
  <div class="am-fl am-cf">
	<a href="?_a=form&_u=sp">
  	<strong class="am-text-primary am-text-lg">通用表单</strong></a>
	<span class="am-icon-angle-right"></span>
   <strong class="am-text-default am-text-lg"><?php echo $form['title'];?></strong> 的表单项
    /<small>总计 <?php echo count($form['data']);?> 个</small></div>
</div>
<!--
<div class="am-padding">
	<div class="am-u-md-1">
		<a class="am-btn am-btn-success am-lg add_form_item" href="?_a=form&_u=sp.additem&r_uid=<?php //echo $option['r_uid']; ?>"></a>
		<button class="am-btn am-btn-success am-lg add_form_item"><span class="am-icon-plus"  ></span> 创建表单项</button>
	</div>
</div>

	<div class="am-u-md-3 am-cf">
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
    <div class="am-modal-hd">删除表单项</div>
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
			<th class="table-type">控件类型
				
			</th>
			<th class="table-title">标题</th>
			<th class="table-required">是否必填
				<span class="am-icon-question-circle am-text-warning" data-am-popover="{content: '勾选后用户在此项不填内容，将无法提交', trigger: 'hover focus'}"></span>
			</th>
			<th class="table-desc">注释
			<div class="help" style="display: none;z-index:9999;position:absolute;background:#fff; ">
			<img style="width:369px;height:160px; max-width:none; " src="/app/form/static/images/help.png">
			<div>设置后将会有类似上图效果</div>
			</div>
			</th>
			<!--<th class="table-default">默认</th>-->
			<th class="table-unique">设为唯一
				<span class="am-icon-question-circle am-text-warning" data-am-popover="{content: '常用于手机号，qq，ip等。若设设置qq为唯一，则该qq只能提交一次.目前只支持一个。', trigger: 'hover focus'}"></span>
			</th>
			<th class="table-set">操作</th>
			
		
			
		</tr>
	</thead>
	<tbody>
<?php
	$typename=array("file_img"=>"图片上传控件",
					"text"=>"单行输入框",
					"text_multi"=>"多行输入框");
						
	if(!$form['data']) {
		
	}
	else {
		$unique=isset($form['access_rule']['unique_field'])?$form['access_rule']['unique_field']:-1;
		$html = '';
		$i=0;
		foreach($form['data'] as $f) {
			
			$html .= '<tr';
			$html .= ' data-id="'.(!empty($f['id'])?$f['id']:"").'">';
			
			$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
			$html .= '<td class="table-id-type"><span value="'.(!empty($f['type'])?$f['type']:"").'">'.(!empty($f['type'])?(empty($typename[$f['type']])?"":$typename[$f['type']]):"点击选择类型").'</span></td>';
			$html .= '<td class="table-id-title " ><span>'.(!empty($f['name'])?$f['name']:"").'</span></td>';
			$html .= '<td><input type="checkbox" class="requiredcheck" '.(!empty($f['required'])?(($f['required']=='true')?'checked':''):"").'></td>';
			$html .= '<td class="table-id-desc " ><span>'.(empty($f['desc'])?"":$f['desc']).'</span></td>';
			//$html .= '<td class="table-id-default " ><span>'.(empty($f['default'])?"":$f['default']).'</span></td>';
			$html .= '<td class="table-id-unique " ><span>'.($i==$unique?'<button class="am-btn am-btn-danger am-btn-sm">唯一</button>':'').'</span></td>';
			
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					//'<button class="am-btn am-btn-success am-btn-xs am-text-dufault cedit" data-id=""><span class="am-icon-edit"></span>编辑</button>'.
					'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id=""><span class="am-icon-trash-o"></span> 删除</button>'
					.'</div></td>';
			
			$html .= ''.'</tr>';
			$i++;
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<div class="am-u-lg-12">
	<button" class="am-u-lg-12 am-btn am-btn-lg am-btn-success add_form_item" style="width:100%;" ><span class="am-icon-plus">增加表单项</span></button>
</div>
<div class="am-u-sm-12 change_page">
	
 <a href="?_a=form&_u=sp"><button  class="am-btn am-btn-lg am-btn-primary">返回</button></a>
</div>

<?php
	echo '<script>var f_uid = '.(!empty($form['uid']) ? $form['uid'] : 0).';</script>';
	echo '<script>var sp_uid = '.(!empty($form['sp_uid']) ? $form['sp_uid'] : 0).';</script>';
	$extra_js = $static_path.'/js/item.js';
?>
