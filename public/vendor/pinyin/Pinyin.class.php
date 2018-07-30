<?php
class Pinyin {
	/*
	*输入中文，返回拼音和拼音缩写,支持多音字
	* 如输入 乐嘉
	* 返回 array {
			'lejia' => 'lj'
			'yuejia' => 'yj'
		}
	*
	*/
	public static function getPinyin($string) {
	    $string = iconv('utf-8', 'gbk', $string);

		static $pinyin_table = null;
		if (!$pinyin_table) {
    		include __DIR__.'/pinyin_table.cache.php';
			$pinyin_table = getPinyinTable();
		}

        $full = array();
		$short = array();

        for ($i=0;$i<strlen($string);$i++)
        {
            if (ord($string[$i]) >= 0x81 and ord($string[$i]) <= 0xfe)
            {
                $h = ord($string[$i]);
                if (isset($string[$i+1]))
                {
                    $i++;
                    $l = ord($string[$i]);
                    if (isset($pinyin_table[$h][$l]))
                    {
						$tb = $pinyin_table[$h][$l];
                        array_push($full, $tb);
						array_push($short, array_map(function($w){
													return substr($w, 0, 1);}, 
													$tb));
                    }
                    else
                    {
                        array_push($full,$h);
                        array_push($full,$l);
                    }
                }
                else
                {
                    array_push($full, ($string[$i]));
                }
            }
            else
            {
                array_push($full, strtolower($string[$i]));

				if (ctype_alnum($string[$i])) {
                	array_push($short, strtolower($string[$i]));
				}
            }
        }

		$full = self::implode_r($full);
		if ($short) {
			return array_combine($full, self::implode_r($short));
		}
		//当输入只有字母数字时，将没有缩写，因此将short赋原始值
		//utf8 和 gbk 都一样
		else {
				return array_fill_keys($full, $string);
		}
    }

	//在word中搜索key，匹配返回true, 如 match('lejia', '乐嘉') 返回true
	public static function match($key, $word) {
		$key  = strtolower($key);
		$key  = str_replace(array('_', '-'), '', $key);
		$word = strtolower($word);
		$word = str_replace(array('_', '-'), '', $word);
	
		if (strpos($word, $key) !== false) {
			return true;
		}
	
		//1.key中有汉字则直接返回
		if (!ctype_alnum($key)) {
			return false;
		}
	
		//2.求出key可能对应的拼音编码
		$comp = (self::completePinyin($key));
		if (!$comp['short']) {
			return false;
		}
	
		//3.求出被搜索字符对应的拼音编码
		$word  = self::getPinyin($word);
	
		//key可能是英文单词，先直接匹配short
		foreach($word as $short) {
			if (strpos($short, $key) !== false) {
				return true;
			}
		}
	
		if (strcmp($key, $comp['short']) != 0) {
			foreach($word as $name => $v) {
				foreach($comp['full'] as $full) {
					if (strncmp($name, $full, strlen($full)) == 0) {
						return true;	
					}
				}
			}
		}
	
		return false;
	}

	//删除str左边属于arr中的字符，返回被删除的字符
	public static function strtrim(&$str, $arr, $del = false) {
		if ($del) {
			foreach($arr as $v) {
				$len = strlen($v);
				if (strncmp($str, $v, $len) == 0) {
					$str = substr($str, $len);	
					return $v;
				}
			}
		}
		else {
			foreach($arr as $v) {
				$len = strlen($v);
				if (strncmp($str, $v, $len) == 0) {
					return $v;
				}
			}
		}

		return false;
	}

	
	//递归implode，所有结果以列表形式返回
	public static function implode_r($list, $glue = '') {
		if (!$list) {
			return null;
		}

		$last = array_pop($list);
		if (!is_array($last)) {
			$last = array($last);
		}

		if (!$result = self::implode_r($list, $glue)) {
			return $last; 
		}

		$ret = array();
		foreach($last as $l) {
			foreach($result as $r) {
				$ret[] = $r.$glue.$l;
			}
		}		

		return $ret;	
	}

	//补全韵母， 将‘yjl’ 补全成‘yijianlian’
	public static function completePinyin($str) {
		$str = strtolower(trim($str));

		static $pinyin_sm = null;
		static $pinyin_ym = null;
		if (!$pinyin_sm) {
    		include __DIR__.'/pinyin_all.cache.php';
			$pinyin_sm = getPinyinSm();
			$pinyin_ym = getPinyinYm();
		}

		$full  = array();
		$short = ''; 

		while ($str) {
			$sm = self::strtrim($str, $pinyin_sm);
			if ($sm) {
				if (($ym = self::strtrim($str, $pinyin_ym[$sm], true))) {
					$full[] = array($ym);
				}
				else {
					$word = array();
					foreach($pinyin_ym[$sm] as $ym) {
						$word[] = $ym;
					}
					$full[] = $word;
					$str = substr($str, strlen($sm));
				}

				// zh ch sh 保存为zcs
				$short .= substr($sm, 0 , 1);
			}
			else {
				//保留不是声母的字符
				$full[] = $str[0];
				$str    = substr($str, 1);	
			}
		}
			
		return array('full' => self::implode_r($full), 'short' => $short);
	}
}
