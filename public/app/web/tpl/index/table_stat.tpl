<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
	<title>销控统计表</title>
<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.12.4.js"></script>
<style>
body {
background:red;
}
thead{
color:white;
}
table.dataTable tbody tr.odd {
background: #ffd;
}
h2 {
text-align:center;
color:gold;
}
.cout{
background: red;
color:white;
padding:2px;
}
/* 单元格连续纯字母数字强制换行显示 */
.wordwrap{
    word-wrap: break-word;
    word-break: break-all;
    overflow: hidden;
}
/* 超长文字单元格省略号显示 */
.ellipsis{
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
}
</style>
</head>
<body>
<h2>1区T1栋楼盘销控表</h2>
<p style="color:white;">更新日期： 2017-12-05</p>
<table id="id_table"></table>
</body>
<script>
$(document).ready(function() {
	function func_render(a) {
		return a&&a.length ? a : '<a class="cout">售</a>';
	};
	$('#id_table').DataTable({
		'autoWidth' : false,
		'paging' : false,
		'searching' : false,
		'info' : false,
		'scrollX' : true,
		'columns': [{'title': '楼层'}, 
					{'title': '1号房', 'orderable': false, 'render': func_render}, 
					{'title': '2号房', 'orderable': false, 'render': func_render}, 
					{'title': '3号房', 'orderable': false, 'render': func_render}, 
					{'title': '4号房', 'orderable': false, 'render': func_render}, 
					{'title': '5号房', 'orderable': false, 'render': func_render}, 
					{'title': '6号房', 'orderable': false, 'render': func_render}, 
					{'title': '7号房', 'orderable': false, 'render': func_render}, 
					{'title': '8号房', 'orderable': false, 'render': func_render}, 
					{'title': '9号房', 'orderable': false, 'render': func_render}, 
					{'title': '10号房', 'orderable': false, 'render': func_render}, 
		],
		'data': [
			 ['1F', '924㎡', '87㎡', '104㎡', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['2F', '924㎡', '', '104㎡', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['3F', '', '', '', '', '', '', '', '', '', '']
			,['4F', '924㎡', '87㎡', '', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['5F', '', '', '', '', '', '', '', '', '', '']
			,['6F', '924㎡', '87㎡', '104㎡', '', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['7F', '924㎡', '87㎡', '104㎡', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['8F', '924㎡', '87㎡', '104㎡', '', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['9F', '924㎡', '87㎡', '104㎡', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
			,['10F', '924㎡', '87㎡', '104㎡', '120㎡', '128㎡', '75㎡', '72㎡', '72㎡', '41㎡', '30㎡']
		]
	});

} );
</script>
</html>
