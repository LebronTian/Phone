$(document).ready(function() {
	TweenLite.set([$("#index")], {
		transformPerspective: 1500
	});
	var tl = new TimelineLite({
		paused: true
	});
	tl.to("#index", 0.5, {
		rotationY: -90,
		transformOrigin: "left center",
		ease:Linear.easeNone
	})
	
	TweenLite.set([$("#qianyan")], {
		transformPerspective: 1500
	});
	var tl2 = new TimelineLite({
		paused: true
	});
	tl2.to("#qianyan", 0.5, {
		rotationY: -90,
		transformOrigin: "left center",
		ease:Linear.easeNone
	})

	var tl3 = new TimelineLite({
		paused: true
	});
	tl3.to("#dir", 0.5, {
		rotationY: -90,
		transformOrigin: "left center",
		ease:Linear.easeNone
	})


	$("#index").touchwipe({
		min_move_x: 15,
		min_move_y: 15,
		wipeLeft: function() {
			tl.play()
		},
		wipeRight: function() {},
		wipeUp: function() {},
		wipeDown: function() {},
		wipe: function() {},
		wipehold: function() {},
		preventDefaultEvents: true
	});
	$("#qianyan").touchwipe({
		min_move_x: 15,
		min_move_y: 15,
		wipeLeft: function() {
			tl2.play()
		},
		wipeRight: function() {
			tl.reverse();
		},
		wipeUp: function() {},
		wipeDown: function() {},
		wipe: function() {},
		wipehold: function() {},
		preventDefaultEvents: true
	});

	$("#dir").touchwipe({
		min_move_x: 15,
		min_move_y: 15,
		wipeLeft: function() {},
		wipeRight: function() {
			tl2.reverse();
		},
		wipeUp: function() {},
		wipeDown: function() {},
		wipe: function() {},
		wipehold: function() {},
		preventDefaultEvents: false
	});
	
	
	if(window.location.href.indexOf('#mulu')>-1){
		//alert ("这个是当前目录页")
		tl.play();
		tl2.play();
	}
});

