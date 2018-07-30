
var qp_a, queue, qp_b = 32, qp_c = 20, qp_d = [], qp_e = null , qp_f = 5, qp_g = 6, qp_h = null , qp_i = 1, qp_j = 1, qp_k = 30, qp_l = 120, qp_m = 20, qp_n = 100, qp_o = 4, qp_p = 1200, qp_q = 500, qp_r = null , qp_s = null , qp_t = null , qp_u = null , qp_v = null , qp_w = null , qp_x = 10, qp_y = qp_x, qp_z = null , qp_A = 0, qp_B = 25, qp_C = qp_B, qp_D = null , qp_E = 100, qp_F = qp_B - 1;
function loadResource() {
    SCREEN_SHOW_ALL = !0;
    var a = new ProgressBar(0.8 * W,40);
    a.regX = a.w / 2;
    a.regY = a.h / 2;
    a.x = W / 2;
    a.y = H / 2;
    stage.addChild(a);
    queue = qp_a = new createjs.LoadQueue(!1);
    qp_a.on("complete", qp_G, null , !0);
    loadGameData();
    USE_NATIVE_SOUND || (IS_NATIVE_ANDROID ? (createjs.Sound.registMySound("linked", 0),
    createjs.Sound.registMySound("ding", 2),
    createjs.Sound.registMySound("over", 6),
    createjs.Sound.registMySound("silenttail", 6.54),
    queue.loadFile({
        id: "sound",
        src: RES_DIR + "audio/all.mp3"
    })) : (createjs.Sound.alternateExtensions = 
    ["ogg"],
    queue.installPlugin(createjs.Sound),
    queue.loadManifest({
        path: RES_DIR + "audio/",
        manifest: [{
            src: "ding.mp3",
            id: "ding"
        }, {
            // src: "linked.mp3",
            // id: "linked"
        }, {
            // src: "over.mp3",
            // id: "over"
        }]
    }, !1)));
    for (var b = [{
        src: "gameover.png",
        id: "gameover"
    }, {
        src: "topline.png",
        id: "topline"
    }, {
        src: "bb1.png",
        id: "bb1"
    }, {
        src: "bb2.png",
        id: "bb2"
    }, {
        src: "bb3.png",
        id: "bb3"
    }, {
        src: "star1.png",
        id: "star1"
    }, {
        src: "star2.png",
        id: "star2"
    }, {
        src: "star3.png",
        id: "star3"
    }, {
        src: "welcome.jpg",
        id: "welcome"
    }, {
        src: "bonus.png",
        id: "bonus"
    }, {
        //src: "bestscore.png",
        //id: "bestscore"
    }, {
        src: "clock.png",
        id: "clock"
    }, {
        src: "curscore.png",
        id: "curscore"
    }, {
        src: "score.png",
        id: "score"
    }, {
        src: "lowkeysharebtn.png",
        id: "lowkeysharebtn"
    }, {
        // src: "toplistbtn.png",
        // id: "toplistbtn"
    }, {
        src: "replaybtn.png",
        id: "replaybtn"
    }, {
        src: "ready.png",
        id: "ready"
    }, {
        src: "go.png",
        id: "go"
    }, {
        src: "bg.png",
        id: "bg"
    }, {
        src: "fcwm520logobg.png",
        id: "fcwm520logobg"
    }, {
        src: "smallline.png",
        id: "smallline"
    }, {
        src: "choose.png",
        id: "choose"
    }, {
        src: "btn.png",
        id: "btn"
    }], c = 1; c < qp_b; c++)
        qp_d.push(c);
    qp_H(qp_d);
    for (c = 0; c < qp_c; c++)
        b.push({
            src: qp_d[c].toString() + 
            ".jpg",
            id: qp_d[c].toString()
        });
    qp_a.loadManifest({
        path: RES_DIR + "img/",
        manifest: b
    }, !1);
    a.forQueue(qp_a);
    qp_a.load();
}
function qp_G(a) {
    a = [];
    for (var b = 1; b < qp_c + 1; b++) {
        var c = qp_a.getResult(qp_d[b - 1].toString())
          , c = new Qp_I(c,b);
        a.push(c)
    }
    qp_e = new Qp_J(a);
    qp_e.girdLoad();
    qp_h = new createjs.Bitmap(qp_a.getResult("choose"));
    qp_h.visible = !1;
    stage.addChild(qp_h);
    a = new createjs.Bitmap(qp_a.getResult("bg"));
    stage.addChild(a);
    a = new createjs.Bitmap(qp_a.getResult("ready"));
    a.regX = 290;
    a.regY = 80;
    a.x = 320;
    a.y = 450;
    a.scaleX = 3;
    a.scaleY = 3;
    a.alpha = 0;
    createjs.Tween.get(a).to({
        alpha: 1,
        scaleX: 1,
        scaleY: 1
    }, 300).to({
        alpha: 1
    }, qp_p - 300).call(function() {
        var a = 
        new createjs.Bitmap(qp_a.getResult("go"));
        a.regX = 240;
        a.regY = 136;
        a.x = 320;
        a.y = 450;
        createjs.Sound.play("ding", !0);
        createjs.Tween.get(a).to({
            scaleX: 1
        }, qp_q - 200).to({
            alpha: 0
        }, 200).call(function() {
            var a = new createjs.Bitmap(qp_a.getResult("score"));
            a.regX = 0;
            a.regY = 0;
            a.x = 40;
            a.y = 15;
            stage.addChild(a);
            qp_t = new createjs.Text("0","bold 48px Arial","#ff1e50");
            qp_t.stroke = "white";
            qp_t.textBaseline = "middle";
            qp_t.x = 140;
            qp_t.y = 35;
            stage.addChild(qp_t);
            a = new createjs.Bitmap(qp_a.getResult("clock"));
            a.scaleX = 1;
            a.scaleY = 1;
            a.regX = 40;
            a.regY = 38;
            a.x = 470;
            a.y = 50;
            stage.addChild(a);
            qp_u = new createjs.Text(qp_C.toString(),"bold 40px Arial","#ff1e50");
            qp_u.stroke = "white";
            qp_u.textBaseline = "middle";
            qp_u.x = 520;
            qp_u.y = 30;
            stage.addChild(qp_u);
            a = new createjs.Bitmap(qp_a.getResult("topline"));
            a.regX = 0;
            a.regY = 0;
            a.x = 0;
            a.y = 80;
            stage.addChild(a);
            qp_z = new createjs.Text(qp_y.toString(),"bold 40px Arial","#ff1e50");
            qp_z.stroke = "white";
            qp_z.textBaseline = "middle";
            qp_z.x = 580;
            qp_z.y = 916;
            qp_z.visible = !1;
            stage.addChild(qp_z);
            qp_D = setInterval(function() {
                0 < 
                qp_C && (qp_C--,
                qp_u.text = qp_C.toString());
                0 == qp_C && qp_K()
            }
            , 1E3);
            qp_w = setInterval(function() {
                !1 == qp_v.visible && (0 >= qp_y ? (qp_y = qp_x,
                qp_z.text = qp_x.toString()) : (qp_y--,
                qp_z.text = qp_y.toString()))
            }
            , 1E3);
            qp_r = new createjs.Container;
            stage.addChild(qp_r);
            qp_L(!0);
            qp_M();
            stage.removeChild(this)
        }
        );
        stage.addChild(a);
        stage.removeChild(this)
    }
    );
    stage.addChild(a);
    a = new createjs.Bitmap(qp_a.getResult("fcwm520logobg"));
    a.regX = 0;
    a.regY = 92;
    a.x = 0;
    a.y = 960;
    stage.addChild(a);
    gjQipa.onGameStarted()
}
function qp_K() {
    createjs.Sound.play("over", !0);
    onNewScore();
    clearInterval(qp_D);
    stage.removeChild(qp_s);
    qp_s = new createjs.Container;
    qp_s.on("mousedown", function(a) {}
    );
    stage.addChild(qp_s);
    var a = new createjs.Shape;
    a.graphics.f("#fff").r(0, 0, 640, 960).ef();
    a.x = 0;
    a.y = 0;
    a.alpha = 0.8;
    qp_s.addChild(a);
    a = new createjs.Bitmap(qp_a.getResult("gameover"));
    a.regX = 180;
    a.regY = 30;
    a.x = 320;
    a.y = 170;
    qp_s.addChild(a);
    var b = new createjs.Bitmap(qp_a.getResult("star3"));
    b.regX = 30;
    b.regY = 30;
    b.x = 320;
    b.y = 480;
    b.alpha = 0;
    createjs.Tween.get(b).to({
        x: 670,
        rotation: 360
    }, 800);
    createjs.Tween.get(b).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(b)
    }
    );
    qp_s.addChild(b);
    var c = new createjs.Bitmap(qp_a.getResult("star3"));
    c.regX = 30;
    c.regY = 30;
    c.x = 320;
    c.y = 480;
    c.alpha = 0;
    createjs.Tween.get(c).to({
        x: -30,
        rotation: 360
    }, 800);
    createjs.Tween.get(c).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(c)
    }
    );
    qp_s.addChild(c);
    var d = new createjs.Bitmap(qp_a.getResult("star3"));
    d.regX = 30;
    d.regY = 30;
    d.x = 320;
    d.y = 480;
    d.alpha = 0;
    createjs.Tween.get(d).to({
        y: 130,
        rotation: 360
    }, 800);
    createjs.Tween.get(d).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(d)
    }
    );
    qp_s.addChild(d);
    var e = new createjs.Bitmap(qp_a.getResult("star3"));
    e.regX = 30;
    e.regY = 30;
    e.x = 320;
    e.y = 480;
    e.alpha = 0;
    createjs.Tween.get(e).to({
        y: 830,
        rotation: 360
    }, 800);
    createjs.Tween.get(e).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(e)
    }
    );
    qp_s.addChild(e);
    var h = new createjs.Bitmap(qp_a.getResult("star2"));
    h.regX = 62;
    h.regY = 60;
    h.x = 320;
    h.y = 480;
    h.alpha = 0;
    createjs.Tween.get(h).to({
        x: 120,
        y: 280,
        rotation: 360
    }, 800);
    createjs.Tween.get(h).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(h)
    }
    );
    qp_s.addChild(h);
    var g = new createjs.Bitmap(qp_a.getResult("star2"));
    g.regX = 62;
    g.regY = 60;
    g.x = 320;
    g.y = 480;
    g.alpha = 0;
    createjs.Tween.get(g).to({
        x: 520,
        y: 280,
        rotation: 360
    }, 800);
    createjs.Tween.get(g).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(g)
    }
    );
    qp_s.addChild(g);
    var k = new createjs.Bitmap(qp_a.getResult("star2"));
    k.regX = 62;
    k.regY = 60;
    k.x = 320;
    k.y = 480;
    k.alpha = 0;
    createjs.Tween.get(k).to({
        x: 120,
        y: 680,
        rotation: 360
    }, 800);
    createjs.Tween.get(k).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(k)
    }
    );
    qp_s.addChild(k);
    var f = new createjs.Bitmap(qp_a.getResult("star2"));
    f.regX = 62;
    f.regY = 60;
    f.x = 320;
    f.y = 480;
    f.alpha = 0;
    createjs.Tween.get(f).to({
        x: 520,
        y: 680,
        rotation: 360
    }, 800);
    createjs.Tween.get(f).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(f)
    }
    );
    qp_s.addChild(f);
    var l = new createjs.Bitmap(qp_a.getResult("star1"));
    l.regX = 69;
    l.regY = 
    67;
    l.x = 320;
    l.y = 480;
    createjs.Tween.get(l).to({
        rotation: 360
    }, 800);
    createjs.Tween.get(l).to({
        alpha: 1
    }, 400).to({
        alpha: 0
    }, 400).call(function() {
        qp_s.removeChild(l)
    }
    );
    qp_s.addChild(l);
    a = stage.getChildByName("follow");
    qp_s.addChild(a);

    a = new createjs.Bitmap(qp_a.getResult("fcwmlogl"));
    a.regX = 320;
    a.regY = 70;
    a.x = 320;
    a.y = 110;
    qp_s.addChild(a);

    a = new createjs.Bitmap(qp_a.getResult("curscore"));
    a.x = 90;
    a.y = 260;
    qp_s.addChild(a);
    /*a = new createjs.Bitmap(qp_a.getResult("bestscore"));
    a.x = 90;
    a.y = 380;
    qp_s.addChild(a);*/
    a = new createjs.Bitmap(qp_a.getResult("sbbbb"));
    a.x = 90;
    a.y = 380;
    qp_s.addChild(a);
    a = new createjs.Text(score,
    "bold 48px Arial","#ff1e50");
    a.stroke = "white";
    a.textBaseline = "middle";
    a.x = 440;
    a.y = 300;
    qp_s.addChild(a);
    var array_1 = ['法海转世有木有','雄踞单身狗巅峰','单身圈传奇！！'];
    var array_2 = ['授你荣誉单身汪','单身情歌，预备唱！','来，我们还有双手','汪~汪~汪汪！'];
    var array_3 = ['单身届耻辱','给你种子自己撸','单身~狗都不如'];
    
    
    if(score < 15){
        $('#scores').val(score);
        var n2 = Math.ceil((Math.random()*10)%3-1);
        //alert(array_3[n2]);
        a = new createjs.Text(array_3[n2],"bold 48px Arial","#515151");
        a.stroke = "white";
        a.textBaseline = "middle";
        a.x = 100;
        a.y = 410;
        qp_s.addChild(a);
        /*var array = ['不哭！今夜我们都是单身汪。我得了'+score+'分','秀恩爱死得快，小情侣看我不灭你，我得了'+score+'分','练好一阳指，情侣挨个灭，灭情侣我得了'+score+'分'];
        var n = Math.ceil((Math.random()*10)%3-1);
        document.title = array[n];*/
    }else if(score>=15 && score<=20){
        $('#scores').val(score);
        var n3 = Math.ceil((Math.random()*10)%3);
        //alert(array_2[n3]);
        a = new createjs.Text(array_2[n3],"bold 48px Arial","#515151");
        a.stroke = "white";
        a.textBaseline = "middle";
        a.x = 100;
        a.y = 410;
        qp_s.addChild(a);
        /*var array = ['不哭！今夜我们都是单身汪。我得了'+score+'分','秀恩爱死得快，小情侣看我不灭你，我得了'+score+'分','练好一阳指，情侣挨个灭，灭情侣我得了'+score+'分'];
        var n = Math.ceil((Math.random()*10)%3-1);
        document.title = array[n];*/
    }else if(score > 20){
        $('#scores').val(score);
        var n1 = Math.ceil((Math.random()*10)%3-1);
        //alert(array_1[n1]);
        a = new createjs.Text(array_1[n1],"bold 48px Arial","#515151");
        a.stroke = "white";
        a.textBaseline = "middle";
        a.x = 100;
        a.y = 410;
        qp_s.addChild(a);
        /*var array = ['不哭！今夜我们都是单身汪。我得了'+score+'分','秀恩爱死得快，小情侣看我不灭你，我得了'+score+'分','练好一阳指，情侣挨个灭，灭情侣我得了'+score+'分'];
        var n = Math.ceil((Math.random()*10)%3-1);
        document.title = array[n];*/
    }
    
    
    /*a = new createjs.Text(best,"bold 48px Arial","#ff1e50");
    a.stroke = "white";
    a.textBaseline = "middle";
    a.x = 440;
    a.y = 410;
    qp_s.addChild(a);*/
    a = new createjs.Bitmap(qp_a.getResult("replaybtn"));
    a.regX = 125;
    a.regY = 42;
    a.x = 200;
    a.y = 450;
    a.on("mousedown", function(a) {
        IS_TOUCH && a.nativeEvent instanceof MouseEvent || (qp_v.visible = !0,
        qp_C = qp_B,
        qp_u.text = qp_C,
        stage.removeChild(qp_s),
        qp_N(!0),
        gjQipa.onGameStarted())
    }
    );
    qp_s.addChild(a);
    // var m = new createjs.Bitmap(qp_a.getResult("toplistbtn"));
    // m.regX = 115;
    // m.regY = 40;
    // m.x = 450;
    // m.y = 540;
    // m.on("mousedown", function(a) {
    //     IS_TOUCH && a.nativeEvent instanceof MouseEvent || showTop()
    // }
    // );
    // qp_s.addChild(m);
    var n = new createjs.Bitmap(qp_a.getResult("lowkeysharebtn"));
    n.regX = 125;
    n.regY = 42;
    n.x = 450;
    n.y = 540;
    n.on("mousedown", function(a) {
        IS_TOUCH && a.nativeEvent instanceof MouseEvent || share()
    }
    );
    qp_s.addChild(n);
    a.y = 1200;
    createjs.Tween.get(a).to({
        y: 540
    }, 200);
    //m.y = 1200;
    createjs.Tween.get(m).to({
        y: 1200
    }, 150).to({
        y: 540
    }, 
    200);
    n.y = 1200;
    createjs.Tween.get(n).to({
        y: 1200
    }, 350).to({
        y: 670
    }, 200);
    gjQipa.onGameOver()
}
function qp_M() {
    qp_v = new createjs.Bitmap(qp_a.getResult("btn"));
    qp_v.regX = 27;
    qp_v.regY = 40;
    qp_v.x = 580;
    qp_v.y = 914;
    var a = new createjs.Shape;
    a.graphics.f("red").r(0, 0, 60, 60);
    qp_v.hitArea = a;
    qp_v.on("mousedown", function(a) {
        IS_TOUCH && a.nativeEvent instanceof MouseEvent || (qp_O(),
        qp_e.girdRefreshLoad(),
        qp_L())
    }
    , this);
    stage.addChild(qp_v)
}
function qp_N(a) {
    qp_r.removeAllChildren();
    qp_e.girdLoad();
    qp_e.m_currentchooseitem = null ;
    qp_e.m_iconnum = qp_f * qp_g;
    !0 == a ? (qp_i = 1,
    score = 0,
    qp_t.text = score.toString(),
    qp_F = qp_B - 1,
    qp_D = setInterval(function() {
        0 < qp_C && (qp_C--,
        qp_u.text = qp_C.toString());
        0 == qp_C && qp_K()
    }
    , 1E3)) : (qp_P(qp_i),
    qp_i++
    );	//score += 5
    qp_L();
}
function qp_P(a) {
    a = new createjs.Shape;
    a.graphics.f("#fff").r(0, 0, 640, 960).ef();
    a.x = 0;
    a.y = 0;
    a.alpha = 1;
    createjs.Tween.get(a).to({
        alpha: 0.8
    }, 200).to({
        alpha: 0.8
    }, 800).to({
        alpha: 0
    }, 200).call(function() {
        stage.removeChild(this)
    }
    );
    stage.addChild(a);
    a = new createjs.Text("+5","bold 70px Arial","#ff1e50");
    a.stroke = "white";
    a.textBaseline = "middle";
    a.scaleX = 2;
    a.scaleY = 2;
    a.x = 400;
    a.y = 380;
    a.alpha = 0;
    createjs.Tween.get(a).to({
        scaleX: 1,
        scaleY: 1
    }, 200).to({
        scaleX: 1,
        scaleY: 1
    }, 790);
    createjs.Tween.get(a).to({
        alpha: 1
    }, 200).to({
        alpha: 1
    }, 
    200).to({
        alpha: 0
    }, 390);
    createjs.Tween.get(a).to({
        x: 520,
        y: 280
    }, 1E3).call(function() {
        stage.removeChild(this)
    }
    );
    stage.addChild(a);
    a = new createjs.Bitmap(queue.getResult("bonus"));
    a.regX = 230;
    a.regY = 100;
    a.x = -230;
    a.y = 480;
    a.alpha = 0;
    createjs.Tween.get(a).to({
        x: 280,
        alpha: 1
    }, 200).to({
        x: 280
    }, 600).to({
        x: 870,
        alpha: 0
    }, 200).call(function() {
        stage.removeChild(this)
    }
    );
    stage.addChild(a)
}
function qp_O() {
    qp_v.visible = !1;
    qp_z.visible = !0;
    qp_y = qp_x;
    qp_w = setTimeout(function() {
        qp_z.visible = !1;
        qp_v.visible = !0
    }
    , 1E3 * qp_x);
    qp_C -= qp_A;
    qp_C = Math.max(0, qp_C);
    qp_u.text = qp_C.toString();
    qp_r.removeAllChildren();
    qp_e.m_currentchooseitem = null 
}
function qp_L(a) {
    if (void 0 == a || !1 == a)
        for (a = 0; a < qp_g; a++)
            for (var b = 0; b < qp_f; b++) {
                var c = (b + a + 1) * qp_E
                  , d = qp_e.m_allitems[a * qp_f + b].img;
                d.alpha = 0;
                createjs.Tween.get(d).to({
                    alpha: 0
                }, c).to({
                    alpha: 1
                }, 100);
                d.x = qp_k + (qp_n + qp_m) * b;
                d.y = qp_l + (qp_n + qp_m) * a;
                qp_r.addChild(d)
            }
    else
        for (a = 0; a < qp_g; a++)
            for (b = 0; b < qp_f; b++)
                d = qp_e.m_allitems[a * qp_f + b].img,
                d.x = qp_k + (qp_n + qp_m) * b,
                d.y = 0,
                d.alpha = 0,
                c = (qp_g - a) * qp_E * 2,
                d.alpha = 0,
                createjs.Tween.get(d).to({
                    alpha: 0
                }, c).to({
                    alpha: 1,
                    y: qp_l + (qp_n + qp_m) * a
                }, 100),
                qp_r.addChild(d)
}
function qp_Q(a, b) {
    stage.removeChild(qp_h);
    -1 != a && -1 != b && (qp_h = new createjs.Bitmap(qp_a.getResult("choose")),
    qp_h.x = qp_k + (qp_n + qp_m) * b,
    qp_h.y = qp_l + (qp_n + qp_m) * a,
    stage.addChild(qp_h),
    qp_R(0, 0))
}
function qp_S(a) {
    for (var b = a[0], c = 1; c < a.length; c++)
        qp_R(b, a[c]),
        b = a[c];
    var b = a[0]
      , c = {
        framerate: 10,
        images: [qp_a.getResult("bb1"), qp_a.getResult("bb2"), qp_a.getResult("bb3")],
        frames: {
            width: 96,
            height: 96,
            regX: 48,
            regY: 48
        },
        animations: {
            fx: [0, 10, !0]
        }
    }
      , c = new createjs.SpriteSheet(c)
      , d = this.bird = new createjs.Sprite(c,"fx");
    d.x = b.y * (qp_m + qp_n) + qp_k + qp_n / 2 + qp_m;
    d.y = b.x * (qp_m + qp_n) + qp_l + qp_n / 2 + qp_m;
    setTimeout(function() {
        qp_r.removeChild(d)
    }
    , 1E3);
    qp_r.addChild(d);
    a = a[a.length - 1];
    var b = {
        framerate: 10,
        images: [qp_a.getResult("bb1"), 
        qp_a.getResult("bb2"), qp_a.getResult("bb3")],
        frames: {
            width: 96,
            height: 96,
            regX: 48,
            regY: 48
        },
        animations: {
            fx: [0, 10, !0]
        }
    }
      , b = new createjs.SpriteSheet(b)
      , e = this.bird = new createjs.Sprite(b,"fx");
    e.x = a.y * (qp_m + qp_n) + qp_k + qp_n / 2 + qp_m;
    e.y = a.x * (qp_m + qp_n) + qp_l + qp_n / 2 + qp_m;
    setTimeout(function() {
        qp_r.removeChild(e)
    }
    , 1E3);
    qp_r.addChild(e)
}
function qp_R(a, b) {
    var c = a.y * (qp_m + qp_n) + qp_k + qp_n / 2 + qp_m
      , d = a.x * (qp_m + qp_n) + qp_l + qp_n / 2 + qp_m
      , e = b.y * (qp_m + qp_n) + qp_k + qp_n / 2 + qp_m
      , h = b.x * (qp_m + qp_n) + qp_l + qp_n / 2 + qp_m;
    if (0 != c - e) {
        var g = (qp_n + qp_m) / qp_o
          , k = Math.abs(c - e) / g;
        0 > e - c && (g = -g);
        for (e = 0; e < k + 1; e++) {
            var f = new createjs.Bitmap(qp_a.getResult("smallline"));
            f.regX = 12;
            f.regY = 12;
            f.x = c + g * e;
            f.y = d;
            createjs.Tween.get(f).to({
                scaleX: 1.2,
                scaleY: 1.2
            }, 100).to({
                scaleX: 1,
                scaleY: 1
            }, 100).to({
                alpha: 0
            }, 100).call(function() {
                qp_r.removeChild(this)
            }
            );
            qp_r.addChild(f);
            qp_r.addChild(f)
        }
    }
    if (0 != 
    d - h)
        for (g = (qp_n + qp_m) / qp_o,
        k = Math.abs(d - h) / g,
        0 > h - d && (g = -g),
        e = 0; e < k + 1; e++)
            f = new createjs.Bitmap(qp_a.getResult("smallline")),
            f.regX = 12,
            f.regY = 12,
            f.x = c,
            f.y = d + g * e,
            createjs.Tween.get(f).to({
                scaleX: 1.2,
                scaleY: 1.2
            }, 100).to({
                scaleX: 1,
                scaleY: 1
            }, 100).to({
                alpha: 0
            }, 100).call(function() {
                stage.removeChild(this)
            }
            ),
            qp_r.addChild(f)
}
var Qp_T = function(a, b, c, d) {
    this.m_img = this.img = new createjs.Shape;
    this.m_isdeleted = !1;
    this.m_id = b;
    this.x = c;
    this.y = d;
    b = this.img.graphics;
    this.iconimg = a.image;
    b.beginBitmapFill(this.iconimg);
    b.drawRoundRect(0, 0, this.iconimg.width, this.iconimg.height, 5);
    this.img.scaleX = qp_n / this.iconimg.width;
    this.img.scaleY = qp_n / this.iconimg.height;
    this.equal = function(a) {
        return a.m_id != this.m_id
    }
    ;
    this.img.on("mousedown", function(a) {
        IS_TOUCH && a.nativeEvent instanceof MouseEvent || (null  == qp_e.m_currentchooseitem ? (qp_e.m_currentchooseitem = 
        this,
        qp_Q(this.x, this.y),
        qp_Q(this.x, this.y)) : qp_e.m_currentchooseitem.m_id == this.m_id ? qp_e.isconnected(qp_e.m_currentchooseitem, this) ? (createjs.Sound.play("linked", !0),
        qp_e.m_currentchooseitem.img.visible = !1,
        this.img.visible = !1,
        qp_e.m_allitems[qp_e.m_currentchooseitem.x * qp_f + qp_e.m_currentchooseitem.y].m_isdeleted = !0,
        qp_e.m_allitems[this.x * qp_f + this.y].m_isdeleted = !0,
        qp_e.m_iconnum -= 2,
        qp_e.m_currentchooseitem = null ,
        qp_Q(-1, -1),
        0 >= qp_e.m_iconnum && qp_N(!1),
        score += qp_j,
        qp_t.text = score) : (qp_e.m_currentchooseitem = 
        this,
        qp_Q(this.x, this.y)) : (qp_e.m_currentchooseitem = this,
        qp_Q(this.x, this.y)))
    }
    , this)
}
  , Qp_U = function(a, b) {
    this.x = a;
    this.y = b
}
  , Qp_V = function(a, b, c) {
    this.a = a;
    this.b = b;
    this.direction = c
}
  , Qp_W = function(a, b) {
    this.m_img = this.img = a;
    this.m_id = this.id = b
}
  , Qp_I = function(a, b) {
    this.m_queueresult = a;
    this.m_id = this.id = b
}
;
function Qp_J(a) {
    this.m_xnum = qp_f;
    this.m_ynum = qp_g;
    this.m_iconnum = qp_f * qp_g;
    this.m_allitems = [];
    a = qp_X(a, 7);
    this.m_imglist = [];
    for (var b = 0; b <= a.length; b++)
        b == a.length && (this.m_imglist.push(a[b - 1]),
        this.m_imglist.push(a[b - 1])),
        this.m_imglist.push(a[b]),
        this.m_imglist.push(a[b]),
        this.m_imglist.push(a[b]),
        this.m_imglist.push(a[b]);
    this.m_imgrescount = this.m_imglist.length;
    this.m_currentchooseitem = null ;
    score = 0
}
Qp_J.prototype.girdLoad = function() {
    var a = [];
    this.m_allitems = [];
    for (var b = 0; b < this.m_xnum * this.m_ynum; b++) {
        var c = new Qp_W(new createjs.Bitmap(this.m_imglist[b].m_queueresult),this.m_imglist[b].id);
        a.push(c)
    }
    b = a.length;
    for (c = 0; c < b; c++) {
        var d = Math.floor(Math.random() * b)
          , e = a[d];
        a[d] = a[c];
        a[c] = e
    }
    for (c = 0; c < b; c++)
        d = new Qp_T(a[c].img,a[c].id,Math.floor(c / this.m_xnum),c % this.m_xnum),
        this.m_allitems.push(d)
}
;
Qp_J.prototype.girdRefreshLoad = function() {
    for (var a = [], b = 0, c = 0; c < this.m_allitems.length; c++)
        !1 == this.m_allitems[c].m_isdeleted && (b++,
        a.push(this.m_allitems[c]));
    b = a.length;
    if (4 == b) {
        if (a[0].m_id == a[3].m_id)
            for (var d = Math.floor(Math.random() * b), e = a[d], c = 0; c < b; c++)
                if (console.log("itemsrcs[i].m_id", a[c].m_id),
                c != d && a[c].m_id != e.m_id) {
                    e = a[d];
                    a[d] = a[c];
                    a[c] = e;
                    break
                }
    } else
        for (c = 0; c < b; c++)
            d = Math.floor(Math.random() * b),
            e = a[d],
            a[d] = a[c],
            a[c] = e;
    for (c = b = 0; c < this.m_allitems.length; c++)
        !1 == this.m_allitems[c].m_isdeleted && 
        (d = new Qp_T(new createjs.Bitmap(a[b].iconimg),a[b].m_id,Math.floor(c / this.m_xnum),c % this.m_xnum),
        this.m_allitems.splice(c, 1, d),
        b++)
}
;
Qp_J.prototype.isconnected = function(a, b) {
    if (a.x == b.x && this.isconnectedInSameHang(a, b)) {
        var c = [];
        c.push(a);
        c.push(b);
        qp_S(c);
        return !0
    }
    return a.y == b.y && this.isconnectedInSameLie(a, b) ? (c = [],
    c.push(a),
    c.push(b),
    qp_S(c),
    !0) : this.isconnectedOneCorner(a, b) ? !0 : this.isconnectedTwoCorner(a, b)
}
;
Qp_J.prototype.isconnectedInSameHang = function(a, b) {
    if (a.x == b.x && a.y == b.y)
        return !1;
    for (var c = a.y < b.y ? b.y : a.y, d = (a.y < b.y ? a.y : b.y) + 1; d < c; d++)
        if (!0 != this.m_allitems[a.x * this.m_xnum + d].m_isdeleted)
            return !1;
    return !0
}
;
Qp_J.prototype.isconnectedInSameLie = function(a, b) {
    if (a.x == b.x && a.y == b.y)
        return !1;
    for (var c = a.x < b.x ? b.x : a.x, d = (a.x < b.x ? a.x : b.x) + 1; d < c; d++)
        if (!0 != this.m_allitems[d * this.m_xnum + a.y].m_isdeleted)
            return !1;
    return !0
}
;
Qp_J.prototype.isconnectedOneCorner = function(a, b) {
    var c = new Qp_U(b.x,a.y)
      , d = new Qp_U(a.x,b.y);
    if (!0 == this.m_allitems[c.x * this.m_xnum + c.y].m_isdeleted) {
        if (this.isconnectedInSameHang(b, c) && this.isconnectedInSameLie(a, c)) {
            var e = [];
            e.push(a);
            !0 == this.m_allitems[c.x * qp_f + c.y].m_isdeleted ? e.push(c) : e.push(d);
            e.push(b);
            qp_S(e);
            return !0
        }
        return !1
    }
    return !0 == this.m_allitems[d.x * this.m_xnum + d.y].m_isdeleted && this.isconnectedInSameHang(a, d) && this.isconnectedInSameLie(b, d) ? (e = [],
    e.push(a),
    !0 == this.m_allitems[c.x * 
    qp_f + c.y].m_isdeleted ? e.push(c) : e.push(d),
    e.push(b),
    qp_S(e),
    !0) : !1
}
;
Qp_J.prototype.isconnectedTwoCorner = function(a, b) {
    var c = this.scanLineBetweenTwoPoints(a, b);
    if (0 == c.length)
        return !1;
    for (var d = 0; d < c.length; d++) {
        var e = c[d];
        if (1 == e.direction) {
            if (this.isconnectedInSameLie(a, e.a) && this.isconnectedInSameLie(b, e.b))
                return e = [],
                e.push(a),
                e.push(new Qp_U(c[d].a.x,c[d].a.y)),
                e.push(new Qp_U(c[d].b.x,c[d].b.y)),
                e.push(b),
                qp_S(e),
                !0
        } else if (this.isconnectedInSameHang(a, e.a) && this.isconnectedInSameHang(b, e.b))
            return e = [],
            e.push(a),
            e.push(new Qp_U(c[d].a.x,c[d].a.y)),
            e.push(new Qp_U(c[d].b.x,
            c[d].b.y)),
            e.push(b),
            qp_S(e),
            !0
    }
    return !1
}
;
Qp_J.prototype.scanLineBetweenTwoPoints = function(a, b) {
    for (var c = [], d = a.y; 0 <= d; d--)
        !0 == this.m_allitems[a.x * this.m_xnum + d].m_isdeleted && !0 == this.m_allitems[b.x * this.m_xnum + d].m_isdeleted && this.isconnectedInSameLie(new Qp_U(a.x,d), new Qp_U(b.x,d)) && c.push(new Qp_V(new Qp_U(a.x,d),new Qp_U(b.x,d),0));
    for (d = a.y; d < this.m_xnum; d++)
        !0 == this.m_allitems[a.x * this.m_xnum + d].m_isdeleted && !0 == this.m_allitems[b.x * this.m_xnum + d].m_isdeleted && this.isconnectedInSameLie(new Qp_U(a.x,d), new Qp_U(b.x,d)) && c.push(new Qp_V(new Qp_U(a.x,
        d),new Qp_U(b.x,d),0));
    for (d = a.x; 0 <= d; d--)
        !0 == this.m_allitems[d * this.m_xnum + a.y].m_isdeleted && !0 == this.m_allitems[d * this.m_xnum + b.y].m_isdeleted && this.isconnectedInSameHang(new Qp_U(d,a.y), new Qp_U(d,b.y)) && c.push(new Qp_V(new Qp_U(d,a.y),new Qp_U(d,b.y),1));
    for (d = a.x; d < this.m_ynum; d++)
        !0 == this.m_allitems[d * this.m_xnum + a.y].m_isdeleted && !0 == this.m_allitems[d * this.m_xnum + b.y].m_isdeleted && this.isconnectedInSameHang(new Qp_U(d,a.y), new Qp_U(d,b.y)) && c.push(new Qp_V(new Qp_U(d,a.y),new Qp_U(d,b.y),1));
    return c
}
;
function qp_H(a) {
    for (var b = a.length; 0 < b; b--) {
        var c = Math.floor(Math.random() * (b - 1))
          , d = a[c];
        a[c] = a[b - 1];
        a[b - 1] = d
    }
}
function qp_Y(a) {
    for (var b = a.length, c = [], d = 0; d < b; d++)
        c.push(d);
    for (d = b; 0 < d; d--) {
        var e = Math.floor(Math.random() * (d - 1))
          , h = c[e];
        c[e] = c[d - 1];
        c[d - 1] = h
    }
    e = [];
    for (d = 0; d < b; d++)
        e.push(a[c[d]]);
    return e
}
function qp_X(a, b) {
    for (var c = qp_Y(a), d = [], e = 0; e < Math.min(b, a.length); e++)
        d.push(c[e]);
    return d
}
;