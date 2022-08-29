import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/histogram.dart';
import 'package:public_opinion_manage_web/custom/triangle.dart' as hTriangle;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/page/statistics_event_info_list_page.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/date_util.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({Key? key}) : super(key: key);

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final colorArr = const [
    Color(0xFFFF9900),
    Color(0xFF89BFFF),
    Color(0xFF54E0FF),
    Color(0xFF67FFB6),
    Color(0xFF8692FF),
    Color(0xFFFF3300),
    Color.fromARGB(255, 57, 57, 160),
    Color(0xFF007B92),
  ];
  Map<String, List<OrdinalSales>>? _unitMediaTypeClassifyStatisticsMap;
  List<charts.TickSpec<double>>? tickSpec;

  Map<String, List<OrdinalSales>>? _unitSumStatistics;

  List<MapEntry>? _mediaTypeSumStatisticsList;

  List<MapEntry>? _typeClassifyStatisticsList;
  @override
  void initState() {
    super.initState();
    final dateTime = DateTime.now();
    String start =
        formatDate(DateTime(dateTime.year, dateTime.month), DateUtil.formats);
    String end = DateUtil.nowDate();
    startDateController.text = start;
    endDateController.text = end;
    requestData(start, end);
  }

  void requestData(String start, String end) async {
    final map = await UserUtil.makeUserIdMap();
    map['start'] = start;
    map['end'] = end;
    ServiceHttp().post("/loadStatistics", data: map, success: (data) {
      // print(jsonEncode(data));
      makeOrdinalSalesData(data['unitMediaTypeClassifyStatistics']);
      makeUnitSumStatisticsData(data['unitSumStatistics']);
      makeMediaTypeSumStatisticsData(data['mediaTypeSumStatistics']);
      makeTypeClassifyStatisticsData(data['typeClassifyStatistics']);
    });
  }

  //各单位舆情分类
  void makeOrdinalSalesData(Map? unitMediaTypeClassifyStatistics) {
    //  <charts.TickSpec<double>>[
    //   const charts.TickSpec(0,)]
    if (null == unitMediaTypeClassifyStatistics) return;
    final unitArr = [];
    final ordinalSalesMap = <String, List<OrdinalSales>>{};
    int count = -1;
    unitMediaTypeClassifyStatistics.forEach((unit, value) {
      unitArr.add(unit);
      ++count;
      value.forEach((mediaType, data) {
        int num = data['num']!;
        data['mediaType'] = mediaType;
        data['unit'] = unit;
        if (ordinalSalesMap[mediaType] == null) {
          ordinalSalesMap[mediaType] = <OrdinalSales>[
            OrdinalSales(num, count, data: data)
          ];
        } else {
          ordinalSalesMap[mediaType]!.add(OrdinalSales(num, count, data: data));
        }
      });
    });
    final xArray = <charts.TickSpec<double>>[];
    for (int i = 0; i < unitArr.length; i++) {
      var unit = unitArr[i];
      xArray.add(charts.TickSpec(
        i.toDouble(),
        label: unit,
        style: _textStyleSpec(),
      ));
    }
    setState(() {
      tickSpec = xArray;
      _unitMediaTypeClassifyStatisticsMap = ordinalSalesMap;
    });
  }

  void makeUnitSumStatisticsData(Map? unitSumStatistics) {
    if (null == unitSumStatistics) return;
    final ordinalSalesMap = <String, List<OrdinalSales>>{};
    int count = -1;
    unitSumStatistics.forEach((key, value) {
      count++;
      int num = value['num'];
      if (ordinalSalesMap[key] == null) {
        ordinalSalesMap[key] = <OrdinalSales>[
          OrdinalSales(num, count, data: value)
        ];
      } else {
        ordinalSalesMap[key]!.add(OrdinalSales(num, count, data: value));
      }
    });
    setState(() {
      _unitSumStatistics = ordinalSalesMap;
    });
  }

  void makeMediaTypeSumStatisticsData(Map? mediaTypeSumStatistics) {
    if (null == mediaTypeSumStatistics) return;
    final list = mediaTypeSumStatistics.entries.toList();
    list.sort((a, b) {
      return a.value['num'] - b.value['num'];
    });
    setState(() {
      _mediaTypeSumStatisticsList = list;
    });
  }

  void makeTypeClassifyStatisticsData(Map? typeClassifyStatistics) {
    if (null == typeClassifyStatistics) return;
    final list = typeClassifyStatistics.entries.toList();
    list.sort((a, b) {
      return a.value['num'] - b.value['num'];
    });
    setState(() {
      _typeClassifyStatisticsList = list;
    });
  }

  charts.TextStyleSpec _textStyleSpec() {
    return const charts.TextStyleSpec(
      color: charts.Color(r: 51, g: 51, b: 51, a: 153),
    );
  }

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
        padding: EdgeInsets.only(left: 43.w, right: 43.w, top: 30.w),
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
                Expanded(child: unitOpinionTypeView()),
                Expanded(child: unitOpinionView())
              ],
            ),
            SizedBox(height: 56.w),
            Row(
              children: [
                Expanded(
                    child: opinionTypeCountView(
                        '舆情分类统计', _mediaTypeSumStatisticsList)),
                Expanded(
                    child: opinionTypeCountView(
                        '舆情类别统计', _typeClassifyStatisticsList))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget opinionTypeCountView(data, List<MapEntry>? list) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(data),
        SizedBox(height: 28.w),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: HistogramWidget(list),
        ),
      ],
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
        hTriangle.TriangleWidget(
            color: const Color(0xFF0DDDBB), width: 7.w, height: 12.w),
        SizedBox(width: 6.w),
        Text(data,
            style: Config.loadDefaultTextStyle(
                fonstSize: 21.w, fontWeight: FontWeight.w500)),
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
          child: Config.dateInputView(
            '年/月/日',
            startDateController,
            type: DateTimePickerType.date,
            initialDate: DateTime(2022, DateTime.now().month),
            suffixIcon: Image.asset("images/op_save.png", color: Colors.grey),
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
          child: Config.dateInputView(
            '年/月/日',
            endDateController,
            initialDate: DateTime.now(),
            type: DateTimePickerType.date,
            suffixIcon: Image.asset("images/op_save.png", color: Colors.grey),
          ),
        ),
        SizedBox(width: 30.w),
        TextButton(
            onPressed: () {
              requestData(startDateController.text, endDateController.text);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.only(
                left: 20.w,
                top: 15.sp,
                right: 20.w,
                bottom: 15.sp,
              ),
              textStyle: Config.loadDefaultTextStyle(),
            ),
            child: const Text('筛选'))
      ],
    );
  }

  Widget lineChartForUnitOpinion(map, String tag) {
    // GestureDetector
    final list = fillList(map);
    return charts.LineChart(
      list,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        // 圆点大小
        radiusPx: 5.w,
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
            _showListDialog(list, tag);
          },
        ),
      ],
      domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: DataUtil.isEmpty(tickSpec)
              ? null
              : charts.StaticNumericTickProviderSpec(tickSpec!),
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
              (measure) => exp(measure ?? 0).toString())),
    );
  }

  List<charts.Series<OrdinalSales, num>> fillList(
      Map<String, List<OrdinalSales>>? dataMap) {
    final list = <charts.Series<OrdinalSales, num>>[];
    if (dataMap?.isNotEmpty == true) {
      int count = 0;
      dataMap!.forEach((String mediaPlay, List<OrdinalSales> childList) {
        list.add(charts.Series<OrdinalSales, int>(
          id: mediaPlay,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(colorArr[count]),
          domainFn: (OrdinalSales sales, _) => sales.index,
          measureFn: (OrdinalSales sales, _) => sales.y,
          // dashPatternFn: (datum, index) => [8, 2, 4, 2],
          data: childList,
        ));
        count++;
      });
    }
    return list;
  }

  final random = Random();

  Widget unitOpinionTypeView() {
    final arr = <Widget>[SizedBox(width: 28.w)];
    if (_unitMediaTypeClassifyStatisticsMap?.isNotEmpty == true) {
      int count = 0;
      for (var e in _unitMediaTypeClassifyStatisticsMap!.keys) {
        arr.addAll(unitOpinionViewItem(colorArr[count], e));
        arr.add(SizedBox(width: 28.w));
        count++;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('各单位舆情分类'),
        SizedBox(height: 27.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: arr,
        ),
        SizedBox(
          width: 631.w,
          height: 400.w,
          child: lineChartForUnitOpinion(
              _unitMediaTypeClassifyStatisticsMap, '各单位舆情分类'),
        ),
      ],
    );
  }

  Widget unitOpinionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('各单位舆情总数'),
        Text('空格',
            style: Config.loadDefaultTextStyle(
              color: Colors.transparent,
              fonstSize: 16.w,
            )),
        SizedBox(height: 27.w),
        SizedBox(
          width: 631.w,
          height: 400.w,
          child: lineChartForUnitOpinion(_unitSumStatistics, '各单位舆情总数'),
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

  void _showListDialog(List<OrdinalSales> list, String tag) {
    // final unit = list.first.x;
    final arr = <Widget>[];
    var unit = list.first.data['unit'];
    if (tag == '各单位舆情总数') {
      arr.add(listSingleUnitDialogItem(list.first, 0));
    } else {
      arr.add(Text(unit, style: dialogTextStyle()));
      for (int i = 0; i < list.length; i++) {
        OrdinalSales element = list[i];
        arr.add(SizedBox(height: 10.w));
        arr.add(listDialogItem(element, i));
      }
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

  Widget listSingleUnitDialogItem(OrdinalSales bean, int index) {
    return InkWell(
      onTap: () {
        _startEventInfoPage(bean.data['unit'], bean.data['eventList']);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 13.w),
          Text(bean.data['unit'], style: dialogTextStyle()),
          const Spacer(),
          Text(bean.y.toString(), style: dialogTextStyle()),
        ],
      ),
    );
  }

  Widget listDialogItem(OrdinalSales bean, int index) {
    return InkWell(
      onTap: () {
        _startEventInfoPage(bean.data['unit'] + " · " + bean.data['mediaType'],
            bean.data['eventList']);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 13.w, height: 13.w, color: colorArr[index]),
          SizedBox(width: 13.w),
          Text(bean.data['mediaType'], style: dialogTextStyle()),
          const Spacer(),
          Text(bean.y.toString(), style: dialogTextStyle())
        ],
      ),
    );
  }

  Color randomColor() {
    return Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  }

  void _startEventInfoPage(title, eventList) {
    // toast(title);
    Config.startPage(
        context,
        StatisticsEventInfoPage(
            title: title, list: PublicOpinionBean.fromJsonArray(eventList)));
  }
}

class OrdinalSales {
  final dynamic data;
  final int y;
  final int index;

  OrdinalSales(this.y, this.index, {this.data});

  @override
  String toString() {
    return 'OrdinalSales{x: $data, y: $y, index: $index}';
  }
}
