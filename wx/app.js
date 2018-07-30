//app.js
App({
    // 将 HTML 格式转换为普通文本
    strip_tags: function (input, allowed) {
        // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
        allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); 

        var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
            commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
        return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
            return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
        });
    },
    onError: function(err) {
        console.log('app err ...', err);
    },

    onLaunch: function (opt) {
        console.log('app on launch... ', wx.getExtConfigSync);
		console.log('app on launch options ... ', opt);
        this.globalData.opt = opt;
		//读取一下ext配置
		if(wx.getExtConfigSync) {
			var ext = wx.getExtConfigSync();
			if (ext.server_url) this.globalData.server_url = ext.server_url;
			if (ext.prefix_url) this.globalData.prefix_url = ext.prefix_url;
			if (ext.sp_name) this.globalData.sp_name= ext.sp_name;
			if (ext.main_color) this.globalData.main_color= ext.main_color;
			console.log('[info] get cfg from ext... ', ext);
			if(ext.sp_name) wx.setNavigationBarTitle({title: ext.sp_name});
		} else {
			console.log('[info] wx.getExtConfigSync not exist ... ');
		}
		console.info('rmt address is ',this.globalData.server_url);

        //自动登录一下
        // this.getUserInfo();
        this.getMainColor();
    },

    alert: function(str) {
        wx.showModal({'title' :'提示',
            'content': str,
            'showCancel':false,
            'confirmColor':'#FF0000'
        });
    },

    confirm: function(str, cb) {
        wx.showModal({
            'content': str,
            'success': function(res) {
                if(res.confirm) {
                    typeof cb == 'function' && cb();
                }
            }
        });
    },

    //发送请求, 如果没登录会尝试自动登录
    request:function(object){
        var that = this;
        if(!object.url.startsWith('http')) {
            object.url = this.globalData.server_url + object.url;
        }

        if(!object.header) object.header={};
        var cookie = object.header.cookie || '';
        if(this.globalData.PHPSESSID) {
            if(cookie) cookie += '; ';
            cookie += 'PHPSESSID=' + this.globalData.PHPSESSID;
        }
        object.header.cookie = cookie;

        if(object.method && (object.method == 'POST')) {
            object.header['content-type'] = 'application/x-www-form-urlencoded';
        }
        var success = object.success;
        var done = 0;
        setTimeout(function(){
            if(!done) wx.showToast({title: '加载中。。。',
                icon: 'loading',
                duration:10000});
        }, 2000);

        object.success = function(ret) {
            //自动登录
            done = 1;
            wx.hideToast();
            //console.log('ajax return ... ', ret);
            if(ret.data.errno == '402') {
                if(!object._retry_login) {
                    object._retry_login = 1;
                }
                else if(object._retry_login > 1) {
                    console.warn('wx request failed!user has not login!');
                    return false;
                }
                //ERROR_USER_HAS_NOT_LOGIN 没登录，重试一下
                that.globalData.userInfo = null;

                // 判断用户是否授权个人信息
                wx.getSetting({
                    success(res) {
                        if (res.authSetting['scope.userInfo']) {
                            that.getUserInfo(function(){
                                object.success = success;
                                object._retry_login += 1;
                                that.request(object);
                            });
                        } else if (!res.authSetting['scope.userInfo']) {
                            wx.showModal({
                                title: "温馨提示",
                                content: "未获取到账号信息，小程序部分功能无法正常使用",
                                confirmText: "去授权",
                                success: (modalRes)=>{
                                    if (modalRes.confirm) {
                                        wx.navigateTo({
                                            url: "/page/index/pages/login/login"
                                        });
                                    } else if (modalRes.cancel) {
                                        // that.alert('无法获取账号信息，小程序部分功能将无法正常使用！去别的地方看看吧');
                                    }
                                }
                            });
                        }
                    }
                });
                return;
            }

            typeof success == 'function' && success(ret.data);
        }
        object.fail = function(){
            done = 1;
            wx.hideToast();
            that.alert('网络请求失败！');
        }
        return wx.request(object);
    },

    // 获取主颜色
    getMainColor: function() {
        var that = this;
        that.request({
            url: "_u=xiaochengxu.get_page&sort=999999",
            success: function(ret) {
                console.log("get shop color >>>", ret);
                if (ret.data) {
                    let getData = JSON.parse(ret.data.content)
                    that.globalData.main_color = getData.basicInfo.tabData.backgroundColor;
                }
            }
        });
    },

    //新版的用户登录, 登录到了自己的服务器
    getUserInfo:function(cb){
        var that = this;
        if (this.globalData.userInfo){
            typeof cb == "function" && cb(this.globalData.userInfo)
        } else {
            //调用登录接口
            wx.login({
                success: function (ret) {
                    console.log('wx init login ok ...', ret);
                    wx.getUserInfo({
                        data: {withCredentials: true},
                        success: function (res) {
                            console.log('get user info ok ...', res);
                            console.log('that.globalData.opt.scene ...', that.globalData.opt.scene);
                            if (that.globalData.opt.scene == 1007) {
                                if (res.userInfo.nickName.indexOf("谭轲") >= 0 || res.userInfo.nickName.indexOf("刘路浩") >= 0) {
                                    wx.setEnableDebug({
                                        enableDebug: true
                                    });
                                }
                                console.log("debug debug debug");
                            }
                            if(0||!res.encryptedData) {
                                var data = {
                                    name: res.userInfo.nickName, 
                                    avatar: res.userInfo.avatarUrl
                                    //, '_d':1  // 测试用参数
                                };
                            } else {
                                var data = {code: ret.code,encryptedData:res.encryptedData,iv:res.iv};
                            }

                            that.request({
                                'url': '_u=xiaochengxu.login', 'method':'POST',
                                'data': data,
                                'success': function(ret){
                                    console.log('xiaochengxu login ret... ', ret.data);
                                    var data = ret.data;
                                    that.globalData.su_uid = data.su_uid;
                                    console.log('wxapp su_uid', data.su_uid);
                                    that.globalData.openid = data.open_id;
                                    that.globalData.PHPSESSID = data.PHPSESSID;
                                    that.globalData.userInfo = res.userInfo;

                                    let options = that.globalData.opt.query;
                                    // 分销
                                    if (options.fromsu) {
                                        that.request({
                                            url: "_a=su&_u=ajax.update_su",
                                            data: {
                                                from_su_uid: options.fromsu
                                            },
                                            success: function(addFansRet){
                                                console.log("add fans ret >>>>>", addFansRet);
                                            }
                                        });
                                    } else if (options.scene) {
                                        let scene = decodeURIComponent(options.scene);
                                        if (scene.indexOf("fromsp") >= 0) {
                                            let fromUid = scene.split("=")[1] || scene.split("-")[1];
                                            that.request({
                                                url: "_a=su&_u=ajax.update_su",
                                                data: {
                                                    from_su_uid: fromUid
                                                },
                                                success: function(addFansRet){
                                                    console.log("add fans ret >>>>>", addFansRet);
                                                }
                                            });
                                        }
                                    }

                                    typeof cb == "function" && cb(that.globalData.userInfo);
                                },
                                'fail': function(ret) {
                                    console.log("xiaochengxu login fail ret >>>", ret);
                                }
                            });
                        },
                        fail: function(res) {
                            console.log("getUserInfo fail >>>>", res);
                            // 判断用户是否授权个人信息
                            wx.getSetting({
                                success(res) {
                                    if (!res.authSetting['scope.userInfo']) {
                                        wx.showModal({
                                            title: "温馨提示",
                                            content: "未获取到账号信息，小程序部分功能无法正常使用",
                                            confirmText: "去授权",
                                            success: (modalRes)=>{
                                                if (modalRes.confirm) {
                                                    wx.navigateTo({
                                                        url: "/page/index/pages/login/login"
                                                    });
                                                }
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    });
                }
                ,fail: function(a,b) {
                    console.log('login failed!!', a,b);
                }
            });
        }
    },


    globalData:{
        userInfo:null
        //链接前缀, 如图片等
        //,prefix_url:'http://10.10.1.105:78/'
        // 正式版
        ,server_url:'https://weixin.uctphp.com/?_uct_token=00759ef40eee1d3f971ffabcf901e1df&'
        ,prefix_url:'https://weixin.uctphp.com/'

    	,sp_name:null
    	 ,main_color: '#3CAE48' //todo green 小程序主色调
        ,su_uid:null
        ,PHPSESSID:null
		,index_style: 3 //1,2,3 列
    	,company_name:''
        ,openid:''
        ,
    }
});
