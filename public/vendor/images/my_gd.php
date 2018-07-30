<?php

/*
	绘图
	$option = array(
		back_ground => array(
			'path' => 图片路径
			'w'
			'h'
		),	
		image => array(
		array(
			'data' => //图片数据，与path二选一
			'path' =>

			'size' => array(w,h)
			'point' => array(x,y)
			'circle' => 是否圆形图像
		)
		),
		string => array(
		array(
			'content' => 文字内容
			'color' => #ff0000

			'size' => 字体大小px
			'point' => array(x,y)
			'center' => 是否居中对齐
		)
		),
	)

	输出一张png图片到浏览器
*/
function uct_gd_draw_poster($option) {
	//1. 背景图
	$r_bg = imagecreatefromstring(file_get_contents($option['back_ground']['path']));
	$w = isset($option['back_ground']['size']['0']) ? $option['back_ground']['size']['0'] : 0;
	$h = isset($option['back_ground']['size']['1']) ? $option['back_ground']['size']['1'] : 0;
	if($w && $h) {
		$r_bg = uct_gd_resize($r_bg, $w, $h);			
	}
	
	//2. 贴图
	if(!empty($option['image']))
	foreach($option['image'] as $i) {
		if(isset($i['data'])) {
			$r_i = imagecreatefromstring($i['data']);	
		} else {
			$r_i = imagecreatefromstring(file_get_contents($i['path']));	
		}	
		if(!empty($i['size']['0']) && !empty($i['size']['1'])) {
			$r_i = uct_gd_resize($r_i, $i['size']['0'], $i['size']['1']);			
		}
		uct_gd_paste($r_bg, $r_i, $i['point']['0'], $i['point']['1'], !empty($i['circle']) || !empty($i['l']));
		imagedestroy($r_i);
	}
	
	//3. 文字
	if(!empty($option['string'])) {
	foreach($option['string'] as $s) {
		$bold    = !empty($s['bold']) ? 'bd' : '';
		$font    = dirname(__file__) . '/font/msyh' . $bold . '.ttf';
		$angle   = isset($s['angle']) ? $s['angle']: 0;
		if(!empty($s['center'])) {
			//文字居中
			$box = imagettfbbox($s['size'], $angle, $font, $s['content']);
			$width = abs($box[4] - $box[0]);
			$height = abs($box[5] - $box[1]);
			$x = $s['point']['0'] - $width/2;
			$y = $s['point']['1'] + $height/2;
		} else {
			$x = $s['point']['0'];
			$y = $s['point']['1'];
		}
		
		imagettftext($r_bg, $s['size'], $angle, $x, $y,
					uct_gd_get_color($r_bg, $s['color']), $font, $s['content']);
	}
	}

	header('Content-Type: ', 'image/png');
	header('Cache-Control: public');
	header('Last-Modified: ' . $_SERVER['REQUEST_TIME']);
	imagepng($r_bg);	
	exit();
}

/*
	图片缩放
	$r gd图片资源
	$w 宽
	$h 高
*/
function uct_gd_resize($r, $w, $h) {
	$size_src = array(imagesx($r), imagesy($r));
	if($size_src[0] == $w && $size_src[1] == $h) {
		return $r;
	}
	$new = imagecreatetruecolor($w, $h);
	imagecopyresampled($new, $r, 0, 0, 0, 0, $w, $h, $size_src['0'], $size_src['1']);
	
	return $new;
}

/*
	把src画到dst上去， 
	$x $y 左上角
	$round 圆形图片
*/
function uct_gd_paste($r_dst, $r_src, $x, $y, $round = false) {
	$size_src = array(imagesx($r_src), imagesy($r_src));
	if(!$round) {
		imagecopy($r_dst, $r_src, $x, $y, 0, 0, $size_src['0'], $size_src['1']);
	} else {
		$r=($size_src['0'] * $size_src['0']/4 + $size_src['1'] * $size_src['1']/4)/2;
		for($i = 0; $i < $size_src['0']; $i++) {
			for($j = 0; $j < $size_src['1']; $j++) {
				if(($i-$size_src['0']/2)*($i-$size_src['0']/2) + 
					($j-$size_src['1']/2)*($j-$size_src['1']/2)<= $r) {	
						imagesetpixel($r_dst, $x+$i, $y+$j, imagecolorat($r_src, $i, $j));	
				}
			}
		}
	}
}

/*
	#ffffff	
*/
function uct_gd_get_color($img, $str) {
	$str = ltrim($str, '#');
	$r = base_convert(substr($str, 0 ,2), 16, 10);
	$g = base_convert(substr($str, 2 ,2), 16, 10);
	$b = base_convert(substr($str, 4 ,2), 16, 10);
	return imagecolorallocate($img, $r, $g, $b);
}

