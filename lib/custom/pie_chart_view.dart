import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          /* style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ), */
          style: Config.loadDefaultTextStyle(
            color: textColor,
            fonstSize: 16.w,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class MyPieChartWidget extends StatefulWidget {
  const MyPieChartWidget(
      {super.key, required this.list, required this.clickValue})
      : assert(list.length == 2);
  final List<dynamic> list;

  final ValueChanged<dynamic> clickValue;
  @override
  State<MyPieChartWidget> createState() => _MyPieChartWidgetState();
}

class _MyPieChartWidgetState extends State<MyPieChartWidget> {
  final List<Color> defaultColorList = const [
    Color(0xFF74b9ff),
    Color(0xFFff7675),
    Color(0xFF55efc4),
    Color(0xFFffeaa7),
    Color(0xFFa29bfe),
    Color(0xFFfd79a8),
    Color(0xFFe17055),
    Color(0xFF00b894),
  ];
  final gradientList = const <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final dataList = widget.list;
    final double noReport = dataList[0]['size'] * 1.0;
    final double hadReport = dataList[1]['size'] * 1.0;
    return AspectRatio(
      aspectRatio: 41 / 40,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Indicator(
                color: const Color(0xff0293ee),
                text: '上级未通报:${widget.list[0]['size']}',
                isSquare: false,
                size: touchedIndex == 0 ? 18 : 16,
                textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
              ),
              Indicator(
                color: const Color(0xfff8b250),
                text: '上级通报:${widget.list[1]['size']}',
                isSquare: false,
                size: touchedIndex == 1 ? 18 : 16,
                textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
              ),
            ],
          ),
          SizedBox(
            height: 16.w,
          ),
          Expanded(
            child: noReport < 1 && hadReport < 1
                ? Center(
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Config.borderColor,
                        borderRadius: BorderRadius.circular(200.w),
                      ),
                      child: Text('暂无数据'),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              if (event is FlTapDownEvent) {
                                print('touchCallback11');
                                // 点击
                                widget.clickValue.call(widget.list[
                                    pieTouchResponse
                                        .touchedSection!.touchedSectionIndex]);
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        startDegreeOffset: 180,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        sections: showingSections(noReport, hadReport),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(noReport, hadReport) {
    print('noReport=$noReport hadReport=$hadReport');

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25.w : 16.w;
      final double radius = isTouched ? 190.w : 180.w;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: noReport,
            title: '上级未通报',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: hadReport,
            title: '上级通报',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
      }
    });
  }
}
