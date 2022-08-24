import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CirclePointWidget extends StatelessWidget {
  final double size;
  final double smallRadius;
  final Color smallCircleColor;
  final Color bgCircleColor;
  const CirclePointWidget({
    Key? key,
    required this.size,
    required this.smallRadius,
    required this.smallCircleColor,
    required this.bgCircleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: _listView(),
      ),
    );
  }

  List<Widget> _listView() {
    final arr = <Widget>[];
    if (smallRadius < size) {
      arr.add(circleView(bgCircleColor, size));
      arr.add(circleView(smallCircleColor, smallRadius));
    }
    arr.add(circleView(smallCircleColor, smallRadius));
    return arr;
  }

  Widget circleView(Color color, double size) {
    return ClipOval(child: Container(color: color, width: size, height: size));
  }
}

class _RenderCirclePointBox<T> extends RenderBox {
  int pointerId = -1;
  final T? tag;
  //选中状态发生改变后的回调
  final ValueChanged<T>? onChanged;
  final Color bgColor;
  bool value;
  final Color smallColor;
  final double smallRadius;
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

  _RenderCirclePointBox(
    this.bgColor,
    this.smallColor,
    this.smallRadius,
    this.value, {
    this.onChanged,
    this.tag,
  }) : assert(onChanged == null || tag != null) {
    progress = value ? 1 : 0;
  }
  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    //背景圆
    _drawBackground(context, rect);
    //调度动画
    _scheduleAnimation();
  }

  void _drawBackground(PaintingContext context, Rect rect) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = bgColor;
    var circleCenterPoint = rect.center;
    var radius = smallRadius;
    var maxSize = min(rect.width, rect.height) / 2.0;
    // print("smallRadius=${smallRadius}, maxSize=${maxSize}");
    if (radius > maxSize) {
      radius = maxSize;
    }
    //背景圆
    context.canvas
        .drawCircle(circleCenterPoint, rect.shortestSide / 2.0, paint);
    //中心圆
    paint.color = smallColor;
    final startRect = Rect.fromCenter(
        center: circleCenterPoint, width: radius, height: radius);
    // print((maxSize - radius) / 2);
    final endRect = rect.deflate((maxSize - radius / 2) / 2);
    final rectProgress = Rect.lerp(startRect, endRect, progress);
    final innerCircle = RRect.fromRectXY(rectProgress!, 0, 0);
    context.canvas
        .drawCircle(circleCenterPoint, innerCircle.shortestSide / 2.0, paint);
  }

  void _scheduleAnimation() {
    if (_animationStatus != AnimationStatus.completed) {
      //需要在Flutter 当前frame 结束之前再执行，因为不能在绘制过程中又将组件标记为需要重绘
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (_lastTimeStamp != null) {
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

  @override
  void performLayout() {
    //如果父组件指定了固定宽高，则使用父组件指定的，否则宽高默认置为 25
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : const Size(25, 25),
    );
  }

  //必须置为true，否则不可以响应事件
  @override
  bool hitTestSelf(Offset position) => onChanged != null;
  //只有通过点击测试的组件才会调用本方法
  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event.down) {
      pointerId = event.pointer;
    } else if (pointerId == event.pointer) {
      //判断手指抬起时是在组件范围内的话才触发onChange
      if (size.contains(event.localPosition)) {
        onChanged?.call(tag as T);
      }
    }
  }
}

class CirclePointRenderWidget<T> extends LeafRenderObjectWidget {
  final T? tag;
  //选中状态发生改变后的回调
  final ValueChanged<T>? onChanged;
  final Color bgColor;
  final bool value;
  final Color smallColor;
  final double smallRadius;
  const CirclePointRenderWidget(
    this.bgColor,
    this.value,
    this.smallColor,
    this.smallRadius, {
    Key? key,
    this.tag,
    this.onChanged,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCirclePointBox(bgColor, smallColor, smallRadius, value,
        tag: tag, onChanged: onChanged);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderCirclePointBox renderObject) {
    if (renderObject.value != value) {
      renderObject.animationStatus =
          value ? AnimationStatus.forward : AnimationStatus.reverse;
    }
    renderObject.value = value;
  }
}
