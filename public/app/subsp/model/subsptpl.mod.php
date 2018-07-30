<?php
/*
	预设 子账户 
*/

class SubspTplMod {
	public static function get_system_tpl($uid = 0) {
		static $tpls = array(
			0 => array('name' => '-', 'access_rule' => ''),
			

			1 => array(
				'name' => '美工',
'access_rule' => '{"*":"0","sp.index.index":"0","unknown.*":"0","sp.index.xiaochengxu":"0","pay.sp.xiaochengxupay":"0","pay.sp.withdraw":"0","shop.sp.gaikuang":"0","shop.*":"1","shop.sp.visualview":"1","sp.index.imgmanage":"1","sp.*":"1","shop.sp.delivery_discount":"0","shopman.sp.index":"0","shop.sp.productlist":"1","shop.sp.catlist":"1","shop.sp.orderlist":"0","shop.sp.commentslist":"0","shop.sp.orderlist8":"0","su.sp.index":"0","su.sp.fanslist":"0","vipcard.sp.vip_card_list":"0","vipcard.sp.uiset33":"0","su.sp.cashset":"0","su.sp.supointlist":"0","shop.sp.index":"0","shop.sp.visit_record":"0","shop.sp.zichan":"0","shop.sp.orderlistjiaoyi":"0","su.sp.sucashlist":"0","sp.index.pluginstore":"0","shop.sp.set":"0","subsp.sp.index":"0","sp.index.password":"0","shopman":"0","shoptuan":"0","shoptuan.sp.productgrouplist":"0","shoptuan.sp.orderlist":"0","auction":"0","auction.sp.index":"0","auction.sp.productlist":"0","auction.sp.itemlist":"0","auction.sp.robotlist":"0","auction.sp.autotasklist":"0","sharecode":"0","sharecode.sp.index":"0","shopdist":"0","shopdist.sp.distribution":"0","shopdist.sp.distribution_productlist":"0","shopdist.sp.orderlist":"0","shopdist.sp.distribution_user_list":"0","shopdist.sp.user_agreement":"0","shopbiz":"0","shopbiz.sp.bizlist":"0","shopbiz.sp.bizcatlist":"0","shopbiz.sp.biz_set":"0","shopbiz.sp.biz_know":"0","bargain":"0","book":"0","book.sp.itemlist":"0","book.sp.recordlist":"0","qrposter":"0","qrposter.sp.index":"0","qrposter.sp.photoset":"0","qrposter.sp.rewardset":"0","qrposter.sp.productlist":"0","qrposter.sp.orderlist":"0","usign":"0","store":"0","store.sp.storelist":"0","site":"1","site.sp.catlist":"1","site.*":"1","site.sp.articlelist":"1","form":"0","vote":"0","reward":"0"}',
),

			2 => array(
				'name' => '财务',
'access_rule'=> '{"*":"0","sp.index.index":"0","unknown.*":"0","sp.index.xiaochengxu":"0","pay.sp.xiaochengxupay":"0","pay.sp.withdraw":"0","shop.sp.gaikuang":"0","shop.sp.visualview":"0","sp.index.imgmanage":"0","shop.sp.delivery_discount":"0","shopman.sp.index":"0","shop.sp.productlist":"0","shop.sp.catlist":"0","shop.sp.orderlist":"0","shop.sp.commentslist":"0","shop.sp.orderlist8":"0","su.sp.index":"0","su.sp.fanslist":"0","vipcard.sp.vip_card_list":"0","vipcard.sp.uiset33":"0","su.sp.cashset":"0","su.sp.supointlist":"0","shop.sp.index":"0","shop.sp.visit_record":"0","shop.sp.zichan":"1","shop.*":"1","shop.sp.orderlistjiaoyi":"1","su.sp.sucashlist":"1","su.*":"1","sp.index.pluginstore":"0","shop.sp.set":"0","subsp.sp.index":"0","sp.index.password":"0","shopman":"0","shoptuan":"0","shoptuan.sp.productgrouplist":"0","shoptuan.sp.orderlist":"0","auction":"0","auction.sp.index":"0","auction.sp.productlist":"0","auction.sp.itemlist":"0","auction.sp.robotlist":"0","auction.sp.autotasklist":"0","sharecode":"0","sharecode.sp.index":"0","shopdist":"0","shopdist.sp.distribution":"0","shopdist.sp.distribution_productlist":"0","shopdist.sp.orderlist":"0","shopdist.sp.distribution_user_list":"0","shopdist.sp.user_agreement":"0","shopbiz":"0","shopbiz.sp.bizlist":"0","shopbiz.sp.bizcatlist":"0","shopbiz.sp.biz_set":"0","shopbiz.sp.biz_know":"0","bargain":"0","book":"0","book.sp.itemlist":"0","book.sp.recordlist":"0","qrposter":"0","qrposter.sp.index":"0","qrposter.sp.photoset":"0","qrposter.sp.rewardset":"0","qrposter.sp.productlist":"0","qrposter.sp.orderlist":"0","usign":"0","store":"0","store.sp.storelist":"0","site":"0","site.sp.catlist":"0","site.sp.articlelist":"0","form":"0","vote":"0","reward":"0"}',
),


			3 => array(
				'name' => '运营',
'access_rule'=> '{"*":"0","sp.index.index":"1","unknown.*":"0","sp.index.xiaochengxu":"1","sp.*":"1","pay.sp.xiaochengxupay":"1","pay.*":"1","pay.sp.withdraw":"1","shop.sp.gaikuang":"1","shop.*":"1","shop.sp.visualview":"1","sp.index.imgmanage":"1","shop.sp.delivery_discount":"1","shopman.sp.index":"1","shopman.*":"1","shop.sp.productlist":"1","shop.sp.catlist":"1","shop.sp.orderlist":"1","shop.sp.commentslist":"1","shop.sp.orderlist8":"1","su.sp.index":"1","su.*":"1","su.sp.fanslist":"1","vipcard.sp.vip_card_list":"1","vipcard.*":"1","vipcard.sp.uiset33":"1","su.sp.cashset":"1","su.sp.supointlist":"1","shop.sp.index":"1","shop.sp.visit_record":"1","shop.sp.zichan":"1","shop.sp.orderlistjiaoyi":"1","su.sp.sucashlist":"1","sp.index.pluginstore":"0","shop.sp.set":"0","subsp.sp.index":"0","sp.index.password":"0","shopman":"0","shoptuan":"0","shoptuan.sp.productgrouplist":"0","shoptuan.sp.orderlist":"0","auction":"0","auction.sp.index":"0","auction.sp.productlist":"0","auction.sp.itemlist":"0","auction.sp.robotlist":"0","auction.sp.autotasklist":"0","sharecode":"0","sharecode.sp.index":"0","shopdist":"0","shopdist.sp.distribution":"0","shopdist.sp.distribution_productlist":"0","shopdist.sp.orderlist":"0","shopdist.sp.distribution_user_list":"0","shopdist.sp.user_agreement":"0","shopbiz":"0","shopbiz.sp.bizlist":"0","shopbiz.sp.bizcatlist":"0","shopbiz.sp.biz_set":"0","shopbiz.sp.biz_know":"0","bargain":"0","book":"0","book.sp.itemlist":"0","book.sp.recordlist":"0","qrposter":"0","qrposter.sp.index":"0","qrposter.sp.photoset":"0","qrposter.sp.rewardset":"0","qrposter.sp.productlist":"0","qrposter.sp.orderlist":"0","usign":"0","store":"0","store.sp.storelist":"0","site":"0","site.sp.catlist":"0","site.sp.articlelist":"0","form":"0","vote":"0","reward":"0"}',
),
		);

		return $uid ? (isset($tpls[$uid]) ? $tpls[$uid] : array()): $tpls;
	}

}

