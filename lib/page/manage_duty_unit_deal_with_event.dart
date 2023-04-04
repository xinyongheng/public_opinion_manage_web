import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/custom/select_duty_unit_dialog.dart';
import 'package:public_opinion_manage_web/data/bean/deal_with_content.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

///create time 2023-01-31
class ManageDutyUnitAndDealWithPage extends StatefulWidget {
  const ManageDutyUnitAndDealWithPage({super.key, this.info, this.eventId})
      : assert(info != null || eventId != null);

  final String? info;
  final int? eventId;

  @override
  State<ManageDutyUnitAndDealWithPage> createState() =>
      _ManageDutyUnitAndDealWithPageState();
}

class _ManageDutyUnitAndDealWithPageState
    extends State<ManageDutyUnitAndDealWithPage> {
  final ScrollController scrollController = ScrollController();
  //事件通过 状态
  String passState = '';

  /// 是否 已经设置了 处理单位。 true->设置了
  bool isSetDealWithUnit() => (widget.info?.length ?? 0) > 5;

  ///事件id
  int? eventId;
  int isLateReportTag = -2;
  final _dataFuture = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    return Config.pageScaffold(
      title: '管理员事件处理',
      scrollController: scrollController,
      body: FutureBuilder(
        builder: buildView,
        future: askInternet(),
      ),
    );
  }

  Widget buildView(BuildContext context, AsyncSnapshot snapshot) {
    ConnectionState state = snapshot.connectionState;
    switch (state) {
      case ConnectionState.done:
        return doneView(snapshot, context);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget doneView(AsyncSnapshot snapshot, context) {
    if (snapshot.hasError || snapshot.data == null) {
      return Text(snapshot.error?.toString() ?? '访问失败',
          style: Config.loadDefaultTextStyle());
    }
    return bodyView(snapshot.data, context);
  }

  Future<Map<String, dynamic>?> loadToken() async {
    String? token = await UserUtil.getToken();
    int? userId = await UserUtil.getUserId();
    var userType = await UserUtil.getType();
    if (DataUtil.isEmpty(token)) return null;
    if (DataUtil.isEmpty(userId)) return null;
    Map<String, dynamic> map = {};
    //map['token'] = token!;
    map['userId'] = userId!;
    map['userType'] = userType!;
    return map;
  }

  Future<dynamic> askInternet() {
    return _dataFuture.runOnce(() {
      if (isSetDealWithUnit()) {
        return askInternetForHadSetUnit();
      } else {
        return askInternetForNotSetUnit();
      }
    });
  }

  Future<dynamic> askInternetForNotSetUnit() async {
    Completer<dynamic> completer = Completer();
    var map = await loadToken();
    if (map == null) return completer.completeError('未登录');
    map['eventId'] = widget.eventId!;
    eventId = widget.eventId;
    ServiceHttp().post(
      '/manageLoadDisposeEvent',
      data: map,
      isData: false,
      success: (data) {
        completer.complete(data);
      },
      error: (msg, data) {
        completer.completeError(msg);
      },
    );
    return completer.future;
  }

  Future<dynamic> askInternetForHadSetUnit() async {
    Completer<dynamic> completer = Completer();
    var map = await loadToken();
    if (map == null) return completer.completeError('未登录');
    int userId = map['userId']!;
    //int userType = await UserUtil.getType();
    //String unit = await UserUtil.getUnit();
    ServiceHttp().post(
      '/loadDisposeEvent',
      data: {'userId': userId, 'info': widget.info!},
      isData: false,
      success: (data) {
        completer.complete(data);
      },
      error: (msg, data) {
        completer.completeError(msg);
      },
    );
    return completer.future;
  }

  Column bodyView(data, context) {
    var arr = loadViewArr(data, context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: arr,
    );
  }

  ///滑动到底部
  void _scrollToEnd() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final serviceDataList = <DealWithContent>[];
  List<Widget> loadViewArr(Map? data, context) {
    if (null == data) {
      return [
        Center(
          child: Text(
            '暂无数据',
            style: Config.loadDefaultTextStyle(
              fonstSize: 27.w,
              fontWeight: FontWeight.w500,
              color: Config.fontColorSelect,
            ),
          ),
        )
      ];
    }
    List? files = data['files'];
    Map? eventInfo = data['data'];
    if (null != eventInfo) {
      eventId = eventInfo['id'];
    }
    passState = loadValue(eventInfo, 'passState');
    Map? disposeEvent = data['disposeEvent'];
    List<dynamic>? disposeEventUnitMappingList =
        data['disposeEventUnitMappingList'];
    var arr = [
      paddingSpace(),
      Center(
        child: Text(
          '事件处理反馈',
          style: Config.loadDefaultTextStyle(
            fonstSize: 27.w,
            fontWeight: FontWeight.w500,
            color: Config.fontColorSelect,
          ),
        ),
      ),
      paddingSpace(),
      paddingSpace(),
      rowView('事件名称：', loadValue(eventInfo, 'description')), paddingSpace(),
      eventMediaInfo(files), paddingSpace(),
      rowView('原文链接：', loadValue(eventInfo, 'link')), paddingSpace(),
      rowView('媒体类型：', loadValue(eventInfo, 'mediaType')), paddingSpace(),
      rowView('发布时间：', loadValue(eventInfo, 'publishTime')), paddingSpace(),
      rowView('舆情类别：', loadValue(eventInfo, 'type')), paddingSpace(),
      rowView('发现时间：', loadValue(eventInfo, 'findTime')), paddingSpace(),
      reportView(loadValue(eventInfo, 'superiorNotificationTime')),
      paddingSpace(),
      //rowView('管理员备注：', loadValue(disposeEvent, 'manageRemark')),
      lineView(), paddingSpace(),
      manageRemarkView(disposeEvent), paddingSpace(),
      // 是否迟报 审核时添加
      // isLateReport(disposeEvent), paddingSpace(),
      //feedbackTimeView(), paddingSpace(),
      //事件信息结束，添加间隔线
      lineView(), paddingSpace(),
    ];
    if (isSetDealWithUnit()) {
      int length = disposeEventUnitMappingList?.length ?? 0;
      if (length <= 0) {
        arr.add(Center(
          child: Text('信息缺失', style: contentStyle()),
        ));
        return arr;
      } else {
        //显示 已经指定的处理单位
        fillDealWithContent(disposeEventUnitMappingList!);
      }
    }
    //添加处理单位
    arr.addAll(addDutyUnitView(context));
    return arr;
  }

  void fillDealWithContent(List<dynamic> disposeEventUnitMappingList) {
    if (serviceDataList.isEmpty) {
      //serviceDataList.add(DealWithContent(unit: '', content: ''));
      for (var mapping in disposeEventUnitMappingList) {
        DealWithContent bean = DealWithContent.make(
            mapping['dutyUnit'] ?? '', mapping['content'] ?? '');
        bean.feedbackTime = mapping['time'] ?? '';
        serviceDataList.add(bean);
      }
      dealWithContentList.addAll(serviceDataList);
    }
  }

  final remarkController = TextEditingController();
  final feedbackTimeController = TextEditingController();

  Widget manageRemarkView(Map? disposeEvent) {
    if (isSetDealWithUnit()) {
      //return rowView('管理员备注：', loadValue(disposeEvent, 'manageRemark'));
      var remark = loadValue(disposeEvent, 'manageRemark');
      if (remark == '无') remark = '';
      remarkController.text = remark;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('管理员备注；'),
        SizedBox(
            width: 624.w,
            child: _textField(remarkController, Config.borderColor,
                maxLinex: 3, minLine: 1))
      ],
    );
  }

  int defaultSelectIndex(Map? disposeEvent) {
    if (disposeEvent == null) return -1;
    return disposeEvent['isLateReport'] ?? -1;
  }

  Widget isLateReport(Map? disposeEvent) {
    int index = defaultSelectIndex(disposeEvent);
    if (index == -1) {
      isLateReportTag = -1;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('是否迟报；'),
        SizedBox(
          width: 624.w,
          child: RadioGroupWidget(
            list: const ['是', '否'],
            defaultSelectIndex: index,
            change: index != -1
                ? null
                : (value) {
                    isLateReportTag = value ?? -1;
                  },
          ),
        )
      ],
    );
  }

  TextField _textField(TextEditingController controller, Color borderColor,
      {int? maxLinex = 1, int? minLine = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLinex,
      minLines: minLine,
      scrollPadding: EdgeInsets.zero,
      // textInputAction: TextInputAction.done,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration: decoration(borderColor, '请输入备注(选填)'),
    );
  }

  String loadValue(Map? map, String key) =>
      null == map ? '无' : (map[key] ?? '无');

  Widget paddingSpace() => SizedBox(height: 15.w);

  Widget lineView() => Center(
        child: Container(
          width: 1000.w,
          height: 1,
          color: Colors.grey,
        ),
      );

  ///上级是否通报
  Widget reportView(String? superiorNotificationTime) {
    bool isReport = superiorNotificationTime?.isNotEmpty == true &&
        superiorNotificationTime != '无';
    // ignore: dead_code
    return isReport
        ? rowView('上级通报时间：', superiorNotificationTime!)
        : rowView('上级是否通报', '未通报');
  }

  ///事件图文信息
  Widget eventMediaInfo(List? medias) {
    bool isHadMedia = medias?.isNotEmpty == true;
    if (!isHadMedia) return rowView('原文图文信息：', '无');
    var arr = <Widget>[];
    medias?.forEach((element) {
      //list[index]['path'], list[index]['description']
      arr.add(_imageView(element['description'], element['path']));
    });
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView('原文图文信息：'),
        SizedBox(
          width: 624.w,
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 5,
            children: arr,
          ),
        )
      ],
    );
  }

  Widget _imageView(String fileName, String urlPath) {
    String type = FileInfoBean.fileType(urlPath);
    var isImage = type == 'image';
    var mediaPath = '${ServiceHttp.parentUrl}/$urlPath';
    var childView =
        isImage ? Image.network(mediaPath) : Image.asset("images/ic_xls.png");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80.w,
          height: 75.w,
          color: Colors.grey,
          child: InkWell(
            onTap: () => Config.launch(mediaPath),
            child: childView,
          ),
        ),
        SizedBox(
          width: 80.w,
          child: SelectableText(
            fileName,
            style: Config.loadDefaultTextStyle(
              color: Config.fontColorSelect,
              fonstSize: 15.w,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            minLines: 1,
          ),
        ),
      ],
    );
  }

  Widget rowView(String title, String content) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(title),
        boardText(content),
      ],
    );
  }

  Widget titleView(String text) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.all(5),
      width: 550.w,
      child: SelectableText(
        text,
        textAlign: TextAlign.end,
        style: Config.loadDefaultTextStyle(
          color: Colors.black.withOpacity(0.85),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  //624.w
  Widget boardText(String text) {
    return Container(
      width: 624.w,
      padding: const EdgeInsets.all(5),
      decoration: _decoration(),
      child: SelectableText(
        text,
        style: contentStyle(),
      ),
    );
  }

  TextStyle contentStyle() => Config.loadDefaultTextStyle(
        color: Colors.black.withOpacity(0.65),
        fontWeight: FontWeight.w400,
      );

  ///添加处理单位
  List<Widget> addDutyUnitView(context) {
    var arr = [
      addDutyUnitTitle(),
    ];
    for (var i = 0; i < dealWithContentList.length; i++) {
      var bean = dealWithContentList[i];
      arr.add(dealUnitView(i + 1, bean));
      arr.add(SizedBox(height: 20.w));
    }
    if (dealWithContentList.isNotEmpty && !isFill()) {
      arr.add(commitView(context));
      arr.add(SizedBox(height: 30.w));
    }
    return arr;
  }

  ///已经设置的处理单位，处理内容是否已经填充完
  bool isFill() {
    if (serviceDataList.isEmpty) return false;
    for (var bean in serviceDataList) {
      if (bean.unit.isEmpty || bean.content.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool isNotAdd() {
    // 已经设置了处理单位 并且 已经审核处理 =>不添加
    return isSetDealWithUnit() && (passState == '未通过' || passState == '通过');
  }

  Widget addDutyUnitTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //624.w
        titleView('单位处理内容：'),
        Container(
          width: 624.w,
          padding: const EdgeInsets.all(5),
          alignment: Alignment.topRight,
          child: isNotAdd()
              ? const SizedBox(width: 0, height: 0)
              : InkWell(
                  onTap: loadAllUser,
                  child: Text(
                    '添加',
                    style: Config.loadDefaultTextStyle(
                      color: Config.fontColorSelect,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
        )
      ],
    );
  }

  ///单位
  final contentUnit = TextEditingController();

  ///内容
  final contentContent = TextEditingController();

  ///存储 处理内容 数组
  final List<DealWithContent> dealWithContentList = [];

  @override
  void dispose() {
    super.dispose();
    serviceDataList.clear();
    contentContent.dispose();
    remarkController.dispose();
    feedbackTimeController.dispose();
  }

  List<UserData> allUser = [];
  void loadAllUser() async {
    ServiceHttp().post(
      '/loadUser',
      data: await UserUtil.makeUserIdMap(),
      success: (data) {
        List<UserData> list = UserData.fromJsonArray(data);
        allUser = list;
        clickAddDutyUnit();
      },
      error: (msg, data) => clickAddDutyUnit(),
    );
  }

  ///点击添加处理单位以及内容
  void clickAddDutyUnit({DealWithContent? bean}) {
    showAddDutyUnitDialog(
      context,
      contentUnit,
      contentContent,
      feedbackTimeController,
      allUser,
      bean,
      onSure: (data, transmitBean) {
        String unit = data[0];
        //反馈时间
        String feedbackTime = data[2];
        //showSuccessDialog('单位：${data[0]} 内容：${data[1]}');
        bool isHad = _checkReportUnit(unit);
        if (isHad && transmitBean?.unit != unit) {
          showNoticeDialog('${data[0]}已经添加，请勿重复添加');
          return;
        }
        //bool isChange = transmitBean != null;
        //是否为 修改 处理单位
        final bean = DealWithContent(unit: unit, content: data[1]);
        bean.feedbackTime = feedbackTime;
        if (transmitBean != null) {
          //同一个下标的处理单位 仅修改数据
          _changeDealUnit(
              transmitBean, bean.unit, bean.content, bean.feedbackTime);
          return;
        }
        //新添加 处理单位
        //向数组添加数据
        _addDealUnit(bean);
      },
    );
  }

  ///向数组添加数据
  void _addDealUnit(DealWithContent bean) {
    setState(() {
      dealWithContentList.add(bean);
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollToEnd();
    });
  }

  void _changeDealUnit(
      DealWithContent old, String unit, String content, String feedbackTime) {
    if (old.unit != unit ||
        old.content != content ||
        feedbackTime != old.feedbackTime) {
      old.unit = unit;
      var offset = scrollController.offset;
      old.content = content;
      setState(() {
        old.feedbackTime = feedbackTime;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollController.jumpTo(offset);
      });
    }
  }

  ///删除数据
  void _deleteDealUnit(DealWithContent bean) {
    setState(() {
      dealWithContentList.remove(bean);
    });
  }

  bool _checkReportUnit(String unit) {
    for (var bean in dealWithContentList) {
      if (bean.unit == unit) {
        return true;
      }
    }
    return false;
  }

  BoxDecoration _decoration() => BoxDecoration(
      border: Border.all(color: Config.borderColor),
      borderRadius: BorderRadius.circular(5));

  ///处理view
  Widget dealUnitView(int index, DealWithContent bean) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 550.w,
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(50.w),
                ),
                child: Text(
                  index.toString(),
                  style: Config.loadDefaultTextStyle(
                      fonstSize: 20.w, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '：',
                style: Config.loadDefaultTextStyle(
                    fonstSize: 20.w,
                    fontWeight: FontWeight.w500,
                    color: Colors.transparent),
              ),
            ],
          ),
        ),
        Container(
          width: 624.w,
          padding: const EdgeInsets.all(5),
          decoration: _decoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 400.w,
                    child: Text(
                      '单位名称：${bean.unit}',
                      style: contentStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    bean.feedbackTime.isEmpty ? '' : '(${bean.feedbackTime})',
                    style: Config.loadDefaultTextStyle(
                      fonstSize: 15.w,
                      color: Config.fontColorSelect,
                    ),
                  ),
                ],
              ),
              lineView(),
              Text.rich(
                TextSpan(children: [
                  const TextSpan(text: '处理内容：\n'),
                  TextSpan(text: bean.content.isEmpty ? '（待添加）' : bean.content),
                ]),
                style: contentStyle(),
              )
            ],
          ),
        ),
        SizedBox(width: 15.w),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bean.onlyRead
                ? const SizedBox(width: 0, height: 0)
                : InkWell(
                    onTap: () {
                      contentContent.text = bean.content;
                      contentUnit.text = bean.unit;
                      feedbackTimeController.text = bean.feedbackTime;
                      clickAddDutyUnit(bean: bean);
                      //showAddDutyUnitDialog(context, controllerUnit, controllerContent, searchList)
                    },
                    child: Text(
                      '编辑',
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                        fonstSize: 15.w,
                      ),
                    ),
                  ),
            SizedBox(height: 20.w),
            (bean.onlyRead || bean.onlyReadForUnit)
                ? const SizedBox(width: 0, height: 0)
                : InkWell(
                    onTap: () {
                      _preDelete(bean);
                    },
                    child: Text(
                      '删除',
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                        fonstSize: 15.w,
                      ),
                    ),
                  )
          ],
        )
      ],
    );
  }

  void _preDelete(DealWithContent bean) {
    showCenterNoticeDialog(
      context,
      isNeedTitle: false,
      contentString: '确定删除处理单位：${bean.unit} 么？',
      onPress: () => _deleteDealUnit(bean),
    );
  }

  Widget commitView(context) {
    return Center(
      child: TextButton(
        onPressed: () => clickCommit(context),
        style: TextButton.styleFrom(
          textStyle: Config.loadDefaultTextStyle(color: Colors.white),
          foregroundColor: Colors.white,
          backgroundColor: Config.fontColorSelect,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          minimumSize: Size(120.w, 55.w),
        ),
        child: const Text('提交'),
      ),
    );
  }

  ///点击提交 信息
  void clickCommit(context) {
    if (!_checkContent()) {
      showNoticeDialog('请至少填写一个完整的单位处理内容');
      return;
    }
    if (isLateReportTag == -1) {
      showNoticeDialog('请选择是否迟报');
      return;
    }
    commit(context);
  }

  ///检测 至少有一个单位填写了处理内容
  bool _checkContent() {
    for (var bean in dealWithContentList) {
      final bool effective = bean.unit.isNotEmpty &&
          bean.content.isNotEmpty &&
          bean.feedbackTime.length > 3;
      if (effective) return true;
    }
    return false;
  }

  void commit(context) async {
    //所有处理单位以及内容
    List<DisposeEventUnitMapping> disposeEventUnitList = [];
    for (var bean in dealWithContentList) {
      disposeEventUnitList.add(bean.toDisposeEventUnitMapping());
    }
    Map<String, dynamic> data = await UserUtil.makeUserIdMap();
    //管理员备注
    String manageRemark = remarkController.text;
    data['manageRemark'] = manageRemark;
    data['eventId'] = eventId;
    // if (isLateReportTag != -2) {
    //   data['isLateReport'] = isLateReportTag;
    // }
    data['disposeEventUnitList'] = disposeEventUnitList;
    showCenterNoticeDialog(
      context,
      title: '温馨提示',
      contentString: '确定提交么？',
      onPress: () {
        ServiceHttp().post('/manageDisposeEvent', data: data, success: (data) {
          showSuccessDialog('提交成功', dialogDismiss: () {
            Config.finishPage(context, refresh: true);
            Config.eventBus.fire(UpdateEventListBean()..needUpdate = true);
          });
        });
      },
    );
  }
}
