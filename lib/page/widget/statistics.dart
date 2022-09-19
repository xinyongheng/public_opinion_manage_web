import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/histogram.dart';
import 'package:public_opinion_manage_web/custom/line_chart_view.dart';
import 'package:public_opinion_manage_web/custom/triangle.dart' as hTriangle;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:public_opinion_manage_web/data/bean/line_data.dart';
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
  // Map<String, List<OrdinalSales>>? _unitMediaTypeClassifyStatisticsMap;
  List<LinePoint>? _unitMediaTypeClassifyStatisticsList;
  // List<charts.TickSpec<double>>? tickSpec;
  List<String>? xAxisInfos;

  // Map<String, List<OrdinalSales>>? _unitSumStatistics;
  List<LinePoint>? _unitSumStatisticsList;

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
      if (data is List) {
        setState(() {
          _unitMediaTypeClassifyStatisticsList = null;
          xAxisInfos = null;
          _unitSumStatisticsList = null;
          _mediaTypeSumStatisticsList = null;
          _typeClassifyStatisticsList = null;
        });
        return;
      }
      makeOrdinalSalesData(data['unitMediaTypeClassifyStatistics']);
      makeUnitSumStatisticsData(data['unitSumStatistics']);
      makeMediaTypeSumStatisticsData(data['mediaTypeSumStatistics']);
      makeTypeClassifyStatisticsData(data['typeClassifyStatistics']);
    });
  }

  //各单位舆情分类
  void makeOrdinalSalesData(Map? unitMediaTypeClassifyStatistics) {
    if (unitMediaTypeClassifyStatistics?.isNotEmpty != true) return;
    xAxisInfos = [];
    var listAll = <LinePoint>[];
    final mediaTypeMap = <String, List<PointInfo>>{};

    //构建所需list
    unitMediaTypeClassifyStatistics!.forEach((unit, value) {
      xAxisInfos!.add(unit);
      int count = 0;
      value.forEach((mediaType, data) {
        ++count;
        int num = data['num']!;
        data['mediaType'] = mediaType;
        data['unit'] = unit;
        if (mediaTypeMap[mediaType] == null) {
          mediaTypeMap[mediaType] = [
            PointInfo.make(Point(count.toDouble(), num.toDouble(), data: data))
          ];
        } else {
          List<PointInfo> list = mediaTypeMap[mediaType]!;
          list.add(PointInfo.make(
              Point(count.toDouble(), num.toDouble(), data: data)));
        }
      });
    });
    int xCount = 0;
    mediaTypeMap.forEach((key, value) {
      listAll.add(LinePoint(key, value, _loadColor(xCount)));
      xCount++;
    });
    setState(() {
      _unitMediaTypeClassifyStatisticsList = listAll;
    });
  }

  Color _loadColor(int index) {
    if (index < colorArr.length) {
      return colorArr[index];
    }
    return Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  }

  void makeUnitSumStatisticsData(Map? unitSumStatistics) {
    if (null == unitSumStatistics) return;

    int count = -1;
    var listInfo = <PointInfo>[];
    unitSumStatistics.forEach((key, value) {
      count++;
      int num = value['num'];
      listInfo.add(
          PointInfo.make(Point(count.toDouble(), num.toDouble(), data: value)));
    });
    var allList = <LinePoint>[];
    allList.add(LinePoint('', listInfo, const Color(0xFF268AFF)));
    setState(() {
      _unitSumStatisticsList = allList;
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
    if (null == typeClassifyStatistics) {
      setState(() {});
      return;
    }
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
                Expanded(child: unitOpinionTypeView(context)),
                Expanded(child: unitOpinionView(context))
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

  Widget lineChartForUnitOpinion(linePoints, String tag, context) {
    return LineChartWidget(
      size: Size(631.w, 400.w),
      linePoints: linePoints ?? [],
      xAxisInfos: xAxisInfos ?? [],
      showPopupMenu: tag != '各单位舆情总数',
      tooltipValueGetter: (m) {
        //_loadAxisInfoForX(index)}-$tag:${point.y
        if (tag == '各单位舆情总数') {
          return m[0] + ':' + m[2].toString();
        } else {
          return m[0] + "-" + m[1] + ": " + m[2].toString();
        }
      },
      itemClick: (value) {
        _startEventInfoPage(context, value['unit'], value['eventList']);
      },
    );
  }

  Widget unitOpinionTypeView(context) {
    final arr = <Widget>[SizedBox(width: 28.w)];
    if (_unitMediaTypeClassifyStatisticsList?.isNotEmpty == true) {
      for (var e in _unitMediaTypeClassifyStatisticsList!) {
        arr.addAll(unitOpinionViewItem(e.background, e.tag));
        arr.add(SizedBox(width: 28.w));
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
        SizedBox(height: 27.w),
        SizedBox(
          width: 631.w,
          height: 400.w,
          child: lineChartForUnitOpinion(
              _unitMediaTypeClassifyStatisticsList, '各单位舆情分类', context),
        ),
      ],
    );
  }

  Widget unitOpinionView(context) {
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
          child: lineChartForUnitOpinion(
              _unitSumStatisticsList, '各单位舆情总数', context),
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

  void _startEventInfoPage(context, title, eventList) {
    toast(title);
    var list = PublicOpinionBean.fromJsonArray(eventList);
    // Config.finishPage(context);
    Config.startPage(
        context, StatisticsEventInfoPage(title: title, list: list));
  }
}
