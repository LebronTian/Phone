<?php

class ApiCtl {

	/*
	 * 小程序模板消息
	 */
	public function get_xcx_template_list_all()
	{
		if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$public_uid = WeixinMod::get_current_weixin_public('uid');
		}


		$refresh =false;
		isset($_REQUEST['refresh']) && $refresh = true ;
		$ret = Templatexcx_Msg_WxPlugMod::xcx_get_template_list($public_uid,$refresh);
		if($ret)
		{
			outRight($ret);
		}
		else
		{
			outError();
		}
	}

	/*
		发送小程序模板消息
	*/
    public function send_template_msg()
    {
        if(!($user_template['template_id'] = requestString('template_id')) || //模板编号
            !($user_template['template_data'] = requestKvJson('template_date'))  //用户设置的内容
        ) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        if(requestBool('toall')) { //群发
			$user_id = array();
		} else if(!$user_id = requestIntArray('user_id')) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

		//跳转路径
        $user_template['url'] = requestString('url',PATTERN_URL);
		//放大关键字
        if(!empty($_REQUEST['emphasis'])) 
			$user_template['emphasis_keyword'] = requestString('emphasis',PATTERN_NORMAL_STRING);
		if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$public_uid = WeixinMod::get_current_weixin_public('uid');
		}

        $ret = Queue::add_job('Templatexcxmsg_pushJob', array($user_template, $user_id, $public_uid));
        !$user_id && $GLOBALS['arraydb_job']['sendtemplatemsg_send'.$public_uid] = 
														array('value'=>'等待运行','expire'=> 60*60*24);
		outRight($ret);
	}

	//设置模板消息  通过现有模板 配置  暂时弃用 2015年11月3日15:43:52
	public function set_user_template_by_ts_id()
	{
		// 示例 post 数据  details  有少许差别
//		$post     = '{"ts_id":"TM00015","even":"2000","template_date":{"first":{"value":"自由EVEN.0.EVEN自由","color":"#173177"},"orderMoneySum":{"value":"","color":"#173177"},"orderProductName":{"value":"","color":"#173177"},"Remark":{"value":"","color":"#173177"}}}';
//		$_REQUEST = array_merge($_REQUEST, json_decode($post, true));


		$user_template['sp_uid'] = AccountMod::get_current_service_provider('uid'); 
		if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$public_uid = WeixinMod::get_current_weixin_public('uid');
		}
		$user_template['public_uid'] = $public_uid;

		//ts_id 即短模板id存在时 取常模板id
		if (!($templatexcx_library['ts_id'] = requestString('ts_id')) ||
			!(checkString($templatexcx_library['ts_id'], '/^(TM|OPENTMTM)[0-9]+$/')) ||
							!($user_template['template_id'] = Templatexcx_Msg_WxPlugMod::wx_get_template($user_template['public_uid'], array('template_id_short' => $templatexcx_library['ts_id'])))
//			!($user_template['template_id'] = 'ISPbHwnD5uQ0d8GUBglmi0yR1paPJt2Y-ferxfGBYcE')
		)
		{
			outError(ERROR_DBG_STEP_1);//取模板失败，请检查模板编号是否输入正确
		}
		// $even = 10002 表示 1表示模块 2模块下对应的事件
		if (!($even = requestInt('even')) ||
			(!($mod = floor($even / 1000)) ||
				!($even_arr = Templatexcx_Msg_WxPlugMod::get_even_arr($mod, 'key')) ||
				!($user_template['even'] = $even_arr[($even % 1000)])
			)
		)
		{

			outError(ERROR_INVALID_REQUEST_PARAM);//参数错误
		}
		//模板设置的状态
		$user_template['status'] = requestInt('status');


		if (isset($_REQUEST['uid']) &&
			(!($user_template['uid'] = requestInt('uid')) ||
			!($user_templated = Templatexcx_Msg_WxPlugMod::get_user_template_by_uid($user_template['uid'])) ||
			!($user_templated['sp_uid'] == $user_template['sp_uid']) ||
			!($user_templated['public_uid'] == $user_template['public_uid'])
			)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);//参数错误
		}

		//格式化 模板消息数据
		if (!($templatexcx_library = Templatexcx_Msg_WxPlugMod::get_templatexcx_library_by_ts_id($templatexcx_library['ts_id'])) ||
			(empty($templatexcx_library['template_data'])) ||
			!($user_template['template_data'] = requestKvJson('template_date')) ||
			!($user_template['template_data'] = Templatexcx_Msg_WxPlugMod::get_template_data_from_template_arr($templatexcx_library['template_data'], $user_template['template_data'], $mod))
		)
		{

			outError(ERROR_DBG_STEP_3);// 模板消息格式化错误
		}

		outRight(Templatexcx_Msg_WxPlugMod::add_or_edit_user_template($user_template));

	}

	/*
	 * 根据模板编号 配置用户的模板消息
	 */
	public function set_user_template_by_tpl_id()
	{

		if (!($user_template['sp_uid'] = AccountMod::get_current_service_provider('uid')) ||  //是否登陆
			!($user_template['public_uid'] = requestInt('public_uid'))||                     //是否有提交public_uid
			!($public = WeixinMod::get_weixin_public_by_uid($user_template['public_uid'])) || //该public_uid的公众号是否存在
			!($public['sp_uid'] == $user_template['sp_uid']) ||                               //是否属于 该商户
			!($public['public_type'] == 8 && $public['has_verified'] )                                                   //是否是认证服务号
		)
		{
//var_dump($public);
			outError(ERROR_OBJ_NOT_EXIST);
		}

		// $even = 10002 表示 1表示模块 2模块下对应的事件
		if (!($even = requestInt('even')) ||
			(!($mod = floor($even / 1000)) ||
				!($even_arr = Templatexcx_Msg_WxPlugMod::get_even_arr($mod, 'key')) ||
				!($user_template['even'] = $even_arr[($even % 1000)])
			)
		)
		{

			outError(ERROR_INVALID_REQUEST_PARAM);//参数错误
		}


		if(!($user_template['template_id'] = trim(requestString('template_id'))) || //模板编号
			!($user_template['details'] = trim(requestString('template_details')))  || //模板结构数组   用户输入模板详情是 通过 get_template_array 接口获取
			!($template_arr = Templatexcx_Msg_WxPlugMod::get_template_array_from_details($user_template['details']))  || //模板结构数组   用户输入模板详情是 通过 get_template_array 接口获取
			!($user_template['template_data'] = requestKvJson('template_date')) ||  //用户设置的内容
			!($user_template['template_data'] = Templatexcx_Msg_WxPlugMod::get_template_data_from_template_arr($template_arr, $user_template['template_data'], $mod))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//模板设置的状态
		$user_template['status'] = requestInt('status');
//		$user_template['su_uid'] = requestInt('su_uid');
		$user_template['page'] = requestString('page');

		if (!empty($_REQUEST['uid']) &&
			(!($user_template['uid'] = requestInt('uid')) ||
				!($user_templated = Templatexcx_Msg_WxPlugMod::get_user_template_by_uid($user_template['uid'])) ||
				!($user_templated['sp_uid'] == $user_template['sp_uid']) ||
				!($user_templated['public_uid'] == $user_template['public_uid'])
			)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);//参数错误
		}
		outRight(Templatexcx_Msg_WxPlugMod::add_or_edit_user_template($user_template));
	}

	/*
	 * 错误信息
	 * ERROR_DBG_STEP_1             模板详情数据格式有误
	 */
	public function get_template_array()
	{
		if( !($template_details = trim(requestString('template_details'))))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$template_arr = Templatexcx_Msg_WxPlugMod::get_template_array_from_details($template_details);
        ($even = requestInt('even')) && $even_args_arr = Templatexcx_Msg_WxPlugMod::get_even_args_arr(floor($even / 1000));
        $select_html = '';
        if(!empty($even_args_arr))
        {
            $option_html ='<option>选择添加参数</option>';

            foreach($even_args_arr as $arrk=>$arr)
            {
                $option_html .='<option value="EVNE.'.$arrk.'.EVEN">'.$arr['title'].'</option>';
            }
            $select_html = '<div class="am-u-sm-2 am-u-end am-form-group"><select class="option_even ">'. $option_html. '</select></div>';
        }
		$html = '';
		if(!empty($template_arr))
		{
			foreach($template_arr as $tak=>$ta)
			{
				$html .= '<div class="makeup-div am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">'.$tak.'
				</div>
				<div class="am-u-sm-6 am-u-end">
				<textarea id="template_arr_value" data-key="'.$tak.'"></textarea>
				</div>
				'.$select_html.'
				<div class="am-u-sm-2">
				<input type="text" class="template_arr_color color" maxlength="6" size="6" value="173177">
				</div>
				<div class="am-u-sm-2 am-u-end">
				<input type="checkbox" class="emphasis" data-key="'.$tak.'">
				<label> 放大关键字</label>
				</div>
				</div>
				';
			}
		}
		outRight($html);
	}

	//取事件数组
	public function get_even_arr()
	{

		var_export( Templatexcx_Msg_WxPlugMod::get_even_args_arr(1, 'key'));
	}

	/*
	 * 编辑或添加模板   保存先需通过测试 才会修改成功
	 * 错误信息 ERROR_DBG_STEP_1  模板详细内容结构有误
	 */
	public function add_or_edit_templatexcx_library()
	{
		//      示例 post 数据  details  有少许差别
//				$post = '{"ts_id":"TM00015","title":"订单支付成功","industry":1,"open_id":"oF71MwdTLhdmtEXwGePhclObViqo","details":"{{first.DATA}}支付金额：{{orderMoneySum.DATA}}商品信息：{{orderProductName.DATA}}{{Remark.DATA}}"}';
//				$_REQUEST = array_merge($_REQUEST,json_decode($post,true));

		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$public_uid = WeixinMod::get_current_weixin_public('uid');
		}

		if (!($templatexcx_library['ts_id'] = requestString('ts_id')) ||
			!(checkString($templatexcx_library['ts_id'], '/^(TM|OPENTMTM)[0-9]+$/')) ||
			!($templatexcx_library['title'] = requestString('title', PATTERN_NORMAL_STRING)) ||
			!($templatexcx_library['details'] = requestString('details')) ||
			!($templatexcx_library['industry'] = requestInt('industry')) ||
			!($open_id = requestString('open_id'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $templatexcx_library['uid'] = requestInt('uid');
		$template_data = Templatexcx_Msg_WxPlugMod::get_template_array_from_details($templatexcx_library['details']);
		$template_id   = Templatexcx_Msg_WxPlugMod::wx_get_template($public_uid, array('template_id_short' => $templatexcx_library['ts_id']));
		$ret           = self::test_send_template_msg($public_uid, $open_id, $template_id, $template_data);
		if (!$ret)
		{
			outRight($GLOBALS['_TMP']['WEIXIN_ERROR']);
		}
		$templatexcx_library['check']           = 1;
		$templatexcx_library['last_check_time'] = $_SERVER['REQUEST_TIME'];
		$templatexcx_library['template_data']   = $template_data;
		outRight(Templatexcx_Msg_WxPlugMod::add_or_edit_templatexcx_library($templatexcx_library));
	}

	/*
	 * 测试发送模板消息 验证模板配置情况
	 */
	public function test_send_template_msg($public_uid, $open_id, $template_id, $template_data)
	{
		$data = array('touser'      => $open_id,
		              'template_id' => $template_id,
		              'url'         => '',
		              'data'        => $template_data,
		);

		return Templatexcx_Msg_WxPlugMod::wx_send_template_msg($public_uid, $data);
	}


	/*
	 * 更改 模板消息设置 状态
	 */

	public function change_template_user_set_status()
	{
		if(!($sp_uid = AccountMod::get_current_service_provider('uid')) ||
			!($user_template['uid'] = requestInt('uid') )||
			!($template_user_set = Templatexcx_Msg_WxPlugMod::get_user_template_by_uid($user_template['uid'])) ||
			!($sp_uid == $template_user_set['sp_uid'])
			)
		{
			outError(ERROR_OBJ_NOT_EXIST);
		}
		$user_template['status'] = requestInt('status');
		outRight(Templatexcx_Msg_WxPlugMod::add_or_edit_user_template($user_template));
	}


	/*
	 * 删除 模板消息配置
	 */
	public function delete_user_template()
	{
		if(!($sp_uid = AccountMod::get_current_service_provider('uid')) ||
			!($uids = requestStringArray('uids'))
		)
		{
			outError(ERROR_OBJ_NOT_EXIST);
		}
		outRight(Templatexcx_Msg_WxPlugMod::delete_user_template($uids,$sp_uid));
	}

	/*
	 * 一键设置  商城的模板消息
	 */
	public function set_shop_templatexcxmsg_by_a_key()
	{
		//设置行业

		//
	}
	

}

