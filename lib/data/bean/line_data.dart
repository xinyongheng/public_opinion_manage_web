import 'dart:ui';

class Point {
  double x;
  double y;
  dynamic data;
  Point(this.x, this.y, {this.data});

  @override
  String toString() {
    return "x=$x, y=$y";
  }
}

class PointInfo {
  Point point;
  Offset? offset;
  PointInfo.make(this.point, {this.offset});
}

class LinePoint {
  String tag;
  Color background;
  late List<PointInfo> list;
  LinePoint(this.tag, this.list, this.background);
  LinePoint.make(
      {required this.tag,
      required this.background,
      required List<Offset> offsets,
      required List<Point> points})
      : assert(offsets.length == points.length) {
    list = [];
    for (int i = 0; i < offsets.length; i++) {
      var offset = offsets[i];
      list.add(PointInfo.make(points[i], offset: offset));
    }
    // list.add(value)
  }
}
