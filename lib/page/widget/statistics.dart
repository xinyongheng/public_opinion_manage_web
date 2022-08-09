import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
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
            )
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
            color: const Color(0xFF0DDDBB), width: 12.w, height: 7.w),
        SizedBox(width: 6.w),
        Text(data, style: Config.loadDefaultTextStyle(fonstSize: 21.sp)),
      ],
    );
  }

  Widget lineChartForUnitOpinion() {
    final list = [];
    return charts.LineChart(
      list,
      animate: true,
    );
  }
}
