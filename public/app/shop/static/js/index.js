var myChart = echarts.init(document.getElementById('id_echart'));
 if(g_echarts.length!=0)
 {
var option = {
    title:{
        //text:'商城统计图'
    },
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
        data:['商城pv','商城uv', '商品pv', '商品uv','订单数','销售额'],
        selected: {
            '销售额': false
        }
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
            name:'商城pv',
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
            name:'商城uv',
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
            name:'商品pv',
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
            name:'商品uv',
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
        {
            name:'订单数',
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
            data: g_echarts.series[4].data
        },
        {
            name:'销售额',
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
            data: g_echarts.series[5].data
        },
   ],
            media:[
                {
                    //小与1000像素时候响应
                    query:{
                        maxWidth:1000
                    },
                    option:{
                        title:{
                            show:true,
                            text:'测试一下'
                        }
                    }
                }
            ]
};
window.onresize = myChart.resize;
myChart.setOption(option);
}
