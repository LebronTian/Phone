$(document).ready(function () {
    /*启用禁用按钮*********************/
    var uid;
    var price;
    var sum_bonus_l = 0;
    var sum_bonus_r = 0;
    $('.pStatus').click(function () {
        uid = $(this).parent().parent().data("uid");
        price = $(this).parent().parent().children('.td_price').text();
        var status;
        if ($(this).hasClass("am-btn-warning")) {
            add_or_edit_agent_product(uid);
            return;
        }
        if ($(this).hasClass("am-btn-success")) {
            status = 2
        } else {
            status = 0
        }
        var data = {uid: uid, status: status};
        $.post('?_a=shop&_u=api.add_or_edit_agent_product', data, function (ret) {
            console.log(ret);
            window.location.reload();
        });
    });
    /*分类选择弹出框*/


    $(".edit").on('click', function () {

        uid = $(this).parent().parent().parent().parent().data("uid");
        price = $(this).parent().parent().parent().parent().children('.td_price').text();


        add_or_edit_agent_product(uid);
        do_get()
        return;
    });

    function add_or_edit_agent_product(uid) {
        init_EditAgentProduct();
        $('#EditAgentProduct .product_price').text(price);
        $('.EditAgentProduct_tips').empty();
        $('#EditAgentProduct').find('[data-am-modal-confirm]').data('uid', uid);
        var ret_data;
        $.ajaxSetup({
            async: false
        });
        console.log(uid);
        $.post('?_a=shop&_u=api.get_shop_agent_product', {uid: uid}, function (ret) {
            console.log(ret);
            ret = $.parseJSON(ret);
            ret_data = ret;
        });
        if (ret_data.errno != 0) {
            return;
        }
        console.log(ret_data.data);
        if (ret_data.data != false) {
            data = ret_data.data;
            (data.price_l != undefined) && $('#EditAgentProduct .price_l').val(parseFloat(data.price_l / 100).toFixed(2));
            (data.price_h != undefined) && $('#EditAgentProduct .price_h').val(parseFloat(data.price_h / 100).toFixed(2));
            console.log(Boolean(parseInt(data.rule_data.cost.status)));
            (data.rule_data.cost != undefined) && (data.rule_data.cost.status != undefined) && $('#EditAgentProduct .agent_cost input').first().prop("checked", Boolean(parseInt(data.rule_data.cost.status)));
            (data.rule_data.paid_fee != undefined) && (data.rule_data.paid_fee.status != undefined) && $('#EditAgentProduct .agent_paid_fee input').first().prop("checked", Boolean(parseInt(data.rule_data.paid_fee.status)));
            (data.rule_data.bonus != undefined) && (data.rule_data.bonus.status != undefined) && $('#EditAgentProduct .agent_bonus input').first().prop("checked", Boolean(parseInt(data.rule_data.bonus.status)));
            (data.rule_data.paid_fee != undefined) && (data.rule_data.paid_fee.weight != undefined) && $('#EditAgentProduct .agent_paid_fee input').last().val(parseFloat(data.rule_data.paid_fee.weight / 100).toFixed(2));
            (data.rule_data.bonus != undefined) && (data.rule_data.bonus.value != undefined) && $('#EditAgentProduct .agent_bonus input').last().val(parseFloat(data.rule_data.bonus.value / 100).toFixed(2));

        }


        var error = 0;
        var $promt = $('#EditAgentProduct').modal({
            relatedTarget: this,
            width: 1200,

        });

        $promt.find('[data-am-modal-confirm]').off('click.close.modal.amui');

    };

    var $confirm = $('#EditAgentProduct');
    var $confirmBtn = $confirm.find('[data-am-modal-confirm]');
    $confirmBtn.off('click.confirm.modal.amui').on('click', function () {
        //var uid = $('#EditAgentProduct').find('[data-am-modal-confirm]').data('uid');
        $('.EditAgentProduct_tips').empty();
        var price_l = parseInt($(".price_l").val());
        var price_h = parseInt($(".price_h").val());


        if (price_l > price_h
            || price_l == undefined
            || price_h == undefined
            || price_l == ''
            || price_h == ''
            || price_l<price
        ) {
            $('.EditAgentProduct_tips').append('<span class="am-btn am-btn-danger"><p>价格区间设置有误</p><p>1.不要为0或为空</p><p>2.不低于原价</p><p>2.最低价格不高于最高</p></span>');
            error = 1;
            return;
        }

        var weight = $('.agent_paid_fee input').last().val();
        var value = $('.agent_bonus input').last().val();
        var cost = {
            status: $('.agent_cost input').first().prop('checked') ? 1 : 0,
        };
        var paid_fee = {
            status: $('.agent_paid_fee input').first().prop('checked') ? 1 : 0,
            weight: (isNaN(weight) ? 0 : weight) * 100
        };
        var bonus = {
            status: $('.agent_bonus input').first().prop('checked') ? 1 : 0,
            value: (isNaN(value) ? 0 : value) * 100
        };
        //console.log(paid_fee.weight);

        if (paid_fee.status == 1 && (paid_fee.weight > 10000 || paid_fee.weight <= 0)) {
            $('.EditAgentProduct_tips').append('<span class="am-btn am-btn-danger">分红比例设置有误，请重新设置。</span>');
            return;
        }
        //return;
        var rule_data = {
            cost: cost,
            paid_fee: paid_fee,
            bonus: bonus
        }

        var data = {
            uid: uid,
            rule_data: rule_data,
            price_h: price_h * 100,
            price_l: price_l * 100
        };
        console.log(data);
        $.post('?_a=shop&_u=api.add_or_edit_agent_product', data, function (ret) {
            console.log(ret);
            ret = $.parseJSON(ret);
            if (ret.errno == 0) {
                showTip("", "保存成功", "1000");
                setTimeout(function () {
                    $('#EditAgentProduct').modal('close');
                    window.location.reload();
                }, 1000);
            }
            else {
                $('.EditAgentProduct_tips').append('<span class="am-btn am-btn-danger">保存失败</span>');
            }
        });
    })
    $('#EditAgentProduct input').change(function () {
        do_get();
    });

    function do_get() {
        sum_bonus_l = 0;
        sum_bonus_r = 0;

        console.log(sum_bonus_l, sum_bonus_r);

        get_product_cost();
        console.log(sum_bonus_l, sum_bonus_r);

        get_product_paid_fee();
        console.log(sum_bonus_l, sum_bonus_r);

        get_product_bonus();
        console.log(sum_bonus_l, sum_bonus_r);

        get_product_sum_bonus();
    }


    function get_product_cost() {
        var text = '0';
        if ($('#EditAgentProduct .agent_cost input').first().prop("checked") == true) {
            var l = ($('#EditAgentProduct .price_l').val() - price).toFixed(2);
            var r = ($('#EditAgentProduct .price_h').val() - price).toFixed(2);
            sum_bonus_l += parseFloat(l);
            sum_bonus_r += parseFloat(r);
            text = (l + '~' + r);
        }
        $('#EditAgentProduct .product_cost ').text(text);

    }

    function get_product_paid_fee() {
        var text = '0';
        if ($('#EditAgentProduct .agent_paid_fee input').first().prop("checked") == true) {
            var l = ($('#EditAgentProduct .price_l').val()   * $('#EditAgentProduct .agent_paid_fee input').last().val() / 100).toFixed(2);
            var r = ($('#EditAgentProduct .price_h').val()   * $('#EditAgentProduct .agent_paid_fee input').last().val() / 100).toFixed(2);
            sum_bonus_l += parseFloat(l);
            sum_bonus_r += parseFloat(r);
            text = l + '~' + r;
        }

        $('#EditAgentProduct .product_paid_fee ').text(text);
    }

    function get_product_bonus() {
        if ($('#EditAgentProduct .agent_bonus input').first().prop("checked") == true) {
            var v = parseFloat($('#EditAgentProduct .agent_bonus input').last().val());
            sum_bonus_l += v;
            sum_bonus_r += v;

            $('#EditAgentProduct .product_bonus ').text(v);

        }
        else {
            $('#EditAgentProduct .product_bonus ').text(0);

        }
    }

    function get_product_sum_bonus() {
        $('#EditAgentProduct .sum_bonus ').text(sum_bonus_l.toFixed(2) + '~' + sum_bonus_r.toFixed(2));
    }


    function init_EditAgentProduct() {
        $('#EditAgentProduct .price_l').val(0);
        $('#EditAgentProduct .price_h').val(0);


    }
});

