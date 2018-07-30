// page/cart/pages/reward/reward.js
var app = getApp();
var util = require('../../../../utils/util.js');
var WxParse = require('../../../common/wxParse/wxParse.js');


Page({

    data: {
        circleList: [],//圆点数组
        awardList: [],//奖品数组
        colorCircleFirst: '#FFDF2F',//圆点颜色1
        colorCircleSecond: '#FE4D32',//圆点颜色2
        colorAwardDefault: '#F5F0FC',//奖品默认颜色
        colorAwardSelect: '#ffe400',//奖品选中颜色
        indexSelect: 0,//被选中的奖品index
        isRunning: false,//是否正在抽奖
        isDoingReward: false,
        
        isEditForm: false,
        showShadow: false,
        showRule: false,
        showIntro: false,
        showMyAward: false
    },

    onLoad: function (options) {
        this.setData({
            mainColor: app.globalData.main_color,
            awardId: options.rewardId
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
    },

    onShow: function () {
        var that = this;
        this.getAwardInfo(that.data.awardId);
        this.initReward();
        this.getMyAward(that.data.awardId);
    },

    // 获取中奖用户列表
    getAwardUsers: function(rid) {
        var that = this;
        app.request({
            url: "_a=reward&_u=ajax.get_user_record_list",
            data: {
                r_uid: rid,
                all: true
            },
            success: (ret)=>{
                console.log("getAwardUsers >>>>>", ret);
                if (!ret.data || !ret.data.list) return;
                var userList = ret.data.list;
                
                // 处理姓名
                userList.forEach(function(ele) {
                    if (ele.user.name.length > 1) {
                        ele.name = ele.user.name.slice(0, 1) + "***" + ele.user.name.slice(-1);
                    } else {
                        ele.name = "*";
                    }
                });
                        
                that.setData({
                    userList: ret.data.list
                });
            }
        });
    },

    // 获取我的抽奖记录
    getMyAward: function(rid) {
        var that = this;

        app.request({
            url: "_a=reward&_u=ajax.get_user_record_list",
            data: {
                r_uid: rid
            },
            success: (ret)=>{
                console.log("my record list >>>>>", ret);
                if (!ret.data || !ret.data.list.length) return;
                var myAwardList = ret.data.list;
                myAwardList.forEach(function(ele) {
                    ele.img = ele.item.img.startsWith("http") ? ele.item.img : (app.globalData.prefix_url + ele.item.img);
                    let time = util.formatTime(ele.create_time);
                    ele.time = time.join("-");
                });
                that.setData({
                    myAwardList: myAwardList
                });
            }
        });
    },

    // 获取抽奖内容
    getAwardInfo: function(rid) {
        var that = this;

        app.request({
            url: "_a=reward&_u=ajax.get_reward",
            data: {
                r_uid: rid
            },
            success: (ret)=>{
                console.log("getAwardInfo ret >>>>>", ret);
                var award = ret.data;
                var awardList = award.items.list.slice(0);

                that.setAwardList(awardList);
                that.getAwardUsers(rid);
                if (award.access_rule.start_time == 0) {
                    award.startTime = "无";
                } else {
                    var startTime = util.formatTime(award.access_rule.start_time);
                    // startTime.pop();
                    award.startTime = startTime.join(".");
                }

                if (award.access_rule.end_time == 0) {
                    award.endTime = "永久有效";
                } else {
                    var endTime = util.formatTime(award.access_rule.end_time);
                    // endTime.pop();
                    award.endTime = endTime.join(".");
                }


                WxParse.wxParse('article', 'html', award.brief, that); 
                wx.setNavigationBarTitle({
                    title: award.title
                });

                that.setData({
                    awardId: award.uid,
                    award: award,
                    winRule: award.win_rule
                });
            }
        });
    },

    // 初始化抽奖跑马灯样式
    initReward: function () {
        var that = this;
        //圆点设置
        var leftCircle = 7.5;
        var topCircle = 7.5;
        var circleList = [];

        for (var i = 0; i < 24; i++) {
            if (i == 0) {
                topCircle = 15;
                leftCircle = 15;
            } else if (i < 6) {
                topCircle = 7.5;
                leftCircle = leftCircle + 102.5;
            } else if (i == 6) {
                topCircle = 15
                leftCircle = 620;
            } else if (i < 12) {
                topCircle = topCircle + 94;
                leftCircle = 620;
            } else if (i == 12) {
                topCircle = 565;
                leftCircle = 620;
            } else if (i < 18) {
                topCircle = 570;
                leftCircle = leftCircle - 102.5;
            } else if (i == 18) {
                topCircle = 565;
                leftCircle = 15;
            } else if (i < 24) {
                topCircle = topCircle - 94;
                leftCircle = 7.5;
            } else {
                return;
            }
            circleList.push({ topCircle: topCircle, leftCircle: leftCircle });
        }
        
        this.setData({
            circleList: circleList
        });

        //圆点闪烁
        setInterval(function () {
            if (that.data.colorCircleFirst == '#FFDF2F') {
                that.setData({
                    colorCircleFirst: '#FE4D32',
                    colorCircleSecond: '#FFDF2F',
                });
            } else {
                that.setData({
                    colorCircleFirst: '#FFDF2F',
                    colorCircleSecond: '#FE4D32',
                });
            }
        }, 500);

    },

    // 设置奖项内容
    setAwardList: function(list) {
        // list.length
        for (var i = 0; i < 8; i++) {
            if (list[i]) {
                list[i].img = list[i].img.startsWith("http") ? list[i].img : (app.globalData.prefix_url + list[i].img);
            } else {
                list.push({});
            }
        }
        
        console.log("init list >>>>>", list);
        list = this.shuffleArray(list);
        console.log("shuffleArray list >>>>>", list);


        //奖品item设置
        var awardList = [];
        //间距,怎么顺眼怎么设置吧.
        var topAward = 25;
        var leftAward = 25;
        for (var j = 0; j < 8; j++) {
            if (j == 0) {
                topAward = 25;
                leftAward = 25;
            } else if (j < 3) {
                topAward = topAward;
                //166.6666是宽.15是间距.下同
                leftAward = leftAward + 166.6666 + 15;
            } else if (j < 5) {
                leftAward = leftAward;
                //150是高,15是间距,下同
                topAward = topAward + 150 + 15;
            } else if (j < 7) {
                leftAward = leftAward - 166.6666 - 15;
                topAward = topAward;
            } else if (j < 8) {
                leftAward = leftAward;
                topAward = topAward - 150 - 15;
            }

            var award = list[j];
            
            award.topAward = topAward;
            award.leftAward = leftAward;
            awardList.push(award);
        }
        this.setData({
            awardList: awardList
        });
    },

    shuffleArray: function (array) {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return array;
    },

    //开始游戏
    startGame: function () {
        if (this.data.isRunning) return

        // 播放抽奖音效
        const backgroundAudioManager = wx.getBackgroundAudioManager();
        backgroundAudioManager.title = '抽奖音乐';

        // 抽奖时音乐
        backgroundAudioManager.src = 'http://weixin.uctphp.com/app/reward/view/dial/static/images/rotate.mp3';

        var that = this,
            indexSelect = 0,
            i = 0,
            awardList = that.data.awardList;
        
        this.setData({
            isRunning: true
        });

        var timer = setInterval(function () {
            //这里我只是简单粗暴用y=30*x+200函数做的处理.可根据自己的需求改变转盘速度
            i += 30;
            if (i > 850) {
                if (that.data.selectedIndex == -1) {
                    if (!awardList[indexSelect].uid) {
                        //去除循环
                        clearInterval(timer);
                        //获奖提示
                        that.awardModal();
                        backgroundAudioManager.title = '没中奖音乐';

                        backgroundAudioManager.src = 'http://weixin.uctphp.com/app/reward/view/dial/static/images/getprize_false.mp3';

                    }
                } else if (indexSelect == that.data.selectedIndex) {
                    // indexSelect == that.data.selectedIndex;
                    //去除循环
                    clearInterval(timer);
                    //获奖提示
                    that.awardModal();
                    backgroundAudioManager.title = '中奖音乐';

                    backgroundAudioManager.src = 'http://weixin.uctphp.com/app/reward/view/dial/static/images/getprize.mp3';
                }
            }

            that.setData({
                indexSelect: indexSelect
            });

            indexSelect++;

            indexSelect = indexSelect % 8;

        }, (200 + i))
    },

    // 抽奖请求
    doreward: function() {
        var that = this,
            award = that.data.award,
            awardList = that.data.awardList,
            time = new Date(),
            now = time.getTime() / 1000;

        if (this.data.isDoingReward) return;
        if (award.access_rule.start_time != 0 && now < award.access_rule.start_time) {
            wx.showModal({
                title: "敬请期待",
                content: "抽奖活动还没开始，详情请查看活动介绍",
                showCancel: false
            });
            return;
        } else if (award.access_rule.end_time != 0 && now > award.access_rule.end_time) {
            wx.showModal({
                title: "已过期",
                content: "抽奖活动已过期，请下次再来",
                showCancel: false
            });
            return;
        }

        this.setData({
            isDoingReward: true
        });

        app.request({
            url: "_a=reward&_u=ajax.doreward",
            data: {
                r_uid: that.data.awardId
            },
            success: (ret)=>{
                console.log("do reward ret >>>>>", ret);
                if (ret.data.item_uid) {
                    for (var i = 0; i < awardList.length; i++) {
                        if(awardList[i].uid == ret.data.item_uid) {
                            that.setData({
                                selectedIndex: i,
                                recordId: ret.data.uid,
                                selectedAward: ret.data
                            });
                            console.log(" reward index >>>>>", i);
                            that.startGame();
                        }
                    }
                } else if (ret.errstr == "ERROR_OUT_OF_LIMIT") {
                    wx.showModal({
                        title: "超出限制",
                        content: "您的抽奖次数已超过限制，详情请查看活动介绍",
                        showCancel: false
                    });
                    that.setData({isDoingReward:false});
                } else if (ret.data.length == 0) {
                    that.setData({
                        selectedIndex: -1
                    });
                    that.startGame();
                } else {
                    wx.showModal({
                        title: "谢谢参与",
                        // content: "抽奖活动设置错误，请联系小程序管理员",
                        showCancel: false
                    });
                    that.setData({isDoingReward:false});
                }
            }
        });
    },

    // 点击阴影
    tapQuit: function() {
        this.setData({
            showShadow: false,
            showRule: false,
            showIntro: false,
            showMyAward: false
        });
    },

    // 显示抽奖规则
    showRule: function() {
        this.setData({
            showShadow: true,
            showRule: true
        });
    },
    showIntro: function() {
        this.setData({
            showShadow: true,
            showIntro: true
        });
    },
    showMyAward: function() {
        let that = this;
        that.getMyAward(that.data.awardId);

        this.setData({
            showShadow: true,
            showMyAward: true
        });
    },

    // 获奖提示
    awardModal: function(awardId) {
        var that = this,
            title = "",
            content = "",
            confirmText = "确定",
            winRule = that.data.winRule,
            award = that.data.selectedAward;

        if (award) {
            title = "恭喜您";
            content = "获得了" + award.item.title;
        } else {
            title = "差一点";
            content = "感谢您的参与";
        }

        wx.showModal({
            title: title,
            content: content,
            showCancel: false,//去掉取消按钮
            success: function (res) {
                if (res.confirm) {
                    that.setData({
                        isRunning: false,
                        isDoingReward: false,
                        indexSelect: 0
                    });

                    if (award && winRule.type == "form") {
                        wx.navigateTo({
                            url: "../awardForm/awardForm?awardId=" + that.data.recordId
                        });
                    }
                }
            }
        });
    },

    // 分享商品页面
    onShareAppMessage: function (res) {
        var winRule = this.data.winRule;

        return {
            title: winRule.title,
            // path: '/page/class/pages/goodDetail/goodDetail?parentId=' + app.globalData.su_uid + "&uid=" + goodDetail.uid,
            success: function(res) {
            // 转发成功
            },
            fail: function(res) {
            // 转发失败
            }
        }
    },

})