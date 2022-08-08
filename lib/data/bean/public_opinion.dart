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
  final String link;
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
  int? isComplete = 0;

  PublicOpinionBean.build(
    this.name,
    this.link,
    this.mediaType,
    this.linkPublishTime,
    this.findTime,
    this.publicOpinionType, {
    this.no,
    this.dutyUnit,
    this.specifiedUnitTime,
    this.feedbackTime,
    this.superiorNoticeTime,
    this.pressType,
    this.isLateReport,
    this.leaderInstructionsContent,
    this.leaderInstructionsTime,
    this.leaderName,
    this.isComplete,
  });

  void specifiedUnit(dutyUnitName) {
    dutyUnit = dutyUnitName;
    specifiedUnitTime = DateUtil.nowDate();
  }

  @override
  String toString() {
    return 'PublicOpinionBean{id: $id, no: $no, name: $name, mediaType: $mediaType, linkPublishTime: $linkPublishTime, findTime: $findTime, publicOpinionType: $publicOpinionType, dutyUnit: $dutyUnit, specifiedUnitTime: $specifiedUnitTime, feedbackTime: $feedbackTime, superiorNoticeTime: $superiorNoticeTime, pressType: $pressType, isLateReport: $isLateReport, leaderInstructionsContent: $leaderInstructionsContent, leaderInstructionsTime: $leaderInstructionsTime, leaderName: $leaderName, isComplete: $isComplete}';
  }

  static List<PublicOpinionBean> create() {
    var list = <PublicOpinionBean>[];
    list.add(PublicOpinionBean.build(
      '111',
      'https://www.xxxx.xx/sd/erm',
      '抖音1',
      '2022-05-01',
      '2022-05-01',
      '拖欠工资1',
      no: 0,
    ));
    list.add(PublicOpinionBean.build(
      '222',
      'https://www.xxxx.xx/sd/erm',
      '抖音2',
      '2022-05-01',
      '2022-05-01',
      '拖欠工资2',
      no: 1,
    ));
    list.add(PublicOpinionBean.build(
      '333',
      'https://www.xxxx.xx/sd/erm',
      '抖音3',
      '2022-05-01',
      '2022-05-01',
      '拖欠工资3',
      no: 2,
    ));
    list.add(PublicOpinionBean.build(
      '333',
      'https://www.xxxx.xx/sd/erm',
      '天涯社区',
      '2022-05-01',
      '2022-05-01',
      '社会问题',
      no: 3,
      dutyUnit: '县公安局',
      feedbackTime: '2022-05-04',
      specifiedUnitTime: '2022-05-04',
      isLateReport: 0,
      isComplete: 1,
    ));
    list.add(PublicOpinionBean.build(
      '333',
      'https://www.xxxx.xx/sd/erm',
      '新浪微博',
      '2022-05-01',
      '2022-05-01',
      '疫情防控',
      no: 4,
      dutyUnit: '县卫健委\n(未处理)',
      feedbackTime: '2022-05-04',
      specifiedUnitTime: '2022-05-04',
      leaderInstructionsContent: '测试批示内容阿伦诺夫看似打开卡十分难看看上的妇女阿斯弗',
      leaderInstructionsTime: '2022-05-05',
      leaderName: '于**',
      isLateReport: 0,
      isComplete: 1,
    ));
    return list;
  }
}
