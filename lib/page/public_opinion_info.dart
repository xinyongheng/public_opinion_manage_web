import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/file_list_view.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class PublicOpinionInfoPage extends StatefulWidget {
  const PublicOpinionInfoPage({Key? key}) : super(key: key);

  @override
  State<PublicOpinionInfoPage> createState() => _PublicOpinionInfoPageState();
}

class _PublicOpinionInfoPageState extends State<PublicOpinionInfoPage> {
  bool _canChange = false;
  final mapController = <String, TextEditingController>{};
  PublicOpinionBean? _publicOpinionBean;
  List? files;
  @override
  void initState() {
    super.initState();
    _loadEventInfo();
  }

  void _loadEventInfo() async {
    final map = UserUtil.makeUserIdMap();
    ServiceHttp().post('/loadEventInfo', data: map, isData: false,
        success: (data) {
      setState(() {
        _publicOpinionBean = PublicOpinionBean.fromJson(data['data']);
        files = data['files'];
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                          firstColumn(),
                          secondColumn(),
                          thirdColumn(),
                        ],
                      ),
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
                            primary: Colors.white,
                            backgroundColor: Config.fontColorSelect,
                            minimumSize: const Size(1, 1),
                            fixedSize: Size(87.w, 43.w),
                            textStyle: Config.loadDefaultTextStyle(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.w)),
                          ),
                          child: Text(!_canChange ? '编辑' : '保存'))
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

  Widget outsideWidget(double width, {required Widget child}) {
    return SizedBox(
      width: width,
      child: child,
    );
  }

  firstColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _itemView('事件名称：', 'description'),
        _itemView('原文链接：', 'link'),
        Visibility(
            visible: files?.isNotEmpty == true,
            child: fileItem('原文图文信息：', files!)),
        _itemView('媒体类型：', 'mediaType'),
        _itemView('发布时间：', 'publishTime'),
      ],
    );
  }

  secondColumn() {
    bool tag = _publicOpinionBean?.superiorNotificationTime?.isNotEmpty == true;
    if (!_canChange) {
      _selectRadio = tag ? 0 : 1;
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _itemView('舆情类别：', 'type'),
      _itemView('发现时间：', 'findTime'),
      _itemView('反馈时间：', 'feedbackTime', isDate: true, readOnly: _canChange),
      // _itemView('上级是否通报：', 'description'),
      _radioView(tag),
      _tongBaoView(),
    ]);
  }

  int _selectRadio = 1;
  Widget _tongBaoView() {
    return Visibility(
        visible: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _itemView('通报时间：', 'superiorNotificationTime',
                isDate: true, readOnly: _canChange),
            _itemView('回复上级时间：', 'superiorNotificationTime',
                isDate: true, readOnly: _canChange),
          ],
        ));
  }

  Row _radioView(bool tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('上级是否通报：', style: _textStyle()),
        RadioGroupWidget(
          defaultSelectIndex: tag ? 0 : 1,
          list: const ['通报', '未通报'],
          change: _canChange
              ? (value) {
                  setState(() {
                    _selectRadio = value!;
                  });
                }
              : null,
        )
      ],
    );
  }

  thirdColumn() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _itemView('领导批示时间：', 'leaderInstructionsTime',
            isDate: true, readOnly: _canChange),
        _itemView('领导姓名：', 'leaderName', isDate: false, readOnly: _canChange),
        _itemView('领导批示内容：', 'leaderInstructionsContent',
            isDate: true, readOnly: _canChange),
      ],
    );
  }

  Widget _itemView(String title, String key,
      {bool isDate = false, bool readOnly = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Config.loadDefaultTextStyle(),
        ),
        SizedBox(
            width: 213.w,
            child: isDate ? _dateInputView(key) : _textField(key)),
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
      case 'description':
        return _publicOpinionBean?.description ?? "";
      case 'link':
        return _publicOpinionBean?.link ?? "";
      case 'mediaType':
        return _publicOpinionBean?.mediaType ?? "";
      case 'publishTime':
        return _publicOpinionBean?.publishTime ?? "";
      case 'type':
        return _publicOpinionBean?.type ?? "";
      case 'findTime':
        return _publicOpinionBean?.findTime ?? "";
      case 'superiorNotificationTime':
        return _publicOpinionBean?.superiorNotificationTime ?? "";
      case 'feedbackTime':
        return _publicOpinionBean?.feedbackTime ?? "";

      case 'replySuperiorTime':
        return _publicOpinionBean?.replySuperiorTime ?? "";
      case 'leaderInstructionsTime':
        return _publicOpinionBean?.leaderInstructionsTime ?? "";

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
  Widget _dateInputView(String key) =>
      Config.dateInputView('年/月/日', _controller(key));
  // 图文信息 列表
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
          width: 344.w,
          crossAxisCount: 2,
        ),
      ],
    );
  }

  void submitInfo() async {
    final map = await UserUtil.makeUserIdMap();
    if (_selectRadio == 1) {
      String superiorNotificationTime =
          _controller('superiorNotificationTime').text;
      if (superiorNotificationTime.isEmpty) {
        toast('请选择通报时间');
        return;
      }
      map['superiorNotificationTime'] = superiorNotificationTime;
      fillInfoForKey('replySuperiorTime', map,
          _publicOpinionBean?.replySuperiorTime ?? '');
    }
    fillInfoForKey('feedbackTime', map, _publicOpinionBean?.feedbackTime ?? '');

    fillInfoForKey('leaderInstructionsTime', map,
        _publicOpinionBean?.leaderInstructionsTime ?? '');
    fillInfoForKey('leaderInstructionsContent', map,
        _publicOpinionBean?.leaderInstructionsContent ?? '');
    fillInfoForKey('leaderName', map, _publicOpinionBean?.leaderName ?? '');
    if (map.length > 1) {
      ServiceHttp().post('/updateEvent', data: map, success: (data) {
        showSuccessDialog('上传成功');
        setState(() {
          _publicOpinionBean = PublicOpinionBean.fromJson(data);
        });
      });
    } else {
      toast('没有更改，无需提交');
    }
  }

  void fillInfoForKey(String key, map, target) {
    String text = _controller(key).text;
    if (text != target) {
      map[key] = text;
    }
  }
}