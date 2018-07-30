var myChart = echarts.init(document.getElementById('id_echart'));
var myChart2 = echarts.init(document.getElementById('id_echart2'));
var myChart3 = echarts.init(document.getElementById('id_echart3'));
if (g_echarts.length != 0)
{
    var option =
    {
        tooltip :
        {
            trigger : "item"
            /*,axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
            }
             */
        },
        legend :
        {
            data : ['总粉丝数', '新增粉丝数']
			
        },
        toolbox :
        {
            show : true,
            orient : 'vertical',
            x : 'right',
            y : 'center',
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
                    type : ['line', 'bar', 'stack', 'tiled']
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
        calculable : false,
        xAxis : [
            {
                type : 'category',
                data : g_echarts.xAxis.data
            }
        ],
        yAxis :
        [
            {
                type : 'value',
                name : '总粉丝数',
            },
            {
                type : 'value',
                name : '新增粉丝数',
            }
        ],
        series : [
            {

                name : '总粉丝数',
                type : 'line',
				itemStyle :
                {
                    normal :
                    {
                        label :
                        {
                            show : true,
                            position : 'top'
                        }
                    }
                },
                data : g_echarts.series[0].data
            },
            {
                name : '新增粉丝数',
                type : 'line',
				yAxisIndex:1,
                itemStyle :
                {
                    normal :
                    {
                        label :
                        {
                            show : true,
                            position : 'top'
                        }
                    }
                },
                data : g_echarts.series[1].data
            },

        ]
    };
window.onresize = myChart.resize;
    myChart.setOption(option);
}
//alert(g_echarts2.options.series.data.value);
if (g_echarts2.length != 0)
{
    var idx = 1;
    var option2 =
    {

          title : {
        text: '用户男女分布情况',
        subtext: '',
        x:'center'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical',
        x : 'left',
        data:['男生','女生','未知']
    },
    toolbox: {
        show : true,
        feature : {
            mark : {show: true},
            dataView : {show: true, readOnly: false},
            magicType : {
                show: true, 
                type: ['pie'],
            },
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    calculable : true,
    series : [
        {
            name:'访问来源',
            type:'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:g_echarts2.series[0].data
           
        }
    ]

    };
window.onresize = myChart.resize;
    myChart2.setOption(option2);
}

//if (g_echarts3.length != 0||1)
if (1)
{
   option3 = {
    title : {
        text: '粉丝全国分布图',
        subtext: '',
        x:'center'
    },
    tooltip : {
        trigger: 'item'
    },

    dataRange: {
        min: 0,
        max: g_echarts3 && g_echarts3.dataRange && g_echarts3.dataRange.max,
        x: 'left',
        y: 'bottom',
        text:['高','低'],           // 文本，默认为数值文本
        calculable : true
    },
    toolbox: {
        show: true,
        orient : 'vertical',
        x: 'right',
        y: 'center',
        feature : {
            mark : {show: true},
            dataView : {show: true, readOnly: false},
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    roamController: {
        show: true,
        x: 'right',
        mapTypeControl: {
            'china': true
        }
    },
    series : [
        {
            name: '粉丝数',
            type: 'map',
            mapType: 'china',
            roam: false,
            itemStyle:{
                normal:{label:{show:true}},
                emphasis:{label:{show:true}}
            },
            data: g_echarts3 && g_echarts3.series && g_echarts3.series[0].data
              // {name: '澳门',value: Math.round(Math.random()*1000)}
            
        }
    ]
};
                    
window.onresize = myChart.resize;
    myChart3.setOption(option3);
}


/*

$('#id_download').click(function ()
{
    var date = $('#doc-datepicker').val();
    window.location.href = "?_a=su&_u=sp.excel&date=" + date + "&r_uid=" + r_uid;
}
);
*/
