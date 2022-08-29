import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/file_list_view.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/custom/triangle.dart';
import 'package:public_opinion_manage_web/data/bean/dispose_event.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class AuditDisposeEventPage extends StatefulWidget {
  final int eventId;
  const AuditDisposeEventPage({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<AuditDisposeEventPage> createState() => _AuditDisposeEventPageState();
}

class _AuditDisposeEventPageState extends State<AuditDisposeEventPage> {
  final TextEditingController _controller3 = TextEditingController();
  TextEditingController? _finalController;
  PublicOpinionBean? eventInfo;
  DisposeEvent? disposeEvent;
  List? files;
  // 多家单位处理
  List<DisposeData>? unitList;
  List<String> unitNameList = [];
  bool submitResult = false;
  // List<Map>? disposeEventUnitMappingList;
  String? dutyCoontent;
  @override
  void initState() {
    super.initState();
    askInternet();
  }

  void askInternet() async {
    // String token = map['token']!;
    final map = await UserUtil.makeUserIdMap();
    map['eventId'] = widget.eventId;
    ServiceHttp().post('/loadAutoDisposeEvent', data: map, isData: false,
        success: (data) {
      final _unitList = <DisposeData>[];
      data['unitList']?.forEach((bean) {
        _unitList.add(DisposeData.fromJson(bean));
      });
      final _unitNameList = <String>[];
      for (var element in _unitList) {
        _unitNameList.add(element.unit!);
        // print(element.list?.length ?? 0);
      }
      setState(() {
        files = data['files'];
        unitList = _unitList;
        unitNameList = _unitNameList;
        eventInfo = PublicOpinionBean.fromJson(data['data']);
        disposeEvent = DisposeEvent.fromJson(data['disposeEvent']);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller3.dispose();
    _finalController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arr = [
      SizedBox(height: 68.w),
      childItem("事件名称：", eventInfo?.description ?? ''),
      childItem("原文链接：", eventInfo?.link ?? ''),
      DataUtil.isEmpty(files)
          ? childItem("原文图文信息：", '')
          : fileItem("原文图文信息：", files!),
      SizedBox(height: 46.w),
      childItem("媒体类型：", eventInfo?.mediaType ?? ''),
      childItem("发布时间：", eventInfo?.publishTime ?? ''),
      childItem("舆情类别：", eventInfo?.type ?? ''),
      childItem("发现时间：", eventInfo?.findTime ?? ''),
      ...superiorNotificationView(eventInfo?.superiorNotificationTime),
      childItem("管理员指定单位备注：", disposeEvent?.manageRemark ?? '无'),
    ];
    if (!DataUtil.isEmpty(unitList)) {
      arr.add(Padding(
        padding: EdgeInsets.only(bottom: 30.w),
        child: SizedBox(width: 1000.w, child: DutyUnitList(list: unitList!)),
      ));
    }
    addAuditWidget(arr);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('事件审核',
              style: Config.loadDefaultTextStyle(
                fonstSize: Config.appBarTitleSize,
                color: Colors.black,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black, //修改颜色
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 1515.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/banner.png',
                    fit: BoxFit.fill,
                    width: 1424.w,
                    height: 235.w,
                  ),
                  Container(
                    width: 1515.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: arr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addAuditWidget(arr) {
    String passState = eventInfo?.passState ?? '';
    if (passState != '通过' && passState != '未处理' && passState != '未通过') {
      arr.add(auditContent());
    }
  }

  Widget historyDutyItem(String passState, String auditDate,
      String feedbackDate, String reason, String content) {
    return SizedBox(
      width: 744.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...auditTitle(auditDate, passState),
          childItem("不通过原因：", reason),
          childItem("处理内容：\n（$feedbackDate）", content,
              textAlign: TextAlign.right),
        ],
      ),
    );
  }

  List<Widget> auditTitle(auditDate, passState) {
    return [
      titleView(auditDate),
      SizedBox(height: 30.w),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 32.w),
          Text(
            '审核：',
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          Radio(value: 1, groupValue: 1, onChanged: (v) {}),
          Text(
            passText(passState),
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
        ],
      )
    ];
  }

  String passText(String passState) {
    if (passState == '完成') return '通过';
    return passState;
  }

  Widget lineView() =>
      Container(width: 4.w, height: 31.w, color: const Color(0xFF3E7BFA));

  Widget titleView(data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        lineView(),
        SizedBox(width: 4.w),
        TriangleWidget(
            color: const Color(0xFF0DDDBB), width: 7.w, height: 12.w),
        SizedBox(width: 6.w),
        Text("审核日期：$data",
            style: Config.loadDefaultTextStyle(
                fonstSize: 20.w, fontWeight: FontWeight.w500)),
      ],
    );
  }

  int _auditType = -1;
  Widget auditContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '最终责任单位：',
              style: Config.loadDefaultTextStyle(
                color: Colors.black.withOpacity(0.85),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 624.w,
              child: Autocomplete(
                optionsBuilder: (textEditingValue) {
                  final v = textEditingValue.text;
                  return unitNameList.where(
                      (String c) => c.toUpperCase().contains(v.toUpperCase()));
                },
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  _finalController = textEditingController;
                  return SizedBox(
                    width: 624.w,
                    // padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
                    child: TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      maxLines: 1,
                      minLines: 1,
                      scrollPadding: EdgeInsets.zero,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      style: Config.loadDefaultTextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(5.w),
                          borderSide:
                              const BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(5.w),
                          borderSide:
                              const BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14.w, horizontal: 16.w),
                        counterText: '',
                        isDense: true,
                        hintText: "请选择最终责任单位",
                        hintStyle: Config.loadDefaultTextStyle(
                            color: Config.borderColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 30.w),
        SizedBox(
          width: 690.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 40.w),
              Text(
                '审核：',
                style: Config.loadDefaultTextStyle(
                  color: Colors.black.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),
              RadioGroupWidget(
                list: const ['通过', '不通过'],
                defaultSelectIndex: _auditType,
                change: (value) {
                  setState(() {
                    _auditType = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: _auditType != 0,
          child: Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '不通过原因：',
                  style: Config.loadDefaultTextStyle(
                    color: Colors.black.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 642.w,
                  child: TextField(
                    controller: _controller3,
                    maxLines: 6,
                    minLines: 6,
                    decoration:
                        Config.defaultInputDecoration(hintText: '请输入不通过原因'),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 30.w),
        TextButton(
          onPressed: submitResult
              ? null
              : () {
                  requestCommitDutyContent(_controller3.text);
                },
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Config.fontColorSelect,
            textStyle: Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.w)),
          ),
          child: const Text('提交'),
        ),
        SizedBox(height: 30.w),
      ],
    );
  }

  List<Widget> superiorNotificationView(String? superiorNotificationTime) {
    if (DataUtil.isEmpty(superiorNotificationTime)) {
      return [
        superiorNotificationChildView('未通报'),
        SizedBox(height: 46.w),
      ];
    } else {
      return [
        superiorNotificationChildView('未通报'),
        SizedBox(height: 46.w),
        childItem('通报时间：', superiorNotificationTime!),
      ];
    }
  }

  Widget superiorNotificationChildView(String data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '上级是否通报：',
          style: Config.loadDefaultTextStyle(
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
        const Radio(value: 1, groupValue: 1, onChanged: null),
        Text(
          data,
          style: Config.loadDefaultTextStyle(
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 504.w),
      ],
    );
  }

  Widget fileItem(String data, List list) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data,
          style: Config.loadDefaultTextStyle(
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
        ShowFileListWidget(
          list: list,
          width: 624.w,
        ),
      ],
    );
  }

  Widget childItem(String data, String content,
      {double? bottom, TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 46.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bordContentTitle(data, textAlign),
          bordContent(content),
        ],
      ),
    );
  }

  Widget bordContentTitle(String data, TextAlign textAlign) {
    return Text(
      data,
      style: Config.loadDefaultTextStyle(
        color: Colors.black.withOpacity(0.85),
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.left,
    );
  }

  Container bordContent(String content) {
    return Container(
      width: 624.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: SelectableText(
        content,
        style: Config.loadDefaultTextStyle(
          color: Colors.black.withOpacity(0.65),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Map loadMapFromDisposeContent(DisposeContent bean, String reason) {
    final map = <String, dynamic>{};
    map['id'] = bean.id;
    map['passState'] = _auditType == 0 ? '通过' : '未通过';
    if (_auditType != 0) {
      map['reason'] = reason;
    }
    map['isPass'] = _auditType == 0 ? 1 : 0;
    return map;
  }

  // 提交处理内容
  void requestCommitDutyContent(String text) async {
    final map = <String, dynamic>{};
    if (_auditType == -1) {
      toast('请选择审核结果');
      return;
    }
    final finalDutyUnit = _finalController!.text.trim();
    final arr = [];
    if (_auditType != 0) {
      map['reason'] = text;
      map['isPass'] = 0;
    } else {
      map['isPass'] = 1;
      if (finalDutyUnit.isEmpty) {
        toast('请指定最终责任单位');
        return;
      }
      if (!unitNameList.contains(finalDutyUnit)) {
        toast('该单位超出此事件单位处理的范围');
        return;
      }
      map['finalDutyUnit'] = finalDutyUnit;
    }
    unitList?.forEach((element) {
      element.list?.forEach((bean) {
        if (bean.passState == '待审核') {
          arr.add(loadMapFromDisposeContent(bean, text));
        }
      });
    });
    map['changeMappingList'] = arr;
    map['eventId'] = eventInfo!.id;
    map['disposeEventId'] = disposeEvent!.id;
    map['userId'] = await UserUtil.getUserId();
    ServiceHttp().post('/auditDisposeEvent', data: map, success: (data) {
      setState(() {
        submitResult = true;
      });
      showSuccessDialog('提交成功');
      if (_auditType == 1) {
        showCenterNoticeDialog(context,
            title: '新的链接',
            contentWidget: SelectableText(
              "${ServiceHttp.parentUrl}${data['linkPath']}",
              style: Config.loadDefaultTextStyle(color: Colors.black),
            ));
      }
    });
  }
}

///处理单位列表
class DutyUnitList extends StatelessWidget {
  final List<DisposeData> list;

  const DutyUnitList({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final DisposeData bean = list[index];
        final String unit = bean.unit ?? "";
        final List<DisposeContent>? childList = bean.list;
        // print('处理单位列表 ${childList?.length ?? 0}');
        return ExpansionTile(
          title: titleView('单位名称', unit),
          childrenPadding: EdgeInsets.only(left: 90.w),
          initiallyExpanded: true,
          children: historyDuty(childList),
        );
      },
    );
  }

  Widget lineView() =>
      Container(width: 4.w, height: 31.w, color: const Color(0xFF3E7BFA));

  Widget titleView(fontData, data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        lineView(),
        SizedBox(width: 4.w),
        TriangleWidget(
            color: const Color(0xFF0DDDBB), width: 7.w, height: 12.w),
        SizedBox(width: 6.w),
        Text("$fontData：$data",
            style: Config.loadDefaultTextStyle(
                fonstSize: 20.w, fontWeight: FontWeight.w500)),
      ],
    );
  }

  List<Widget> historyDuty(List<DisposeContent>? disposeEventUnitMappingList) {
    if (DataUtil.isEmpty(disposeEventUnitMappingList)) {
      return <Widget>[const Center(child: Text('暂无内容'))];
    }
    // 从小到大排序
    disposeEventUnitMappingList!.sort((a, b) => a.rank!.compareTo(b.rank!));
    final length = disposeEventUnitMappingList.length;

    final DisposeContent lastMap = disposeEventUnitMappingList.last;
    //最终状态
    final finalPassState = lastMap.passState;

    final list = <Widget>[];
    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        DisposeContent element = disposeEventUnitMappingList[i];
        //通过、未通过、待审核、未处理
        final passState = element.passState ?? "";
        final auditDate = element.utime ?? "";
        final feedbackDate = element.time ?? "";
        final reason = element.reason ?? "";
        final content = element.content ?? "";
        list.add(historyDutyItem(
            passState, auditDate, feedbackDate, reason, content));
      }
    }
    var endList = <Widget>[];
    // 不添加: 处理内容，仅展示
    //if (finalPassState == '未处理') return [auditContent()];
    if (finalPassState == '待审核') {
      endList = [
        childItem("处理内容：\n（${lastMap.time}）", lastMap.content ?? "",
            textAlign: TextAlign.right)
      ];
    } else if (finalPassState == '通过') {
      endList = [
        ...auditTitle(lastMap.utime, finalPassState),
        childItem("处理内容：\n（${lastMap.time}）", lastMap.content ?? "",
            textAlign: TextAlign.right),
      ];
    } else if (finalPassState == '未通过') {
      endList = [
        historyDutyItem(finalPassState ?? "", lastMap.utime ?? "",
            lastMap.time ?? "", lastMap.reason ?? "", lastMap.content ?? "")
      ];
    }
    return [
      ...list,
      ...endList,
    ];
  }

  Widget historyDutyItem(String passState, String auditDate,
      String feedbackDate, String reason, String content) {
    return SizedBox(
      // width: 744.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...auditTitle(auditDate, passState),
          childItem("不通过原因：", reason),
          childItem("处理内容：\n（$feedbackDate）", content,
              textAlign: TextAlign.right),
        ],
      ),
    );
  }

  List<Widget> auditTitle(auditDate, passState) {
    return [
      titleView('审核日期', auditDate),
      SizedBox(height: 30.w),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 60.w),
          Text(
            '审核：',
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          const Radio(value: 1, groupValue: 1, onChanged: null),
          Text(
            passText(passState),
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
        ],
      ),
      SizedBox(height: 30.w),
    ];
  }

  String passText(String passState) {
    if (passState == '完成') return '通过';
    return passState;
  }

  Widget childItem(String data, String content,
      {double? bottom, TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 46.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bordContentTitle(data, textAlign),
          bordContent(content),
        ],
      ),
    );
  }

  Text bordContentTitle(String data, TextAlign textAlign) {
    return Text(
      data,
      style: Config.loadDefaultTextStyle(
        color: Colors.black.withOpacity(0.85),
        fontWeight: FontWeight.w400,
      ),
      textAlign: textAlign,
    );
  }

  Container bordContent(String content) {
    return Container(
      width: 624.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: SelectableText(
        content,
        style: Config.loadDefaultTextStyle(
          color: Colors.black.withOpacity(0.65),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
