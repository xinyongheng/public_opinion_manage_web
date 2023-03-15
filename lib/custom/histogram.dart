import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/page/statistics_event_info_list_page.dart';
import 'package:public_opinion_manage_web/page/widget/empty_data.dart';

class TriangleWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool isTop;
  const TriangleWidget(
      {Key? key, required this.color, required this.size, required this.isTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrianglePainter(color, isTop),
      size: Size.square(size),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool isTop;
  _TrianglePainter(this.color, this.isTop);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
    var path = Path();
    // print(size.toString());
    if (isTop) {
      path
        ..moveTo(size.width / 2.0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2.0, size.height);
    }

    // canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height),
    //     paint..color = Colors.yellow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    // return oldDelegate.color != color;
    return false;
  }
}

class HistogramWidget extends StatefulWidget {
  final List<MapEntry>? list;
  const HistogramWidget(this.list, {Key? key}) : super(key: key);

  @override
  State<HistogramWidget> createState() => _HistogramWidgetState();
}

class _HistogramWidgetState extends State<HistogramWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list?.isNotEmpty != true) {
      return emptyWidget();
    }
    if (widget.list?.isNotEmpty == true) {
      widget.list!.sort(((a, b) {
        var aa = a.value['num'] as int;
        var bb = b.value['num'] as int;
        return bb.compareTo(aa);
      }));
    }
    double max = 631.w;
    double maxNum = 1000;
    final arr = <Widget>[];
    if (widget.list?.isNotEmpty == true) {
      maxNum = math.max(
          widget.list!.first.value['num'], widget.list!.last.value['num']);
      int count = 0;
      for (MapEntry element in widget.list!) {
        count++;
        String mediaType = element.key;
        var num = element.value['num'];
        Color color = count == 1
            ? const Color(0xFF0DDDB8)
            : (count == 2 ? const Color(0xFFD85766) : Colors.blue);
        arr.addAll(titleRow(
            num * max / maxNum, count, mediaType, num.toString(),
            color: color, dataTag: element.value));
      }
    } else {
      arr.add(Text('暂无数据', style: Config.loadDefaultTextStyle()));
      arr.add(SizedBox(height: 30.w));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: arr,
    );
  }

  List<Widget> titleRow(double width, int no, String title, String data,
      {Color color = Colors.blue, dynamic dataTag}) {
    final arr = <Widget>[];
    if (no < 3) {
      arr.add(TriangleWidget(color: color, size: 13.33.w, isTop: no == 1));
      arr.add(SizedBox(width: 11.w));
    } else {
      arr.add(SizedBox(width: 24.w));
    }

    return [
      SizedBox(
        // width: width,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...arr,
              Text('No.$no',
                  style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333))),
              SizedBox(width: 22.w),
              Text(title,
                  style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333))),
              const SizedBox(width: 20),
              Text(data,
                  style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333))),
              const Spacer(),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          _startEventInfoPage(title, dataTag['eventList']);
        },
        child: Container(
          width: width,
          height: 21.33.w,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFF0DDDB8), Color(0xFF3E7BFA)],
          )),
        ),
      ),
      SizedBox(height: 28.w),
    ];
  }

  void _startEventInfoPage(title, eventList) {
    // toast(title);
    Config.startPage(
        context,
        StatisticsEventInfoPage(
            title: title, list: PublicOpinionBean.fromJsonArray(eventList)));
  }
}
