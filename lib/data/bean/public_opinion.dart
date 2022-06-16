import 'package:public_opinion_manage_web/utils/date_util.dart';

class PublicOpinionBean {
  // 主键Id
  int? id;
  // 序号
  int? no;

  // 事件名称
  final String name;
  // 媒体类型
  final String mediaType;
  // 发布时间
  final String linkPublishTime;
  // 发现时间
  final String findTime;
  // 舆情类别
  final String publicOpinionType;

  // 责任单位
  String? dutyUnit;
  String? specifiedUnitTime;
  // 反馈时间
  String? feedbackTime;

  // 上级通报时间
  String? superiorNoticeTime;

  // 报刊类型
  String? pressType;

  // 是否迟报 0否1是
  int? isLateReport;

  // 领导批示
  String? leaderInstructionsContent;
  String? leaderInstructionsTime;
  String? leaderName;

  // 是否完结 0否1是
  int isComplete = 0;

  PublicOpinionBean.build(this.name, this.mediaType, this.linkPublishTime,
      this.findTime, this.publicOpinionType);

  void specifiedUnit(dutyUnitName) {
    dutyUnit = dutyUnitName;
    specifiedUnitTime = DateUtil.nowDate();
  }

  @override
  String toString() {
    return 'PublicOpinionBean{id: $id, no: $no, name: $name, mediaType: $mediaType, linkPublishTime: $linkPublishTime, findTime: $findTime, publicOpinionType: $publicOpinionType, dutyUnit: $dutyUnit, specifiedUnitTime: $specifiedUnitTime, feedbackTime: $feedbackTime, superiorNoticeTime: $superiorNoticeTime, pressType: $pressType, isLateReport: $isLateReport, leaderInstructionsContent: $leaderInstructionsContent, leaderInstructionsTime: $leaderInstructionsTime, leaderName: $leaderName, isComplete: $isComplete}';
  }
}
