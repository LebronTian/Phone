var requestUrl = "?_easy=sp.api.get_xcxpage";
var postUrl = "?_easy=sp.api.add_xcxpage";


function GetQueryString(name) {
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return decodeURI(r[2]); return null;
}

var pageId = GetQueryString("uid");
console.log("page id >>>", pageId);


// 可视化编辑
var nodeStorage = {
    fetch: function () {
        $.post(requestUrl, {uid: pageId}, function (ret) {
            ret = $.parseJSON(ret);

            if (ret.data) {
                var nodes = JSON.parse(ret.data.content);
                console.log("get nodes >>>>>>", nodes);

                nodes.forEach(function(ele) {
                    ele.edited = false;
                    if (ele.settings) {
                        for (var i = 0, len = ele.settings.length; i < len; i++) {
                            if (ele.settings[i].type == "checkbox") {
                                ele.settings[i].value = ele.settings[i].value;
                            }
                        }
                    }
                });
                newApp.nodes = nodes;
            } else {
                newApp.nodes = [];
            }
        });
    },
    save: function (nodes) {
        var nodeString = JSON.stringify(nodes);
        $.post(postUrl, {content: nodeString, title:"首页", public_uid: g_public_uid, uid: pageId}, function (ret) {
            ret = $.parseJSON(ret);
            console.log("save ret >>>>>>", ret);
            if (ret.data && ret.data != 0) {
                if (ret.data != pageId) {
                    pageId = ret.data;
                }
                window.alert("保存成功！");
            }
        });
    }
}

// 预览二维码
var encodeUrl = encodeURIComponent("/page/index/pages/preview/preview");        
var qrcodeUrl = "https://weixin.uctphp.com/?_uct_token=00759ef40eee1d3f971ffabcf901e1df&_u=xiaochengxu.qrcode&type=1&path=" + encodeUrl;


Vue.use(VueDragging)
// app Vue instance
var newApp = new Vue({
    el: '.custom-layout',
    data: {
        qrcode: qrcodeUrl,
        nodes: [],
        addBtns: nodeTypes,
        editedNode: null,
        // htmltext: "<span style='color:red'>red red red</span>"
    },

    // filters: {
    //     pluralize: function (n) {
    //         return n === 1 ? 'item' : 'items'
    //     }
    // },

    methods: {
        // 添加节点
        addNode: function(type) {
            var newNode = new Node(type);
            var editedNode = this.editedNode;

            var insertIdx = editedNode ? (this.nodes.indexOf(editedNode) + 1) : (this.nodes.length);

            this.nodes.splice(insertIdx, 0, newNode);

            this.nodes.forEach(function(node) {
                node.edited = false;
            });
            newNode.edited = true;
            this.editedNode = newNode;
        },
        // 删除节点
        removeNode: function (node) {
            this.nodes.splice(this.nodes.indexOf(node), 1);
            if (node == this.editedNode) {
                this.editedNode = null;
            }
        },
        // 点击编辑节点
        editNodeTap: function(node) {
            this.nodes.forEach(function(node) {
                node.edited = false;
            });
            node.edited = true;
            this.editedNode = node;
            console.log("edited node >>>", node);
        },
        // 添加节点的数据
        addNodeData: function() {
            var item = [];
            this.editedNode.item.forEach(function(obj) {
                let prop = {};
                for (var key in obj) {
                    prop[key] = obj[key];
                }
                item.push(prop);
                console.log("add prop >>>", prop);
            });
            this.editedNode.list.push(item);
        },
        // 删除节点的数据
        removeNodeData: function(nodeData) {
            if (this.editedNode.list.length > 1) {
                this.editedNode.list.splice(this.editedNode.list.indexOf(nodeData), 1);
            }
        },

        // 保存编辑的数据
        saveData: function() {
            console.log("node data >>>>>", this.nodes);
            nodeStorage.save(this.nodes);
        },
    },

    mounted: function() {
        var that = this;
        this.$dragging.$on('dragend', function(data) {
            console.log('dragend nodes >>', that.nodes);
        })
    },

    // a custom directive to wait for the DOM to be updated
    // before focusing on the input field.
    // http://vuejs.org/guide/custom-directive.html
    directives: {
        'todo-focus': function (el, binding) {
            if (binding.value) {
                el.focus()
            }
        }
    }
})

nodeStorage.fetch();
