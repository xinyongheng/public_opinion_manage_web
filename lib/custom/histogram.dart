import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

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
    print(size.toString());
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
  const HistogramWidget({Key? key}) : super(key: key);

  @override
  State<HistogramWidget> createState() => _HistogramWidgetState();
}

class _HistogramWidgetState extends State<HistogramWidget> {
  @override
  Widget build(BuildContext context) {
    double max = 631.w;
    double maxNum = 1000;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...titleRow(820 * max / maxNum, 1, '抖音1', '820',
              color: const Color(0xFF0DDDB8)),
          ...titleRow(785 * max / maxNum, 2, '快手2', '785',
              color: const Color(0xFFD85766)),
          ...titleRow(780 * max / maxNum, 3, '抖音3', '780'),
          ...titleRow(700 * max / maxNum, 4, '抖音4', '700'),
          ...titleRow(650 * max / maxNum, 5, '抖音5', '650'),
          ...titleRow(630 * max / maxNum, 5, '抖音5', '650'),
          ...titleRow(610 * max / maxNum, 5, '抖音5', '650'),
          ...titleRow(600 * max / maxNum, 5, '抖音5', '650'),
        ],
      ),
    );
  }

  List<Widget> titleRow(double width, int no, String title, String data,
      {Color color = Colors.blue}) {
    final arr = <Widget>[];
    if (no < 3) {
      arr.add(TriangleWidget(color: color, size: 13.33.w, isTop: no == 1));
      arr.add(SizedBox(width: 11.w));
    } else {
      arr.add(SizedBox(width: 24.w));
    }

    return [
      SizedBox(
        width: width,
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
              const Spacer(),
              Text(data,
                  style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333))),
            ],
          ),
        ),
      ),
      Container(
        width: width,
        height: 21.33.w,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xFF0DDDB8), Color(0xFF3E7BFA)],
        )),
      ),
      SizedBox(height: 28.w),
    ];
  }
}
