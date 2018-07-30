var myChart = echarts.init(document.getElementById('id_echart')); 
 if(g_echarts && g_echarts.length!=0)
 {
var option = {
    dataZoom:{
        show:true,
    },
    tooltip : {
        trigger:"item"
		/*
       ,axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
        } 
		*/
    },
    legend: {
        data:['浏览量','访客数', '商品浏览量', '商品访客数']
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
        }
    ],
    yAxis : [
        {
            type : 'value'
        }
    ],
    series : [
        {	
			
            name:'浏览量',
            type:'line',
			stack:'',
            itemStyle:{
                normal:
                {
                    label:{
                        show:true,
                        position:'top'
                    }
                }
            },
            smooth:true,
			data: g_echarts.series[0].data
        },
        {
            name:'访客数',
            type:'line',
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
            smooth:true,
			data: g_echarts.series[1].data
        },
        {
            name:'商品浏览量',
            type:'line',
			stack:'',
            itemStyle:{
                normal:
                {
                    label:{
                        show:true,
                        position:'top'
                    }
                }
            },
            smooth:true,
			data: g_echarts.series[2].data
        },
        {
            name:'商品访客数',
            type:'line',
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
            smooth:true,
			data: g_echarts.series[3].data
        },

   ]
};
window.onresize = myChart.resize;
myChart.setOption(option);
}
