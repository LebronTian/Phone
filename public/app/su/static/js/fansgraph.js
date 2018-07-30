var myChart = echarts.init(document.getElementById('id_echart'));
var option = {
    title: {
        text: (g_su['name'] || g_su['account']),
    },
    animationDurationUpdate: 1500,
    animationEasingUpdate: 'quinticInOut',
    series : [
        {
            type: 'graph',
            layout: 'none',
            roam: true,
            //layout: 'force',
			//draggable: true,
            symbolSize: 50,
            label: {
                normal: {
                    show: true
                }
            },
            edgeSymbol: ['circle', 'arrow'],
            edgeSymbolSize: [4, 10],
            edgeLabel: {
                normal: {
                    textStyle: {
                        fontSize: 20
                    }
                }
            },
            data: g_echarts.data,
            // links: [],
            links: g_echarts.links,
            lineStyle: {
                normal: {
                    opacity: 0.9,
                    width: 2,
                    curveness: 0
                }
            }
        }
    ]
};
myChart.setOption(option);

myChart.on('click', function(params) {
	console.log(params, params.data);
	if(params.data && params.data.uid) {
		if(params.data.uid != g_su.uid) {
			window.location.href = '?_a=su&_u=sp.fansgraph&su_uid=' + params.data.uid;
		}
	}
});

