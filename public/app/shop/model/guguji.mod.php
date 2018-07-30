<?php


class GugujiMod {
	public static function func_get_guguji($item) {
		if(!empty($item['params'])) $item['params'] = json_decode($item['params'], true);
		return $item;
	}

	public static function get_all_type() {
		return array(
			'gugug2' => '咕咕机g2',
			'yilianyun' => '易联云',
		);
	}

	/*
		打印
	 	打印换行符为 "\r\n"

		$data 打印字符串
		$g 打印机
	*/
	public static function do_print($data, $g) {
		if(is_numeric($g)) {
			$g = GugujiMod::get_guguji_by_uid($g);
		}
		if(!$g || !$g['status']) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		if(empty($g['type'])) $g['type'] = 'gugug2';
		switch($g['type']) {
			case 'yilianyun': {
		        include_once UCT_PATH.'vendor/gugu/yprint.php';
				//todo 先用个固定的
				$yonghuming = '23551';
				$apimiyao = '90c51ae18349efeca1ec3e3d09b9fc933f3572fe';
				if(empty($g['params']['zhongduanhao']) || empty($g['params']['miyao'])) {
					setLastError(ERROR_SERVICE_NOT_AVAILABLE);
					return false;
				}	
				$print = new Yprint();
				$ret = $print->action_print($yonghuming, $g['params']['zhongduanhao'], $data, $apimiyao, $g['params']['miyao']);
				
				#Weixin:weixin_log('yilianyun print ret ---> '.var_export($ret, true));
				break;
			}

			case 'gugug2':
			default: {
		        include_once UCT_PATH.'vendor/gugu/memobird.php';
				$mem = new memobird($g['ak']);
				$api = $mem->getUserId($g['memobirdid'],$g['useridentifying']);
		        $api = json_decode($api,true);
				if(empty($api['showapi_userid'])){
					setLastError(ERROR_DBG_STEP_1);
					return false;
				}
				$type = 'T';
				$data =$mem->contentSet($type,$data);
				$ret =$mem->printPaper($data,$g['memobirdid'], $api['showapi_userid']);
			}
		}
		return $ret;
	}

    //获取全部打印机
    public static function get_guguji_list($option){
        $sql = 'select * from guguji ';

        if(!empty($option['sp_uid'])) {
            $where_arr[] = 'sp_uid = '.$option['sp_uid'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

        $sql .= ' order by create_time desc';
        $option['page']  = isset($option['page']) ? $option['page'] : 0;
        $option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'GugujiMod::func_get_guguji');
//        return Dba::readAllAssoc($sql);

    }

    /*
    新增或修改打印机
    */
    public static function add_or_edit_guguji($guguji) {

        //保证uid存在
        if(!empty($guguji['uid'])) {
            $sp_uid = Dba::readOne('select sp_uid from guguji where uid = '.$guguji['uid']);
            if($sp_uid != $guguji['sp_uid']) {
                setLastError(ERROR_PERMISSION_DENIED);
                return false;
            }
        }

        if(!empty($guguji['uid'])) {
            Dba::update('guguji', $guguji, 'uid = '.$guguji['uid'].' and sp_uid = '.$guguji['sp_uid']);
        }
        else {
            $guguji['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('guguji', $guguji);
            $guguji['uid'] = Dba::insertID();
			
        }

        if($guguji['status']==1){
            Dba::update('guguji', array('status'=>0), 'uid != '.$guguji['uid'].' and sp_uid = '.$guguji['sp_uid']);
        }

        return $guguji['uid'];
    }

    /*
    删除打印机
    返回删除的条数
    */
    public static function delete_guguji($aids, $sp_uid) {
        if(!is_array($aids)) {
            $aids = array($aids);
        }
        $sql = 'delete from guguji where uid in ('.implode(',',$aids).') and sp_uid = '.$sp_uid;
        $ret = Dba::write($sql);

        return $ret;
    }

    /*
        打印机详情
    */
    public static function get_guguji_by_uid($uid) {
        return Dba::readRowAssoc('select * from guguji where uid = '.$uid, 'GugujiMod::func_get_guguji');
    }

    /*
     * 获取使用中的打印机
     */
    public static function get_used_guguji($sp_uid){
        return Dba::readRowAssoc('select * from guguji where status = 1 and sp_uid = '.$sp_uid);
    }



}
