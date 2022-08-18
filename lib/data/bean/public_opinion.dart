import 'package:public_opinion_manage_web/utils/date_util.dart';

class PublicOpinionBean {
  // 主键Id
  int? id;
  // 序号
  int? no;

  // 事件名称
  late String description;
  late String author;
  // 媒体类型
  late String mediaType;
  String? mediaTypeOther;
  late String link;
  String? linkOther;
  // 发布时间
  late String publishTime;
  // 发现时间
  late String findTime;
  // 舆情类别
  late String type;

  // 责任单位
  String? dutyUnit;
  String? specifiedUnitTime;
  // 反馈时间
  String? feedbackTime;

  // 上级通报时间
  String? superiorNotificationTime;
  // 审核通过时间
  String? auditApprovedTime;
  // 回复上级时间
  String? replySuperiorTime;

  // 报刊类型
  String? pressType;

  // 是否迟报 0否1是
  int? isLateReport;

  // 领导批示
  String? leaderInstructionsContent;
  String? leaderInstructionsTime;
  String? leaderName;

  // 是否完结 0否1是
  int? isComplete = 0;
  //此事件综合（多单位）处理状态；通过（完成）、未通过、待审核、未处理
  String? passState;
  PublicOpinionBean.build(
    this.description,
    this.author,
    this.link,
    this.mediaType,
    this.publishTime,
    this.findTime,
    this.type, {
    this.no,
    this.dutyUnit,
    this.specifiedUnitTime,
    this.feedbackTime,
    this.superiorNotificationTime,
    this.pressType,
    this.isLateReport,
    this.leaderInstructionsContent,
    this.leaderInstructionsTime,
    this.leaderName,
    this.isComplete,
    this.passState,
  });

  PublicOpinionBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author']!;
    description = json['description'];
    type = json['type'];
    publishTime = json['publishTime'];
    findTime = json['findTime'];
    auditApprovedTime = json['auditApprovedTime'];
    superiorNotificationTime = json['superiorNotificationTime'];
    replySuperiorTime = json['replySuperiorTime'];
    feedbackTime = json['feedbackTime'];
    leaderInstructionsTime = json['leaderInstructionsTime'];
    leaderInstructionsContent = json['leaderInstructionsContent'];
    link = json['link'];
    linkOther = json['linkOther'];
    mediaType = json['mediaType'];
    mediaTypeOther = json['mediaTypeOther'];
    pressType = json['pressType'];
    isLateReport = json['isLateReport'];
    dutyUnit = json['dutyUnit'];
    isComplete = json['isComplete'];
    passState = json['passState'];
  }

  static List<PublicOpinionBean> fromJsonArray(List data) {
    final list = <PublicOpinionBean>[];
    for (int i = 0; i < data.length; i++) {
      final v = data[i];
      final bean = PublicOpinionBean.fromJson(v);
      bean.no = i + 1;
      list.add(bean);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['author'] = author;
    data['description'] = description;
    data['type'] = type;
    data['publishTime'] = publishTime;
    data['findTime'] = findTime;
    data['auditApprovedTime'] = auditApprovedTime;
    data['superiorNotificationTime'] = superiorNotificationTime;
    data['replySuperiorTime'] = replySuperiorTime;
    data['feedbackTime'] = feedbackTime;
    data['leaderInstructionsTime'] = leaderInstructionsTime;
    data['leaderInstructionsContent'] = leaderInstructionsContent;
    data['link'] = link;
    data['linkOther'] = linkOther;
    data['mediaType'] = mediaType;
    data['mediaTypeOther'] = mediaTypeOther;
    data['pressType'] = pressType;
    data['isLateReport'] = isLateReport;
    data['dutyUnit'] = dutyUnit;
    data['isComplete'] = isComplete;
    data['passState'] = passState;
    return data;
  }

  void specifiedUnit(dutyUnitName) {
    dutyUnit = dutyUnitName;
    specifiedUnitTime = DateUtil.nowDate();
  }

  @override
  String toString() {
    return 'PublicOpinionBean{id: $id, no: $no, name: $description, mediaType: $mediaType, linkPublishTime: $publishTime, findTime: $findTime, publicOpinionType: $type, dutyUnit: $dutyUnit, specifiedUnitTime: $specifiedUnitTime, feedbackTime: $feedbackTime, superiorNoticeTime: $superiorNotificationTime, pressType: $pressType, isLateReport: $isLateReport, leaderInstructionsContent: $leaderInstructionsContent, leaderInstructionsTime: $leaderInstructionsTime, leaderName: $leaderName, isComplete: $isComplete}';
  }
}
