
<style type="text/css">

    .am-form input[type=search]{
        padding: 0.3em;
        display: none;
    }

    .user-p{
        cursor: pointer;
        color: #ffffff;
        padding: 0.5em;
        width: 50%;
        display: inline-block;
        margin: 0.5em 0;
    }
    .active-p{
        background: #5eb95e;!important;
        border: 2px solid crimson;
    }
    .user-p:nth-child(odd){
        background: #0e90d2;
    }
    .user-p:nth-child(even){
        background: #3bb4f2;
    }


    .user-list-foot{
        border-top: 1px solid #dedede;
        width: 100%;
        background: #ffffff;
        position: absolute;
        left: 0;
        bottom: 0;
        height: 3em;
        line-height: 3em;
        color: #0e90d2;
    }
    .user-list-foot span{
        width: 50%;
        display: inline-block;
        text-align: center;
        cursor: pointer;
    }
    .user-list-foot span:first-child{
        border-right: 1px solid #dedede;
    }
    .user-head{
        width: 2em;
        height: 2em;
        background: url(/static/images/null_avatar.png);
        background-size: 100% auto;
        border-radius: 50%;
        margin: 0 0.3em;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">粉丝详情</strong> / <small>  </small></div>
</div>

<div class="am-g am-padding" style="padding-top: 0">
    <div data-am-widget="tabs" class="am-tabs am-tabs-d2 my-tab" data-am-tabs-noswipe="1">
        <ul class="am-tabs-nav am-cf">
            <li class="am-active">
                <a href="[data-tab-panel-0]">基本资料</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-1]">详细资料</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-2]">微信相关</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-3]">积分&账户</a>
            </li>
        </ul>
        <div class="am-tabs-bd">
            <div data-tab-panel-0 class="am-tab-panel am-active">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        称呼：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user['name'])?'':$user['name']);
						if(!empty($_REQUEST['_d']) || empty($user['name'])) {	
						echo ' <a href="javascript:;" data-uid="'.$user['uid'].'" class="update_su">[点击刷新]</a>';
						}
						 ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        登陆账号：
                    </div>
                    <div class="am-u-sm-8 am-u-end ">
                        <?php echo  (empty($user['account'])?'':$user['account']); 
						if(!empty($_REQUEST['_d']) /*&& !empty($user['account'])*/) {	
						echo ' <a href="javascript:;" data-uid="'.$user['uid'].'" class="rm_su">[删除用户]</a>';
						}
						?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        生日：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user['birthday'])?'':$user['birthday']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        性别：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user['gender'])?'未知':(($user['gender']==1)?'男':'女')); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        头像：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                    <button class="imgBoxBtn am-btn am-btn-secondary buttonImg1" data-addr="#main-img-src" data-func="mainImg" >从图片库选择</button>
                    <input id="main-img-src" type="hidden" <?php if(!empty($user['avatar'])) echo'src="'.$user['avatar'].'"'; ?>/>
                    <div  id="main-img-box">
                        <?php echo  (empty($user['avatar'])?'':'<img  id="main-img"  	 style="max-width:100px;max-height:100px;margin:10px 0" src="'.$user['avatar'].'"></img>'); ?>
                    </div>
                    </div>
                    
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        注册时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user['create_time'])?'':date("Y-m-d H:i:s",$user['create_time'])); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        最近登陆时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user['last_time'])?'':date("Y-m-d H:i:s",$user['last_time'])); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        最近登陆ip：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <span class="id_ip">
							<?php if(!empty($user['last_ip'])) {
								require_once UCT_PATH.'vendor/ipip/IP.class.php';
								$addr = IP::find($user['last_ip']);
								is_array($addr) && $addr = implode(' ',$addr);
								echo $user['last_ip'].' ('.$addr.')';	
							} ?>
						</span>
                    </div>
                </div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        邀请人：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <span class="">
							<?php if(!empty($user['from_su_uid'])) {
								$from_su = AccountMod::get_service_user_by_uid($user['from_su_uid']);
								echo '<a href="?_a=su&_u=sp.fansdetail&uid='.$user['from_su_uid'].'">'
										.($from_su['name'] ? $from_su['name'] : $from_su['account'])
									.'</a>';
								if(!empty($_REQUEST['_d'])) {
									echo ' <a href="javascript:;" class="cchange select-user" data-id="'.$user['uid'].'">[修改!]</a>';
								}
							} 
							else {
								if(empty($_REQUEST['_d'])) {
									echo '-';
								}
								else 
								echo '<a href="javascript:;" class="cchange select-user" data-id="'.$user['uid'].'">[设置!]</a>';
							}
							?>
						</span>
						

						<span style="margin-left: 100px;"><a href="?_a=su&_u=sp.fanslist&from_su_uid=<?php 
							echo $user['uid'];?>" target="_blank">
								[TA邀请的用户]</a></span>

						<span style="margin-left: 100px;"><a href="?_a=su&_u=sp.fansgraph&su_uid=<?php 
							echo $user['uid'];?>" target="_blank">
								[查看关系图]</a></span>
                    </div>
                </div>

				<?php
					$groups = SuGroupMod::get_sp_groups($user['sp_uid']);
					$user['g_uid'] = Dba::readOne('select g_uid from groups_users where su_uid = '.$user['uid']);
					//var_export($user);
				?>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        用户分组：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
					<?php 
			$html = '<div class="am-dropdown apart_team am-dropdown-up" data-am-dropdown=""><button class="am-btn am-btn-primary am-dropdown-toggle" data-am-dropdown-toggle data-guid="'.$user['g_uid'].'">';
			if($user['g_uid'] == 0) {
				$html.='未分组';
			}
			else {
				foreach ($groups as $g) {
					if($user['g_uid']==$g['uid'])
					$html.=$g['name'];
				}
			}

			$html.='</button><ul class="am-dropdown-content private_move">';
			$html .= '<li><a data-id="'.$user['uid'].'" g_uid="0">未分组</a></li>';
        	foreach($groups as  $c) {
					$html .= '<li><a data-id="'.$user['uid'].'"g_uid="'.$c['uid'].'">'.$c['name'].'</a></li>';
			}
        	$html.='</ul></div>';
			echo $html;

				?>
					</div>
				</div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        审核状态：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
					<?php
			$html ='<div class="am-dropdown am-dropdown-up private_verify" data-am-dropdown>
  <button class="am-btn ';
	if($user['status']==0) {
		$html.='am-btn-default';
	}
	else if($user['status']==1) {
		$html.='am-btn-success';
	}
	else  {
		$html.='am-btn-danger';
	}
	$html.=' am-dropdown-toggle" data-am-dropdown-toggle style="width:40px;height:30px"></button>
  <ul id="uidx" class="am-dropdown-content creview" data-uid="'.$user['uid'].'" style="min-width:40px !important; cursor:pointer; text-align:center;">
    <li class="am-btn-default" data-id="'.$user['uid'].'" sp="0">&nbsp;</li>
    <li class="am-btn-success" data-id="'.$user['uid'].'" sp="1">通过</li>
    <li class="am-btn-danger" data-id="'.$user['uid'].'" sp="2">拒绝</li>
  </ul>
</div>';

	echo $html;
					?>
					</div>
				</div>
				<div class="am-u-sm-8 am-u-end" style="margin: 20px 0 0 320px;">
		            <button class="am-btn am-btn-secondary" id="save">保存</button>
		        </div>

            </div>

            <div data-tab-panel-1 class="am-tab-panel ">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        真实姓名：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['realname'])?'':$user_profile['realname']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        邮箱：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['email'])?'':$user_profile['email']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        手机：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['phone'])?'':$user_profile['phone']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        地址：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['province'])?'':$user_profile['province']); ?>
                        <?php echo  (empty($user_profile['city'])?'':$user_profile['city']); ?>
                        <?php echo  (empty($user_profile['town'])?'':$user_profile['town']); ?>
                        <?php echo  (empty($user_profile['address'])?'':$user_profile['address']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        二维码：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['qrcode'])?'':'<img style="max-width:100px;max-height:100px;" src="'.$user_profile['qrcode'].'"></img>'); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        简介：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['brief'])?'':$user_profile['brief']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        其他信息：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
               <?php if(!empty($user_profile['extra_info'])) 
				foreach($user_profile['extra_info'] as $k => $v) {
					echo '<p>'.$k.': '.$v.'</p>';
				}
				?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        <?php
                        if(empty($user_profile['card_type']) || empty($user_profile['card_id']))
                        {
                            #echo '木有相关证件信息';
                        }
                        else
                        {
                            switch($user_profile['card_type'])
                            {
                                case 1:
                                    echo '身份证：';
                                    break;
                                case 2:
                                    echo '护照：';
                                    break;

                            }
                        }
                        ?>
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_profile['card_id'])?'':$user_profile['card_id']); ?>
                    </div>
                </div>
            </div>
            <div data-tab-panel-2 class="am-tab-panel ">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        用户open_id：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php if(!empty($user_public['open_id'])) {
								echo $user_public['open_id']; 
								$wx = WeixinMod::get_weixin_public_by_uid($user_public['public_uid']);
								echo ' ['.$wx['public_name'].']';
							}
						?>
                    </div>
                </div>

<?php
$user_public2 = Dba::readRowAssoc('select * from weixin_fans_xiaochengxu where su_uid =' . $user['uid']);
if($user_public2) {
?>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        小程序open_id：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php if(!empty($user_public2['open_id'])) {
								echo $user_public2['open_id']; 
								$wx2 = WeixinMod::get_weixin_public_by_uid($user_public2['public_uid']);
								echo ' ['.$wx2['public_name'].']';
							}
						?>
                    </div>
                </div>
<?php }?>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        用户union_id：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
<?php 
	$union_id = Dba::readOne('select union_id from weixin_unionid where su_uid = '.$user['uid']); 
	echo $union_id ? $union_id: '-'; 
?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        是否关注：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_public['has_subscribed'])?'未知':(($user_public['has_subscribed']==1)?'已关注':'未关注')); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        最近和微信交互时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo  (empty($user_public['last_time'])?'':date("Y-m-d H:i:s",$user_public['last_time'])); ?>
                    </div>
                </div>
            </div>

			<?php
				$pt = SuPointMod::get_user_points_by_su_uid($user['uid']);
				//var_export($pt);
			?>
            <div data-tab-panel-3 class="am-tab-panel ">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        开卡时间:
                    </div>
                    <div class="am-u-sm-8 ">
                        <?php echo  date('Y-m-d H:i:s', $pt['create_time']); ?>
                    </div>
                </div>
				<hr>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        账户余额:
                    </div>
                    <div class="am-u-sm-2 ">
                        &yen; <?php echo  ($pt['cash_remain']/100); ?>
                    </div>
                    <div class="am-u-sm-2 am-text-right">
                        已消费:
                    </div>
                    <div class="am-u-sm-2 ">
                        &yen; <?php echo  ($pt['cash_transfered']/100); ?>
                    </div>
                    <div class="am-u-sm-2 am-text-right am-u-end">
                        <a href="?_a=su&_u=sp.sucashlist&su_uid=<?php echo $user['uid'];?>">点击查看账户明细</a>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        积分:
                    </div>
                    <div class="am-u-sm-2 ">
                        <?php echo $pt['point_remain'].'/'.$pt['point_max'] ; ?>
                    </div>
                    <div class="am-u-sm-2 am-text-right">
                        已使用:
                    </div>
                    <div class="am-u-sm-2 ">
                        <?php echo  ($pt['point_transfered']); ?>
                    </div>
                    <div class="am-u-sm-2 am-text-right am-u-end">
                        <a href="?_a=su&_u=sp.supointlist&su_uid=<?php echo $user['uid'];?>">点击查看积分明细</a>
                    </div>
                </div>
            </div>


        </div>
    </div>
</div>

<!--虚拟弹窗-->
<div class="am-popup" id="user-popup">
    <div class="am-popup-inner">
        <div class="am-popup-hd">
            <h4 class="am-popup-title">用户列表</h4>
            <span data-am-modal-close class="am-close">&times;</span>
        </div>
		<div class="am-form">
			<input class="" type="text" placeholder="搜索">
		</div>
        <div style="padding-bottom: 3em" class="am-popup-bd">

        </div>
        <div class="user-list-foot">
            <span>取消</span><span>确定</span>
        </div>
    </div>
</div>
		<div id="toast" style="display: none;">
			<div style="position: fixed;z-index: 1000;top: 0;right: 0;left: 0;bottom: 0;"></div>
			<div style="position: fixed;z-index: 5000;width: 6em;height: 6em;top:180px;left: 60%;margin-left: -3.8em;background: rgba(40, 40, 40, 0.75);text-align: center;border-radius: 5px;color: #FFFFFF;">
				<p style="margin:35px 0 15px">设置成功</p>
			</div>
		</div>

<?php
	$extra_js = $static_path.'/js/fansdetail.js';
?>

<script>
    seajs.use(['selectPic']);
    
    $('#save').click(function(){
		var data = {
						'avatar': $('img#main-img').attr('src'),
						'uid':$('#uidx').attr('data-uid')
					};
					$.post('?_a=su&_u=api.update_su', data, function(ret) {
						ret = $.parseJSON(ret);
						if(ret && (ret.errno == 0)) {
						var $toast = $('#toast');
						$toast.fadeIn(100);
						setTimeout(function() {
							$toast.fadeOut(100);
						}, 2000);
					} else {
						alert('操作失败！' + ret.errstr);
					}
					});
	});
</script>
