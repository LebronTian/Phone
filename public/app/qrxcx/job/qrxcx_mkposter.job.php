<?php

/*
	生成用户专属二维码海报 并使用客服消息将海报推送给用户
*/

/*
	file_get_contents  当服务器为Connection: keep-alive 时将一直等到超时
	如 微信头像 , 应该使用此函数立即返回
	http://wx.qlogo.cn/mmopen/pibp762tfrel7WBnOd2HjHAhSGO8Vbaibn30ibHbHPlduaDXItylQgpfOTo1nBecp4wAyheMnqabKL9Edq48JX0uTMbLGVt9H8e/0

*/
function curl_file_get_contents($url)
{
	if(strncasecmp($url, 'http', 4)) {
		return file_get_contents($url);
	}

        #Weixin::weixin_log('weixin get '.$url);
        $c = curl_init();
        curl_setopt($c, CURLOPT_URL, $url);
        curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
	if(!strncasecmp($url, 'https', 5)) {
        	curl_setopt($c, CURLOPT_SSL_VERIFYPEER, false);
	        curl_setopt($c, CURLOPT_SSL_VERIFYHOST, false);
	}
        $ret = curl_exec($c);
        curl_close($c);

        return $ret;
}


