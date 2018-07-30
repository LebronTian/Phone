<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
	<title>销售统计图</title>
</head>
<body>

	<div id="chartmain" style="margin-top:1em;width:100%; height: 400px;"></div>

	<div id="chartmain11" style="margin-top:1em;width:100%; height: 400px;"></div>
	<div id="chartmain22" style="margin-top:1em;width:100%; height: 400px;"></div>
	<div id="chartmain33" style="margin-top:1em;width:100%; height: 400px;"></div>

	<div id="chartmain2" style="margin-top:1em;width:100%; height: 400px;"></div>
</body>

<script src="/static/js/echarts/echarts.js"></script>
<script>

    var option = {
        title:{
            text:'1区T1栋楼盘销控柱状图'
        },
        tooltip:{},
        legend:{
        	x: 'right',
            data:['数量']
        },
        xAxis:{

            data:['1号楼','2号楼','3号楼','4号楼','5号楼','6号楼']
        },
        yAxis:{

        },
        series:[{
            name:'数量',
            type:'bar',
            stack: '',
            itemStyle:{
                normal:
                {
                    label:{
                        show:true,
                        position:'top'
                    }
                }
            },
            smooth:false,
            data:[5,3,3,4,5,6,7]
        }]
    };
    var myChart = echarts.init(document.getElementById('chartmain'));
    //使用制定的配置项和数据显示图表
    myChart.setOption(option);
	
	option['title']['text'] = '1区T2栋楼盘销控柱状图';
	option['series'][0]['data'] = [2,2,3,8,8,8,7];
    var myChart11 = echarts.init(document.getElementById('chartmain11'));
    myChart11.setOption(option);

	option['title']['text'] = '1区T3栋楼盘销控柱状图';
	option['series'][0]['data'] = [3,2,9,3,1,8,7];
    var myChart22 = echarts.init(document.getElementById('chartmain22'));
    myChart22.setOption(option);

	option['title']['text'] = '1区T4栋楼盘销控柱状图';
	option['series'][0]['data'] = [5,5,5,3,3,1,2];
    var myChart33 = echarts.init(document.getElementById('chartmain33'));
    myChart33.setOption(option);

	option = {
	    title : {
	        text: '智慧新城楼盘总销售饼图',
	        subtext: '',
	        x:'left'
	    },
	    tooltip : {
	        trigger: 'item',
	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	    },
	    legend: {
	        orient: 'vertical',
	        x: 'right',
	        data: ['已售','剩余']
	    },
	    series : [
	        {
	            name: '销售额',
	            type: 'pie',
	            radius : '55%',
	            center: ['50%', '60%'],
	            data:[
	                {value:335, name:'已售'},
	                {value:310, name:'剩余'},
	            ],
	            itemStyle: {
	                emphasis: {
	                    shadowBlur: 10,
	                    shadowOffsetX: 0,
	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	                }
	            }
	        }
	    ]
	};


    var myChart = echarts.init(document.getElementById('chartmain2'));

    //使用制定的配置项和数据显示图表
    myChart.setOption(option);


</script>
</html>
