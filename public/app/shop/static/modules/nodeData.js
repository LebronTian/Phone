
var Node = function(type) {
    this.id = type;
    this.edited = false;
    // this.html = "<span style='color:red'>red red red</span>";
    this.styles = { 
        width: {title: "宽度", key: "width", value: "100", unit: "%"},
        height: {title: "高度", key: "height", value: "100", unit: "rpx"},
        marginTop: {title: "上边距", key: "margin-top", value: "0", unit: "rpx"},
        marginLeft: {title: "左边距", key: "margin-left", value: "0", unit: "rpx"},
        borderRadius: {title: "圆角", key: "border-radius", value: "0", unit: "%"},
        borderStyle: {title: "边框样式", key: "border-style", value: "none", unit: ""},
        borderWidth: {title: "边框宽度", key: "border-width", value: "0", unit: "rpx"},
        borderColor: {title: "边框颜色", key: "border-color", value: "#000000", unit: ""},
        opacity: {title: "透明度", key: "opacity", value: "1", unit: ""}
    };

    console.log("Node type >>>", type);
    switch(type) {
        case "search":
            this.title = "搜索框";
            this.list = [];
            this.item = [];
            this.styles.height.value = "96";
            break;
        case "radio":
            this.title = "广播";
            this.list = [[{title: "广播标题", key:"title", data:"小程序商城广播"}, {title:"广播链接(选填)", key:"link", data: "article001"}], [{title: "广播标题", key:"title", data:"小程序商城广播"}, {title:"广播链接(选填)", key:"link", data: "article001"}]];
            this.item = [{title: "广播标题", key:"title", data:""}, {title:"广播链接(选填)", key:"link", data: ""}];
            this.settings = [{title: "广播icon图片链接", key: "icon", value: "http://via.placeholder.com/50x50", type: "string"}, {title: "是否自动切换", key:"autoplay", value:true, type:"checkbox"}, {title: "自动切换时间间隔", key:"interval", value:"5000", type:"number"}, {title: "滑动动画时长", key:"duration", value:"500", type:"number"}, {title: "是否采用衔接滑动", key:"circular", value:true, type:"checkbox"}];
            this.styles.height.value = "90";
            this.styles.color = {title: "文字颜色", key: "color", value: "#000000", unit: ""};
            this.styles.fontSize = {title: "文字大小", key: "font-size", value: "32", unit: "rpx"};
            this.styles.backgroundColor = {title: "背景颜色", key: "background-color", value: "#ffffff", unit: ""};
            break;
        case "text":
            this.title = "文本框（标题）";
            this.list = [[{title: "文本", key:"title", data:"热销"}, {title:"跳转链接(选填)", key:"link", data: "article001"}]];
            this.item = [];
            this.styles.height.value = "90";
            this.styles.color = {title: "文字颜色", key: "color", value: "#000000", unit: ""};
            this.styles.fontSize = {title: "文字大小", key: "font-size", value: "32", unit: "rpx"};
            this.styles.backgroundColor = {title: "背景颜色", key: "background-color", value: "#ffffff", unit: ""};
            this.styles.textIndent = {title: "文字缩进", key: "text-indent", value: "0", unit: "rpx"};
            this.styles.textAlign = {title: "文字对齐方式", key: "text-align", value: "center", unit: ""};
            break;
        case "swiper":
            this.title = "轮播图";
            this.list = [[{title:"轮播图链接", key:"img", data:"http://via.placeholder.com/375x200"}, {title:"轮播图跳转链接(选填)", key:"link", data:"article001"}], [{title:"轮播图链接", key:"img", data:"http://via.placeholder.com/375x200"}, {title:"轮播图跳转链接(选填)", key:"link", data:"article001"}]];
            this.item = [{title:"轮播图链接", key:"img", data:""}, {title:"轮播图跳转链接(选填)", key:"link", data:""}];
            this.settings = [{title: "是否显示面板指示点", key:"indicatorDots", value:false, type:"checkbox"}, {title: "是否自动切换", key:"autoplay", value:false, type:"checkbox"}, {title: "自动切换时间间隔", key:"interval", value:"5000", type:"number"}, {title: "滑动动画时长", key:"duration", value:"500", type:"number"}, {title: "是否采用衔接滑动", key:"circular", value:false, type:"checkbox"}, {title: "滑动方向是否为纵向", key:"vertical", value:false, type:"checkbox"}, ];
            this.styles.height.value = "400";
            break;
        case "video":
            this.title = "视频播放器";
            this.list = [];
            this.item = [];
            this.settings = [{title: "视频资源地址", key:"src", value:"www.mp4", type:"string"}, {title: "自动播放", key:"autoplay", value:false, type:"checkbox"}, {title: "循环播放", key:"loop", value:false, type:"checkbox"}, {title: "静音播放", key:"muted", value:false, type:"checkbox"}, {title: "指定视频初始播放位置", key:"initialTime", value:"0", type:"number"}, ];
            this.styles.height.value = "450";
            break;
        case "navigations":
            this.title = "导航栏";
            this.list = [[{title:"导航图片链接", key:"img", data:"http://via.placeholder.com/50x50"}, {title:"导航标题", key:"title", data:"秒杀"}, {title:"导航链接", key:"link", data:"page/index/index"}], [{title:"导航图片链接", key:"img", data:"http://via.placeholder.com/50x50"}, {title:"导航标题", key:"title", data:"秒杀"}, {title:"导航链接", key:"link", data:"page/index/index"}]];
            this.item = [{title:"导航图片链接", key:"img", data:""}, {title:"导航标题", key:"title", data:""}, {title:"导航链接", key:"link", data:""}];
            this.styles.height.value = "auto";
            this.styles.height.unit = "";
            this.styles.itemColor = {title: "文字颜色", key: "color", value: "#000000", unit: ""};
            this.styles.itemFontSize = {title: "文字大小", key: "font-size", value: "32", unit: "rpx"};
            this.styles.itemWidth = {title: "导航项宽度", key: "width", value: "50", unit: "rpx"};
            this.styles.itemHeight = {title: "导航项高度", key: "height", value: "50", unit: "rpx"};
            this.styles.itemMarginTop = {title: "导航项上边距", key: "margin-top", value: "15", unit: "rpx"};
            // this.styles.itemMarginLeft = {title: "导航项左边距", key: "margin-left", value: "0", unit: "rpx"};
            this.styles.imgWidth = {title: "导航图片高度", key: "width", value: "50", unit: "rpx"};
            this.styles.imgHeight = {title: "导航图片高度", key: "height", value: "50", unit: "rpx"};
            break;
        case "goods":
            this.title = "商品列表(一行三列)";
            this.list = [];
            this.item = [];
            this.settings = [{title:"呈列商品编号(请用英文分号隔开)", key:"uids", value: "", type:"textarea"}];
            this.styles.height.value = "auto";
            this.styles.height.unit = "";
            break;
        case "goods1":
            this.title = "商品列表(一行一列)";
            this.list = [];
            this.item = [];
            this.settings = [{title:"呈列商品编号(请用英文分号隔开)", key:"uids", value: "", type:"textarea"}];
            this.styles.height.value = "auto";
            this.styles.height.unit = "";
            break;
        case "goods2":
            this.title = "商品列表(一行两列)";
            this.list = [];
            this.item = [];
            this.settings = [{title:"呈列商品编号(请用英文分号隔开)", key:"uids", value: "", type:"textarea"}];
            this.styles.height.value = "auto";
            this.styles.height.unit = "";
            break;
        case "image1":
            this.title = "图片样式一";
            this.list = [[{title: "图片链接", key:"url", data:"http://via.placeholder.com/750x460"}, {title:"跳转链接(选填)", key:"link", data: "article001"}]];
            this.item = [];
            this.styles.height.value = "460";
            break;
        case "image2":
            this.title = "图片样式二";
            this.list = [
                            [
                                {title: "左图片链接", key:"url1", data:"http://via.placeholder.com/360x220"},
                                {title:"左图片跳转链接(选填)", key:"link1", data: "article001"},
                                {title: "右图片链接", key:"url2", data:"http://via.placeholder.com/360x220"},
                                {title: "右图片跳转链接(选填)", key:"link2", data:"article001"}
                            ]
                        ];
            this.item = [];
            break;
        case "image3":
            this.title = "图片样式三";
            this.list = [
                            [
                                {title: "左图片链接", key:"url1", data:"http://via.placeholder.com/430x550"},
                                {title:"左图片跳转链接(选填)", key:"link1", data: "article001"},
                                {title: "右上图片链接", key:"url2", data:"http://via.placeholder.com/360x220"},
                                {title: "右上图片跳转链接(选填)", key:"link2", data:"http://via.placeholder.com/360x220"},
                                {title: "右下图片链接", key:"url3", data:"http://via.placeholder.com/360x220"},
                                {title: "右下图片跳转链接(选填)", key:"link3", data:"http://via.placeholder.com/360x220"}
                            ]
                        ];
            this.item = [];
            break;
        case "image4":
            this.title = "图片样式四";
            this.list = [
                            [
                                {title: "左上图片链接", key:"url1", data:"http://via.placeholder.com/430x550"},
                                {title:"左上图片跳转链接(选填)", key:"link1", data: "article001"},
                                {title: "右上图片链接", key:"url2", data:"http://via.placeholder.com/360x220"},
                                {title: "右上图片跳转链接(选填)", key:"link2", data:"http://via.placeholder.com/360x220"},
                                {title: "左下图片链接", key:"url3", data:"http://via.placeholder.com/430x550"},
                                {title:"左下图片跳转链接(选填)", key:"link3", data: "article001"},
                                {title: "右下图片链接", key:"url4", data:"http://via.placeholder.com/360x220"},
                                {title: "右下图片跳转链接(选填)", key:"link4", data:"http://via.placeholder.com/360x220"}
                            ]
                        ];
            this.item = [];
            break;
    }
    console.log("create node done");
}


var nodeTypes = [
    {
        id: "search",
        title: "搜索框",
    }, {
        id: "radio",
        title: "广播",
    }, {
        id: "text",
        title: "文本框（标题）",
    }, {
        id: "swiper",
        title: "轮播图",
    }, {
        id: "navigations",
        title: "导航栏",
    }, {
        id: "goods1",
        title: "商品列表(一行一列)",
    }, {
        id: "goods2",
        title: "商品列表(一行两列)",
    }, {
        id: "goods",
        title: "商品列表(一行三列)",
    }, {
        id: "image1",
        title: "图片组件(一张)",
    }, {
        id: "image2",
        title: "图片组件(二张)",
    }, {
        id: "image3",
        title: "图片组件(三张)",
    }, {
        id: "image4",
        title: "图片组件(四张)",
    }, {
        id: "video",
        title: "视频播放器",
    }, 
];