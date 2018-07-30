<?php include $tpl_path.'/header.tpl'; ?>
<?php 
     $pt = SuPointMod::get_user_points_by_su_uid($su['uid']);
?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/user.css">
<style>
    .user-top-box{
        background-image: url('static/images/user-b.png') !important;
    }
</style>


<article class="user-article nav-footer-margin">
    <section class="user-top-box clear">
        <div class="left" onclick="window.location.href='?_easy=su.common.index.mycount'">
            <p>余额</p>
            <p class="num">&yen;<?php if(isset($pt['cash_remain'])) echo sprintf('%.2f',($pt['cash_remain']/100)) ?></p>
        </div>
        <div class="center">
            <div class="img"><img src="<?php echo((!empty($su['avatar']))?$su['avatar']:
            $static_path.'/images/avatar.png')?>" alt=""></div>
            <p><?php if(!empty($su['name'])) echo $su['name'] ?></p>
            <p>id:<?php if(!empty($su['uid'])) echo $su['uid'] ?></p>
        </div>
        <div class="right" onclick="window.location.href='?_easy=vipcard.single.index.point'">
            <p>积分</p>
            <p class="num"><?php echo((!empty($pt['point_remain']))?$pt['point_remain']:0)?></p>
        </div>
    </section>

    <section class="linear-section linear-noinput margin-top" onclick="window.location.href='?_a=shop&_u=user.orders'">
         <p class="user-section-p"><svg t="1494482738185" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5666" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M800 928 224 928c-52.928 0-96-43.072-96-96L128 192c0-52.928 43.072-96 96-96l576 0c52.928 0 96 43.072 96 96l0 640C896 884.928 852.928 928 800 928zM224 160C206.368 160 192 174.368 192 192l0 640c0 17.664 14.368 32 32 32l576 0c17.664 0 32-14.336 32-32L832 192c0-17.632-14.336-32-32-32L224 160z" p-id="5667"></path><path d="M640.992 544.864 287.776 544.864c-17.664 0-32-14.336-32-32s14.336-32 32-32l353.216 0c17.696 0 32 14.336 32 32S658.688 544.864 640.992 544.864z" p-id="5668"></path><path d="M734.88 735.52 287.648 735.52c-17.664 0-32-14.304-32-32s14.336-32 32-32l447.232 0c17.696 0 32 14.304 32 32S752.576 735.52 734.88 735.52z" p-id="5669"></path><path d="M303.712 305.344m-48 0a1.5 1.5 0 1 0 96 0 1.5 1.5 0 1 0-96 0Z" p-id="5670"></path><path d="M511.104 305.344m-48 0a1.5 1.5 0 1 0 96 0 1.5 1.5 0 1 0-96 0Z" p-id="5671"></path><path d="M719.232 305.344m-48 0a1.5 1.5 0 1 0 96 0 1.5 1.5 0 1 0-96 0Z" p-id="5672"></path></svg><span>我的订单</span></p>
        <span class="linear-right vertical-box"><span>
            <span class="white-tips-font fz12" style="vertical-align: text-bottom;">查看更多订单</span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>
    <?php
    $status_array=array();
    if(!empty($order_count_group_by_status)){
        foreach($order_count_group_by_status as $order_status){
            $status_array[$order_status['status']] = $order_status['count'];
        }
    }
    ?>
    <section class="detail-sort-section margin-bottom">
        <div class="display-table">
            <ul>
              <li class="tips-font" onclick="window.location.href='?_a=shop&_u=user.orders&status=1'">
              	<span class="user-tips-img">
              		<svg t="1493893748103" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4362" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M799.488 900.448 159.936 900.448c-52.928 0-96-43.072-96-96L63.936 225.952c0-52.928 43.072-96 96-96l642.496 0c52.928 0 96 43.072 96 96L898.432 320c0 17.664-14.304 32-32 32s-32-14.336-32-32L834.432 225.952c0-17.632-14.336-32-32-32L159.936 193.952c-17.632 0-32 14.368-32 32l0 578.496c0 17.664 14.368 32 32 32l639.552 0c17.664 0 32-14.336 32-32l0-98.944c0-17.696 14.304-32 32-32s32 14.304 32 32l0 98.944C895.488 857.376 852.448 900.448 799.488 900.448z" p-id="4363"></path><path d="M661.472 514.112m-31.328 0a0.979 0.979 0 1 0 62.656 0 0.979 0.979 0 1 0-62.656 0Z" p-id="4364"></path><path d="M896 640 576 640c-35.296 0-64-28.704-64-64l0-128c0-35.296 28.704-64 64-64l320 0c35.296 0 64 28.704 64 64l0 128C960 611.296 931.296 640 896 640zM576 448l0 128 320.064 0L896 448 576 448z" p-id="4365"></path></svg>
              	</span>
                    <span class="order-ball-content">待付款
                        <?php
                        if(!empty($status_array['1'])){
                            echo '<span class="order-green-ball active-font">'.$status_array['1'].'</span>';
                        }
                        ?>
                    </span>
                </li>
              <li class="tips-font" onclick="window.location.href='?_a=shop&_u=user.orders&status=2'">
              	<span class="user-tips-img">
              		<svg t="1493893902079" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4493" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M287.008 512 224.992 512c-17.664 0-32-14.336-32-32s14.336-32 32-32l62.016 0c17.664 0 32 14.336 32 32S304.672 512 287.008 512z" p-id="4494"></path><path d="M882.624 128 141.44 128C98.72 128 64 162.688 64 205.376l0 154.624 0 8.48 0 458.016c0 38.304 31.936 69.472 71.168 69.472l753.696 0c39.264 0 71.168-31.168 71.168-69.472L960.032 368.48 960.032 205.376C960 162.688 925.28 128 882.624 128zM896 205.376l0 131.104-223.488 0L672.512 192l210.112 0C889.984 192 896 198.016 896 205.376zM446.688 192l161.824 0 0 360.448-70.784-28.224c-7.712-3.104-16.352-3.04-24 0.128l-67.04 27.52L446.688 192zM128 205.376C128 198.016 134.016 192 141.44 192l241.248 0 0 144.48L128 336.48 128 205.376zM888.832 831.968 135.168 831.968C130.944 831.968 128 829.088 128 826.496L128 400.48l254.688 0 0 199.168c0 10.656 5.312 20.64 14.176 26.592 5.344 3.552 11.552 5.408 17.824 5.408 4.096 0 8.256-0.768 12.16-2.4l99.232-40.736 102.592 40.864c9.856 3.968 21.024 2.72 29.824-3.232 8.768-5.984 14.016-15.872 14.016-26.496l0-199.168L896 400.48l0 426.016C896 829.088 893.056 831.968 888.832 831.968z" p-id="4495"></path></svg>
              	</span>
                    <span class="order-ball-content">待发货
                        <?php
                        if(!empty($status_array['2'])){
                            echo '<span class="order-green-ball active-font">'.$status_array['2'].'</span>';
                        }
                        ?>
                    </span>
                </li>
               <li class="tips-font" onclick="window.location.href='?_a=shop&_u=user.orders&status=3'">
              	<span class="user-tips-img">
              		<svg t="1493893965634" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4623" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M352 576 224 576c-17.664 0-32-14.304-32-32 0-17.664 14.336-32 32-32l96 0 0-96c0-17.664 14.336-32 32-32s32 14.336 32 32l0 128C384 561.696 369.664 576 352 576z" p-id="4624"></path><path d="M702.144 666.88c-61.952 0-113.664 43.296-127.296 101.12l-123.808 0c-13.568-57.888-65.344-101.216-127.328-101.216-72.288 0-131.104 58.784-131.104 131.072 0 72.352 58.816 131.232 131.104 131.232 60.384 0 110.848-41.344 125.984-97.056l126.432 0c15.104 55.712 65.568 96.992 126.016 96.992 72.224 0 131.008-58.784 131.008-131.072S774.368 666.88 702.144 666.88zM323.744 865.056c-36.992 0-67.104-30.144-67.104-67.232 0-36.96 30.08-67.072 67.104-67.072 36.992 0 67.072 30.08 67.072 67.072C390.816 834.912 360.736 865.056 323.744 865.056zM702.144 864.992c-36.96 0-67.072-30.08-67.072-67.072s30.08-67.072 67.072-67.072c36.928 0 67.008 30.08 67.008 67.072S739.104 864.992 702.144 864.992z" p-id="4625"></path><path d="M864.032 96 399.744 96C355.776 96 320 131.776 320 175.744l0 92.512L125.344 366.08c-1.376 0.704-2.72 1.504-4 2.4-36.096 25.376-56 64.96-56 111.52l0 321.984c0 17.696 14.336 32 32 32s32-14.304 32-32L129.344 480c0-25.024 9.088-44.512 27.04-57.888l209.984-105.504c1.44-0.704 2.368-1.984 3.648-2.88 1.888-1.312 3.776-2.496 5.312-4.16 1.408-1.536 2.336-3.328 3.424-5.056 1.088-1.728 2.24-3.328 2.976-5.28 0.8-2.176 1.024-4.416 1.344-6.688C383.328 290.976 384 289.6 384 288L384 175.744C384 167.072 391.072 160 399.744 160l464.288 0C881.664 160 896 174.592 896 192.512L896 800c0 17.696 14.304 32 32 32s32-14.304 32-32L960 192.512C960 139.296 916.928 96 864.032 96z" p-id="4626"></path></svg>
              	</span>
                    <span class="order-ball-content">待收货
                        <?php
                        if(!empty($status_array['3'])){
                            echo '<span class="order-green-ball active-font">'.$status_array['3'].'</span>';
                        }
                        ?>
                    </span>
                </li>
                <li class="tips-font" onclick="window.location.href='?_a=shop&_u=user.orders&status=4'">
              	<span class="user-tips-img">
              		<svg t="1493894009954" class="icon svg-main" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4754" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M405.536 932.128c-8.8 0-17.568-3.584-23.904-10.688-83.232-93.216-217.856-94.112-220.64-94.112-0.096 0-0.096 0-0.192 0-17.568 0-31.904-14.176-32.032-31.744-0.128-17.664 14.016-32.064 31.648-32.256 6.656-0.352 165.664-0.192 268.96 115.488 11.776 13.184 10.624 33.408-2.56 45.184C420.736 929.44 413.12 932.128 405.536 932.128z" p-id="4755"></path><path d="M620.128 932.064c-7.776 0-15.584-2.816-21.76-8.544-12.96-12-13.76-32.256-1.728-45.216 106.976-115.52 262.752-115.392 268.896-115.136 17.696 0.192 31.872 14.656 31.68 32.32-0.192 17.568-14.464 31.68-32 31.68-0.096 0-0.16 0-0.256 0L864.96 827.168c-2.656 0-134.56 0.864-221.376 94.624C637.312 928.64 628.704 932.064 620.128 932.064z" p-id="4756"></path><path d="M563.712 769.312l-101.408 0c-3.232 0-6.368-0.48-9.344-1.408-108.256-13.888-200.256-76.704-259.552-177.44C124.576 473.472 108.8 321.888 154.208 213.248c4.896-11.68 16.224-19.392 28.896-19.648l9.632-0.096c60.96 0 117.888 11.52 169.696 34.304 37.44-68.448 80.192-120.384 127.328-154.688 2.496-2.176 5.344-4 8.512-5.344l0 0c9.888-4.288 21.376-3.36 30.432 2.528 1.568 1.024 3.04 2.176 4.384 3.456 47.264 34.688 88.832 85.856 126.464 155.744 52.832-23.872 111.072-35.968 173.632-35.968l9.792 0.096c12.672 0.256 24 7.968 28.896 19.648 45.408 108.672 29.664 260.256-39.232 377.248-59.296 100.672-151.264 163.52-259.488 177.44C570.112 768.8 566.976 769.312 563.712 769.312zM468 705.312l90.016 0c0.672-0.128 1.376-0.224 2.08-0.32 115.712-12.864 182.08-87.072 217.376-147.008 54.048-91.872 70.432-211.936 42.528-300.32-58.24 1.888-111.616 16.16-158.816 42.528-7.712 4.288-16.832 5.184-25.184 2.624-8.384-2.624-15.328-8.608-19.2-16.512-32.448-66.368-67.232-115.2-105.824-148.48-38.624 33.216-74.176 82.4-105.92 146.592-3.872 7.808-10.72 13.696-19.04 16.32-8.32 2.656-17.28 1.76-24.96-2.4C314.848 273.216 262.72 259.552 206.048 257.696c-27.904 88.384-11.52 208.448 42.528 300.288 35.296 59.936 101.632 134.112 217.312 147.008C466.592 705.088 467.296 705.184 468 705.312z" p-id="4757"></path><path d="M512.768 960c-17.664 0-32-14.304-32-32l0-190.688c0-17.696 14.336-32 32-32s32 14.304 32 32L544.768 928C544.736 945.696 530.432 960 512.768 960z" p-id="4758"></path></svg>
              	</span>
                    <span class="order-ball-content">待评价
                        <?php
                        if(!empty($status_array['4'])){
                            echo '<span class="order-green-ball active-font">'.$status_array['4'].'</span>';
                        }
                        ?>
                    </span>
                </li>
            </ul>
        </div>
    </section>

    <section class="linear-section linear-noinput"><p class="user-section-p"><svg t="1497929549254" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4407" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M384 480 192 480c-52.928 0-96-43.072-96-96L96 192c0-52.928 43.072-96 96-96l192 0c52.928 0 96 43.072 96 96l0 192C480 436.928 436.928 480 384 480zM192 160C174.368 160 160 174.368 160 192l0 192c0 17.632 14.368 32 32 32l192 0c17.632 0 32-14.368 32-32L416 192c0-17.632-14.368-32-32-32L192 160z" p-id="4408"></path><path d="M384 928 192 928c-52.928 0-96-43.072-96-96l0-192c0-52.928 43.072-96 96-96l192 0c52.928 0 96 43.072 96 96l0 192C480 884.928 436.928 928 384 928zM192 608c-17.632 0-32 14.336-32 32l0 192c0 17.664 14.368 32 32 32l192 0c17.632 0 32-14.336 32-32l0-192c0-17.664-14.368-32-32-32L192 608z" p-id="4409"></path><path d="M832 928l-192 0c-52.928 0-96-43.072-96-96l0-64c0-52.928 43.072-96 96-96l192 0c52.928 0 96 43.072 96 96l0 64C928 884.928 884.928 928 832 928zM640 736c-17.664 0-32 14.336-32 32l0 64c0 17.664 14.336 32 32 32l192 0c17.664 0 32-14.336 32-32l0-64c0-17.664-14.336-32-32-32L640 736z" p-id="4410"></path><path d="M832 608l-192 0c-52.928 0-96-43.072-96-96L544 192c0-52.928 43.072-96 96-96l192 0c52.928 0 96 43.072 96 96l0 320C928 564.928 884.928 608 832 608zM640 160c-17.664 0-32 14.368-32 32l0 320c0 17.632 14.336 32 32 32l192 0c17.664 0 32-14.368 32-32L864 192c0-17.632-14.336-32-32-32L640 160z" p-id="4411"></path></svg><span>必备工具</span></p></section>
    <section class="user-tool linear-section">
        <ul class="clear">
            <li onclick="window.location.href='<?php echo DomainMod::get_app_url('vipcard',$shop['sp_uid']); ?>'">
                <p><svg t="1497931213108" class="icon" style="" viewBox="0 0 1304 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3794" xmlns:xlink="http://www.w3.org/1999/xlink" width="254.6875" height="200"><defs><style type="text/css"></style></defs><path d="M1117.499034 439.011948c-6.811187 0-13.312774-0.773998-19.659562-2.012396l-13.931973 64.241875c-2.167196 65.015874-39.319124 288.85624-39.319124 288.85624L257.122302 790.097667c0 0-23.374755-224.304765-29.102344-292.571433l-12.229176-64.087076c-10.06198 3.405593-20.58836 5.572789-31.579139 5.572789-56.347091 0-102.013002-45.820711-102.013002-102.477401 0-56.50189 45.665911-102.322602 102.013002-102.322602 56.50189 0 102.013002 45.820711 102.013002 102.322602 0 17.182767-4.643991 33.127136-12.074377 47.368708l186.998038 69.659865L618.270002 199.072413c-40.247922-13.622374-69.505065-51.5483-69.505065-96.595013 0-56.50189 45.665911-102.477401 102.013002-102.477401 56.347091 0 102.167802 45.820711 102.167802 102.477401 0 45.046713-29.257143 82.972639-69.659865 96.595013l157.121695 254.490707L1025.548012 380.497661c-6.346788-13.467574-10.21678-28.173545-10.21678-43.963115 0-56.50189 45.820711-102.477401 102.167802-102.477401 56.347091 0 102.013002 45.820711 102.013002 102.477401C1219.512037 393.191236 1173.846125 439.011948 1117.499034 439.011948L1117.499034 439.011948zM1044.588376 906.971441c-40.712321 86.997431-90.557824 117.028573-175.078461 117.028573L432.045963 1024.000014c-64.396675 0-139.31973-30.031142-174.923661-117.028573l0-29.102344 787.620874 0L1044.743175 906.971441 1044.588376 906.971441zM1044.588376 906.971441" p-id="3795" fill="#39cb80"></path></svg></p>
                <p>我的会员</p>
            </li>
            <li onclick="window.location.href='?_a=shop&_u=user.profile'">
                <p><svg t="1497931314844" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1560" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M101.43744 797.83936" p-id="1561" fill="#39cb80"></path><path d="M876.84608 934.6816 110.11072 934.6816c-24.00768 0-43.55072-19.52768-43.55072-43.55072l0-107.89376 5.13536-5.11488c44.3648-44.2112 147.03104-78.27968 188.97408-99.072 47.72864-23.66464 88.192-38.01088 112.62976-44.3392 0.47104-2.3296 0.95744-5.09952 1.35168-8.20224-17.65888-20.88448-49.60768-64.32256-64.26112-119.6032-15.17056-9.80992-27.51488-26.30144-35.24608-47.33952-10.53696-28.60544-14.34624-72.2432 7.46496-105.1648-4.33152-41.57952-11.75552-137.33888 47.2576-202.99264 36.992-41.20064 92.05248-62.09024 163.6352-62.09024 71.6032 0 126.68416 20.89984 163.6864 62.11584 58.91584 65.6384 51.54304 161.2544 47.19616 202.95168 21.80608 32.87552 18.00192 76.49792 7.4752 105.10848-7.71584 21.05344-20.06528 37.56544-35.27168 47.38048-14.66368 55.32672-46.61248 98.74944-64.26112 119.61344 0.40448 3.11808 0.8704 5.89312 1.34144 8.20224 24.00768 6.23104 63.6928 20.2496 110.58176 43.32032 41.19552 20.27008 146.19136 53.52448 190.83776 96.77824l5.30432 5.13536 0 111.21152C920.3968 915.14368 900.864 934.6816 876.84608 934.6816L876.84608 934.6816 876.84608 934.6816" p-id="1562" fill="#39cb80"></path><path d="M957.44 309.97504c0 4.90496-2.87232 8.87808-6.4 8.87808l-197.58592 0c-3.53792 0-6.4-3.97312-6.4-8.87808l0-20.29568c0-4.90496 2.86208-8.87808 6.4-8.87808l197.58592 0c3.52768 0 6.4 3.97312 6.4 8.87808L957.44 309.97504M957.44 309.97504" p-id="1563" fill="#39cb80"></path><path d="M957.44 553.14944c0 4.90496-1.9968 8.87808-4.45952 8.87808l-137.44128 0c-2.46272 0-4.45952-3.97312-4.45952-8.87808l0-20.29568c0-4.90496 1.9968-8.88832 4.45952-8.88832l137.44128 0c2.46272 0 4.45952 3.97824 4.45952 8.88832L957.44 553.14944 957.44 553.14944M957.44 553.14944" p-id="1564" fill="#39cb80"></path><path d="M957.44 436.85888c0 4.89984-2.53952 8.86784-5.67808 8.86784l-175.25248 0c-3.12832 0-5.67296-3.97312-5.67296-8.86784l0-20.30592c0-4.90496 2.54464-8.8832 5.67296-8.8832l175.25248 0c3.13856 0 5.67808 3.97824 5.67808 8.8832L957.44 436.85888M957.44 436.85888" p-id="1565" fill="#39cb80"></path></svg></p>
                <p>个人资料</p>
            </li>
            <li onclick="window.location.href='?_a=shop&_u=user.coupons'">
                <p><svg t="1497930445406" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1010" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M4.992 357.056c0-20.288 3.456-34.752 9.984-43.52 6.656-8.64 21.312-12.864 44.288-12.864l141.312 0 0 563.584L139.904 864.256c-16.256 0-32.192-0.128-48-0.512-15.936-0.256-26.688-0.512-32.576-0.512-19.904 0.768-33.92-2.624-42.048-10.24-8.064-7.488-12.224-21.888-12.224-42.88l0-162.24c0-8.256 1.408-14.528 3.904-18.496C11.456 625.28 16.832 622.4 24.96 620.864c3.008 0 6.912-1.152 12.224-3.392 5.056-2.368 10.24-6.016 15.36-10.88s9.6-11.136 13.248-19.136C69.44 579.648 71.36 570.112 71.36 558.72c0-17.28-4.544-30.72-13.76-40.512C48.384 508.48 38.528 502.72 28.16 501.376 20.16 499.904 14.208 497.344 10.56 494.016 6.848 490.496 4.992 484.736 4.992 476.48L4.992 357.056 4.992 357.056zM96.704 249.984 96.704 236.416 96.704 235.264 96.704 234.112 96.704 220.608c0-14.912 5.824-28.928 17.152-41.664 11.328-12.736 23.744-19.2 36.992-19.2l152.576 0 0 90.24L96.704 249.984 96.704 249.984zM997.376 494.528c-5.76 1.6-10.112 4.736-12.736 9.728-2.368 4.736-3.904 10.24-3.904 16.128 0 6.144 1.472 11.904 3.904 17.472 2.624 5.76 6.976 9.728 12.736 11.904 5.888 2.368 10.624 6.848 13.888 13.504 3.392 6.848 5.248 13.888 5.504 21.504 0.384 7.488-0.64 14.72-2.752 21.376-2.24 6.72-5.504 11.648-9.856 14.72-14.72 9.024-22.016 19.136-22.016 30.4s7.232 22.656 22.016 33.728c3.008 2.368 5.632 6.528 8.256 12.352 2.496 6.144 3.776 12.096 3.776 18.24 0 6.016-1.344 11.136-4.352 15.616-3.008 4.608-8.128 6.848-15.488 6.848l-59.648 0c-4.224 0-6.72-0.384-6.976-1.28-0.384-0.768 0.128-1.984 1.472-3.776 1.472-1.984 3.264-4.032 5.504-6.4 2.24-2.24 4.032-4.864 5.632-7.872 3.648-10.496 3.648-19.52 0-27.008-3.776-7.616-9.856-13.888-18.88-19.136-5.888-3.008-10.24-7.744-12.608-14.272-2.624-6.272-3.648-12.864-3.264-19.648 0.256-6.848 1.472-12.736 3.776-17.984 2.24-5.376 5.632-9.152 9.856-11.392 6.016-2.24 10.368-6.4 13.248-12.352 3.008-5.888 4.48-12.352 4.48-19.136s-1.28-12.992-3.264-18.624c-2.24-5.632-5.504-9.6-10.112-11.776-5.76-3.136-10.368-7.488-13.76-13.632C908.48 528 906.88 521.28 906.88 513.728c0-7.616 1.344-14.848 4.352-22.016s7.616-12.992 14.272-17.472c4.608-3.008 8.256-7.104 11.136-12.352 3.136-5.376 4.48-10.88 5.12-16.896 0.384-6.08-1.024-11.84-3.392-17.472-2.624-5.696-7.232-10.304-13.888-14.08-7.232-3.712-12.736-9.28-16-16.32-3.264-7.168-4.992-14.592-4.992-22.016 0-7.616 1.728-14.656 4.992-21.504 3.264-6.656 7.872-12.032 13.76-15.872 12.48-6.656 19.52-15.936 20.48-27.52 1.152-11.648 0.256-22.464-2.752-32.064-2.368-7.616-6.656-14.336-13.12-20.352-6.72-6.08-15.232-9.024-25.472-9.024L370.944 248.768 370.944 159.744l622.208 0c5.12 0 9.344 1.92 12.992 5.632 3.776 3.776 6.272 8.256 7.36 13.568 1.152 5.248 0.768 10.688-1.152 16.32-1.728 5.568-5.248 10.432-10.496 14.208-4.48 3.776-8.384 8.512-11.648 14.592-3.392 6.016-4.992 12.16-5.632 18.624-0.256 6.464 0.768 12.736 2.88 19.2 2.112 6.336 6.144 11.072 12.096 14.08 8.256 4.48 14.272 10.688 18.24 18.496C1021.888 302.336 1024 310.208 1024 318.016c0 8-2.112 15.296-6.144 22.016-4.032 6.848-9.6 11.776-17.024 14.656-8.128 3.136-14.144 7.36-17.728 12.992-3.776 5.696-5.632 11.904-6.144 18.56-0.384 6.784 1.024 13.376 4.224 19.712 3.392 6.464 8.768 12.032 16.128 16.512 7.36 4.352 12.864 10.368 16.128 17.984 3.264 7.424 4.608 14.912 4.352 22.528-0.384 7.488-2.24 14.4-5.504 20.864C1008.896 490.112 1004.096 493.76 997.376 494.528L997.376 494.528zM853.76 477.632c-8.768 2.24-15.616 6.656-20.48 12.864-4.736 6.528-7.232 12.992-7.744 19.904-0.256 6.72 1.6 13.504 5.504 20.352 4.224 6.656 10.112 11.52 18.368 14.528 7.232 3.136 12.864 7.616 16.512 13.504 3.776 6.144 5.76 12.48 6.144 19.264s-1.024 13.248-3.904 19.136c-2.88 6.016-7.36 10.624-13.248 13.504-18.368 9.152-28.032 20.032-28.608 32.768-0.896 12.736 6.144 22.848 20.864 30.528 6.656 3.008 12.032 7.616 16 14.016 4.096 6.4 6.272 13.12 6.72 20.352 0.384 6.976-1.024 13.504-4.032 19.008-2.88 5.888-7.744 9.6-14.272 12.032-8.896 2.24-15.616 6.272-20.608 12.352-4.608 5.888-7.104 12.352-7.488 19.008-0.512 6.976 1.344 13.632 5.504 20.352 4.032 6.848 10.496 12.48 19.264 17.024 6.016 3.008 10.112 7.744 12.736 14.016 2.624 6.528 3.52 12.608 2.88 18.624-0.896 6.016-2.88 11.52-6.272 16.256-3.264 4.992-7.872 7.36-13.888 7.36l-577.92 0L265.792 300.672l584.576 0c5.888 0 10.624 2.304 14.016 7.36 3.264 4.864 4.992 10.24 5.504 16.32 0.384 6.08-1.024 12.032-4.032 17.984-2.88 5.952-7.744 10.176-14.272 12.352-6.656 2.304-12.032 6.08-16.128 11.328-4.096 5.184-6.4 11.136-7.232 17.408-0.64 6.464 0.896 12.544 4.48 18.624 3.776 6.08 9.984 10.56 18.88 13.504 6.528 3.008 12.032 7.488 16 13.568s6.4 12.16 6.656 18.496c0.384 6.592-1.152 12.48-4.352 18.24C866.624 471.36 861.248 475.392 853.76 477.632L853.76 477.632zM587.392 553.28c-3.52 0-7.488-0.384-11.648-1.152C571.776 551.232 571.008 548.992 572.992 545.28c0.896-1.344 4.352-6.72 10.624-15.744 6.272-9.152 13.12-18.624 20.992-28.736 7.744-10.24 14.72-19.776 21.632-28.736 6.528-9.024 10.624-14.656 12.032-17.024 3.776-5.888 1.472-12.992-6.656-21.312C630.272 432.192 627.264 429.888 622.72 426.816 618.496 423.872 614.4 421.632 610.752 420.16c-6.016-2.176-10.24-2.624-12.864-1.088C595.52 420.544 592.256 423.872 588.608 429.184 587.136 431.36 583.488 436.864 577.472 445.44 571.648 454.272 565.376 463.36 558.72 473.152 552.128 483.008 545.984 491.776 540.48 499.52 534.848 507.52 531.776 512.128 531.136 513.728 529.728 516.608 526.848 517.888 522.752 517.12 518.72 516.352 516.032 514.496 514.624 511.488 513.728 510.016 510.528 505.6 504.576 498.368 498.624 491.392 492.288 483.392 485.76 474.24S472.768 456.896 466.496 448.896C460.16 440.96 456 435.584 453.696 432.448 447.04 419.712 440.064 415.616 432.768 420.16 427.584 423.104 422.912 426.304 418.816 429.632 414.784 433.152 410.944 435.968 407.296 438.272c-7.36 5.12-8.448 11.968-3.328 20.224 12.48 14.976 23.616 28.864 33.216 41.728 8.064 10.496 15.744 20.48 23.232 30.528 7.296 9.6 11.712 15.232 13.12 16.896 1.536 2.88 0 4.48-4.416 4.48L456 552.128c-3.648 0-9.088 0.128-16 0.512C432.896 553.024 426.432 552.896 420.48 552.128c-5.824 0-10.688 1.344-14.4 4.48C402.496 559.488 401.344 563.264 402.88 567.744 403.584 570.88 403.968 575.36 403.968 581.248l0 13.76c0 3.648 1.024 5.76 3.328 6.144C409.536 601.472 412.032 601.6 415.04 601.6l64.128 0c8.704 0 13.12 1.856 13.12 5.632l0 21.376c0 3.904-0.64 5.76-2.176 5.76L484.608 634.368 473.472 634.368 451.456 634.368 429.312 634.368 416.064 634.368C411.712 633.6 408.832 634.752 407.296 637.632c-1.408 3.136-2.496 6.528-3.328 10.24-0.768 3.904-0.768 7.36 0 10.624 0.832 3.52 1.024 6.4 1.024 8.512 0 9.856 4.8 14.72 14.4 14.72L485.76 681.728c3.84 0 5.952 0.512 6.592 1.6 0.704 1.152 1.152 3.648 1.152 7.36 0.768 3.776 1.024 10.496 0.512 20.224C493.696 720.768 493.44 727.104 493.44 730.24c0 8.256 4.8 12.352 14.336 12.352l35.456 0c5.888 0 8.896-1.856 8.896-5.76l0-7.744 0-37.248c0-7.616 3.392-11.392 9.856-11.392l9.984 0c5.12 0 11.008-0.128 17.152-0.64 6.4-0.256 12.352-0.512 18.112-0.512l14.4 0c10.24 0 15.616-3.776 15.616-11.136l0-24.896c0-6.848-3.648-10.24-11.008-10.24L561.984 633.024c-7.232 1.6-11.136 0-11.136-4.48 0-2.112-0.128-4.992-0.512-8.384S549.888 613.76 549.888 610.624c0-2.88 1.152-5.248 3.776-6.656C556.352 602.368 559.104 601.6 561.984 601.6l65.28 0c7.232 0 11.008-2.496 11.008-7.872L638.272 566.656c0-3.008-1.28-5.888-3.904-8.896-2.624-3.136-5.76-4.48-9.344-4.48L587.392 553.28 587.392 553.28zM587.392 553.28" p-id="1011" fill="#39cb80"></path></svg></p>
                <p>我的优惠券</p>
            </li>
            <li onclick="window.location.href='?_a=shop&_u=user.address'">
                <p><svg t="1497930494426" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1724" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M896 384C896 663.296 571.08 991.424 557.264 1005.256 544.768 1017.752 528.376 1024 512 1024 495.624 1024 479.248 1017.752 466.752 1005.256 452.92 991.424 128 663.296 128 384 128 172.264 300.264 0 512 0 723.736 0 896 172.264 896 384L896 384ZM512 576C618.048 576 704 490.048 704 384 704 277.968 618.048 192 512 192 405.968 192 320 277.968 320 384 320 490.048 405.968 576 512 576L512 576Z" p-id="1725" fill="#39cb80"></path></svg></p>
                <p>收货地址</p>
            </li>
        </ul>
    </section>
    <section class="user-tool linear-section">
        <ul class="clear">
            <li onclick="location.href='?_a=shop&_u=user.history'">
                <p><svg t="1497930784224" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1017" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M210.58016 169.6a33.12 33.12 0 0 1-20.48-7.04 30.112 30.112 0 0 1-4.16-43.52A346.336 346.336 0 0 1 515.22016 23.68a30.944 30.944 0 0 1 24.96 36.48 32 32 0 0 1-37.76 24c-172.8-33.92-263.36 69.76-267.2 74.24a32 32 0 0 1-24.64 11.2zM128.34016 294.08a64.192 64.192 0 1 1-64.32-61.76A63.264 63.264 0 0 1 128.34016 294.08z m376-123.52a389.504 389.504 0 0 0-199.36 53.12 283.328 283.328 0 0 0-141.44 200.64c-24.64 158.72 101.44 312.32 287.68 349.76a57.12 57.12 0 0 0 7.36 0.64 166.4 166.4 0 0 1 111.04 33.6 1059.904 1059.904 0 0 1 76.16 96.32 285.92 285.92 0 0 0 22.08 28.8 202.688 202.688 0 0 0 156.8 74.56A197.12 197.12 0 0 0 1024.34016 814.08a262.624 262.624 0 0 0-88.64-175.04l-49.92-54.72a76.8 76.8 0 0 1-9.28-56 279.168 279.168 0 0 0-74.88-232 391.84 391.84 0 0 0-234.88-121.28 412.288 412.288 0 0 0-62.4-4.48z" p-id="1018" fill="#39cb80"></path></svg></p>
                <p>我的足迹</p>
            </li>
            <li onclick="window.location.href='?_a=shop&_u=user.favlist'">
                <p><svg t="1497930856315" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2812" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M1019.483316 381.790015c-8.995053-25.985708-31.98241-45.974714-58.967568-49.972515l-266.853231-40.977462L578.725733 42.976363C566.732329 16.990655 540.746621 0 511.762563 0c-28.984059 0-54.969767 16.990655-66.96317 42.976363L328.863157 290.840038 63.009377 331.8175c-26.985158 3.997801-49.972515 22.987357-58.967568 49.972515-8.995053 25.985708-1.998901 55.969217 16.990655 74.958773l194.892809 200.889511-44.975264 278.846634c-4.997252 27.984608 6.996152 55.969217 29.983509 72.959872 12.992854 8.995053 27.984608 13.992304 42.976363 13.992304 11.993404 0 24.986258-2.998351 35.980211-8.995053L511.762563 889.510769l231.87247 124.931288c10.993953 5.996702 23.986807 8.995053 35.980211 8.995053 14.991755 0 29.983509-4.997252 42.976363-13.992304 22.987357-16.990655 34.980761-44.975264 29.983509-72.959872l-44.975264-278.846634 195.892259-200.889511C1021.482217 436.759782 1028.478369 407.775723 1019.483316 381.790015z" p-id="2813" fill="#39cb80"></path></svg></p>
                <p>我的收藏</p>
            </li>
            <li onclick="window.location.href='tel:<?php echo $sp['phone']?>'">
                <p><svg t="1497931162331" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2514" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M787.320755 630.339623a318.309434 318.309434 0 0 1 158.913207 275.803773v19.803774a48.301887 48.301887 0 0 1-48.301887 48.301887 1738.867925 1738.867925 0 0 1-386.415094 48.301886 1669.313208 1669.313208 0 0 1-382.067924-48.301886 48.301887 48.301887 0 0 1-48.301887-48.301887v-19.803774a318.792453 318.792453 0 0 1 249.720755-311.064151 269.041509 269.041509 0 0 0 71.486792 55.064151 250.686792 250.686792 0 0 0 40.090566 15.939623 79.215094 79.215094 0 0 0 74.384906 52.166038h96.603773a212.045283 212.045283 0 0 0 173.886793-87.909434zM275.320755 492.679245a56.513208 56.513208 0 0 1-56.996227-56.030188V295.124528a56.513208 56.513208 0 0 1 23.667925-45.886792 270.973585 270.973585 0 0 1 540.015094 0 56.513208 56.513208 0 0 1 23.667925 45.886792v141.524529a56.513208 56.513208 0 0 1-22.701887 44.920754v24.150944a167.124528 167.124528 0 0 1-167.124528 167.124528h-96.603774a33.811321 33.811321 0 0 1 0-67.622641h96.603774a99.501887 99.501887 0 0 0 99.501886-99.501887v-24.150944a56.513208 56.513208 0 0 1-14.007547-17.871698 285.464151 285.464151 0 0 1-26.566038 51.2 111.577358 111.577358 0 0 1-31.879245 36.709434 55.54717 55.54717 0 0 1-27.049056 7.245283h-96.603774a78.732075 78.732075 0 0 0-67.139623 37.192453 220.256604 220.256604 0 0 1-126.550943-129.449057 56.513208 56.513208 0 0 1-50.233962 26.083019z m236.679245-425.056603a203.350943 203.350943 0 0 0-201.901887 183.06415 56.513208 56.513208 0 0 1 15.939623 19.803774 205.766038 205.766038 0 0 1 185.962264-142.007547 205.766038 205.766038 0 0 1 185.962264 141.524528 56.513208 56.513208 0 0 1 15.939623-19.803773 203.350943 203.350943 0 0 0-201.901887-182.098114z" fill="#39cb80" p-id="2515"></path></svg></p>
                <p>联系客服</p>
            </li>
            <li onclick="window.location.href='?_a=shop&_u=user.imageurl'">
                <p><svg t="1497931122501" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1208" xmlns:xlink="http://www.w3.org/1999/xlink" width="200" height="200"><defs><style type="text/css"></style></defs><path d="M473.6 770.048c0-57.344 16.896-111.104 45.056-156.16-1.024-8.192 0.512-18.432 6.144-31.232 31.744-42.496 50.688-90.624 52.224-106.496 0 0 48.64-38.4 51.712-95.744 3.072-57.344-10.752-59.904-10.752-59.904 20.48-62.464 27.136-297.472-123.904-269.312-25.088-49.152-182.784-88.064-256 43.52-36.864 65.536-50.176 154.624-21.504 227.84-1.024 5.632-10.24-5.12-13.312 28.16-3.072 32.256 11.264 78.848 27.136 100.864 7.168 9.216 17.92 15.872 25.6 18.944 0 0 9.728 57.856 54.784 112.64 10.24 43.52-32.768 66.048-32.768 66.048-142.336 27.136-272.896 106.496-272.896 192v66.048c0 92.672 216.064 112.64 410.624 112.64 58.368 0 118.784-5.12 175.104-13.824-70.656-54.784-116.736-139.776-117.248-236.032z" p-id="1209" fill="#39cb80"></path><path d="M769.536 521.216c-137.216 0-248.832 111.104-248.832 248.832 0 137.216 111.104 248.832 248.832 248.832s248.832-111.104 248.832-248.832c0-137.216-111.616-248.832-248.832-248.832z m169.984 250.88c0 22.016-17.92 39.424-39.424 39.424H819.2v80.896c0 22.016-17.92 39.424-39.424 39.424h-10.24c-22.016 0-39.424-17.92-39.424-39.424v-80.896h-80.896c-22.016 0-39.424-17.92-39.424-39.424v-10.24c0-22.016 17.92-39.424 39.424-39.424h80.896v-80.896c0-22.016 17.92-39.424 39.424-39.424h10.24c22.016 0 39.424 17.92 39.424 39.424V721.92h80.896c22.016 0 39.424 17.92 39.424 39.424v10.752z" p-id="1210" fill="#39cb80"></path></svg></p>
                <p>邀请好友</p>
            </li>
        </ul>
    </section>

    <!--<section class="linear-section linear-noinput last-liner-section margin-bottom" onclick="window.location.href='?_easy=reminder.index.welcome'">
	        <p class="user-section-p"><img src="<?php echo $static_path;?>/images/list_good.png"><span>关注微信公众号</span></p>
	        <span class="linear-right vertical-box"><span>
	            <img src="<?php echo $static_path;?>/images/go.png">
	        </span></span>
	    </section>-->
    <?php
    if(!empty($agent_set) && empty($agent_set['status'])&&
        in_array($GLOBALS['_UCT']['TPL'],AgentMod::get_agent_tpl_array())){
        ?>
        <?php
        }
        ?>
        <section class="linear-section linear-noinput margin-top margin-bottom last-liner-section"
                 onclick="window.location.href='?_a=shop&_u=user.distribution_apply'">
            <p class="user-section-p"><svg t="1494560762829" class="icon" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4362" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M668.8 384c0-140.8-115.2-256-256-256s-256 115.2-256 256c0 92.8 51.2 172.8 124.8 217.6-105.6 44.8-192 137.6-217.6 256-3.2 16 6.4 35.2 22.4 38.4h6.4c16 0 28.8-9.6 32-25.6 32-134.4 153.6-233.6 288-233.6h3.2c140.8 0 252.8-115.2 252.8-252.8z m-448 0c0-105.6 86.4-192 192-192s192 86.4 192 192-86.4 192-192 192-192-86.4-192-192zM732.8 544c-19.2 0-32 16-28.8 35.2 0 16 16 28.8 32 28.8h3.2c105.6-6.4 188.8-96 188.8-201.6s-83.2-192-185.6-201.6c-19.2 0-32 12.8-35.2 28.8 0 19.2 12.8 32 28.8 35.2 70.4 6.4 128 67.2 128 137.6 0 73.6-57.6 134.4-131.2 137.6zM960 758.4c-9.6-41.6-41.6-92.8-80-118.4-16-9.6-35.2-3.2-44.8 9.6-9.6 16-3.2 35.2 9.6 44.8 22.4 12.8 44.8 51.2 51.2 76.8 3.2 16 16 25.6 32 25.6h6.4c19.2-3.2 28.8-19.2 25.6-38.4zM620.8 640l-19.2-12.8c-16-9.6-35.2-6.4-44.8 9.6s-6.4 35.2 9.6 44.8l19.2 12.8c57.6 41.6 102.4 105.6 118.4 176 3.2 16 16 25.6 32 25.6h6.4c16-3.2 28.8-22.4 22.4-38.4-22.4-89.6-73.6-166.4-144-217.6z" fill="#666666" p-id="4363"></path></svg><span>我要分销</span></p>
            <p class="tips-font small-text" style="margin-top: 5px">来分销，发大财</p>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
        </section>

</article>
<?php include $tpl_path.'/footer2.tpl';?>

</body>
</html>
