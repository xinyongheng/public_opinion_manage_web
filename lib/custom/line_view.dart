// import 'dart:js';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LineRenderWidget extends LeafRenderObjectWidget {
  final double length;
  final bool value;
  final Color backgroundColor;
  final double strokeWidth;
  const LineRenderWidget({
    Key? key,
    required this.length,
    required this.value,
    this.backgroundColor = Colors.white,
    this.strokeWidth = 1,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLineBox(length, value,
        backgroundColor: backgroundColor, strokeWidth: strokeWidth);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderLineBox renderObject) {
    if (renderObject.value != value || renderObject.length != length) {
      renderObject.animationStatus =
          value ? AnimationStatus.forward : AnimationStatus.reverse;
      renderObject.setLength(length);
      renderObject.value = value;
    }
  }
}

class _RenderLineBox extends RenderBox {
  final Color backgroundColor;
  double length;
  bool value;
  final Axis axis;
  final bool dashed;
  final double dashWidth;
  final double spaceWidth;
  final double strokeWidth;
  _RenderLineBox(
    this.length,
    this.value, {
    required this.backgroundColor,
    this.axis = Axis.vertical,
    this.dashed = true,
    this.dashWidth = 5,
    this.spaceWidth = 3,
    this.strokeWidth = 1,
  })  : assert(length > 0),
        assert(strokeWidth > 0),
        assert(!dashed || (dashed && dashWidth > 0 && spaceWidth > 0)) {
    progress = value ? 1 : 0;
  }

  //下面的属性用于调度动画
  double progress = 0; //动画当前进度
  int? _lastTimeStamp; //上一次绘制的时间
  //动画执行时长
  Duration get duration => const Duration(milliseconds: 150);
  //动画当前状态
  AnimationStatus _animationStatus = AnimationStatus.completed;
  set animationStatus(AnimationStatus v) {
    if (_animationStatus != v) {
      markNeedsPaint();
    }
    _animationStatus = v;
  }

  void setLength(double l) {
    if (l != length) {
      length = l;
      // markNeedsLayout();
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    Size size = axis == Axis.horizontal
        ? Size(length, strokeWidth)
        : Size(strokeWidth, length);
    this.size =
        constraints.constrain(constraints.isTight ? Size.infinite : size);
  }

  @override
  bool hitTestSelf(Offset position) {
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    super.paint(context, offset);
    Rect rect = offset & size;
    _drawLine(context.canvas, rect);
    _scheduleAnimation();
  }

  void _drawLine(Canvas canvas, Rect rect) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = backgroundColor;
    var center = Offset(rect.left, rect.top);
    // Rect.fromLTRB(left, top, right, bottom)
    if (Axis.horizontal == axis) {
      var endProgress = lerpDouble(0, length, progress)!;
      if (dashed) {
        drawDashLineForHorizontal(
            canvas, rect.left, rect.left + endProgress, center.dy, paint);
      } else {
        canvas.drawLine(Offset(rect.left, center.dy),
            Offset(rect.left + endProgress, center.dy), paint);
      }
    } else {
      var endProgress = lerpDouble(0, length, progress)!;
      if (dashed) {
        drawDashLineForVertical(
            canvas, rect.top, rect.top + endProgress, center.dx, paint);
      } else {
        canvas.drawLine(Offset(center.dx, rect.top),
            Offset(center.dx, rect.top + endProgress), paint);
      }
    }
  }

  void drawDashLineForHorizontal(
      Canvas canvas, double startX, double endX, double y, Paint p) {
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

  void drawDashLineForVertical(
      Canvas canvas, double startY, double endY, double x, Paint p) {
    if (startY > endY) {
      final double x = endY;
      endY = startY;
      startY = x;
    }
    double tem = startY;

    while (tem < endY) {
      var p1 = Offset(x, tem);
      var dxTem = tem + dashWidth;
      var dy = dxTem < endY ? dxTem : endY;
      canvas.drawLine(p1, Offset(x, dy), p);
      tem += (dashWidth + spaceWidth);
    }
  }

  void _scheduleAnimation() {
    if (_animationStatus != AnimationStatus.completed) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (null != _lastTimeStamp) {
          double delta = (timeStamp.inMilliseconds - _lastTimeStamp!) /
              duration.inMilliseconds;
          //如果是反向动画，则 progress值要逐渐减小
          if (_animationStatus == AnimationStatus.reverse) {
            delta = -delta;
          }
          //更新动画进度
          progress = progress + delta;
          if (progress >= 1 || progress <= 0) {
            //动画执行结束
            _animationStatus = AnimationStatus.completed;
            progress = progress.clamp(0, 1);
          }
        }
        //标记为需要重绘
        markNeedsPaint();
        _lastTimeStamp = timeStamp.inMilliseconds;
      });
    } else {
      _lastTimeStamp = null;
    }
  }
}
