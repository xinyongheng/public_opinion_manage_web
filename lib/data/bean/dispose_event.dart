class DisposeData {
  String? unit;
  List<DisposeContent>? list;

  DisposeData({this.unit, this.list});

  DisposeData.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    if (json['list'] != null) {
      list = <DisposeContent>[];
      json['list'].forEach((v) {
        list!.add(DisposeContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    if (list != null) {
      data['disposeContent'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DisposeContent {
  int? id;
  int? state;
  int? disposeEventId;
  int? eventId;
  String? dutyUnit;
  String? time;
  String? content;
  int? rank;
  String? passState;
  int? isPass;
  String? reason;
  String? ctime;
  String? utime;

  DisposeContent(
      {this.id,
      this.state,
      this.disposeEventId,
      this.eventId,
      this.dutyUnit,
      this.time,
      this.content,
      this.rank,
      this.passState,
      this.isPass,
      this.reason,
      this.ctime,
      this.utime});

  DisposeContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    disposeEventId = json['disposeEventId'];
    eventId = json['eventId'];
    dutyUnit = json['dutyUnit'];
    time = json['time'];
    content = json['content'];
    rank = json['rank'];
    passState = json['passState'];
    isPass = json['isPass'];
    reason = json['reason'];
    ctime = json['ctime'];
    utime = json['utime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state'] = state;
    data['disposeEventId'] = disposeEventId;
    data['eventId'] = eventId;
    data['dutyUnit'] = dutyUnit;
    data['time'] = time;
    data['content'] = content;
    data['rank'] = rank;
    data['passState'] = passState;
    data['isPass'] = isPass;
    data['reason'] = reason;
    data['ctime'] = ctime;
    data['utime'] = utime;
    return data;
  }
}

class DisposeEvent {
  int? id;
  int? state;
  int? userId;
  int? eventId;
  String? manageRemark;
  String? linkPath;
  String? finalDutyUnit;
  int? isPass;
  String? ctime;
  String? utime;

  DisposeEvent(
      {this.id,
      this.state,
      this.userId,
      this.eventId,
      this.manageRemark,
      this.linkPath,
      this.finalDutyUnit,
      this.isPass,
      this.ctime,
      this.utime});

  DisposeEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    userId = json['userId'];
    eventId = json['eventId'];
    manageRemark = json['manageRemark'];
    linkPath = json['linkPath'];
    finalDutyUnit = json['finalDutyUnit'];
    isPass = json['isPass'];
    ctime = json['ctime'];
    utime = json['utime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state'] = state;
    data['userId'] = userId;
    data['eventId'] = eventId;
    data['manageRemark'] = manageRemark;
    data['linkPath'] = linkPath;
    data['finalDutyUnit'] = finalDutyUnit;
    data['isPass'] = isPass;
    data['ctime'] = ctime;
    data['utime'] = utime;
    return data;
  }
}
