// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:math' as math show max, pow;

import 'package:flutter/material.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/line_data.dart';
import 'dart:ui' as ui show Gradient;
import 'circle_point.dart' show CirclePointRenderWidget;
import 'line_view.dart';

class AxisInfo {
  Offset offset;
  String explain;
  AxisInfo(this.explain, this.offset);
  @override
  String toString() {
    return explain;
  }
}

class LayoutInfo {
  Offset offset;
  Object childId;
  LayoutInfo(this.childId, this.offset);
}

typedef LineVauleGetter<T, M> = T Function(M? m);

class LineChartWidget extends StatefulWidget {
  final Size size;
  final List<LinePoint> linePoints;
  final List<String> xAxisInfos;
  final LineVauleGetter<String, dynamic>? tooltipValueGetter;
  final LineVauleGetter<List<PopupMenuEntry>, Map<String, Point>>?
      popupMenuGetter;
  final ValueChanged? itemClick;
  final bool showPopupMenu;
  const LineChartWidget({
    Key? key,
    required this.size,
    required this.linePoints,
    required this.xAxisInfos,
    this.tooltipValueGetter,
    this.popupMenuGetter,
    this.itemClick,
    this.showPopupMenu = true,
  }) : super(key: key);

  @override
  State<LineChartWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  List<LayoutInfo>? listLayoutInfo;
  late LineMultiChildLayoutDelegate _delegate;
  late List<AxisInfo> xListAxisInfo;
  // List<AxisInfo>? yListAxisInfo;
  @override
  Widget build(BuildContext context) {
    var children = makePointOffsetViews(widget.linePoints, widget.size);
    _delegate = LineMultiChildLayoutDelegate(listLayoutInfo!);
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: CustomMultiChildLayout(
        delegate: _delegate,
        children: children,
      ),
    );
  }

  /// 计算单位距离
  static List<int> loadMaxValue(List<LinePoint> list) {
    int maxLength = 0;
    double maxValue = 0;
    for (var linePoint in list) {
      int length = linePoint.list.length;
      if (length > maxLength) {
        maxLength = length;
      }
      for (var pointInfo in linePoint.list) {
        if (pointInfo.point.y > maxValue) {
          maxValue = pointInfo.point.y;
        }
      }
    }
    // print("maxValue=${maxValue} ${maxValue.ceil()} ${maxValue.ceilToDouble()}");
    return [maxLength, calculationMaxInt(maxValue)];
  }

  /// 5, 10的倍数
  static int calculationMaxInt(double value) {
    int intValue = value.ceil();
    if (intValue <= 10) return intValue;
    if (value <= 50) return value ~/ 5 * 5 + 5;
    if (intValue % 10 == 0) {
      return intValue;
    }
    return intValue ~/ 10 * 10 + 10;
  }

  static int ySpiltCount(int max) {
    if (max <= 10) return max;
    if (max <= 50) return max ~/ 5;
    int _max = max ~/ 10;
    return _Less10(_max);
  }

  static int _Less10(int count) {
    if (count <= 10) {
      return count;
    } else {
      return _Less10(count ~/ 2);
    }
  }

  static List<int> calculationYSize(int max) {
    int ySizeTem = ySpiltCount(max);
    int yEverySizeTem = max ~/ ySizeTem;
    int count = yEverySizeTem.toString().length;
    int divisor = math.pow(10, count - 1) as int;
    int yEverySize = (yEverySizeTem / divisor).round() * divisor;
    int ySize = (max / yEverySize).ceil();
    int newMax = ySize * yEverySize;
    return [newMax, ySize, yEverySize];
  }

  String _loadAxisInfoForX(int index) {
    if (index < widget.xAxisInfos.length) {
      return widget.xAxisInfos[index];
    }
    return (index + 1).toString();
  }

  /// 计算坐标  [size] 绘制折线图区域
  List<LayoutId> makePointOffsetViews(List<LinePoint> linePoints, Size size) {
    double width = size.width;
    double height = size.height;
    List<int> result = loadMaxValue(linePoints);
    // print("result=${result}");
    int maxLength = result[0] == 0 ? 6 : result[0];
    int maxLengthX = math.max(widget.xAxisInfos.length, 1);
    List calculationArr = calculationYSize(result[1] == 0 ? 10 : result[1]);
    int max = calculationArr[0];
    //x轴
    double xSingleLength = width / maxLengthX;
    double xSingleLengthHalf = xSingleLength / 2.0;
    //y轴
    int ySize = calculationArr[1];
    int yEverySize = calculationArr[2];
    double yEveryLength = height / max;
    // print("ySize=${ySize}, max=${max} ${yEveryLength}-${height}");
    //x轴上坐标
    var xListAxisInfo = <AxisInfo>[];
    for (int i = 0; i < widget.xAxisInfos.length; i++) {
      xListAxisInfo.add(AxisInfo(
        _loadAxisInfoForX(i),
        Offset(xSingleLengthHalf + i * xSingleLength, height),
      ));
      print('x轴：${i + 1} ${xSingleLengthHalf + i * xSingleLength}');
    }
    this.xListAxisInfo = xListAxisInfo;
    //y轴上坐标
    var yListAxisInfo = <AxisInfo>[];
    for (var i = 0; i < ySize; i++) {
      int yValue = yEverySize * (i + 1);
      yListAxisInfo.add(
        AxisInfo(
          yValue.toString(),
          Offset(0, height - yEveryLength * yValue),
        ),
      );
    }
    var viewList = <LayoutId>[];
    listLayoutInfo = <LayoutInfo>[];
    //点 坐标, 生成点view
    for (LinePoint element in linePoints) {
      var list = element.list;
      var size = list.length;
      var color = element.background;
      var tag = element.tag;
      for (int i = 0; i < maxLengthX; i++) {
        if (i < size) {
          var pointInfo = list[i];
          var point = pointInfo.point;
          int indexForX = loadIndexForX(
              xListAxisInfo, i, maxLengthX, pointInfo.point.data['unit']);
          pointInfo.offset = Offset(xListAxisInfo[indexForX].offset.dx,
              height - yEveryLength * point.y);
          String childId = "${tag}_${i}";
          print('点$indexForX ${i} ${childId} ${pointInfo.offset!.dx}');
          viewList.add(LayoutId(
              id: childId,
              child: makePointView(
                  color, point, indexForX, tag, pointInfo.offset!)));
          listLayoutInfo!.add(LayoutInfo(childId, pointInfo.offset!));
        }
      }
    }
    viewList.insert(
      0,
      LayoutId(
        id: 'lineChartView',
        child: CustomPaint(
          size: size,
          painter: LineChartPainter(
            linePoints: linePoints,
            xList: xListAxisInfo,
            yList: yListAxisInfo,
          ),
        ),
      ),
    );
    listLayoutInfo!.insert(0, LayoutInfo('lineChartView', Offset.zero));
    lineLength = height;
    viewList.add(LayoutId(
        id: 'lineVertical',
        child: SizedBox(
          width: 2,
          height: height,
          child: LineRenderWidget(
            length: lineLength,
            value: clickTag.isNotEmpty,
            backgroundColor: Config.borderColor,
            strokeWidth: 1.5,
          ),
        )));
    listLayoutInfo!.add(LayoutInfo('lineVertical', Offset(lineDx, lineDy)));
    if (linePoints.isEmpty) {
      viewList.add(LayoutId(
          id: 'empry',
          child: Center(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text('暂无数据')))));
      listLayoutInfo!.add(LayoutInfo('empry', Offset.zero));
    }
    return viewList;
  }

  double lineDx = 0;
  double lineDy = 0;
  double lineLength = 100;
  int clickIndex = -1;
  String clickTag = '';
  Widget makePointView(
      Color color, Point point, int indexForX, String tag, Offset offset) {
    String xInfo = _loadAxisInfoForX(indexForX);
    final pointDx = offset.dx;
    final pointDy = offset.dy;
    Map<String, Point> map = loadTargetPoint(xInfo);
    if (!widget.showPopupMenu) {
      return InkWell(
          onTap: () {
            widget.itemClick?.call(point.data);
          },
          child: Tooltip(
            message: widget.tooltipValueGetter?.call([xInfo, tag, point.y]) ??
                "${xInfo}:${point.y}",
            child: SizedBox(
                width: 16,
                height: 16,
                child: CirclePointRenderWidget(
                  color.withOpacity(0.2),
                  false,
                  color.withOpacity(1),
                  8,
                )),
          ));
    }
    List<PopupMenuEntry> arr;
    if (null == widget.popupMenuGetter) {
      arr = [
        PopupMenuItem(
          height: 35,
          enabled: false,
          child: Text(
            _loadAxisInfoForX(indexForX),
            style: const TextStyle(color: Colors.white),
          ),
        )
      ];
      map.forEach((key, value) {
        arr.add(const PopupMenuDivider(height: 1));
        arr.add(PopupMenuItem(
          height: 45,
          value: value,
          /* onTap: () {
            widget.itemClick?.call(value.data);
          }, */
          child: Row(
            children: [
              Text(
                key,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Text(
                "${value.y}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
      });
    } else {
      arr = widget.popupMenuGetter!.call(map);
    }
    // print('click11:$tag dx=$pointDx $pointDy ${_loadAxisInfoForX(indexForX)}');
    return PopupMenuButton(
      color: const Color(0xFF4B4F52).withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.33)),
      padding: const EdgeInsets.all(12),
      offset: const Offset(10, 10),
      constraints: const BoxConstraints(maxWidth: 179),
      tooltip: widget.tooltipValueGetter
              ?.call([_loadAxisInfoForX(indexForX), tag, point.y]) ??
          "${_loadAxisInfoForX(indexForX)}-$tag:${point.y}",
      onSelected: <Point>(value) {
        widget.itemClick?.call(value.data);
        setState(() {
          clickIndex = -1;
          clickTag = '';
        });
      },
      itemBuilder: (context) {
        return arr;
      },
      onCanceled: () {
        setState(() {
          clickIndex = -1;
          clickTag = '';
        });
      },
      child: SizedBox(
        width: 16,
        height: 16,
        child: CirclePointRenderWidget(
          color.withOpacity(0.2),
          clickIndex == indexForX && clickTag == tag,
          color.withOpacity(1),
          8,
          tag: '$tag,%$indexForX,%${pointDx},%${pointDy}',
          onChanged: (String value) {
            print(value);
            List<String> arr = value.split(',%');
            String tagTem = arr[0];
            int indexTem = int.parse(arr[1]);
            double dx = double.parse(arr[2]);
            // print('click:$tag dx=$dx ${_loadAxisInfoForX(indexTem)}');
            // double dy = double.parse(arr[3]);
            setState(() {
              clickIndex = indexTem;
              clickTag = tagTem;
              lineDx = dx;
              //lineDy = dy;
              // lineLength = widget.size.height - dy;
              _delegate.x = dx;
            });
          },
        ),
      ),
    );
  }

  Map<String, Point> loadTargetPoint(String xInfo) {
    var map = <String, Point>{};
    for (var linePoint in widget.linePoints) {
      var list = linePoint.list;
      for (var i = 0; i < list.length; i++) {
        PointInfo pointInfo = list[i];
        String unit = pointInfo.point.data['unit'];
        if (unit == xInfo) {
          map[linePoint.tag] = pointInfo.point;
        }
      }
    }
    return map;
  }

  int loadIndexForX(
    List<AxisInfo> xListAxisInfo,
    int index,
    int xLength,
    String tag,
  ) {
    int indexForX = index;
    for (int i = 0; i < xListAxisInfo.length; i++) {
      AxisInfo element = xListAxisInfo[i];
      if (element.explain == tag) {
        indexForX = i;
        break;
      }
    }
    return indexForX;
  }
}

class LineMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  double x;
  final List<LayoutInfo> list;
  LineMultiChildLayoutDelegate(this.list, [this.x = 0]);
  @override
  void performLayout(Size size) {
    BoxConstraints constraints = BoxConstraints.loose(size);
    for (var layoutInfo in list) {
      Size size = layoutChild(layoutInfo.childId, constraints);
      if (layoutInfo.childId is String &&
          (layoutInfo.childId as String).contains('_')) {
        positionChild(layoutInfo.childId,
            layoutInfo.offset.translate(-size.width / 2.0, -size.height / 2.0));
      } else {
        positionChild(layoutInfo.childId, layoutInfo.offset);
      }
    }
  }

  @override
  bool shouldRelayout(covariant LineMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.x != x || oldDelegate.list.length != list.length;
  }

  /* @override
  Size getSize(BoxConstraints constraints) {
    // TODO: implement getSize
    return super.getSize(constraints);
  } */
}

class LineChartPainter extends CustomPainter {
  final TextStyle axisTextStyle;
  // Color background;
  final Color axisColor;
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    // ..color = Colors.black
    ..strokeWidth = 1;
  final Paint p = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFD6D6D6)
    ..strokeWidth = 1;

  final Paint pRect = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    // ..color = const Color(0xFFD6D6D6)
    ..strokeWidth = 1;
  List<LinePoint> linePoints;
  List<AxisInfo> xList;
  List<AxisInfo> yList;

  LineChartPainter({
    required this.linePoints,
    required this.xList,
    required this.yList,
    this.axisTextStyle = const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 13,
      color: Colors.black,
    ),
    this.axisColor = Colors.black,
  });
  double height = 0;
  double width = 0;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    // canvas.clipRect(rect);
    height = rect.height;
    width = rect.width;
    drawAxis(canvas, yList, Axis.vertical);
    drawPoint(canvas, linePoints);
    drawAxis(canvas, xList, Axis.horizontal);
  }

  void drawText(Canvas canvas, String text, Offset offset, Axis axis) {
    var textPainter = TextPainter(
      textDirection: TextDirection.rtl,
      text: TextSpan(text: text, style: axisTextStyle),
    );
    textPainter.layout(maxWidth: 50, minWidth: 5);
    if (axis == Axis.horizontal) {
      textPainter.paint(canvas, offset.translate(-textPainter.width / 2.0, 5));
    } else {
      textPainter.paint(canvas,
          offset.translate(-textPainter.width - 5, -textPainter.height / 2.0));
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return false;
  }

  void drawAxis(Canvas canvas, List<AxisInfo> list, Axis axis) {
    _paint.color = axisColor;
    _paint.style = PaintingStyle.fill;
    _paint.strokeWidth = 1;
    for (var axisInfo in list) {
      drawText(canvas, axisInfo.explain, axisInfo.offset, axis);
      if (Axis.vertical == axis) {
        // 画虚线
        drawDashLineForHorizontal(
            canvas, axisInfo.offset.dx, width, axisInfo.offset.dy);
      } else {
        drawSplitPoint(canvas, axisInfo.offset, axis);
      }
    }
    Offset p1;
    Offset p2;
    if (Axis.horizontal == axis) {
      p1 = Offset(0, height);
      p2 = Offset(width, height);
      drawArrow(canvas, p2.translate(-10, 5), p2.translate(-10, -5), p2);
      canvas.drawLine(p1, p2, _paint);
    } else {
      // p1 = Offset(0, height);
      // p2 = Offset.zero.translate(0, -10);
      //drawArrow(canvas, p2.translate(5, 10), p2.translate(-5, 10), p2);
    }
  }

  void drawDashLineForHorizontal(
      Canvas canvas, double startX, double endX, double y) {
    const double dashWidth = 5;
    const double spaceWidth = 3;
    if (startX > endX) {
      final double x = endX;
      endX = startX;
      startX = x;
    }
    double tem = startX;

    while (tem < endX) {
      var p1 = Offset(tem, y);
      var dxTem = tem + dashWidth;
      var dx = dxTem < endX ? dxTem : endX;
      canvas.drawLine(p1, Offset(dx, y), p);
      tem += (dashWidth + spaceWidth);
    }
  }

  void drawArrow(Canvas canvas, Offset start, Offset end, Offset center) {
    var path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(center.dx, center.dy);
    path.lineTo(end.dx, end.dy);
    canvas.drawPath(path, _paint);
  }

  void drawSplitPoint(Canvas canvas, Offset offset, Axis axis) {
    if (axis == Axis.horizontal) {
      canvas.drawLine(offset, offset.translate(0, -5), _paint);
    } else {
      canvas.drawLine(offset, offset.translate(5, 0), _paint);
    }
  }

  void drawPoint(Canvas canvas, List<LinePoint> linePoints) {
    _paint
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var linePoint in linePoints) {
      // String tag = linePoint.tag;
      Color background = linePoint.background;
      final Path path = Path();
      final Path bgPath = Path();
      for (var i = 0; i < linePoint.list.length; i++) {
        PointInfo pointInfo = linePoint.list[i];
        Offset offset = pointInfo.offset!;
        if (i == 0) {
          path.moveTo(offset.dx, offset.dy);
          bgPath.moveTo(offset.dx, height);
          bgPath.lineTo(offset.dx, offset.dy);
        } else {
          path.lineTo(offset.dx, offset.dy);
          bgPath.lineTo(offset.dx, offset.dy);
        }
      }
      if (linePoint.list.isNotEmpty) {
        bgPath.lineTo(linePoint.list.last.offset!.dx, height);
        bgPath.close();
        canvas.drawPath(
          path,
          _paint..color = background.withOpacity(1),
        );
        canvas.drawPath(
          bgPath,
          pRect
            ..shader = ui.Gradient.linear(
                Offset(0, height),
                const Offset(0, 0),
                [background.withOpacity(0.1), background.withOpacity(0.5)],
                [0, 1],
                TileMode.clamp)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }
}
