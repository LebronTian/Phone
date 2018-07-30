
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .form-article{  padding: 0.8rem;  }
    .form-section{  margin-bottom: 1.2rem; border-radius: 6px }

    .status-btn{float: right;padding: 0.3rem 0.6rem;border-radius: 6px;border: thin solid white;}

    .form-title{padding: 1rem;border-top-left-radius: 6px;border-top-right-radius: 6px;line-height: 1.6}
    .form-bottom{padding: 1rem;}
    .form-detail{margin: 0.5rem 0;}
    .go-btn{padding: 0.5rem;border-radius: 4px;border: none}
    .date-icon{height: 1.3rem}

    .form-section:nth-child(odd){  background: #e8fcfc;  }
    .form-section:nth-child(even){  background: #f2f7fd;  }
    .form-section:nth-child(odd) .form-title{  background: #10b2ac;  color: white;  }
    .form-section:nth-child(even) .form-title{  background: #0189fc;  color: white;  }
    .form-section:nth-child(odd) .status-btn{  background:#249692; color: white }
    .form-section:nth-child(even) .status-btn{  background:#197ccd; color: white }
</style>
<article class="form-article">

    <?php
    if(!empty($forms['list'])){
        foreach ($forms['list'] as $form) {
            ?>
            <section class="form-section">
                <p class="form-title clearfix">
                    <?php echo $form['title'] ?>
                    <?php
                    if(isset($form['status'])){
                        echo'<button class="status-btn">'.(($form['status']==0)?"报名中":"已结束").'</button>';
                    }
                    ?>
                </p>
                <div class="form-bottom">
                    <div class="form-brief small-text">
                        <?php echo $form['brief'] ?>
                    </div>
                    <diV class="form-detail linear-section">
                        <?php
                        if(!empty($form['access_rule']['start_time'])){
                            ?>
                            <p class="small-text">
                                <img class="date-icon" src="/app/form/view/girl/static/images/start.png">
                                <span>报名时间：<?php echo date('m月d日 H点',$form['access_rule']['start_time']) ?></span>
                            </p>
                        <?php
                        }
                        ?>
                        <?php
                        if(!empty($form['access_rule']['end_time'])){
                            ?>
                            <p class="small-text">
                                <img class="date-icon" src="/app/form/view/girl/static/images/end.png">
                                <span>结束时间：<?php echo date('m月d日 H点',$form['access_rule']['end_time']) ?></span>
                            </p>
                        <?php
                        }
                        ?>
                <span class="linear-right vertical-box"><span>
                        <?php
                        if(isset($form['status'])&&($form['status']==0)){
                            ?>
                            <button class="go-btn color-secondary" onclick="window.location.href='?_a=form&f_uid=<?php echo $form['uid'] ?>'">点我报名</button>
                            <?php
                        }
                        ?>
                </span></span>
                    </diV>
                </div>
            </section>
    <?php
        }
    }
    ?>

    <!--<section class="form-section">
        <p class="form-title clearfix">
            深圳创业沙龙大会，你听说了吗，各路大牛踊跃参加，你还在等什么？
            <button class="status-btn">报名中</button>
        </p>
        <div class="form-bottom">
            <div class="form-brief small-text">
                到场的各路大牛都有，新疆牦牛，非洲大水牛，南美犀牛，中国野生天牛，就问你牛不牛，个个创业高手。能看见的机会真不多，是不是更想来了啊
            </div>
            <diV class="form-detail linear-section">
                <p class="small-text">10月16日</p>
                <span class="linear-right vertical-box"><span>
                    <button class="go-btn color-secondary">点我报名</button>
                </span></span>
            </diV>
        </div>
    </section>-->

</article>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('zepto', function () {
        $(document).ready(function () {
            var max_text_length = 150;
            $('.form-brief').each(function () {
                var brief = $(this).text();
                var length = brief.length;
                console.log(length,length>max_text_length);
                if(length>max_text_length){
                    var short_brief = brief.substr(0,max_text_length)+'......';
                    $(this).text(short_brief)
                }
            })
        })
    });
</script>