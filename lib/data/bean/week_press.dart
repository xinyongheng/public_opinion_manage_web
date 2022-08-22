class WeekPressBean {
  String? firstRankTitle;
  List<SecondRank>? secondRank;

  WeekPressBean({this.firstRankTitle, this.secondRank});

  WeekPressBean.fromJson(Map<String, dynamic> json) {
    firstRankTitle = json['firstRankTitle'];
    if (json['secondRank'] != null) {
      secondRank = <SecondRank>[];
      json['secondRank'].forEach((v) {
        secondRank!.add(SecondRank.fromJson(v));
      });
    }
  }
  static List<WeekPressBean> fromJsonList(List<dynamic> list) {
    List<WeekPressBean> weekList = [];
    for (var element in list) {
      weekList.add(WeekPressBean.fromJson(element));
    }
    return weekList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstRankTitle'] = firstRankTitle;
    if (secondRank != null) {
      data['secondRank'] = secondRank!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SecondRank {
  String? secondRankTitle;
  String? content;

  SecondRank({this.secondRankTitle, this.content});

  SecondRank.fromJson(Map<String, dynamic> json) {
    secondRankTitle = json['secondRankTitle'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secondRankTitle'] = secondRankTitle;
    data['content'] = content;
    return data;
  }
}
