<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">公众号列表</strong> / </div>
</div>
<?php
#var_export($option);
#var_export($cats);
#var_export($data['list']);
$cats = array(0 => '伪公众号', 1 => '订阅号', 2 => '服务号', 3 => '企业号', 8 => '小程序');

?>

<style>
    .public-title{
        font-size: 1em;
        color: #696868;
    }
    .title-number{
        font-size: 1.5em;
    }

</style>

<div class="am-u-sm-12">
    <p class="public-title">
        <span style="color: #5eb95e" class="title-number"><?php echo $cnt ?></span>（已有的公众号）
        /
        <span>&nbsp;<?php echo $max_public_cnt ?></span>（公众号配额）
    </p>
    <a href="?_a=sp&_u=index.addpublic"><button class="am-btn am-btn-secondary" <?php if($cnt>=$max_public_cnt) echo 'disabled' ?>>添加公众号</button></a>
    <a href="?_a=sp&_u=index.servicedetail&uid=4"><button class="am-btn am-btn-success">购买公众号配额</button></a>

    <table class="am-table am-table-striped am-table-hover table-main">
        <thead>
        <tr>
            <!--<th class="table-check"><input type="checkbox"></th>-->
            <th class="table-title">名称</th>
            <th class="table-title">appid</th>
            <th class="table-type">类型</th>
            <th class="table-date">介绍</th>
            <th class="table-set">操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(!$list) {
            echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
        }
        else {
            $html = '';
            foreach($list as $l) {
                $html .= '<tr class="';
                if($l['uct_token']==$uct_tokens){
                    $html.='am-success ';
                }else if($l['access_mod']==-1){
                    $html.='am-danger" data-am-popover="{content: \'此公众号已取消授权\', trigger: \'hover focus\'}';
                }
                $html .= '">
              <td><a href="?_a=sp&_u=index.addpublic&uid='.$l['uid'].'">'.$l['public_name'].'</a></td>
              <td>'.$l['app_id'].($l['access_mod'] == 1 ? ' <span class="am-btn-xs am-btn-success">自动授权</span>' : '').'</td>
              <td><span>'.(isset($cats[$l['public_type']]) ? $cats[$l['public_type']] : '').'</span></td>
              <td>'.$l['weixin_brief'].'</td>
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs">';
                $html .= '<a href="?_a=sp&_u=index.addpublic&uid='.$l['uid'].'" class="am-btn am-btn-primary am-btn-xs"><span class="am-icon-edit"></span> 编辑</a>';
                if(!empty($_REQUEST['_d'])) {
                    $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
                }
                if($l['uct_token']==$uct_tokens){
                    $html.='<button style="margin-left: 0.5em" class="am-btn am-btn-warning">默认</button>';
                }else{
                    $html.='<button data-uid="'.$l['uid'].'" style="margin-left: 0.5em" class="default-btn am-btn am-btn-success">设为默认</button>';
                }
                if($l['access_mod']==-1){
                    $html.='
                <a href="https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=wxa6dae76787aaf8cd&pre_auth_code='.(!empty($component['pre_auth_code'])? $component['pre_auth_code'] : "").'&redirect_uri='.urlencode('http://weixin.uctphp.com/rewrite.web.component.uricallbcak.sp_uid='.(empty($component['sp_uid'])?'':$component['sp_uid'])).'.php">
                    <button style="margin-left:0.5em" class="am-btn am-btn-danger am-btn-xs">重新授权</button>
                </a>';

                }
                $html .= '
                  </div>
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

<?php
$extra_js = $static_path.'/js/publiclist.js';
?>


<script>
 //   var list =<?php //echo(!empty($list) ? json_encode($list) : "null") ?>;
 //   var uct_token =<?php //echo(!empty($uct_token) ? json_encode($uct_token) : "null") ?>;
</script>
