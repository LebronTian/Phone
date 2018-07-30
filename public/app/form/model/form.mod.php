<?php

/*
	通用表单系统
*/

class FormMod {
	public static function func_get_form($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['access_rule'])) $item['access_rule'] = json_decode($item['access_rule'], true);
		if(!empty($item['data'])) $item['data'] = json_decode($item['data'], true);
		if(!empty($item['admin_uids'])) $item['admin_uids'] = json_decode($item['admin_uids'],true);

		return $item;
	}

	public static function func_get_form_record($item) {
		if(!empty($item['data'])) $item['data'] = json_decode($item['data'], true);
		if(!empty($item['su_uid'])) $item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		$item['order'] = FormMod::get_form_record_order_by_uid($item['uid']);
		
		return $item;
	}

	public static function func_get_form_record_order($item) {
		if(!empty($item['pay_info'])) $item['pay_info'] = json_decode($item['pay_info'], true);
		
		return $item;
	}

	/*
		todo 配额管理

		添加或编辑表单
		form = array(
			...

			'access_rule' => array(
				'must_login' => true, //是否必须登陆才能填写表单
				'can_edit'   => true, //提交一次后是否还能修改

				'start_time' => 0, //允许提交的开始时间戳, 0表示不限制
				'end_time'   => 0, //允许提交的截止时间戳, 0表示不限制

				'total_cnt'  => 0, //最多允许多少份表单, 0表示不限制
				'max_cnt'    => 1, //每个用户最多允许提交多少份, 0不限制 
				'max_cnt_day'=> 1, //每个用户每天最多允许提交多少份, 0不限制 
			
				'unique_field' => 'text1', //唯一字段id, 现在支持设置1个唯一的字段
			),

			'data' => array(
				array(
					'id'   => 'text1',	     //id
					'type' => text,          //表单类型, 先支持 text, text_multi file_img
					'name' => "您的姓名",
					'desc' => "请填写您的姓名",
					'default' => "xxxxxx",
					'required' => true,     //是否必填
					'pattern'  => '',       //正则表达式验证
				),
				array(
					'id'   => 'file_img2'   //id
					'type' => file_img,     //表单类型, 先支持 text, file_img
					'name' => "您的作品",
					'desc' => "请选择图片,png格式,不要超过1M"
					'default' => "",
					'required' => true,     //是否必填
				),

			),
		)
	*/
	public static function add_or_edit_form($form) {
		if(!empty($form['uid'])) {
			Dba::update('form', $form, 'uid = '.$form['uid'].' and sp_uid = '.$form['sp_uid']);
		}
		else {
			$form['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('form', $form);
			$form['uid'] = Dba::insertID();

			Event::handle('AfterAddForm', array($form['uid']));
		}

		return $form['uid'];
	}

	/*
		删除表单

		返回删除的条数
	*/
	public static function delete_form($fids, $sp_uid) {
		if(!is_array($fids)) {
			$fids = array($fids);
		}
		$real_fids = Dba::readAllOne('select uid from form where uid in ('.implode(',', $fids).') && sp_uid = '.$sp_uid);
		if(!$real_fids) {
			return 0;
		}

		$sql = 'delete from form where uid in ('.implode(',',$real_fids).')';
		Dba::beginTransaction(); {
			if($ret = Dba::write($sql)) {
				$sql = 'delete from form_record where f_uid in ('.implode(',', $real_fids).')';
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	public static function get_form_by_uid($uid) {
		return Dba::readRowAssoc('select * from form where uid = '.$uid, 'FormMod::func_get_form');
	}

	/*
		根据商户uid获取一个表单
	*/
	public static function get_default_form_by_sp_uid($sp_uid) {
		return Dba::readRowAssoc('select * from form where sp_uid = '.$sp_uid.' && status = 0 order by create_time desc limit 1', 
								'FormMod::func_get_form');
	}

	/*
		获取表单列表 
	*/
	public static function get_form_list($option) {
		$sql = 'select * from form';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid='.$option['sp_uid'];
		}
        if(!empty($option['uids']))
        {
            $where_arr[] = 'uid in('.implode(',', $option['uids']).')';
        }
        if(!empty($option['key']))
        {
            $where_arr[] = 'title like "%'.$option['key'].'%"';
        }
		if(!empty($option['type']))
		{
			$where_arr[] = 'type ="'.addslashes($option['type']).'"';
		}
        if(isset($option['status']))
        {
            $where_arr[] = 'status ='.$option['status'];
        }
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'FormMod::func_get_form');
	}

	
	/*
		添加表单内容
		
		注意不要用本函数修改sp_remark,因为会检查权限
		请使用 remark_form_record
		
		$record = array(
			'data' => array(
				'text1' => '刘路浩',
				'file_img2' => array('file_name' => 'xxxxxx', 'url' => 'xxxxxx'),
				...
			)
		)
	*/
	public static function add_or_edit_form_record($form, $record) {
		if(is_numeric($form)) {
			if(!($form = self::get_form_by_uid($form))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}

		if($form['status'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		//登陆检查
		if(!empty($form['access_rule']['must_login']) && empty($record['su_uid'])) {
			setLastError(ERROR_USER_HAS_NOT_LOGIN);
			return false;
		}
		
		//是否能修改
		if(!empty($record['uid']) && (empty($form['access_rule']['can_edit'])) ) {
			setLastError(ERROR_PERMISSION_DENIED);
			return false;
		}

		//提交时间检查
		if(((!empty($form['access_rule']['start_time']) && $form['access_rule']['start_time'] > $_SERVER['REQUEST_TIME']) ||
		   (!empty($form['access_rule']['end_time']) && $form['access_rule']['end_time'] < $_SERVER['REQUEST_TIME']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		//提交总次数检查
		if(empty($record['uid']) && 
			!empty($form['access_rule']['total_cnt']) && ($form['record_cnt'] >= $form['access_rule']['total_cnt'])) {
			setLastError(ERROR_OUT_OF_LIMIT);
			return false;
		}
		
		//唯一字段检查
		#if(!empty($form['access_rule']['unique_field'])) {
		//compatible for -1 xxx
		if(!empty($form['access_rule']['unique_field']) && 
			!(is_numeric($form['access_rule']['unique_field']) && $form['access_rule']['unique_field'] < 0)) {

			if(empty($record['uid']) && empty($record['data'][$form['access_rule']['unique_field']])) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			if(!empty($record['data'][$form['access_rule']['unique_field']])) {
				$unique_field = md5($record['data'][$form['access_rule']['unique_field']]);
				$sql = 'select 1 from form_record where f_uid = '.$form['uid'].' && unique_field = "'
								.addslashes($unique_field);
				if(!empty($record['uid'])) {
					$sql .= ' && uid != '.$record['uid'];
				}
				$sql .= '" limit 1';
				if(Dba::readOne($sql)) {
					setLastError(ERROR_OBJECT_ALREADY_EXIST);
					return false;
				}
				$record['unique_field'] = $unique_field;
			}
		}

		//用户提交次数检查
		if(empty($record['uid']) && !empty($form['access_rule']['max_cnt'])) {
			$field = !empty($record['su_uid']) ? 'su_uid' : 'user_ip';
			$sql = 'select count(*) from form_record where f_uid = '.$form['uid'].' && '.$field.' = "'.addslashes($record[$field]).'"';
			$max_cnt = Dba::readOne($sql);
			if($max_cnt >= $form['access_rule']['max_cnt']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//用户每日提交次数检查
		if(empty($record['uid']) && !empty($form['access_rule']['max_cnt_day'])) {
			$field = !empty($record['su_uid']) ? 'su_uid' : 'user_ip';
			$sql = 'select count(*) from form_record where f_uid = '.$form['uid'].' && '.$field.' = "'.addslashes($record[$field]).'"'
					.' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
			$max_cnt_day = Dba::readOne($sql);
			if($max_cnt_day >= $form['access_rule']['max_cnt_day']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//todo 根据类型再检查一下具体字段
		if($form['data'])
		foreach($form['data'] as $d) {
			if(!empty($d['required']) && empty($record['data'][$d['id']])) {
				setLastError(ERROR_DBG_STEP_1);
				return false;
			}	
		}

		if(!empty($record['uid'])) {
			Dba::update('form_record', $record, 'uid = '.$record['uid'].' && su_uid = '.$record['su_uid']);
		}
		else {
			Dba::beginTransaction(); {
				$record['create_time'] = $_SERVER['REQUEST_TIME'];
				Dba::insert('form_record', $record);
				$record['uid'] = Dba::insertID();
				Dba::write('update form set record_cnt = record_cnt + 1 where uid = '.$form['uid']);
				//表单支付
				if(!empty($form['access_rule']['order']['price'])) {
					Dba::insert('form_record_order', array('r_uid' => $record['uid'], 'paid_fee' => $form['access_rule']['order']['price']));
					$order_uid = Dba::insertID();
					setcookie('__form_order_uid', $order_uid, 0, '/');
					
				}
			} Dba::commit();
		}

		return $record['uid'];
	}

	/*
		删除表单数据

		返回删除的条数
	*/
	public static function delete_form_record($rids, $f_uid) {
		if(!is_array($rids)) {
			$rids = array($rids);
		}
		$real_rids = Dba::readAllOne('select uid from form_record where uid in ('.implode(',', $rids).') && f_uid = '.$f_uid);
		if(!$real_rids) {
			return 0;
		}

		$sql = 'delete from form_record where uid in ('.implode(',',$real_rids).')';
		Dba::beginTransaction(); {
			if($ret = Dba::write($sql)) {
				$sql = 'update form set record_cnt = record_cnt - '.$ret.' where uid = '.$f_uid;
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	/*
		标记表单数据

		返回标记的条数
	*/
	public static function remark_form_record($rids, $sp_remark, $f_uid) {
		if(!is_array($rids)) {
			$rids = array($rids);
		}

		$sql = 'update form_record set sp_remark = '.$sp_remark.' where uid in ('.implode(',', $rids).') && f_uid = '.$f_uid;
		return	Dba::write($sql);
	}


	public static function get_form_record_by_uid($uid) {
		return Dba::readRowAssoc('select * from form_record where uid = '.$uid, 'FormMod::func_get_form_record');
	}

	/*
		获取表单数据列表 
	*/
	public static function get_form_record_list($option) {
		$sql = 'select * from form_record';
		if(!empty($option['f_uid'])) {
			$where_arr[] = 'f_uid='.$option['f_uid'];
		}
		if(isset($option['sp_remark']) && ($option['sp_remark'] >= 0)) {
			$where_arr[] = 'sp_remark='.$option['sp_remark'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid='.$option['su_uid'];
		}

		if(!empty($option['key'])) {
			$where_arr[] = 'data like "%'.addslashes($option['key']).'%"';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sql .= ' order by uid desc';
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'FormMod::func_get_form_record');
	}

	public static function get_form_record_order_by_uid($uid) {
		return Dba::readRowAssoc('select * from form_record_order where r_uid = '.$uid, 'FormMod::func_get_form_record_order');
	}

	//表单支付成功 可以发消息等
	public static function onAfterFormRecordOrderPay($form, $record) {
	
	}


    /*
    获取模板列表

    从本地目录获取
*/
    public static function get_tpls_list($option = array()) {
        $dir = UCT_PATH.'app'.DS.$GLOBALS['_UCT']['APP'].DS.'view'.DS;
        $ds = scandir($dir);
        $ds = array_diff($ds, array('.', '..'));
        $all = array();
        foreach($ds as $d) {
            if(!is_dir($dir.$d) || !file_exists($dir.$d.DS.'tplinfo.php')) {
                continue;
            }
            $p = include $dir.$d.DS.'tplinfo.php';
            $p['dir'] = $d;
            $all[] = $p;
        }
        //var_export($ds);
        //var_export($all);


        if(!empty($option['type']) && $all) {
            $all = array_filter($all, function($i) use($option) {
                return $i['type'] == $option['type'];
            });
        }
        if(!empty($option['industry']) && $all) {
            $all = array_filter($all, function($i) use($option) {
                return $i['industry'] == $option['industry'];
            });
        }
        if(!empty($option['key']) && $all) {
            $all = array_filter($all, function($i) use($option) {
                return stripos($i['name'], $option['key']) !== false;
            });
        }

        $cnt = count($all);
        if($option['limit'] >= 0) {
            $all = array_slice($all, $option['page']*$option['limit'], $option['limit']);
        }
        /*
        array_walk($all, function(&$i){
            $i['has_installed'] = WeixinPlugMod::is_plugin_installed($i);
        });
        */
        return array('count' => $cnt, 'list' => $all);
    }

    /*
		根据目录名获取模板信息
	*/
    public static function get_tpl_by_dir($dir) {
        $fd = UCT_PATH.'app'.DS.$GLOBALS['_UCT']['APP'].DS.'view'.DS.$dir;
        if(!is_dir($fd) || !file_exists($fd.DS.'pluginfo.php')) {
            return false;
        }

        $p = include $fd.DS.'tplinfo.php';

        return $p;
    }

	//第一次改一下数据结构
	public static function onInitAddAppointmentForm($uid) {
		$init = array('access_rule' => array (
						'must_login' => true, 
						'max_cnt' => 1, 
						'order' => array ( 'price' => '5000', ), 
						),
					'data' => array (array('id' => 0, 'type' => 'text', 'name' => '姓名', 'required' => true, 'desc' => '', ), 
									 array('id' => 1, 'type' => 'text', 'name' => '电话', 'required' => true, 'desc' => '', ), 
									 array('id' => 2, 'type' => 'text', 'name' => '推荐人uid', 'desc' => '', ), 
								),
					);

		Dba::update('form', $init, 'uid = '.$uid);
	}

	//第一次改一下数据结构
	public static function onInitAddSignupForm($uid) {
		$init = array('access_rule' => array (
						'must_login' => true, 
						'max_cnt' => 1, 
						'order' => array ( 'price' => '12000', ), 
						),
					'data' => array (array('id' => 0, 'type' => 'text', 'name' => '姓名', 'required' => true, 'desc' => '', ), 
									 array('id' => 1, 'type' => 'text', 'name' => '电话', 'required' => true, 'desc' => '', ), 
									 array('id' => 2, 'type' => 'text', 'name' => '身份证', 'required' => true, 'desc' => '', ), 
									 array('id' => 3, 'type' => 'text', 'name' => '其他人',  'desc' => '', ), 
								),
					);

		Dba::update('form', $init, 'uid = '.$uid);
	}

	/*
		todo 支付超时，重新下个订单
	*/
	public static function reorder_form_record($r_uid) {
	}

}

