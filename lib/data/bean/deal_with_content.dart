class DealWithContent {
  ///处理单位
  late String unit;

  ///处理内容
  late String content;

  String feedbackTime = '';

  bool isMainUnit = false;

  ///true->仅读，不修改
  bool onlyRead = false;

  bool onlyReadForUnit = false;

  DealWithContent({required this.unit, required this.content});

  DealWithContent.make(this.unit, this.content) {
    if (unit.isNotEmpty) {
      onlyReadForUnit = true;
      if (content.length > 1) {
        onlyRead = true;
      }
    }
  }

  DealWithContent.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    content = json['content'];
    isMainUnit = json['isMainUnit'];
    feedbackTime = json['feedbackTime'];
    onlyRead = json['onlyRead'];
    onlyReadForUnit = json['onlyReadForUnit'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['unit'] = unit;
    map['content'] = content;
    map['isMainUnit'] = isMainUnit;
    map['feedbackTime'] = feedbackTime;
    map['onlyRead'] = onlyRead;
    map['onlyReadForUnit'] = onlyReadForUnit;
    return map;
  }

  DisposeEventUnitMapping toDisposeEventUnitMapping() {
    return DisposeEventUnitMapping(
        dutyUnit: unit, content: content, time: feedbackTime);
  }
}

class DisposeEventUnitMapping {
  late String dutyUnit;
  late String time;
  late String content;
  DisposeEventUnitMapping(
      {required this.dutyUnit, required this.content, required this.time});
  DisposeEventUnitMapping.fromJson(Map<String, dynamic> json) {
    dutyUnit = json['dutyUnit'];
    time = json['time'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['dutyUnit'] = dutyUnit;
    map['time'] = time;
    map['content'] = content;
    return map;
  }
}
