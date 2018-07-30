var myChart = echarts.init(document.getElementById('id_echart')); 
var myChart2 = echarts.init(document.getElementById('id_echart2'));
 if(g_echarts.length!=0)
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
        data:['商城pv','商城uv', '商品pv', '商品uv']
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

   ]
};

myChart.setOption(option);
}
if (g_echarts2.length != 0) {
    var idx = 1;
    var option2 = {

        timeline: {
            data: g_echarts2.xAxis.data,
            currentIndex:(g_echarts2.xAxis.data.length-1),
            autoPlay:true,
            loop:true
        },
        options: [
            {

                title: {
                    text: 'PV分布情况',
                    subtext: ''
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    data: g_echarts2.options.legend.data
                },
                toolbox: {
                    orient: 'vertical',
                    show: true,
                    feature: {
                        mark: {show: true},
                        dataView: {show: true, readOnly: false},
                        magicType: {
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
                        restore: {show: true},
                        saveAsImage: {show: true}
                    }
                },
                //series : g_echarts2.options.series
                series: g_echarts2.options[0].series,
            },

        ]


    };
//for(var i=0;i<g_echarts2.count;i++)
    for (var i = 1; i < g_echarts2.count; i++) {
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

$(function() {
    var startDate = new Date($('#my-startDate').text());
    var endDate = new Date($('#my-endDate').text());
    $('#my-start').datepicker().
        on('changeDate.datepicker.amui', function(event) {
            if (event.date.valueOf() > endDate.valueOf()) {
                showTip("err","结束日期应大于开始日期",1000);
            } else {

                startDate = new Date(event.date);
                $('#my-startDate').text($('#my-start').data('date'));
            }
            $(this).datepicker('close');
        });

    $('#my-end').datepicker().
        on('changeDate.datepicker.amui', function(event) {
            if (event.date.valueOf() < startDate.valueOf()) {
                showTip("err","结束日期应大于开始日期",1000);
            } else {

                endDate = new Date(event.date);
                $('#my-endDate').text($('#my-end').data('date'));
            }
            $(this).datepicker('close');
        });
});
$('.btn_show').click(function(){

    var a_uid = $('.option_agent').val();
    var p_uid = $('.option_product').val();
    var start_time = new Date($('#my-startDate').text());
    var end_time = new Date($('#my-endDate').text());
    start_time = start_time.getTime()/1000;
    end_time = end_time.getTime()/1000;
    var url = '?_a=shop&_u=sp.visit_record';
    if(a_uid!=undefined || a_uid!=0) url+='&a_uid=' + a_uid;
    if(p_uid!=undefined ||p_uid!=0) url+='&p_uid='+p_uid;
    if(start_time!=undefined) url+='&start_time='+start_time;
    if(end_time!=undefined) url+='&end_time='+end_time;

    window.location.href=url;

});