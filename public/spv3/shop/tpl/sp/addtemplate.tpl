<link rel="stylesheet" href="/spv3/shop/static/css/addtemplate.css"/>
<link rel="stylesheet" href="/app/shop/static/css/select2.min.css"/>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($delivery) ? '编辑': '添加')?>模板</strong> / </div>
</div>


<div class="am-form" id="addtemplate-body" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            模板名称
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="template_title" placeholder="必填" minlength="1" required <?php if(!empty($delivery)) echo 'value="'.$delivery['title'].'"';?> >
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            模板简述
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="template_brief" placeholder="选填" <?php if(!empty($delivery)) echo 'value="'.$delivery['brief'].'"';?> />
        </div>
    </div>
    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            模板类型
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-radio am-radio-inline" style="margin-top: 0">
                <input type="radio" name="template-type" value="1" data-am-ucheck checked> 统一运费模板
            </label>
            <label class="am-radio am-radio-inline">
                <input type="radio" name="template-type" value="2" data-am-ucheck> 特殊运费模板
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm template-type1 templateType">
        <div class="am-u-sm-2 am-text-right">
            统一运费模板
        </div>
        <div class="am-u-sm-8 am-u-end temp-input-group-self">
            <div class="am-cf">
                <label class="am-checkbox am-fl">
                    <input type="checkbox" name="cbx-template-type" value="0" data-type="1" data-am-ucheck required minchecked="1"> 平邮
                </label>
                <input class="price-input js-pattern-number am-fl" type="text"/>
                <span class="yuan-text">元</span>
            </div>
            <div class="am-cf">
                <label class="am-checkbox am-fl">
                    <input type="checkbox" name="cbx-template-type" value="1" data-type="2" data-am-ucheck> 普通快递
                </label>
                <input class="price-input js-pattern-number am-fl" type="text"/>
                <span class="yuan-text">元</span>
            </div>
            <div class="am-cf">
                <label class="am-checkbox am-fl">
                    <input type="checkbox" name="cbx-template-type" value="2" data-type="3" data-am-ucheck> EMS
                </label>
                <input class="price-input js-pattern-number am-fl" type="text"/>
                <span class="yuan-text">元</span>
            </div>
        </div>
        <!-- <div class="am-u-sm-8 am-u-end" style="width: 120px">
            <div class="am-form-group">
                <label class="am-checkbox margin-bottom" style="margin-top: 0">
                    <input type="checkbox" name="cbx-template-type" value="0" data-type="1" data-am-ucheck required minchecked="1"> 平邮
                </label>
                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="cbx-template-type" value="1" data-type="2" data-am-ucheck> 普通快递
                </label>
                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="cbx-template-type" value="2" data-type="3" data-am-ucheck> EMS
                </label>
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end" style="width: 80px;padding: 0">
            <input class="price-input js-pattern-number" type="text"/>
            <input class="price-input js-pattern-number" type="text"/>
            <input class="price-input js-pattern-number" type="text"/>
        </div>
        <div class="am-u-sm-8 am-u-end yuan-text">
            元<br/>
            元<br/>
            元
        </div> -->
    </div>

    <div class="am-g am-margin-top-sm template-type2 templateType" style="display: none">
        <div class="am-u-sm-2 am-text-right">
            特殊运费模板
        </div>
        <div class="am-u-sm-8 am-u-end"  style="margin-top: 5px">
            <div class="am-form-group">
                <label class="am-checkbox am-radio-inline"  style="margin-top: 0">
                    <input type="checkbox" name="delivery" value="1" data-am-ucheck required minchecked="1"> 平邮
                </label>
                <label class="am-checkbox am-radio-inline">
                    <input type="checkbox" name="delivery" value="2" data-am-ucheck> 普通快递
                </label>
                <label class="am-checkbox am-radio-inline">
                    <input type="checkbox" name="delivery" value="3" data-am-ucheck> EMS
                </label>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm template-type2 templateType" style="margin-top: 0">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <table class="am-table am-table-striped am-table-hover am-table-bordered am-table-radius postage-table" id="postage-table1">
                <thead>
                <tr class="am-primary">
                    <td colspan="5">平邮运费设置</td>
                </tr>
                <tr>
                    <td>配送区域</td>
                    <td>首N件</td>
                    <td>首费（￥）</td>
                    <td>续N件</td>
                    <td>续费（￥）</td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>全国默认地区</td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                </tr>
                <tr class="add-more-delivery">
                    <td colspan="5">为指定地区设置运费</td>
                </tr>
                </tbody>
            </table>
            <table class="am-table am-table-striped am-table-hover am-table-bordered am-table-radius postage-table" id="postage-table2">
                <thead>
                <tr class="am-primary">
                    <td colspan="5">普通快递运费设置</td>
                </tr>
                <tr>
                    <td>配送区域</td>
                    <td>首N件</td>
                    <td>首费（￥）</td>
                    <td>续N件</td>
                    <td>续费（￥）</td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>全国默认地区</td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                </tr>
                <tr class="add-more-delivery">
                    <td colspan="5">为指定地区设置运费</td>
                </tr>
                </tbody>
            </table>
            <table class="am-table am-table-striped am-table-hover am-table-bordered am-table-radius postage-table" id="postage-table3">
                <thead>
                <tr class="am-primary">
                    <td colspan="5">EMS运费设置</td>
                </tr>
                <tr>
                    <td>配送区域</td>
                    <td>首N件</td>
                    <td>首费（￥）</td>
                    <td>续N件</td>
                    <td>续费（￥）</td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>全国默认地区</td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                    <td><div class="spe-td"><input class="normal-deli js-pattern-number" type="text" placeholder="必填"/></div></td>
                </tr>
                <tr class="add-more-delivery">
                    <td colspan="5">为指定地区设置运费</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary template-save" >保存</button>
        </div>
    </div>

</div>

<!--指定地址选择弹出框****************-->
<div class="am-popup" id="addr-popup" style="height: 600px">
    <div class="am-popup-inner">
        <div class="am-popup-hd">
            <h4 class="am-popup-title">选择指定区域</h4>
            <span data-am-modal-close class="am-close" style="color: #000">&times;</span>
        </div>
        <div class="am-popup-bd addr-box-body">
            <div class="popup-left">
                <div class="addr-box">
                    <p class="addr-box-p">省、直辖市、市</p>
                    <div class="addr-list-box">
                        <!--example
                        <div class="first-level-box">
                            <p class="am-icon-plus-circle parent-addr">&nbsp;北京</p>
                            <div class="second-level-box">
                                <dl class="child-addr">&nbsp;北京</dl>
                                <dl class="child-addr">&nbsp;北京</dl>
                                <dl class="child-addr">&nbsp;北京</dl>
                                <dl class="child-addr">&nbsp;北京</dl>
                            </div>
                        </div>
                        <div class="first-level-box">
                            <p class="parent-addr">&nbsp;北京</p>
                        </div>-->
                    </div>
                </div>
            </div>
            <div class="popup-right">
                <div class="addr-box">
                    <p class="addr-box-p">已选择<span id="addr-count">0</span>个</p>
                    <div class="addr-selected-list">
                    <!--example
                        <p>北京<span class="am-icon-times-circle added-addr"></span></p>
                        <p data-parent="好的">北京<span class="am-icon-times-circle added-addr"></span></p>-->
                    </div>
                </div>
            </div>
            <button class="am-btn am-btn-success addr-add-btn">添加</button>
        </div>
        <div class="am-modal-footer" style="margin-top: 14px;border-top: 1px solid #dedede">
            <span class="am-modal-btn">取消</span>
            <span class="yhc-am-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>



<?php

    echo'
    <script>
        var delivery = '.json_encode($delivery).';
    </script>';


    $extra_js = array(
        '/spv3/shop/static/js/district-all.js',

        '/spv3/shop/static/js/addtemplate.js'
        );
?>
