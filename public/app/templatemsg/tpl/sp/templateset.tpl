<!--<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">-->
<!--<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">-->
<script src="http://cdn.amazeui.org/amazeui/2.7.2/js/amazeui.min.js"></script>
<style type="text/css">
    .am-checkbox {
        margin-top: 3px;
    }
    .time-label .am-ucheck-icons {
        top: 10px;
    }
    .time-label input[type='datetime-local'] {
        display: inline-block;
    }
    .reward-limit-box .am-ucheck-icons {
        top: 10px;
    }
    .reward-limit-box label {
        height: 46px;
        line-height: 41px;
    }
    .reward-limit-box input[type='number'] {
        display: inline-block;
        width: 8em;
        text-align: center;
    }
    #id_template_details {
        height: 200px;
    }
    .new-input{
        min-height:5em;
        padding: 0.8em;
        border:thin solid #cbcbcb;
        /*margin-top: 0.5em;*/
    }
    .variable-span{
        display: inline-block;
        padding: 0 0.3em;
        background: #e6e6e6;
        border: thin solid #dedede;
        border-radius: 5px;
        margin-bottom: 4px;
    }

    /*选择用户*/
    .user-p{
        cursor: pointer;
        color: #ffffff;
        padding: 0.5em;
        width: 50%;
        display: inline-block;
        margin: 0.5em 0;
    }
    .active-p{
        background: #5eb95e;!important;
        border: 2px solid crimson;
    }
    .user-p:nth-child(odd){
        background: #0e90d2;
    }
    .user-p:nth-child(even){
        background: #3bb4f2;
    }
    .user-head{
        width: 2em;
        height: 2em;
        background: url(/static/images/null_avatar.png);
        background-size: 100% auto;
        border-radius: 50%;
        margin: 0 0.3em;
    }
    #id_template_preview{
        border: 1px solid #aaaaaa;
        border-radius: 5px;
    }
    #id_template_preview_title{
        padding: 10px 0 0 20px;
        font-size: large;
        font-weight: bold;
    }
    #id_template_preview_content{
        word-wrap: break-word;
        padding: 10px 0 10px 20px;
    }
    #id_template_preview_content span{
        word-wrap: break-word;
    }
    #id_template_preview_url{
        padding: 0 0 5px 20px;
        font-size: smaller;
    }
    #id_template_preview_url span{
        padding: 0 8px 5px 0;
        float: right;

    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">模板设置</strong>
        <span class="am-icon-angle-right"></span>

        <strong class="am-text-default am-text-lg"><?php echo $even_title?></strong>
        <span class="am-icon-angle-right"></span>
        <strong class="am-text-default am-text-lg"><?php echo(!empty($template_user_set['uid']) ? '编辑模板设置' : '添加模板设置') ?></strong>
        <small></small>
    </div>
</div>

<div class="am-form  data-am-validator ">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            选择模板
        </div>
<!--        <div class="am-u-sm-8 am-u-end">-->
<!--            <input type="text" id="id_template_id" placeholder="必填"-->
<!--                --><?php //if (!empty($template_user_set['template_id']))
//                {
//                    echo 'value="' . $template_user_set['template_id'] . '"';
//                } ?><!-->
<!--        </div>-->
        <div class="am-u-sm-4 am-u-end">

            <select id="id_template_id" data-am-selected="{btnSize: 'lg' }">
            </select>
            <button class="am-btn am-btn-primary am-btn-sm template_refresh"> <i class="am-icon-refresh am-icon-spin"></i> 刷新</button>
        </div>
    </div>


    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right" style="display: none">
            模板详细内容
        </div>
        <div class="am-u-sm-4 am-u-end" style="display: none">
            <textarea id="id_template_details" ><?php
//                if (!empty($template_user_set['details']))
//                {
//                    echo $template_user_set['details'];
//                }
            ?></textarea>

        </div>
        <div class="am-u-sm-2 am-text-right">
            预览
        </div>
        <div class="am-u-sm-6 am-u-end">
            <div id="id_template_preview" >
                <div id="id_template_preview_title">

                </div>
                <div id="id_template_preview_content">
                </div>
                <div id="id_template_preview_url">
                  详情<span><i class="am-icon-chevron-right" aria-hidden="true"></i></span>
                </div>

            </div>

        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="display: none">
        <div class="am-u-sm-2 am-text-right">
            初始化配置
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <button type="submit" class="am-btn am-btn-lg am-btn-primary create">生成</button>
            </p>
        </div>
    </div>

    <div class="am-g am-margin-top-sm template_arr" style="margin-bottom: 20px">
        <?php
        $option_html ='<option>选择添加参数</option>';
        foreach($even_args_arr as $arrk=>$arr)
        {
            $option_html .='<option value="EVNE.'.$arrk.'.EVEN">'.$arr['title'].'</option>';
        }
        $select_html = '<select class="option_even ">'. $option_html. '</select>';
        $html = '';
        if(!empty($template_user_set['template_data']))
        {
            foreach($template_user_set['template_data'] as $tak=>$ta)
            {
                $html .= '<div class="makeup-div am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">'.$tak.'
				</div>
				<div class="am-u-sm-6 am-u-end">
				<textarea id="template_arr_value" data-key="'.$tak.'">'.(empty($ta['value'])?'':$ta['value']).'</textarea>
				</div>
				<div class="am-u-sm-2 am-u-end am-form-group">
				'. $select_html.'
				</div>
				<div class="am-u-sm-2 am-u-end">
				<input type="text" class="template_arr_color color" maxlength="6" size="6" id="id_color" value="'.(empty($ta['color'])?'':$ta['color']).'">
				</div>
				</div>
				';
            }
        }
        echo $html;

        ?>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            跳转链接
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_url" placeholder="用户点击模板消息后跳转的链接，可不填"
                <?php if (!empty($template_user_set['url']))
                {
                    echo 'value="' . $template_user_set['url'] . '"';
                } ?>>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            只发给指定用户
        </div>
        <div class="am-u-sm-6 am-u-end">
            <input
                type="text"
                class="select-user"
                id="id_su_uid"
                data-uid="<?php if(!empty($template_user_set['su_uid'])) echo $template_user_set['su_uid'];?>"
                placeholder="点击选择用户，不填默认发给下单的用户"
                readonly
                <?php if (!empty($template_user_set['user']['name'])) echo 'value="' . $template_user_set['user']['name'] . '"';?>
            >

            <label class="am-checkbox-inline" style="padding-top: 0">
                <i class=" am-icon-warning" style="color: orange"></i><a style="margin-top: 0.5em" href="?_a=su&_u=sp.fanslist"  target="_blank">未同步粉丝？</a>
            </label>
        </div>
        <div class="am-u-sm-3 am-u-end">
            <button class="am-btn am-btn-primary clean_su_uid">删除</button>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_status" data-am-ucheck <?php if (empty($template_user_set['status'])) echo 'checked';?>>
                是否开启</label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <button class="am-btn am-btn-lg am-btn-primary save">保存</button>
                <button style="margin-left: 0.5em" onclick="history.back()" class="am-btn am-btn-lg am-btn-primary">取消
                </button>
            </p>
        </div>
    </div>
</div>

<!--选择用户虚拟弹窗-->
<div class="am-popup" id="user-popup">
    <div class="am-popup-inner">
        <div class="am-popup-hd">
            <h4 class="am-popup-title">用户列表</h4>
            <span data-am-modal-close class="am-close">&times;</span>
        </div>
        <div class="am-form">
            <input class="" type="text" placeholder="搜索">
        </div>
        <div style="padding-bottom: 3em" class="am-popup-bd">

        </div>
    </div>
</div>

<?php
echo '<script>
        var even_data = ' . (!empty($even) ? $even : 0) . ';
        var uid = ' . (!empty($template_user_set['uid']) ? $template_user_set['uid'] : 0) . ';
        var public_uid = ' . (!empty($template_user_set['public_uid']) ? $template_user_set['public_uid'] : 0) . ';
        var templateData = ' . (!empty($template_user_set) ? json_encode($template_user_set) : 0) . ';
	</script>';
$extra_js = array(
    '/app/site/view/wapsite/static/js/jscolor.js',

    $static_path . '/js/setcolor.js',
    $static_path . '/js/templateset.js',
    $static_path . '/js/selectuser.js',
);

?>



