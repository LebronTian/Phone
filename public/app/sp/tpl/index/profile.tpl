
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/profile.css">

<body>
<div class="am-cf am-padding profile-tit">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商户资料</strong> / <small>Personal information</small></div>
    <hr>
</div>
<div class="am-form-horizontal pro-form" action="" data-am-validator>

    <div class="am-form-group">
        <?php 
            if($profile['type']!="1")
                echo '<label for="user-name" class="am-u-sm-3 am-form-label company_name">公司全称</label>';
            else
                echo '<label for="user-name" class="am-u-sm-3 am-form-label person_name">个人全称</label>';
        ?>
        <div class="am-u-sm-9">
            <input type="text" value="<?php echo $profile['fullname'];?>" id="fullname" minlength="3" placeholder="全称 / Fullname" required/>
        </div>
    </div>
 
    <div class="am-form-group" style="color:#333333 !important;">
        <label for="user-trade" class="am-u-sm-3 am-form-label"  style="color:#333333 !important;">行业</label>
        <div class="am-u-sm-9">
            <select id="industry"  data-am-selected="{maxHeight:300}"  style="color:#333333 !important;">
              <?php
                $gn=array();
                $i=0;
                $html='';
                foreach ($industries as $it) {
                  if($gn==null){
                    array_push($gn,$it['name']);
                    $i++;
                    }
                  else{
                    for ($j=0; $j<$i ; $j++) { 
                        if($it['name']!=$gn[$j]){
                            if($j==($i-1)){
                                array_push($gn,$it['name']);
                                $i++;
                            }
                        }
                    }
                  }
                }
                foreach ($gn as $g) {
                    $html.='<optgroup label="'.$g.'">';
                    foreach ($industries as $it) {
                        if($it['name']==$g){
                        $html.='<option value="'.$it['uid'].'" ';
                        if($profile['industry']==$it['uid'])$html.=' selected';
                        $html.='>'.$it['sub_name'].'</option>';
                        }
                    }
                    $html.='</optgroup>';
                }
                echo $html;
            ?>         
<!--              
                
                <option value="b">Banana</option>
                <option value="o">Orange</option>
                <option value="m">Mango</option>
              
              <optgroup label="装备">
                <option value="phone">iPhone</option>
                <option value="im">iMac</option>
                <option value="mbp">Macbook Pro</option>
              </optgroup>
-->
            </select>
        </div>
    </div>

    <!--  <div class="am-form-group">
       <label for="user-name" class="am-u-sm-3 am-form-label">详细地址 / Address</label>
       <div class="am-u-sm-9">
         <input type="text" value="<?php echo ($profile['address']);?>" id="address" minlength="6" placeholder="地址 / Address" required/>
       </div>
     </div> -->
    <div class="am-form-group">
        <label for="user-email" class="am-u-sm-3 am-form-label">电子邮件</label>
        <div class="am-u-sm-9">
            <input type="email" value="<?php echo ($profile['email']);?>" id="email" placeholder="请输入你的电子邮件 / Email" required/>
        </div>
    </div>
    <div class="am-form-group">
        <label for="user-phone" class="am-u-sm-3 am-form-label">联系电话</label>
        <div class="am-u-sm-9">
            <input type="text" value="<?php echo ($profile['phone']);?>" id="phone" pattern="((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)" placeholder="请输入你的电话号码 / Phone" required/>
        </div>
    </div>
    <div class="am-form-group">
        <?php
            if($profile['type']!="1")
                echo '<label for="user-QQ" class="am-u-sm-3 am-form-label company_qq">企业 QQ</label>';
            else
                echo '<label for="user-QQ" class="am-u-sm-3 am-form-label person_qq">个人 QQ</label>';
        ?>
        
        
        <div class="am-u-sm-9">
            <input type="text" value="<?php echo ($profile['qq']);?>" id="QQ" pattern="^\d{5,10}$" placeholder="请输入你的QQ号码" required/>
        </div>
    </div>




    <div class="am-form-group clearfix">
        <label for="user-code" class="am-u-sm-3 am-form-label">二维码</label>
        <div class="am-u-sm-9">
            <button class="imgBoxBtn am-btn am-btn-secondary" data-addr="#codeImg">从图片库选择</button>
            <div id="codeImgBox" style="margin-top: 10px">
                <img id="codeImg" src="<?php echo ($profile['qrcode']);?>" style="width:100px;height:100px;">
            </div>
        </div>
    </div>
    <div class="am-form-group clearfix" style="width:1000px;" id="parent">
        <label for="user-header" class="am-u-sm-3 am-form-label" style="text-align:right;">客户头像</label>
        <div class="am-u-sm-9">
            <button class="imgBoxBtn client-btn am-btn am-btn-secondary" data-addr="#client-avatar,.jcrop-preview">从图片库选择</button>

            <!--估计是插件box，我text
            <div id="headImgBox" >
                <div class="jc-demo-box">
                    <img src="<?php echo ($profile['avatar']);?>" id="target" class="headImg" alt="头像上传" />
                    <div id="default_img"><img src=""></div>
                    <div id="preview-pane">
                        <div class="preview-container clearfix">
                            <img src="<?php echo ($profile['avatar']);?>" class="jcrop-preview" alt="Preview" />
                        </div>
                    </div>
                </div>
            </div>-->

        </div>

        <!--预加载的图片-->
        <div id="default_img" class="def_img" style="margin-left:268px;margin-top: 50px">
            <img id="client-avatar" src="<?php echo ($profile['avatar']);?>" style="width:100px;height: 100px">
            <!--预览框**************-->
            <div id="preview-pane" style="display: none;text-align: center">
                <div class="preview-container">
                    <img src="" class="jcrop-preview" alt="Preview" style="width: 100%;height: 100%">
                </div>
                <button class="am-btn am-btn-warning getNewPic" style="margin-top: 5px">保存</button>
            </div>
        </div>
        <!--剪切button
        <button class="am-btn am-btn-primary" id="fcrop_btn" style="margin-left:268px;margin-top:5px;" data-uidm="">剪切</button>-->
    </div>

    <div class="am-form-group">
        <label for="user-address" class="am-u-sm-3 am-form-label">联系地址</label>
        <div class="am-u-sm-9">
            <!--<input type="text" value="<?php echo ($profile['address']);?>" id="address" size="50" placeholder="示例:广东省深圳市南山区工业六路9号创新谷2楼" required/>-->
            <input type="text" value="<?php echo ($profile['address']);?>" id="address" size="50"required/>
        </div>
    </div>

    <div class="am-form-group">
        <label class="am-u-sm-3 am-form-label">地理位置 经纬度</label>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="p_lat" placeholder="纬度" <?php if(!empty($profile['lat'])) echo 'value="'.$profile['lat'].'"'; ?>>
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="p_lng" placeholder="经度" <?php if(!empty($profile['lat'])) echo 'value="'.$profile['lng'].'"'; ?>>
        </div>
    </div>


    <div class="am-form-group clearfix" id="select_box" style="width:1000px;">
        <label for="user-brief" class="am-u-sm-3 am-form-label" style="text-align:right;">商户资料</label>
        <div class="am-u-sm-9">
            <!--文本编辑/-->
            <script id="container" name="content" type="text/plain" style="height:250px;margin-top:20px;"><?php echo ($profile['brief']);?></script>
        </div>
    </div>
</div>



<button type="submit" class="am-btn am-btn-primary" id="save-btn" style="margin-left:264px;margin-bottom:20px;">保存修改</button>

<img style="display: none" class="justforselect" src=""/>

<script type="text/javascript">
    var profileJSON = <?php echo (!empty($profile) ? json_encode($profile) : "null") ?>;
</script>

<?php
  $extra_js = array(

            '/app/sp/static/js/jquery.Jcrop.js',
            '/app/sp/static/js/jquery.provincesCity.js',
            '/app/sp/static/js/provincesdata.js',
            '/static/js/ueditor/ueditor.config.js',
            '/static/js/ueditor/ueditor.all.js',
            '/app/sp/static/js/linkagesel.js',
            '/app/sp/static/js/district-all.js',
            '/app/sp/static/js/smalltitle.js',

            'http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ',
            '/static/js/baidumap/SearchInfoWindow_min.js',
            '/static/js/choose_address.js',
            '/static/js/geo.js',
           	'/app/sp/static/js/profile.js'
            );
?>


<script>
    seajs.use(['selectPic']);
</script>

</body>




