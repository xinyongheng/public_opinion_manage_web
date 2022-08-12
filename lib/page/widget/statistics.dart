import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 43.w, right: 43.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '舆情统计',
              style: Config.loadDefaultTextStyle(
                  fonstSize: 26.w, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 36.w),
            dateSelectView(),
            SizedBox(height: 36.w),
            Row(
              children: [
                unitOpinionTypeView(),
                const Spacer(),
                unitOpinionView(),
              ],
            ),
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
        Text(data,
            style: Config.loadDefaultTextStyle(
                fonstSize: 21.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget dateSelectView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '时间：',
          style: Config.loadDefaultTextStyle(
            color: Colors.black.withOpacity(0.85),
            fonstSize: 16.w,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 213.w,
          child: TextField(
            controller: startDateController,
            decoration: Config.defaultInputDecoration(
              hintText: '年/月/日',
              suffixIcon: Image.asset("images/op_save.png", color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            "至",
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fonstSize: 16.w,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 213.w,
          child: TextField(
            controller: endDateController,
            decoration: Config.defaultInputDecoration(
              hintText: '年/月/日',
              suffixIcon: Image.asset("images/op_save.png", color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget lineChartForUnitOpinion() {
    // GestureDetector
    final list = <charts.Series<OrdinalSales, num>>[];
    fillList(list);
    return charts.LineChart(
      list,
      animate: true,
      behaviors: [
        // eventTrigger
        // ChartBehavior<num>()
      ],
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
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel<num> value) {
            /*int index = value.selectedDatum.first.index!;
            final clickSeries = value.selectedSeries.first;
            final tag = clickSeries.id;
            toast("$tag ,第$index个");
            final clickBean = value.selectedDatum.firstWhere((element) {
              return element.series.id == tag;
            });
            toast(clickBean.toString());*/
            //throw Error('故意的');
            final list = <OrdinalSales>[];
            // value.selectedDatum[4];
            for (var element in value.selectedDatum) {
              list.add(element.datum);
            }
            _showListDialog(list);
          },
        ),
      ],
      domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.StaticNumericTickProviderSpec(tickSpec()),
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
              (measure) => exp(measure ?? 0).toString())),
    );
  }

  List<charts.TickSpec<num>> tickSpec() {
    final ticks = <charts.TickSpec<double>>[
      const charts.TickSpec(0,
          label: '公安局',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xFF, b: 0x50))),
      const charts.TickSpec(1,
          label: '卫健委',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      const charts.TickSpec(2,
          label: '1.3',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      const charts.TickSpec(3,
          label: '1.4',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      const charts.TickSpec(4,
          label: '1.5',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      const charts.TickSpec(5,
          label: '1.6',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      const charts.TickSpec(6,
          label: '1.7',
          style: charts.TextStyleSpec(
              //可对x轴设置颜色等
              color: charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
    ];
    return ticks;
  }

  void fillList(list) {
    var random = Random();
    final data = [
      OrdinalSales('县公安局1', 13, 0),
      OrdinalSales('县公安局2', 13, 1),
      OrdinalSales('县卫健委3', 24, 2),
      OrdinalSales('县民政局4', 12, 3),
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
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(const Color(0xFFE41E31)),
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
    list.addAll([
      charts.Series<OrdinalSales, int>(
        id: 'User',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(const Color(0xFF13A331)),
        domainFn: (OrdinalSales sales, _) => sales.index,
        measureFn: (OrdinalSales sales, _) => sales.y,
        // dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data2,
      ),
      charts.Series<OrdinalSales, int>(
        id: 'Dart',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(const Color(0xFF6300A1)),
        domainFn: (OrdinalSales sales, _) => sales.index,
        measureFn: (OrdinalSales sales, _) => sales.y,
        // dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data3,
      ),
    ]);
  }

  final random = Random();

  Widget unitOpinionTypeView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('各单位舆情分类'),
        SizedBox(height: 27.w),
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
          child: lineChartForUnitOpinion(),
        ),
      ],
    );
  }
  Widget unitOpinionView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('各单位舆情总数'),
        SizedBox(height: 27.w),
        SizedBox(
          width: 631.w,
          height: 359.w,
          child: lineChartForUnitOpinion(),
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

  void _showListDialog(List<OrdinalSales> list) {
    // final unit = list.first.x;
    final arr = <Widget>[];
    arr.add(Text('标题***', style: dialogTextStyle()));
    for (OrdinalSales element in list) {
      arr.add(SizedBox(height: 10.w));
      arr.add(listDialogItem(element));
    }
    for (OrdinalSales element in list) {
      arr.add(SizedBox(height: 10.w));
      arr.add(listDialogItem(element));
    }
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: arr,
    );

    //179,220,5 #4B4F52
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF4B4F52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.sp)),
          content: SizedBox(
            width: 179.w,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: child,
            ),
          ),
        );
      },
      barrierColor: Colors.transparent,
    );
  }

  TextStyle dialogTextStyle() {
    return Config.loadDefaultTextStyle(
        color: Colors.white, fonstSize: 16.w, fontWeight: FontWeight.w400);
  }

  Row listDialogItem(OrdinalSales bean) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 13.w, height: 13.w, color: randomColor()),
        SizedBox(width: 13.w),
        Text(bean.x, style: dialogTextStyle()),
        const Spacer(),
        Text(bean.y.toString(), style: dialogTextStyle())
      ],
    );
  }

  Color randomColor() {
    return Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  }
}

class OrdinalSales {
  final String x;
  final int y;
  final int index;

  OrdinalSales(this.x, this.y, this.index);

  @override
  String toString() {
    return 'OrdinalSales{x: $x, y: $y, index: $index}';
  }
}
