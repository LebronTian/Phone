$(function() {

	//后台首页图表
	var options = {
			"xAxis": [{
				"type": "category",
				"categories": ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
				"opposite": false,
				"reversed": false,
				"labels": {
					"format": ""
				},
				"title": {
					"text": ""
				},
				"index": 0,
				"isX": true
			}],
			"series": [{
				"name": "累计访问用户数",
				"data": [7, 6, 9, 14, 18, 21, 21, 25, 23, 13, 13, 9],
				"_colorIndex": 0,
				"_symbolIndex": 0
			}, {
				"name": "打开次数",
				"data": [1, 7, 7, 10, 17, 22, 18, 16, 21, 14, 6, 5],
				"_colorIndex": 1,
				"_symbolIndex": 1
			}, {
				"name": "访问次数",
				"data": [5, 5, 3, 8, 15, 17, 16, 19, 14, 9, 3, 7],
				"_colorIndex": 2,
				"_symbolIndex": 2
			}, {
				"name": "访问人数",
				"data": [3, 4, 5, 5, 11, 15, 17, 16, 12, 10, 6, 11],
				"_colorIndex": 3,
				"_symbolIndex": 3
			}, {
				"name": "新访问用户数",
				"data": [5, 8, 6, 9, 15, 13, 19, 22, 13, 8, 8, 15],
				"_colorIndex": 4,
				"_symbolIndex": 4
			}],
			"yAxis": [{
				"opposite": false,
				"reversed": false,
				"title": {
					"text": "",
					"style": {
						"fontFamily": "\"微软雅黑\", Arial, Helvetica, sans-serif",
						"color": "#666666",
						"fontSize": "12px",
						"fontWeight": "normal",
						"fontStyle": "normal"
					}
				},
				"type": "linear",
				"labels": {
					"format": "{value}"
				},
				"index": 0
			}],
			"chart": {
				"style": {
					"fontFamily": "\"微软雅黑\", Arial, Helvetica, sans-serif",
					"color": "#333",
					"fontSize": "12px",
					"fontWeight": "normal",
					"fontStyle": "normal"
				},
				"type": "line",
				"spacingBottom": 45,
				"spacingLeft": 0,
				"spacingRight": 0,
				"spacingTop": 0,
				"colorCount": 10,
				"borderWidth": 0,
				"description": "undefined",
				"ignoreHiddenSeries": true,
				"inverted": false,
				"showAxes": false,
				"options3d": {
					"enabled": true,
					"fitToPlot": true,
					"viewDistance": 25,
					"frame": {
						"back": {
							"size": 1
						},
						"bottom": {
							"size": 1
						},
						"side": {
							"size": 1
						}
					}
				},
				"resetZoomButton": {
					"relativeTo": "plot",
					"theme": {},
					"position": {
						"verticalAlign": "top"
					}
				}
			},
			"legend": {
				"verticalAlign": "top",
				"align": "left",
				"layout": "horizontal",
				"floating": false,
				"squareSymbol": true,
				"useHTML": true,
				"reversed": false,
				"enabled": true
			},
			"tooltip": {
				"enabled": true,
				"shared": true,
				"split": true,
				"useHTML": true,
				"animation": true,
				"valueDecimals": 0
			},
			"credits": {
				"enabled": false,
				"position": {
					"align": "right",
					"y": -5
				}
			},
			"title": {
				"text": "访问数量统计图",
				"align": "center",
				"verticalAlign": "bottom",
				"widthAdjust": -44,
				"y": 32,
				"margin": 15,
				"x": 0,
				"style": {
					"color": "#333333",
					"fontSize": "15px",
					"fill": "#333333",
					"width": "1078px"
				}
			},
			"plotOptions": {
				"series": {
					"dataLabels": {
						"enabled": false,
						"allowOverlap": false
					},
					"animation": false
				},
				"area": {
					"allowPointSelect": false,
					"getExtremesFromAll": false,
					"selected": false,
					"showCheckbox": false,
					"showInLegend": false,
					"dataLabels": {
						"align": "left",
						"y": -6
					},
					"tooltip": {
						"followPointer": true
					}
				}
			},
			"exporting": {
				"enabled": true,
				"fallbackToExportServer": true,
				"allowHTML": true
			},
			"navigation": {
				"buttonOptions": {
					"enabled": true,
					"verticalAlign": "top"
				}
			},
			"drilldown": {
				"allowPointDrilldown": true
			},
			"noData": {
				"position": {
					"align": "center",
					"verticalAlign": "middle"
				}
			}
		},
		creditsOptions = {
			credits: {
				"enabled": true,
				"text": "",
				"href": ""
			}
		},
		chart = null;
	injectTheme(function() {
		options = g_data;
		chart = new Highcharts.Chart('chart-rmcqf', Highcharts.extend(options, creditsOptions));
	});

})
