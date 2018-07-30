<?php

/*
	e类订单 old 微医疗订单
*/

class EOrderMod
{
    public function __construct($uid)
    {
        uct_use_app('shop');
        uct_use_app('old');
        if (!($this->o = OldorderMod::get_doctor_order_by_uid($uid)) && !($this->o = OldorderMod::get_org_order_by_uid($uid))) {
            setLastError(ERROR_OBJ_NOT_EXIST);
        } else {
            $this->o['sp_uid'] = Dba::readOne('select sp_uid from shop where uid = ' . $this->o['uid']);
            if (isset($this->o['d_uid'])) {
                //支付成功 注意不要重复添加事件
                Event::addHandlerOnce('AfterDoctorOrderPay', array('OldorderMod', 'onAfterDoctorOrderPay'));
            }
            if (isset($this->o['or_uid'])) {
                //支付成功 注意不要重复添加事件
                Event::addHandlerOnce('AfterOrgOrderPay', array('OldorderMod', 'onAfterOrgOrderPay'));
            }

        }
    }

    /*
        获取订单信息, 必须为待支付状态

        return array(
                    'trade_no' => 订单号 axxxxxx
                    'total_fee'=> 费用
                    'title'    => 支付名称
                    'detail'   => 支付详情

                    'sp_uid' => 商户uid
                    'su_uid' => 用户uid, 如果sp_uid=0那么su_uid表示商户uid

                    'product_uid' => 商品uid, 可选
                    'expire'  => 订单过期时间(秒), 可选
        )
    */
    public function PreparePayInfo()
    {
        if (!$this->o) {
            return false;
        }
        if ($this->o['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
            setLastError(ERROR_BAD_STATUS);
            return false;
        }

        $title = '';
        $detail = '';

        if (isset($this->o['d_uid'])) {
            $title = $this->o['doctor']['name'];
            $detail = '预约['.$this->o['doctor']['name'].'],咨询时间：' . $this->o['server_time'].'分';
        }

        if (isset($this->o['or_uid'])) {
            $title = $this->o['org']['title'];
            $detail = '预约['.$this->o['org']['title']. ']的服务 ';
        }

        return array(
            'trade_no' => 'e' . $this->o['uid'],
            'total_fee' => $this->o['paid_fee'],
            'title' => $title,
            'detail' => $detail,
            'su_uid' => $this->o['user_id'],
            'sp_uid' => Dba::readOne('select sp_uid from shop where uid = ' . $this->o['shop_uid']),
        );
    }

    /*
        获取订单信息, 包括状态和支付信息
        return array(
                    'status' => 订单状态
                    'create_time' => 下单时间
                    'create_time' => 支付时间
                    'return_url' => 支付完返回地址,通常是订单详情页

                    'pay_type' => 支付类型
                    'pay_info' => 支付信息

                    'sp_uid' => 商户uid
                    'su_uid' => 用户uid, 如果sp_uid=0那么su_uid表示商户uid
    */
    public function GetOrderInfo()
    {

        if (!$this->o) {
            return false;
        }
        return array(
            'trade_no' => 'c' . $this->o['uid'],
            'status' => $this->o['status'],
            'create_time' => $this->o['create_time'],
            'paid_time' => $this->o['paid_time'],
            'total_fee' => $this->o['paid_fee'],
            'title' => isset($this->o['doctor']['name'])?$this->o['doctor']['name']:$this->o['org']['title'],
            'return_url' => '?_a=old&_u=index.orderdetails&uid=' . $this->o['uid'],
            'pay_type' => $this->o['pay_type'],
            'pay_info' => $this->o['pay_info'],
            'su_uid' => $this->o['user_id'],
            'sp_uid' => Dba::readOne('select sp_uid from shop where uid = ' . $this->o['shop_uid']),
        );
    }

    /*
        发出了支付请求, 返回一些支付信息如prepay_id等, 保存一下
        $params = array(
                        'pay_type' =>
                        'pay_info' =>
        )
    */
    public function SavePayInfo($params)
    {
        if (!$this->o) {
            return false;
        }

        $update = array('uid' => $this->o['uid'],
            'pay_type' => $params['pay_type'],
            'pay_info' => $params['pay_info'],
        );
        return OrderMod::edit_order($update);
    }

    /*
        支付成功回调

        $params = array(
                        'pay_type' =>
                        'pay_info' =>

                        'paid_time' =>  //支付时间 可选
        )

    */
    public function PaySucceedCallback($params)
    {
        if (!$this->o) {
            return false;
        }
        if ($this->o['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
            setLastError(ERROR_BAD_STATUS);
            return false;
        }

        $update = array('uid' => $this->o['uid'],
            'status' => OrderMod::ORDER_WAIT_FOR_DELIVERY,  //已付款,待发货
            'pay_type' => $params['pay_type'],
            'paid_time' => isset($params['paid_time']) ? $params['paid_time'] : $_SERVER['REQUEST_TIME'],
            'pay_info' => $params['pay_info'],
        );

        Dba::beginTransaction();
        {
            OrderMod::edit_order($update);
            if (isset($this->o['d_uid'])) {
                Event::handle('AfterDoctorOrderPay', array(OldorderMod::get_doctor_order_by_uid($this->o['uid'])));
            }
            if (isset($this->o['or_uid'])) {
                Event::handle('AfterOrgOrderPay', array(OldorderMod::get_org_order_by_uid($this->o['uid'])));
            }


        }
        Dba::commit();
        return true;
    }

}

