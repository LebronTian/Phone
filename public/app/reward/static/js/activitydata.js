var myChart = echarts.init(document.getElementById('id_echart')); 
var myChart2 = echarts.init(document.getElementById('id_echart2')); 
 if(g_echarts.length!=0)
 {
var option = {
    tooltip : {
        trigger:"item"
		/*
       ,axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
        } 
		*/
    },
    legend: {
        data:['历史参与人数','今日参与人数', '历史中奖数', '今日中奖数']
    },
    toolbox: {
        show : true,
        orient: 'vertical',
        x: 'right',
        y: 'center',
        feature : {
            mark : {show: true},
            dataView : {show: true, readOnly: false},
            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    calculable : false,
    xAxis : [
        {
            type : 'category',
            //data : ['周一','周二','周三','周四','周五','周六','周日']
			data: g_echarts.xAxis.data
        }
    ],
    yAxis : [
        {
            type : 'value'
        }
    ],
    series : [
        {	
			
            name:'历史参与人数',
            type:'line',
			stack:'人数',	

            //data:[320, 332, 301, 334, 390, 330, 320]
			data: g_echarts.series[0].data
        },
        {
            name:'今日参与人数',
            type:'line',
            stack: '人数',
            //data:[120, 132, 101, 134, 90, 230, 210]
            itemStyle:{
              normal:
              {
                 label:{
                   show:true,
                   position:'top'
                 }
              }
            },
			data: g_echarts.series[1].data
        },
        {
            name:'历史中奖数',
            type:'line',
			stack:'模型',	
            //data:[320, 332, 301, 334, 390, 330, 320]
			data: g_echarts.series[2].data
        },
        {
            name:'今日中奖数',
            type:'line',
            stack: '模型',
			itemStyle:{
				normal:
				{
					label:{
						show:true,
						position:'top'
					}
				}
			},
            //data:[120, 132, 101, 134, 90, 230, 210]
			data: g_echarts.series[3].data
        }
   ]
};

myChart.setOption(option);
}
//alert(g_echarts2.options.series.data.value);
 if(g_echarts2.length!=0)
 {
var idx = 1;
var option2 = {
	
    timeline : {
        data :g_echarts2.xAxis.data,
        label : {
            formatter : function(s) {
                return s.slice(0, 7);
            }
        }
    },
    options : [
        {
            title : {
                text: '中奖情况',
                subtext: ''
            },
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                data:g_echarts2.options.legend.data
            },
            toolbox: {
                show : true,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {
                        show: true, 
                        type: ['pie'],
                        option: {
                            funnel: {
                                x: '25%',
                                width: '50%',
                                funnelAlign: 'left',
                                max: 1700
                            }
                        }
                    },
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            //series : g_echarts2.options.series
            series : g_echarts2.options[0].series
        },

    ]

                    
}; 
//for(var i=0;i<g_echarts2.count;i++)
for(var i=1;i<g_echarts2.count;i++)
{
	option2.options.push(g_echarts2.options[i]);
}	
// 为echarts对象加载数据 

 myChart2.setOption(option2); 
 }
$('#id_download').click(function(){
	var date = $('#doc-datepicker').val();
	window.location.href="?_a=reward&_u=sp.excel&date="+date+"&r_uid="+r_uid;
	//window.open("?_a=reward&_u=sp.excel&date="+date+"&r_uid="+r_uid);
});

var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=reward&_u=sp.activitydata&r_uid=' + cat;
	}
});
