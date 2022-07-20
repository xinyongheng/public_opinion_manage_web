import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/file_view.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/service/service.dart';

class SaveEventInfoWidget extends StatefulWidget {
  final String token;
  const SaveEventInfoWidget({Key? key, required this.token}) : super(key: key);

  @override
  State<SaveEventInfoWidget> createState() => _SaveEventInfoWidgetState();
}

class _SaveEventInfoWidgetState extends State<SaveEventInfoWidget> {
  //上级是否通报
  bool _isSuperiorNotice = false;
  final _controllerMap = <String, TextEditingController>{};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 50.sp),
          Expanded(
            flex: 1,
            child: secondColumn(),
          ),
          SizedBox(width: 100.w),
          Expanded(
            flex: 1,
            child: firstColumn(),
          ),
          SizedBox(width: 100.w),
          // secondColumn(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerMap.forEach((_, value) => value.dispose());
    for (var element in _listLink) {
      element.dispose();
    }
    for (var element in _listMediaType) {
      element.dispose();
    }
  }

  loadcontroller(String key) {
    if (!_controllerMap.containsKey(key)) {
      _controllerMap[key] = TextEditingController();
    }
    return _controllerMap[key]!;
  }

  final typeList = [
    '教育领域',
    '医疗领域',
    '房产领域',
    '金融领域',
    '涉军领域',
    '涉贫领域',
    '涉农领域',
    '涉法涉诉',
    '社会治安',
    '扫黑除恶',
    '市政管理',
    '城乡建设',
    '安全生产',
    '环境保护',
    '疫情防控',
    '拖欠农民工工资',
    '信访维权',
    '其他'
  ];
  firstColumn() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceWidget(),
          ...childTextItems('问题描述：', '问题描述', 'description', min: 5, max: 5),
          ...childDateItems('发布时间：', '发布时间', 'publishTime'),
          ...childAutocomplete('舆情类别：', '舆情类别', typeList),
          ...childDateItems('发现时间：', '发现时间', 'findTime'),
          ...childRadioItems('上级是否通报：'),
          Visibility(
            visible: _isSuperiorNotice,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childDateItems(
                    '通报时间：', '通报时间', 'superiorNotificationTime')),
          ),
          TextButton(
            onPressed: () => saveEventInfo(),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              textStyle: Config.loadDefaultTextStyle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              fixedSize: Size(700.sp, Config.defaultSize * 3),
            ),
            child: const Text('录入事件'),
          ),
          spaceWidget(),
        ],
      ),
    );
  }

  Widget titleView(data) => Text(data,
      style: Config.loadDefaultTextStyle(fonstSize: Config.secondSize));

  List<Widget> childAutocomplete(title, explain, List<String> searchList) => [
        titleView(title),
        SizedBox(width: 25.sp, height: 25.sp),
        Autocomplete(
          /* optionsViewBuilder:(context, onSelected, options) {
            return 
          }, */
          optionsBuilder: (textEditingValue) {
            final v = textEditingValue.text;
            final candidates = searchList;
            return candidates
                .where((String c) => c.toUpperCase().contains(v.toUpperCase()));
          },
        ),
        spaceWidget(),
      ];
  List<Widget> childTextItems(title, explain, key,
          {int min = 1, int max = 1}) =>
      [
        titleView(title),
        SizedBox(width: 25.sp, height: 25.sp),
        TextField(
          controller: loadcontroller(key),
          maxLines: max,
          minLines: min,
          scrollPadding: EdgeInsets.all(0.sp),
          textInputAction: TextInputAction.next,
          style: Config.loadDefaultTextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(gapPadding: 10.sp),
            contentPadding: EdgeInsets.all(10.sp),
            counterText: '',
            hintText: "请输入$explain",
            hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
          ),
        ),
        spaceWidget(),
      ];
  List<Widget> childDateItems(title, explain, key) => [
        titleView(title),
        SizedBox(width: 25.sp, height: 25.sp),
        DateTimePicker(
          controller: loadcontroller(key),
          type: DateTimePickerType.date,
          dateMask: 'yyyy-MM-dd',
          firstDate: DateTime(1992),
          lastDate: DateTime.now(),
          textInputAction: TextInputAction.next,
          style: Config.loadDefaultTextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: const OutlineInputBorder(gapPadding: 0),
            contentPadding: EdgeInsets.only(
              left: 5.sp,
              right: 20.sp,
            ),
            hintText: "请输入$explain",
            hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
            // errorText: '错误',
          ),
        ),
        spaceWidget(),
      ];
  childRadioItems(title) => [
        titleView(title),
        SizedBox(width: 25.sp, height: 25.sp),
        RadioGroupWidget(
          list: const ['通报', '为通报'],
          change: (int? value) {
            setState(() {
              _isSuperiorNotice = value! == 0;
            });
          },
        ),
        spaceWidget(),
      ];
  Widget spaceWidget() => SizedBox(width: 50.sp, height: 50.sp);
  secondColumn() {
    if (_listLink.isEmpty) {
      _listLink.add(TextEditingController());
    }
    if (_listMediaType.isEmpty) {
      _listMediaType.add(TextEditingController());
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceWidget(),
          titleAddIconView('事件链接：', () {
            setState(() {
              _listLink.add(TextEditingController());
            });
          }),
          SizedBox(height: 25.sp),
          loadListView('事件链接', _listLink),
          spaceWidget(),
          titleAddIconView('媒体类型：', () {
            setState(() {
              _listMediaType.add(TextEditingController());
            });
          }),
          SizedBox(height: 25.sp),
          loadListView('事件链接', _listMediaType),
          spaceWidget(),
          ...titleFileView('事件图文信息'),
          spaceWidget(),
        ],
      ),
    );
  }

  final _listLink = <TextEditingController>[];
  final _listMediaType = <TextEditingController>[];

  titleAddIconView(title, onPressed) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleView(title),
          const Spacer(flex: 2),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.white,
                textStyle: Config.loadDefaultTextStyle(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.sp))),
            child: const Text('添加'),
          ),
          const Spacer(flex: 1),
        ],
      );
  ListView loadListView(String explain, List<TextEditingController> list) =>
      ListView.separated(
          itemCount: list.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: list[index],
                    maxLines: 1,
                    minLines: 1,
                    scrollPadding: EdgeInsets.all(0.sp),
                    textInputAction: TextInputAction.next,
                    style: Config.loadDefaultTextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(gapPadding: 10.sp),
                      contentPadding: EdgeInsets.only(
                        left: 5.sp,
                        right: 20.sp,
                      ),
                      counterText: '',
                      hintText:
                          index > 0 ? "请输入$explain-$index" : "请输入$explain",
                      hintStyle:
                          Config.loadDefaultTextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 50.sp),
                Container(
                  width: 100.sp,
                  height: 50.sp,
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: index > 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            list.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.close, color: Colors.blue)),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 25.sp,
              thickness: 25.sp,
              color: Colors.transparent,
            );
          });
  final _fileView = FileView();
  titleFileView(title) => [
        titleView(title),
        SizedBox(height: 25.sp),
        _fileView,
      ];
  String loadText(String key) => _controllerMap[key]?.value.text ?? '';
  String splicingString(List<TextEditingController> list) {
    if (list.length < 2) return ',';
    String s = ',';
    for (int i = 1; i < list.length; i++) {
      String item = list[i].value.text;
      if (item.isNotEmpty) {
        s += '$item,';
      }
    }
    return s;
  }

  saveEventInfo() {
    String description = loadText('description');
    if (description.isEmpty) {
      return toast('请输入事件问题描述');
    }
    String publishTime = loadText('publishTime');
    if (publishTime.isEmpty) {
      return toast('请输入事件发布时间');
    }
    String type = loadText('type');
    if (type.isEmpty) {
      return toast('请输入事件舆情类型');
    }
    String findTime = loadText('findTime');
    if (findTime.isEmpty) {
      return toast('请输入事件发现时间');
    }
    String link = _listLink[0].value.text;
    if (link.isEmpty) {
      return toast('请输入事件链接');
    }
    String mediaType = _listMediaType[0].value.text;
    if (mediaType.isEmpty) {
      return toast('请输入事件媒体类型');
    }
    String linkOther = splicingString(_listLink);
    String mediaTypeOther = splicingString(_listMediaType);
    final Map map = <String, dynamic>{};
    if (_isSuperiorNotice) {
      String superiorNotificationTime = loadText('superiorNotificationTime');
      if (superiorNotificationTime.isEmpty) {
        return toast('请输入上级通报时间');
      }
      map['superiorNotificationTime'] = superiorNotificationTime;
    }
    map['description'] = description;
    map['publishTime'] = publishTime;
    map['type'] = type;
    map['findTime'] = findTime;
    map['link'] = link;
    map['mediaType'] = mediaType;
    if (linkOther != ',') {
      map['linkOther'] = linkOther;
    }
    if (mediaTypeOther != ',') {
      map['mediaTypeOther'] = mediaTypeOther;
    }
    if (_fileView.list.isEmpty) {
      showCenterNoticeDialog(
        context,
        title: '温馨提示',
        contentString: '确定不上传此事件相关的图文信息么？',
        onPress: () => requestInternet(map, false),
      );
    } else {
      requestInternet(map, true);
    }
  }

  void requestInternet(map, bool tag) {
    if (tag) {
      List arr = [];
      for (int i = 0; i < _fileView.list.length; i++) {
        final element = _fileView.list[i];

        arr.add(dio.MultipartFile.fromBytes(element.bytes!,
            filename: 'file-${i + 1}${element.name!}'));
      }
      map['file'] = arr;
    }
    ServiceHttp().post(
      '/saveEvent',
      data: dio.FormData.fromMap(map),
      success: (data) {
        showSuccessDialog('录入成功');
      },
    );
  }
}
