
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    body{background-color: #e8fcfc}
    .form-article{}
    .form-section{  margin-bottom: 0.8rem; border-radius: 6px }
    .status-btn{float: right;padding: 0.3rem 0.6rem;border-radius: 6px;border: thin solid white;}
    .form-title{padding: 1rem;line-height: 1.6}
    .form-bottom{padding: 1rem;}
    .form-detail{margin: 0.5rem 0;line-height: 1.5}
    .go-btn{padding: 0.5rem;border-radius: 4px;border: none}
    .date-icon{height: 1.3rem}
    .form-section:nth-child(odd){  background: #e8fcfc;  }
    .form-section:nth-child(even){  background: #f2f7fd;  }
    .form-section:nth-child(odd) .form-title{  background: #10b2ac;  color: white;  }
    .form-section:nth-child(even) .form-title{  background: #0189fc;  color: white;  }
    .form-section:nth-child(odd) .status-btn{  background:#249692; color: white }
    .form-section:nth-child(even) .status-btn{  background:#197ccd; color: white }

    .new-color{  background: #10b2ac;  color: white; }

    #id_form_content{
        padding: 0.8rem;
        padding-top: 0;
    }
    body>header{
        overflow: hidden;
    }
    .form-article .linear-title{
        text-align: right;
    }
    .remark-input{
        color: #666666;
        font-size: 1em;
    }
</style>
<!--<header class="color-main vertical-box">
    <span class="header-title"><?php /*echo $form['title'] */?></span>
</header>-->
<article class="form-article btn-footer-margin">

    <?php
    if(!empty($form)){
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
                </diV>
            </div>
        </section>
        <section id="id_form_content">

        </section>
    <?php
    }
    ?>

</article>

<?php

if(
    (empty($record))||($form['access_rule']['can_edit'])
){
    ?>

    <footer class="btn-footer footer-one-btn">
        <button class="new-color" id="id_commit"><?php echo(!empty($record))?"修改报名资料":"立即报名" ?></button>
    </footer>

<?php


}
?>



<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var g_form = <?php echo(!empty($form)? json_encode($form):"null")?>;
    var g_record = <?php echo(!empty($record)? json_encode($record):"null")?>;
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('zepto', function () {
        $(document).ready(function () {
            seajs.use('app_js/index.js')

        })
    });
</script>