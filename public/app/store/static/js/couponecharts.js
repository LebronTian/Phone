var myChart = echarts.init(document.getElementById('id_echart')); 
        
var option = {
    tooltip : {
        trigger: 'axis'
		/*
       ,axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
        } 
		*/
    },
    legend: {
        data:['今日发放','历史发放', '今日核销', '历史核销']
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
    calculable : true,
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
            name:'历史发放',
            type:'bar',
			stack:'发放',	
            //data:[320, 332, 301, 334, 390, 330, 320]
			data: g_echarts.series[0].data
        },
        {
            name:'今日发放',
            type:'bar',
            stack: '发放',
            //data:[120, 132, 101, 134, 90, 230, 210]
			data: g_echarts.series[1].data
        },
        {
            name:'历史核销',
            type:'bar',
			stack:'核销',	
            //data:[320, 332, 301, 334, 390, 330, 320]
			data: g_echarts.series[2].data
        },
        {
            name:'今日核销',
            type:'bar',
            stack: '核销',
            //data:[120, 132, 101, 134, 90, 230, 210]
			data: g_echarts.series[3].data
        }
   ]
};
                    

// 为echarts对象加载数据 
myChart.setOption(option); 


var myChart2 = echarts.init(document.getElementById('id_echart2'));
{
    var idx = 1;
    var option2 =
    {

        title :
        {
            text : '已发放优惠券',
            subtext : '',
            x : 'center'
        },
        tooltip :
        {
            trigger : 'item',
            formatter : "{a} <br/>{b} : {c} ({d}%)"
        },
        legend :
        {
            orient : 'vertical',
            x : 'left',
            data : g_echarts2.legend.data
        },
        toolbox :
        {
            show : true,
            feature :
            {
                mark :
                {
                    show : true
                },
                dataView :
                {
                    show : true,
                    readOnly : false
                },
                magicType :
                {
                    show : true,
                    type : ['pie'],
                },
                restore :
                {
                    show : true
                },
                saveAsImage :
                {
                    show : true
                }
            }
        },
        calculable : true,
        series : [
            {
                name : '优惠券',
                type : 'pie',
                radius : '55%',
                center : ['50%', '60%'],
                data : g_echarts2.series[0].data

            }
        ]

    };

    myChart2.setOption(option2);
}

/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var cat = $(this).val();
	window.location.href='?_a=store&_u=sp.couponecharts&store_uid=' + cat;
});

