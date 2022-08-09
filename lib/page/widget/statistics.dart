import 'dart:html';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/triangle.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({Key? key}) : super(key: key);

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 43.w, right: 43.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '舆情统计',
              style: Config.loadDefaultTextStyle(fonstSize: 27.sp),
            ),
            unitOpinionView(),
          ],
        ),
      ),
    );
  }

  Widget lineView() =>
      Container(width: 4.w, height: 31.w, color: const Color(0xFF3E7BFA));

  Widget titleView(data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        lineView(),
        SizedBox(width: 4.w),
        TriangleWidget(
            color: const Color(0xFF0DDDBB), width: 7.w, height: 12.w),
        SizedBox(width: 6.w),
        Text(data, style: Config.loadDefaultTextStyle(fonstSize: 21.sp)),
      ],
    );
  }

  Widget lineChartForUnitOpinion() {
    final list = <charts.Series<OrdinalSales, num>>[];
    fillList(list);
    return charts.LineChart(
      list,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        // 圆点大小
        radiusPx: 8.w,
        stacked: false,
        // 线的宽度
        strokeWidthPx: 1.0,
        // 是否显示线
        includeLine: true,
        // 是否显示圆点
        includePoints: true,
        // 是否显示包含区域
        includeArea: true,
        // 区域颜色透明度 0.0-1.0
        areaOpacity: 0.2,
      ),
    );
  }

  void fillList(list) {
    var random = Random();
    final data = [
      OrdinalSales('县公安局', 13, 0),
      OrdinalSales('县公安局', 13, 1),
      OrdinalSales('县卫健委', 24, 2),
      OrdinalSales('县民政局', 12, 3),
      OrdinalSales('县住建局1', 12, 4),
      OrdinalSales('县住建局2', random.nextInt(100), 5),
      OrdinalSales('县住建局3', random.nextInt(100), 6),
      OrdinalSales('县住建局4', random.nextInt(100), 7),
      OrdinalSales('县住建局5', random.nextInt(100), 8),
    ];
    final data2 = [
      OrdinalSales('县公安局', random.nextInt(100), 0),
      OrdinalSales('县公安局', random.nextInt(100), 1),
      OrdinalSales('县卫健委', random.nextInt(100), 2),
      OrdinalSales('县民政局', random.nextInt(100), 3),
      OrdinalSales('县住建局1', random.nextInt(100), 4),
      OrdinalSales('县住建局2', random.nextInt(100), 5),
      OrdinalSales('县住建局3', random.nextInt(100), 6),
      OrdinalSales('县住建局4', random.nextInt(100), 7),
      OrdinalSales('县住建局5', random.nextInt(100), 8),
    ];
    final data3 = [
      OrdinalSales('县公安局', random.nextInt(100), 0),
      OrdinalSales('县公安局', random.nextInt(100), 1),
      OrdinalSales('县卫健委', random.nextInt(100), 2),
      OrdinalSales('县民政局', random.nextInt(100), 3),
      OrdinalSales('县住建局1', random.nextInt(100), 4),
      OrdinalSales('县住建局2', random.nextInt(100), 5),
      OrdinalSales('县住建局3', random.nextInt(100), 6),
      OrdinalSales('县住建局4', random.nextInt(100), 7),
      OrdinalSales('县住建局5', random.nextInt(100), 8),
    ];

    list.add(charts.Series<OrdinalSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFE41E31)),
      domainFn: (OrdinalSales sales, _) => sales.index,
      measureFn: (OrdinalSales sales, _) => sales.y,
      // labelAccessorFn: (sales, index) => sales.x,
      // keyFn: (OrdinalSales sales, _) => sales.x,
      // domainFormatterFn: (OrdinalSales sales, index) {
      //   return (v) => '$v';
      // },
      measureFormatterFn: (sales, index) {
        return (measure) => "${sales.y}拉拉";
      },
      // dashPatternFn: (datum, index) => [8, 2, 4, 2],
      data: data,
    ));
    /*  list.addAll([
      charts.Series<OrdinalSales, int>(
        id: 'User',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF13A331)),
        domainFn: (OrdinalSales sales, _) => sales.index,
        measureFn: (OrdinalSales sales, _) => sales.y,
        // dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data2,
      ),
      charts.Series<OrdinalSales, int>(
        id: 'Dart',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF6300A1)),
        domainFn: (OrdinalSales sales, _) => sales.index,
        measureFn: (OrdinalSales sales, _) => sales.y,
        // dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data3,
      ),
    ]); */
  }

  final random = Random();
  Widget unitOpinionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('各单位舆情分类'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...unitOpinionViewItem(const Color(0xFFFF9900), '抖音'),
            SizedBox(width: 28.w),
            ...unitOpinionViewItem(const Color(0xFF89BFFF), '快手'),
            SizedBox(width: 28.w),
            ...unitOpinionViewItem(const Color(0xFF54E0FF), '天涯论坛'),
            SizedBox(width: 28.w),
            ...unitOpinionViewItem(const Color(0xFF67FFB6), '西瓜视频'),
            SizedBox(width: 28.w),
          ],
        ),
        SizedBox(
          width: 631.w,
          height: 359.w,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(1, 1),
                    FlSpot(3, 1.5),
                    FlSpot(5, 1.4),
                    FlSpot(7, 3.4),
                    FlSpot(9, 2),
                    FlSpot(11, 2.2),
                    FlSpot(13, 1.8),
                  ],
                  color: const Color(0xFFFF9900),
                ),
                LineChartBarData(
                  spots: [
                    FlSpot(1, 2),
                    FlSpot(3, 3.5),
                    FlSpot(5, 4.4),
                    FlSpot(7, 5.4),
                    FlSpot(9, 6),
                    FlSpot(11, 7.2),
                    FlSpot(13, 17.8),
                  ],
                  color: const Color(0xFF89BFFF),
                ),
                LineChartBarData(
                  spots: [
                    FlSpot(1, random.nextInt(10) * 1.0),
                    FlSpot(3, random.nextInt(10) * 1.0),
                    FlSpot(5, random.nextInt(10) * 1.0),
                    FlSpot(7, random.nextInt(10) * 1.0),
                    FlSpot(9, random.nextInt(10) * 1.0),
                    FlSpot(11, random.nextInt(10) * 1.0),
                    FlSpot(13, random.nextInt(10) * 1.0),
                  ],
                  color: const Color(0xFF54E0FF),
                ),
                LineChartBarData(
                  spots: [
                    FlSpot(1, random.nextInt(10) * 1.0),
                    FlSpot(3, random.nextInt(10) * 1.0),
                    FlSpot(5, random.nextInt(10) * 1.0),
                    FlSpot(7, random.nextInt(10) * 1.0),
                    FlSpot(9, random.nextInt(10) * 1.0),
                    FlSpot(11, random.nextInt(10) * 1.0),
                    FlSpot(13, random.nextInt(10) * 1.0),
                  ],
                  color: const Color(0xFF67FFB6),
                ),
                // TouchLineBarSpot(bar, barIndex, spot, distance)
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchCallback: (p0, p1) {
                  //toast('$p0$p1');
                },
                touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 179.w,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: touchedSpot.bar.gradient?.colors.first ??
                            touchedSpot.bar.color ??
                            Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      touchedSpot.x;
                      return LineTooltipItem(
                        "", //touchedSpot.y.toString() + "月",
                        textStyle,
                        textAlign: TextAlign.left,
                        children: [
                          TextSpan(
                            text: 'aa',
                            style: TextStyle(
                                color: Colors.transparent,
                                backgroundColor:
                                    touchedSpot.bar.gradient?.colors.first ??
                                        touchedSpot.bar.color ??
                                        Colors.blueGrey),
                          ),
                          TextSpan(
                              text: 'aa',
                              style: TextStyle(color: Colors.transparent)),
                          TextSpan(
                              text: '西瓜视频',
                              recognizer: LongPressGestureRecognizer()
                                ..onLongPress = () {
                                  toast('点击');
                                }),
                          TextSpan(
                              text: 'aaaa',
                              style: TextStyle(color: Colors.transparent)),
                          TextSpan(text: touchedSpot.y.toString()),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: null,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 44,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(meta.formattedValue + "单位");
                    },
                  ),
                ),
              ),
              backgroundColor: const Color(0xFFFF9900).withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> unitOpinionViewItem(Color color, String data) {
    return [
      Container(
        width: 13.w,
        height: 13.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1.w),
        ),
      ),
      SizedBox(width: 9.w),
      Text(data,
          style: Config.loadDefaultTextStyle(
            color: const Color(0xFF333333),
            fonstSize: 16.w,
          )),
    ];
  }
}

class OrdinalSales {
  final String x;
  final int y;
  final int index;

  OrdinalSales(this.x, this.y, this.index);
}
