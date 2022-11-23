// ignore_for_file: must_be_immutable
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/render_custom.dart';
import 'package:public_opinion_manage_web/data/bean/line_data.dart';

import 'line_chart_view.dart';

class HistogramRenderWidget extends StatefulWidget {
  const HistogramRenderWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.linePoint,
    required this.xAxisInfos,
    required this.onChanged,
    this.startPaddingX = 10,
    this.rectWidth = 20,
  }) : super(key: key);
  final double width;
  final double height;
  final LinePoint? linePoint;
  final double startPaddingX;
  final double rectWidth;
  final List<String> xAxisInfos;
  final ValueChanged<dynamic>? onChanged;
  @override
  State<HistogramRenderWidget> createState() => _HistogramRenderWidgetState();
}

class _HistogramRenderWidgetState extends State<HistogramRenderWidget> {
  @override
  Widget build(BuildContext context) {
    var array = makeViews(widget.linePoint);
    return CustomMultiChildLayout(
      delegate: LineMultiChildLayoutDelegate(array[0]),
      children: array[1],
    );
  }

  makeViews(LinePoint? linePoint) {
    if (linePoint == null || linePoint.list.isEmpty) {
      return [
        [LayoutInfo(1, Offset.zero)],
        [
          LayoutId(
              id: 1,
              child: Center(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text('暂无数据'))))
        ]
      ];
    }
    List<PointInfo> list = linePoint.list;
    // X轴个数
    int lengthX = list.length;
    final double rectPadding =
        (widget.width - widget.rectWidth * lengthX) / (lengthX + 1);

    List<int> maxYResult =
        LineChartWidgetState.loadMaxValue(<LinePoint>[linePoint]);
    int maxY = maxYResult[1];
    maxY = maxY == 0 ? 10 : maxY;
    List<int> calculationArr = LineChartWidgetState.calculationYSize(maxY);
    // Y轴最大值（代表值）
    maxY = calculationArr[0];
    // Y轴数值个数
    int ySize = calculationArr[1];
    // Y轴每一段代表的大小
    int yEverySize = calculationArr[2];
    // Y轴单位实际长度（绘制使用）
    double yEveryLength = widget.height / maxY;
    // X轴上数据坐标
    double dx = widget.startPaddingX;
    // X轴坐标点集合
    var xListAxisInfo = <AxisInfo>[];
    // Y轴坐标点集合
    var yListAxisInfo = <AxisInfo>[];
    for (var i = 0; i < ySize; i++) {
      int yValue = yEverySize * (i + 1);
      yListAxisInfo.add(
        AxisInfo(
          yValue.toString(),
          Offset(0, widget.height - yEveryLength * yValue),
        ),
      );
    }
    var viewList = <LayoutId>[];
    var listLayoutInfo = <LayoutInfo>[];
    var rectHalf = widget.rectWidth / 2.0;
    for (int i = 0; i < list.length; i++) {
      PointInfo pointInfo = list[i];
      double realY = pointInfo.point.y;
      double childHeight = realY * yEveryLength;
      final double dy = widget.height - childHeight;
      dx = rectPadding + i * (widget.rectWidth + rectPadding);
      Offset offset = Offset(dx, dy);
      String xExplain = widget.xAxisInfos[i];
      xListAxisInfo
          .add(AxisInfo(xExplain, Offset(dx + rectHalf, widget.height)));
      String childId = 'histogram-$i';
      // print('$childId offset=$offset $childHeight');
      listLayoutInfo.add(LayoutInfo(childId, offset));
      viewList.add(LayoutId(
          id: childId,
          child: Tooltip(
            message: '$xExplain:$realY',
            child: SingleHistogramRenderWidget(
              width: widget.rectWidth,
              height: childHeight,
              backgroundColor: Colors.blue,
              value: pointInfo.point.data,
              onChanged: widget.onChanged,
            ),
          )));
    }
    viewList.insert(
      0,
      LayoutId(
        id: 'xy坐标轴',
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: LineChartPainter(
            linePoints: [],
            xList: xListAxisInfo,
            yList: yListAxisInfo,
          ),
        ),
      ),
    );
    listLayoutInfo.insert(0, LayoutInfo('xy坐标轴', Offset.zero));
    return [listLayoutInfo, viewList];
  }
}

class SingleHistogramRenderWidget<T> extends LeafRenderObjectWidget {
  SingleHistogramRenderWidget({
    Key? key,
    required this.value,
    required this.width,
    required this.height,
    this.backgroundColor = Colors.blue,
    this.onChanged,
  }) : super(key: key);
  final T value;
  final ValueChanged<T>? onChanged;
  double height;
  final double width;
  final Color backgroundColor;
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHistogramObject<T>(
      value: value,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      onChanged: onChanged,
    )..animationStatus = AnimationStatus.forward;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderHistogramObject renderObject) {
    if (renderObject._height != height) {
      renderObject.value = value;
      renderObject.height = height;
      // renderObject.onChanged = onChanged;
      renderObject.animationStatus = AnimationStatus.forward;
    }
  }
}

class RenderHistogramObject<T> extends RenderBox
    with RenderObjectAnimationMixin {
  final ValueChanged<T>? onChanged;
  RenderHistogramObject({
    this.onChanged,
    required this.value,
    required double height,
    required this.width,
    required Color backgroundColor,
  })  : startRect = Rect.fromLTWH(0, height, width, 0),
        _height = height,
        _backgroundColor = backgroundColor {
    _paint.color = _backgroundColor;
    // progress = 1;
  }
  int pointerId = -1;
  T value;

  double _height;
  double get height => _height;
  set height(double value) {
    if (value != _height) {
      _height = value;
      progress = 0;
      markNeedsLayout();
    }
  }

  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  final double width;
  final Rect startRect;
  Color _backgroundColor;
  set backgroundColor(Color color) {
    if (_backgroundColor != color) {
      _backgroundColor = color;
      _paint.color = _backgroundColor;
      markNeedsPaint();
    }
  }

  Color get backgroundColor => _backgroundColor;

  @override
  Duration get duration => const Duration(milliseconds: 500);

  @override
  void performLayout() {
    Size size1 = Size(width, _height);
    // print('-------------------');
    // print(size1);
    size = constraints.constrain(constraints.isTight ? Size.infinite : size1);
    // print(size);
    // print('-------------------');
  }

  /* @override
  get sizeByParent => true;

  @override
  void performResize() {
    // size = computeDryLayout(constraints);
    print(constraints.biggest);
    Size size1 = Size(width, _height);
    print('performResize size1=$size1');
    // super.performResize();
    size = size1;
  } */

  @override
  bool hitTestSelf(Offset position) => onChanged != null;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event.down) {
      pointerId = event.pointer;
    } else if (pointerId == event.pointer) {
      // 判断手指抬起时是在组件范围内的话才触发onChange
      if (size.contains(event.localPosition)) {
        onChanged?.call(value);
      }
    }
  }

  @override
  void doPaint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    Canvas canvas = context.canvas;
    // print('$context-$rect');
    // canvas.drawCircle(rect.center, 20, Paint()..color = Colors.red);
    // 限制绘画区域
    // canvas.clipRect(rect);
    // canvas.drawRect(rect, Paint()..color = Colors.red);
    // Offset progressOffset =
    //     Offset.lerp(Offset(0, height), Offset.zero, progress)!;
    // double progressHeight = progressOffset.dy;
    Rect progressRect = Rect.lerp(
        Rect.fromLTWH(rect.left, rect.bottom, rect.width, 0), rect, progress)!;
    // 绘制矩形
    // print('${rect.height} $rect');
    canvas.drawRect(progressRect, _paint);
  }
}
