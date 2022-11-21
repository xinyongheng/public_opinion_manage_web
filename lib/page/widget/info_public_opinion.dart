import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/check_box.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/duty_unit.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/page/audit_dispose_event.dart';
import 'package:public_opinion_manage_web/page/public_opinion_info.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/date_util.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'load_dispose_event.dart';

///舆情列表
class PublicOpinionListWidget extends StatefulWidget {
  const PublicOpinionListWidget({Key? key}) : super(key: key);

  @override
  State<PublicOpinionListWidget> createState() =>
      _PublicOpinionListWidgetState();
}

class _PublicOpinionListWidgetState extends State<PublicOpinionListWidget> {
  final controllerMap = <String, TextEditingController>{};
  List<PublicOpinionBean> _list = [];
  @override
  void initState() {
    super.initState();
    askInternet(null);
    Config.eventBus.on<UpdateEventListBean>().listen((event) {
      print("eventBus_PublicOpinionListWidgetState, $mounted");
      if (event.needUpdate && mounted) {
        askInternet(null);
      }
    });
  }

  // 请求网络列表
  void askInternet(Map<String, dynamic>? map) async {
    final finalMap = <String, dynamic>{};
    if (null != map) {
      finalMap.addAll(map);
    }
    finalMap["userId"] = await UserUtil.getUserId();
    ServiceHttp().post("/eventList", data: finalMap, success: (data) {
      if (mounted) {
        setState(() {
          _list = PublicOpinionBean.fromJsonArray(data);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerMap.forEach((_, value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 32.w, 0, 39.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('舆情列表', style: Config.loadFirstTextStyle()),
            SizedBox(height: 38.w),
            ...headFilterView(),
            SizedBox(width: 45.w, height: 60.w),
            ListInfoWidget(
              canSelect: false,
              type: 1,
              selectList: _list,
              onUpdate: () => requestSearch(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> headFilterView() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...filterWidget('事件名称：', 'descriptionFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('舆情类别：', 'typeFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('舆情报刊类型：', 'pressTypeFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('媒体类型：', 'mediaTypeFilter'),
        ],
      ),
      SizedBox(width: 45.w, height: 21.w),
      timeFilter('发布时间：', 'publishTimeStart', 'publishTimeEnd'),
      SizedBox(width: 45.w, height: 21.w),
      timeFilter('反馈时间：', 'feedbackTimeStart', 'feedbackTimeEnd'),
      SizedBox(width: 45.w, height: 21.w),
      Row(
        children: [
          timeFilter('发现时间：', 'findTimeStart', 'findTimeEnd'),
          SizedBox(width: 33.w),
          loadTextButton('查 询', () {
            requestSearch();
          }),
          SizedBox(width: 33.w),
          loadTextButton(
            '重 置',
            () {
              controllerMap.forEach((key, value) {
                value.text = '';
              });
              askInternet(null);
            },
            primary: Config.fontColorSelect,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ];
  }

  TextButton loadTextButton(
    data,
    onPressed, {
    Color? primary = Colors.white,
    Color? backgroundColor = Config.fontColorSelect,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: primary,
        backgroundColor: backgroundColor,
        textStyle: Config.loadDefaultTextStyle(fonstSize: 19.sp),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
        minimumSize: Size(87.sp, 43.sp),
        side: backgroundColor == Colors.white
            ? const BorderSide(width: 0.5)
            : null,
        shape: RoundedRectangleBorder(
          side: backgroundColor == Colors.white
              ? const BorderSide(color: Color(0xFFD9D9D9))
              : BorderSide.none,
          borderRadius: BorderRadius.circular(2.sp),
        ),
      ),
      child: Text(data, textAlign: TextAlign.center),
    );
  }

  TextEditingController loadController(String key) {
    if (!controllerMap.containsKey(key)) {
      controllerMap[key] = TextEditingController();
    }
    return controllerMap[key]!;
  }

  Widget filterTitle(data) {
    return Text(
      data,
      style: Config.loadDefaultTextStyle(),
    );
  }

  List<Widget> filterWidget(data, key) {
    return [
      filterTitle(data),
      loadTextField(key),
    ];
  }

  Widget timeFilter(data, keyStart, keyEnd) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          filterTitle(data),
          SizedBox(
            width: 213.w,
            child: DateTimePicker(
              controller: loadController(keyStart),
              type: DateTimePickerType.date,
              dateMask: 'yyyy-MM-dd',
              firstDate: DateTime(1992),
              lastDate: DateTime.now(),
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: Config.defaultInputDecoration(
                hintText: '年/月/日',
                suffixIcon: Image.asset(
                  'images/icon_date.png',
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Text('至', style: Config.loadDefaultTextStyle()),
          ),
          SizedBox(
            width: 213.w,
            child: DateTimePicker(
              controller: loadController(keyEnd),
              type: DateTimePickerType.date,
              dateMask: 'yyyy-MM-dd',
              firstDate: DateTime(1992),
              lastDate: DateTime.now(),
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: Config.defaultInputDecoration(
                hintText: '年/月/日',
                suffixIcon: Image.asset(
                  'images/icon_date.png',
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ]);
  }

  Widget loadTextField(String key, {String hint = '请输入'}) {
    return SizedBox(
      width: 213.w,
      child: TextField(
        controller: loadController(key),
        decoration: Config.defaultInputDecoration(hintText: hint),
        style: Config.loadDefaultTextStyle(color: Colors.black),
      ),
    );
  }

  void requestSearch() async {
    final map = <String, dynamic>{};
    controllerMap.forEach((key, value) => fillFilterData(map, key, value));
    askInternet(map.isEmpty ? null : map);
  }

  void fillFilterData(map, key, value) {
    final data = value.text;
    if (data.isNotEmpty) {
      map[key] = data;
    }
  }
}

class ListInfoWidget extends StatefulWidget {
  final bool? canSelect;
  final List<PublicOpinionBean> selectList;
  final int type;
  final CheckBoxChange? onChange;
  final VoidCallback? onUpdate;
  final bool? isOnlyShow;
  const ListInfoWidget({
    Key? key,
    this.canSelect,
    required this.selectList,
    required this.type,
    this.onChange,
    this.onUpdate,
    this.isOnlyShow,
  }) : super(key: key);
  @override
  State<ListInfoWidget> createState() => ListInfoWidgetState();
}

class ListInfoWidgetState extends State<ListInfoWidget>
    with TickerProviderStateMixin {
  final wordLength = 16.w;
  final List<PublicOpinionBean> _hadSelectList = [];

  final _physics = const NeverScrollableScrollPhysics();
  final ScrollController _scrollController = ScrollController();
  bool _slideLeftTag = false;
  @override
  void initState() {
    super.initState();
  }

  void clearSelect() {
    setState(() {
      _hadSelectList.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timeController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w),
      child: Stack(children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, //内容适配
          itemBuilder: itemView,
          itemCount: widget.selectList.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE8E8E8),
            );
          },
        ),
        Positioned(
          right: _slideLeftTag ? null : 0,
          left: _slideLeftTag ? 0 : null,
          top: 0,
          child: slideLeftWidget(),
        )
      ]),
    );
  }

  Widget slideLeftWidget() {
    return Card(
      // color: Colors.grey,
      elevation: 10,
      child: InkWell(
        onTap: () {
          if (_slideLeftTag) {
            _scrollController.animateTo(-1800.w,
                duration: const Duration(seconds: 3), curve: const SawTooth(5));
          } else {
            _scrollController.animateTo(1800.w,
                duration: const Duration(seconds: 3), curve: const SawTooth(5));
          }
          setState(() {
            _slideLeftTag = !_slideLeftTag;
          });
        },
        child: Container(
          height: 60.w,
          width: 27.w,
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: _slideLeftTag ? -pi : 0,
            child: Image.asset('images/slide_left.png'),
          ),
        ),
      ),
    );
  }

// RotationTransition
  Widget itemView(BuildContext context, int index) {
    return index == 0
        ? firstTableRowView()
        : tableRowView(widget.selectList[index - 1], index);
  }

  Widget firstTableRowView() {
    final arr = [
      Container(
        width: 40.w,
        height: 30.w,
        color: const Color(0xFFFAFAFA),
        child: Center(
          child: InkWell(
              onTap: null,
              child: Text('选择',
                  style: Config.loadDefaultTextStyle(fonstSize: wordLength))),
        ),
      ),
      childItemView('序号', '',
          width: 4 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('事件描述', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('媒体类型', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('发布时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('发现时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('舆情类别', '',
          width: 6 * wordLength,
          color: Colors.black,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('责任单位', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('反馈时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('上级通报时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('报刊类型', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('是否迟报', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('领导批示', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('批示内容', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('是否完结', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('详情', '',
          width: 4 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    if (widget.isOnlyShow == true) {
      arr.removeLast();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: _physics,
      controller: _scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: arr,
      ),
    );
  }

  Widget tableRowView(PublicOpinionBean bean, int indexNo) {
    // print("tableRowView indexNo=${indexNo} + ${_hadSelectList.length}");
    bool tag = bean.leaderName == null;
    String leaderInstructions = tag
        ? (widget.type == 1 && widget.isOnlyShow != true ? '添加' : "—")
        : "${bean.leaderName}\n${DateUtil.subDate(bean.leaderInstructionsTime ?? '')}";
    // print(leaderInstructions);
    int index = bean.no!;
    final arr = [
      Container(
        width: 40.w,
        height: 30.w,
        // color: Colors.yellow,
        alignment: Alignment.center,
        child: Transform.scale(
          scale: 0.7,
          child: CheckBoxWidget(
            boxTag: indexNo - 1,
            value: _hadSelectList.contains(widget.selectList[indexNo - 1]),
            onChanged: (value, tag) {
              if (value) {
                _hadSelectList.add(widget.selectList[tag as int]);
              } else {
                _hadSelectList.remove(widget.selectList[tag as int]);
              }
              //print("2选中数量：${_hadSelectList.length}-value=${value}");
              widget.onChange?.call(value, _hadSelectList);
            },
          ),
        ),
      ),
      childItemView("$indexNo", '序号', width: 4 * wordLength, index: index),
      childItemView(bean.description.toString(), '事件描述',
          width: 8 * wordLength, index: index),
      childItemView(bean.mediaType.toString(), '媒体类型',
          width: 8 * wordLength, index: index),
      childItemView(bean.publishTime.toString(), '发布时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.findTime.toString(), '发现时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.type.toString(), '舆情类别',
          width: 6 * wordLength, index: index),
      childItemView(
          dutyUnit(bean.dutyUnit, bean.passState ?? '') ??
              (widget.isOnlyShow != true ? '指定' : '—'),
          '责任单位',
          width: 8 * wordLength,
          index: index),
      childItemView(bean.feedbackTime ?? "—", '反馈时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.superiorNotificationTime ?? "—", '上级通报时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.pressType ?? "—", '报刊类型',
          width: 6 * wordLength, index: index),
      childItemView(
          bean.isLateReport == 1 ? '是' : (bean.isLateReport == 0 ? '否' : "—"),
          '是否迟报',
          width: 6 * wordLength,
          index: index),
      childItemView(bean.passState == '通过' ? leaderInstructions : '—', '领导批示',
          width: 8 * wordLength, index: index),
      childItemView(bean.leaderInstructionsContent ?? "—", '批示内容',
          width: 8 * wordLength, index: index),
      childItemView(bean.isComplete == 1 ? '是' : '否', '是否完结',
          width: 6 * wordLength, index: index),
      childItemView('查看', '详情', width: 4 * wordLength, index: index),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    if (widget.isOnlyShow == true) {
      arr.removeLast();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: _physics,
      controller: _scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: arr,
      ),
    );
  }

  String? dutyUnit(String? units, String passState) {
    if (DataUtil.isEmpty(units)) return null;
    return "${units!.substring(1, units.length - 1)}($passState)";
  }

  Widget childItemView(String data, String tag,
      {color = Colors.black,
      bgColor = Colors.white,
      double? width,
      double? height,
      int index = 1}) {
    const clickTag = ',添加,指定,查看,编辑,';
    bool isClick = clickTag.contains(data);
    bool canClick = isClick || (data != "—" && tag == '批示内容') || tag == '责任单位';
    Widget child;
    String dataTem = data;
    // print('111$tag-${data.length}');
    if (data.length > 13 && !tag.contains('时间') && tag != '领导批示') {
      //dataTem = '${data.substring(0, 9)}…';
      // print('222$tag-${dataTem}');
      if (tag == '事件描述') {
        canClick = true;
      }
    } else if (tag.contains('时间') && data.length > 10) {
      dataTem = data.substring(0, 10);
    }
    child = Text(
      dataTem,
      textAlign: TextAlign.center,
      style: Config.loadDefaultTextStyle(
        color: isClick
            ? Config.fontColorSelect
            : (tag == '序号' ? Colors.white : color),
        fonstSize: wordLength,
        fontWeight: tag.isNotEmpty ? FontWeight.w400 : FontWeight.w600,
      ),
      // softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    if (tag == '序号') {
      child = Container(
          width: 22.w,
          height: 22.w,
          color: Config.fontColorSelect,
          alignment: Alignment.center,
          child: child);
    }
    return Container(
      alignment: Alignment.center,
      // color: bgColor,
      width: width ?? data.length * wordLength,
      height: height ?? 60.w,
      decoration: BoxDecoration(
        color: bgColor,
        // border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: canClick
          ? InkWell(
              onTap: data != '—' ? () => viewClick(data, tag, index - 1) : null,
              child: child)
          : child,
    );
  }

  void viewClick(String data, String tag, int index) {
    final bean = widget.selectList[index];
    switch (tag) {
      case '事件描述':
        showNotice(tag, data);
        break;
      case '责任单位':
        if (data == '指定') {
          preDutyUnit(bean);
        } else {
          if (widget.type == 1) {
            //管理员
            Config.startPage(context,
                AuditDisposeEventPage(eventId: widget.selectList[index].id!));
          } else {
            String linkPath = widget.selectList[index].linkPath ?? '';

            Config.startPage(
                context,
                LoadDisposeEventPage(
                    info: linkPath.replaceAll('/loadDisposeEvent?info=', '')));
          }
        }
        break;
      case '上级通报时间':
        shangJiShiJian(bean.id);
        break;
      case '报刊类型':
        break;
      case '领导批示':
        lingDaoPiShi(bean.id);
        break;
      case '批示内容':
        showCenterNoticeDialog(
          context,
          title: '批示内容',
          contentWidget: SizedBox(
            width: 400.w,
            child: SelectableText(bean.leaderInstructionsContent!,
                style: Config.loadDefaultTextStyle(
                  color: Colors.black,
                )),
          ),
        );
        break;
      case '详情':
        Config.startPage(context, PublicOpinionInfoPage(eventId: bean.id!));
        break;
      default:
      // toast('暂未开发');
      //详情
    }
  }

  void showNotice(String title, String msg) {
    showCenterNoticeDialog(context,
        title: title,
        contentWidget: SizedBox(
          width: 400.w,
          child: SelectableText(
            msg,
            style: Config.loadDefaultTextStyle(
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ));
  }

  void preDutyUnit(bean) async {
    ServiceHttp().post('/loadUser', data: await UserUtil.makeUserIdMap(),
        success: (data) {
      var list = UserData.fromJsonArray(data);
      showDutyUnitDialog(context, bean.id, list);
    });
  }

  TextEditingController? _timeController;
  TextEditingController _loadTimeController() {
    _timeController ??= TextEditingController();
    return _timeController!;
  }

  void shangJiShiJian(eventId) {
    showCenterNoticeDialog(context,
        barrierDismissible: false,
        title: '添加回复上级时间',
        contentWidget: SizedBox(
          width: 294.w,
          child: Config.dateInputView(
            '年/月/日',
            _loadTimeController(),
            suffixIcon: Image.asset("images/icon_date.png"),
          ),
        ), onPress: () {
      String time = _timeController!.text;
      if (time.isEmpty) {
        toast('请选择时间');
      } else {
        _updateShangJiShiJian(time, eventId);
      }
    });
  }

  void _updateShangJiShiJian(String time, eventId) async {
    final map = await UserUtil.makeUserIdMap();
    map['eventId'] = eventId;
    map['changeContent'] = {
      "replySuperiorTime": time,
    };
    ServiceHttp().post("/updateEvent", data: map, success: (data) {
      _timeController?.text = '';
      widget.onUpdate?.call();
      Config.finishPage(context);
      showSuccessDialog('上传成功');
    });
  }

  // 领导批示
  String? _name;
  String? _content;
  void lingDaoPiShi(eventId) {
    showCenterNoticeDialog(
      context,
      barrierDismissible: false,
      title: '添加领导批示',
      contentWidget: SizedBox(
        // width: 294.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('领导姓名：', style: Config.loadDefaultTextStyle()),
                  SizedBox(
                    width: 293.w,
                    child: TextField(
                      onChanged: (value) => _name = value,
                      decoration: Config.defaultInputDecoration(),
                      style: Config.loadDefaultTextStyle(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('批示时间：', style: Config.loadDefaultTextStyle()),
                  SizedBox(
                    width: 293.w,
                    child: Config.dateInputView(
                      '年/月/日',
                      _loadTimeController(),
                      type: DateTimePickerType.date,
                      suffixIcon: Image.asset("images/icon_date.png"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('批示内容：', style: Config.loadDefaultTextStyle()),
                  SizedBox(
                    width: 293.w,
                    child: TextField(
                      onChanged: (value) => _content = value,
                      maxLines: 5,
                      minLines: 5,
                      decoration: Config.defaultInputDecoration(),
                      style: Config.loadDefaultTextStyle(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onPress: () async {
        if (DataUtil.isEmpty(_content)) {
          toast('请输入批示内容');
          return;
        }
        if (DataUtil.isEmpty(_name)) {
          toast('请输入领导姓名');
          return;
        }
        String time = _timeController!.text;
        if (time.isEmpty) {
          toast('请选择批示时间');
          return;
        }
        final map = await UserUtil.makeUserIdMap();
        // map['id'] = eventId;
        map['changeContent'] = {
          "id": eventId,
          "leaderInstructionsTime": time,
          "leaderInstructionsContent": _content,
          "leaderName": _name,
        };
        ServiceHttp().post("/updateEvent", data: map, success: (data) {
          _timeController?.text = '';
          _name = null;
          _content = null;
          widget.onUpdate?.call();
          //Config.finishPage(context);
          showSuccessDialog('上传成功');
        });
      },
    );
  }
}
