define(function (require,exports,module) {
    module.exports = {
        cancel: function (uid) {
            if(confirm('您确定要取消订单？')){
                $.post('?_a=shop&_u=ajax.cancel_order',{uid:uid}, function (ret) {
                    ret = JSON.parse(ret);
                    if(ret.errno==0){
                        window.location.reload()
                    }
                })
            }
        },
        pay: function (uid) {
            window.location.replace('?_a=pay&oid=b'+uid)
        },
        accept: function (uid) {
            if(confirm('您确定要确认收货吗？')){
                $.post('?_a=shop&_u=ajax.do_receipt',{uid:uid}, function (ret) {
                    ret = JSON.parse(ret);
                    if(ret.errno==0){
                        window.location.reload()
                    }
                })
            }
        },
        comment: function (uid) {
            window.location.href = '?_a=shop&_u=user.comment&uid='+uid
        }
    };
});