import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/file_list_view.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/date_util.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class PublicOpinionInfoPage extends StatefulWidget {
  final int eventId;
  const PublicOpinionInfoPage({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<PublicOpinionInfoPage> createState() => _PublicOpinionInfoPageState();
}

class _PublicOpinionInfoPageState extends State<PublicOpinionInfoPage> {
  bool _canChange = false;
  final mapController = <String, TextEditingController>{};
  PublicOpinionBean? _publicOpinionBean;
  List? files;
  List? leaderFiles;
  @override
  void initState() {
    super.initState();
    _loadEventInfo();
  }

  void _loadEventInfo() async {
    final map = await UserUtil.makeUserIdMap();
    map["eventId"] = widget.eventId;
    ServiceHttp().post('/loadEventInfo', data: map, isData: false,
        success: (data) {
      List? allFiles = data['files'];
      List remarkList = [];
      List leaderList = [];
      if (allFiles?.isNotEmpty == true) {
        for (var element in allFiles!) {
          if (element['fileType'] == 'leader') {
            leaderList.add(element);
          } else {
            remarkList.add(element);
          }
        }
      }
      setState(() {
        _publicOpinionBean = PublicOpinionBean.fromJson(data['data']);
        radioGroupWidgetKey.currentState!.updateDefault(
            _publicOpinionBean?.superiorNotificationTime?.isNotEmpty == true
                ? 0
                : 1);
        initControllerValue();
        files = remarkList;
        leaderFiles = leaderList;
      });
    });
  }

  void initControllerValue() {
    if (null != _publicOpinionBean) {
      mapController.forEach((key, value) {
        value.text = _defaultValue(key);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    mapController.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/bg.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('查看详情',
              style: Config.loadDefaultTextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.w),
            child: Container(
              width: 1515.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.w),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 35.w),
                          firstColumn(),
                          const Spacer(),
                          secondColumn(),
                          const Spacer(),
                          SizedBox(width: 455.w, child: thirdColumn()),
                          SizedBox(width: 68.w),
                        ],
                      ),
                      endView(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget endView(context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
            onPressed: () {
              if (_canChange) {
                // 提交信息
                submitInfo();
              } else {
                //仅修改状态
                setState(() {
                  _canChange = !_canChange;
                });
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Config.fontColorSelect,
              minimumSize: const Size(1, 1),
              fixedSize: Size(87.w, 43.w),
              textStyle: Config.loadDefaultTextStyle(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.w)),
            ),
            child: Text(!_canChange ? '编辑' : '保存')),
        Visibility(
          visible: _publicOpinionBean?.feedbackTime?.isNotEmpty != true,
          child: Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: TextButton(
                onPressed: () => showDeleteDialog(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Config.fontColorSelect,
                  minimumSize: const Size(1, 1),
                  fixedSize: Size(87.w, 43.w),
                  textStyle: Config.loadDefaultTextStyle(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.w)),
                ),
                child: const Text('删除')),
          ),
        ),
      ],
    );
  }

  void showDeleteDialog(context) {
    showCenterNoticeDialog(context, contentString: '确定删除这条事件么？', onPress: () {
      requestDeleteEventInfo(context);
    });
  }

  Widget outsideWidget(double width, {required Widget child}) {
    return SizedBox(
      width: width,
      child: child,
    );
  }

  Widget firstColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemView('事件名称：', 'description', line: 5),
        SizedBox(height: 30.w),
        Material(
          elevation: 0,
          color: Colors.transparent,
          child: InkWell(
              onTap: _publicOpinionBean?.link?.isNotEmpty == true
                  ? () {
                      Config.launch(_publicOpinionBean!.link!);
                    }
                  : null,
              child: _itemView('原文链接：', 'link', line: 1)),
        ),
        SizedBox(height: 30.w),
        Visibility(
            visible: files?.isNotEmpty == true,
            child: fileItem('原文图文信息：', files ?? [])),
        _itemView('媒体类型：', 'mediaType'),
        SizedBox(height: 30.w),
        _itemView('发布时间：', 'publishTime'),
        SizedBox(height: 30.w),
        _itemView('发现时间：', 'findTime'),
      ],
    );
  }

  Widget secondColumn() {
    bool tag = _publicOpinionBean?.superiorNotificationTime?.isNotEmpty == true;
    if (!_canChange) {
      _selectRadio = tag ? 0 : 1;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _itemView('舆情类别：', 'type', readOnly: !_canChange),
        SizedBox(height: 30.w),
        _itemView('转办时间：', 'transferTime', isDate: true, readOnly: !_canChange),
        SizedBox(height: 30.w),
        _itemView('反馈时间：', 'feedbackTime', isDate: true, readOnly: !_canChange),
        SizedBox(height: 30.w),
        _itemView('风险等级：', 'riskLevel', readOnly: !_canChange),
        // _itemView('上级是否通报：', 'description'),
        SizedBox(height: 30.w),
        _radioView(tag),
        SizedBox(height: 30.w),
        _tongBaoView(),
        SizedBox(height: 30.w),
      ],
    );
  }

  int _selectRadio = 1;
  Widget _tongBaoView() {
    return Visibility(
        visible: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _itemView('通报时间：', 'superiorNotificationTime',
                isDate: true, readOnly: !_canChange),
            SizedBox(height: 30.w),
            _itemView('回复上级时间：', 'replySuperiorTime',
                isDate: true, readOnly: !_canChange),
            SizedBox(height: 30.w),
          ],
        ));
  }

  GlobalKey<RadioGroupWidgetState> radioGroupWidgetKey = GlobalKey();

  Row _radioView(bool tag) {
    var radioGroupWidget = RadioGroupWidget(
      key: radioGroupWidgetKey,
      defaultSelectIndex: tag ? 0 : 1,
      list: const ['通报', '未通报'],
      change: _canChange
          ? (value) {
              setState(() {
                _selectRadio = value!;
              });
            }
          : null,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('上级是否通报：', style: _textStyle()),
        SizedBox(height: 30.w),
        radioGroupWidget,
      ],
    );
  }

  Widget thirdColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _itemView('领导批示时间：', 'leaderInstructionsTime',
            isDate: true, readOnly: !_canChange),
        SizedBox(height: 30.w),
        _itemView('领导姓名：', 'leaderName', isDate: false, readOnly: !_canChange),
        SizedBox(height: 30.w),
        _itemView('领导批示内容：', 'leaderInstructionsContent',
            isDate: false, readOnly: !_canChange, line: 6),
        leaderFiles?.isNotEmpty == true
            ? leaderFileItem('领导批示图片：', leaderFiles!)
            : const SizedBox(),
      ],
    );
  }

  Widget _itemView(String title, String key,
      {bool isDate = false, bool readOnly = true, int line = 1}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          line == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Config.loadDefaultTextStyle(),
          maxLines: line,
          softWrap: true,
        ),
        SizedBox(
            width: 213.w,
            child: isDate
                ? _dateInputView(key, readOnly)
                : _textField(key, readOnly: readOnly, line: line)),
      ],
    );
  }

  TextEditingController _controller(String key) {
    if (!mapController.containsKey(key)) {
      mapController[key] = TextEditingController();
    }
    return mapController[key]!;
  }

  String _defaultValue(String key) {
    switch (key) {
      case 'riskLevel':
        return _publicOpinionBean?.riskLevelString() ?? '';
      case 'description':
        return _publicOpinionBean?.description ?? "";
      case 'link':
        return _publicOpinionBean?.link ?? "";
      case 'mediaType':
        return _publicOpinionBean?.mediaType ?? "";
      case 'publishTime':
        return DateUtil.subDate(_publicOpinionBean?.publishTime ?? "");
      case 'transferTime':
        return DateUtil.subDate(_publicOpinionBean?.transferTime ?? "");
      case 'type':
        return _publicOpinionBean?.type ?? "";
      case 'findTime':
        return DateUtil.subDate(_publicOpinionBean?.findTime ?? "");
      case 'superiorNotificationTime':
        return DateUtil.subDate(
            _publicOpinionBean?.superiorNotificationTime ?? "");
      case 'feedbackTime':
        return DateUtil.subDate(_publicOpinionBean?.feedbackTime ?? "");

      case 'replySuperiorTime':
        return DateUtil.subDate(_publicOpinionBean?.replySuperiorTime ?? "");
      case 'leaderInstructionsTime':
        return DateUtil.subDate(
            _publicOpinionBean?.leaderInstructionsTime ?? "");

      case 'leaderName':
        return _publicOpinionBean?.leaderName ?? "";
      case 'leaderInstructionsContent':
        return _publicOpinionBean?.leaderInstructionsContent ?? "";
      default:
        return "";
    }
  }

  TextStyle _textStyle() => Config.loadDefaultTextStyle(
        color: Colors.black.withOpacity(0.85),
        fontWeight: FontWeight.w400,
      );
  TextField _textField(String key, {bool readOnly = false, int line = 1}) =>
      TextField(
        readOnly: readOnly,
        maxLines: line,
        minLines: line,
        toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
        controller: _controller(key),
        decoration: Config.defaultInputDecoration(),
        style: _textStyle(),
      );
  Widget _dateInputView(String key, readOnly) => Config.dateInputView(
        '年/月/日 时:分',
        _controller(key),
        readOnly: readOnly,
        type: DateTimePickerType.dateTime,
      );
  // 图文信息 列表
  Widget fileItem(String data, List list) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.w),
      child: Row(
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
            width: 344.w,
            crossAxisCount: 2,
          ),
        ],
      ),
    );
  }

  Widget leaderFileItem(String data, List list) {
    String path = "${ServiceHttp.parentUrl}/${list.first['path']}";
    String name = list.first['description'];
    // String type = FileInfoBean.fileType(path);
    String endString = name;
    if (!name.contains('.')) {
      int pointIndex = path.lastIndexOf('.');
      if (pointIndex > -1) {
        endString = name + path.substring(pointIndex);
        // print("${endString}---urlPath=" + path);
      }
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 30.w, top: 30.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data,
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 213.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 45.w,
                  height: 43.w,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Config.launch(path);
                    },
                    child: Image.network(path),
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Text(
                    endString,
                    style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: Config.fontColorSelect,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitInfo() async {
    final mapData = await UserUtil.makeUserIdMap();
    final map = <String, dynamic>{}; //
    if (_selectRadio == 0) {
      String superiorNotificationTime =
          _controller('superiorNotificationTime').text;
      if (superiorNotificationTime.isEmpty) {
        toast('请选择通报时间');
        return;
      }
      // map['superiorNotificationTime'] = superiorNotificationTime;
      fillInfoForKey('superiorNotificationTime', map,
          _publicOpinionBean?.superiorNotificationTime ?? "");
      fillInfoForKey('replySuperiorTime', map,
          _publicOpinionBean?.replySuperiorTime ?? '');
    }

    fillInfoForKey('type', map, _publicOpinionBean?.type ?? '');
    fillInfoForKey('feedbackTime', map, _publicOpinionBean?.feedbackTime ?? '');
    fillInfoForKey('transferTime', map, _publicOpinionBean?.transferTime ?? '');
    fillInfoForKey(
        'riskLevel', map, _publicOpinionBean?.riskLevelString() ?? '');

    fillInfoForKey('leaderInstructionsTime', map,
        _publicOpinionBean?.leaderInstructionsTime ?? '');
    fillInfoForKey('leaderInstructionsContent', map,
        _publicOpinionBean?.leaderInstructionsContent ?? '');
    fillInfoForKey('leaderName', map, _publicOpinionBean?.leaderName ?? '');
    if (map.isNotEmpty) {
      map['id'] = widget.eventId;
      if (map.containsKey('riskLevel')) {
        String riskLevel = map['riskLevel'];
        if (riskLevel == '低') {
          map['riskLevel'] = 0;
        } else if (riskLevel == '中') {
          map['riskLevel'] = 1;
        } else if (riskLevel == '高') {
          map['riskLevel'] = 2;
        } else {
          toast('风险等级输入错误，只能是高、中、低');
          return;
        }
      }
      mapData["changeContent"] = map;
      ServiceHttp().post('/updateEvent', data: mapData, success: (data) {
        _publicOpinionBean = PublicOpinionBean.fromJson(data);
        initControllerValue();
        setState(() {
          _canChange = false;
        });
        showSuccessDialog('上传成功');
      });
    } else {
      toast('没有更改，无需提交');
    }
  }

  void fillInfoForKey(String key, map, target) {
    String text = _controller(key).text.trim();
    if (text != target) {
      map[key] = text;
    }
  }

  void requestDeleteEventInfo(context) async {
    final mapData = await UserUtil.makeUserIdMap();
    if (_publicOpinionBean == null ||
        DataUtil.isEmpty(_publicOpinionBean?.id)) {
      showNoticeDialog('信息丢失，暂无无法删除');
      return;
    }
    mapData['eventId'] = _publicOpinionBean!.id;
    ServiceHttp().post('/deleteEvent', data: mapData, success: (data) {
      showSuccessDialog('删除成功', dialogDismiss: () {
        Config.finishPage(context, refresh: true);
        Config.eventBus.fire(UpdateEventListBean()..needUpdate = true);
      });
    });
  }
}
