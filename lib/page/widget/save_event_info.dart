import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/custom/select_file.dart';
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(width: 50.sp),
          // Expanded(
          //   flex: 1,
          //   child: secondColumn(),
          // ),
          // SizedBox(width: 100.w),
          // Expanded(
          //   flex: 1,
          //   child: firstColumn(),
          // ),
          // SizedBox(width: 100.w),
          Padding(
            padding: EdgeInsets.fromLTRB(43.w, 32.w, 0, 39.w),
            child: Text('舆情录入', style: Config.loadFirstTextStyle()),
          ),
          ...firstColumn(),
          ...secondColumn(),
          Row(
            children: [
              SizedBox(width: 403.w),
              Opacity(opacity: 0, child: titleView('原文图文信息：')),
              TextButton(
                onPressed: () => saveEventInfo(),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    textStyle: Config.loadDefaultTextStyle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    // fixedSize: Size(112.sp, 43.sp),
                    padding:
                        EdgeInsets.symmetric(vertical: 14.w, horizontal: 19.w)),
                child: const Text('录入事件'),
              ),
            ],
          ),
          spaceWidget(),
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
  List<Widget> firstColumn() {
    return [
      childTextItems('问题描述：', '问题描述', 'description', min: 3, max: 5),
      SizedBox(height: 43.w),
      childTextItems('发帖主题：', '发帖主题', 'author'),
      SizedBox(height: 43.w),
      childDateItems('发布时间：', '发布时间', 'publishTime'),
      SizedBox(height: 43.w),
      childAutocomplete('舆情类别：', '舆情类别', typeList),
      SizedBox(height: 43.w),
      childDateItems('发现时间：', '发现时间', 'findTime'),
      SizedBox(height: 43.w),
      childRadioItems('上级是否通报：'),
      Visibility(visible: _isSuperiorNotice, child: SizedBox(height: 43.w)),
      Visibility(
        visible: _isSuperiorNotice,
        child: childDateItems('通报时间：', '通报时间', 'superiorNotificationTime'),
      ),
    ];
  }

  Widget titleView(data) => Padding(
        padding: EdgeInsets.symmetric(vertical: 7.w),
        child: Text(data, style: Config.loadDefaultTextStyle()),
      );

  Widget childAutocomplete(title, explain, List<String> searchList) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 440.w),
          titleView(title),
          SizedBox(
            width: 624.w,
            child: Autocomplete(
              optionsBuilder: (textEditingValue) {
                final v = textEditingValue.text;
                final candidates = searchList;
                return candidates.where(
                    (String c) => c.toUpperCase().contains(v.toUpperCase()));
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                // return TextFormField(
                //   controller: textEditingController,
                //   focusNode: focusNode,
                //   onFieldSubmitted: (String value) {
                //     onFieldSubmitted();
                //   },
                // );
                _controllerMap['type'] = textEditingController;
                return TextFormField(
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
                      borderRadius: BorderRadius.circular(5.sp),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(5.sp),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
                    counterText: '',
                    isDense: true,
                    hintText: "请输入$explain",
                    hintStyle: Config.loadDefaultTextStyle(color: borderColor),
                  ),
                );
              },
            ),
          ),
          spaceWidget(),
        ],
      );
  final Color borderColor = const Color.fromRGBO(0, 0, 0, 0.15);
  Widget childTextItems(title, explain, key, {int min = 1, int max = 1}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 440.w),
          titleView(title),
          SizedBox(
            width: 624.w,
            child: TextField(
              controller: loadcontroller(key),
              maxLines: max,
              minLines: min,
              scrollPadding: EdgeInsets.zero,
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(5.sp),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(5.sp),
                  borderSide: BorderSide(color: borderColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
                counterText: '',
                isDense: true,
                hintText: "请输入$explain",
                hintStyle: Config.loadDefaultTextStyle(color: borderColor),
              ),
            ),
          ),
          spaceWidget(),
        ],
      );
  Widget childDateItems(title, explain, key) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 440.w),
        titleView(title),
        SizedBox(
          width: 624.w,
          child: DateTimePicker(
            controller: loadcontroller(key),
            type: DateTimePickerType.date,
            dateMask: 'yyyy-MM-dd',
            firstDate: DateTime(1992),
            lastDate: DateTime.now(),
            textInputAction: TextInputAction.next,
            style: Config.loadDefaultTextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(5.sp),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(5.sp),
                borderSide: BorderSide(color: borderColor),
              ),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
              hintText: "请输入$explain（年/月/日）",
              hintStyle: Config.loadDefaultTextStyle(color: borderColor),
              // errorText: '错误',
            ),
          ),
        ),
        spaceWidget(),
      ]);
  Widget childRadioItems(title) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 440.w),
        titleView(title),
        RadioGroupWidget(
          list: const ['通报', '为通报'],
          change: (int? value) {
            setState(() {
              _isSuperiorNotice = value! == 0;
            });
          },
        ),
        spaceWidget(),
      ]);
  Widget spaceWidget() => SizedBox(width: 50.sp, height: 50.sp);
  List<Widget> secondColumn() {
    if (_listLink.isEmpty) {
      _listLink.add(TextEditingController());
    }
    if (_listMediaType.isEmpty) {
      _listMediaType.add(TextEditingController());
    }
    return [
      SizedBox(height: 43.w),
      titleAddIconView('事件链接：', '请输入事件链接', _listLink.first, () {
        setState(() {
          _listLink.add(TextEditingController());
        });
      }),
      SizedBox(height: 25.sp),
      loadListView('事件链接', _listLink),
      spaceWidget(),
      titleAddIconView('媒体类型：', '请输入媒体类型', _listMediaType.first, () {
        setState(() {
          _listMediaType.add(TextEditingController());
        });
      }),
      SizedBox(height: 25.sp),
      loadListView('事件链接', _listMediaType),
      spaceWidget(),
      titleFileView('原文图文信息：'),
      spaceWidget(),
    ];
  }

  final _listLink = <TextEditingController>[];
  final _listMediaType = <TextEditingController>[];

  titleAddIconView(title, hintText, controller, onPressed) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 440.w),
          titleView(title),
          SizedBox(
            width: 624.w,
            child: TextField(
              controller: controller,
              maxLines: 1,
              minLines: 1,
              scrollPadding: EdgeInsets.zero,
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(5.sp),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(5.sp),
                  borderSide: BorderSide(color: borderColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
                counterText: '',
                isDense: true,
                hintText: hintText,
                hintStyle: Config.loadDefaultTextStyle(color: borderColor),
              ),
            ),
          ),
          SizedBox(width: 31.w),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: onPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 19.sp, color: Config.fontColorSelect),
                  SizedBox(width: 8.sp),
                  Text(
                    '添加',
                    style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect),
                  ),
                ],
              ),
            ),
          )
        ],
      );
  ListView loadListView(String explain, List<TextEditingController> list) =>
      ListView.separated(
          itemCount: list.length - 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(width: 440.w),
                Opacity(
                  opacity: 0,
                  child: titleView('原文链接：'),
                ),
                SizedBox(
                  width: 624.w,
                  child: TextField(
                    controller: list[index],
                    maxLines: 1,
                    minLines: 1,
                    scrollPadding: EdgeInsets.all(0.sp),
                    textInputAction: TextInputAction.next,
                    style: Config.loadDefaultTextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(5.sp),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(5.sp),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 14.w, horizontal: 16.w),
                      counterText: '',
                      isDense: true,
                      hintText: "请输入$explain-${index + 2}",
                      hintStyle:
                          Config.loadDefaultTextStyle(color: borderColor),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                IconButton(
                    onPressed: () {
                      setState(() {
                        list.removeAt(index);
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.blue,
                      size: 20.w,
                    )),
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
  final _fileView = FileListWidget();
  Widget titleFileView(title) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 403.w),
            titleView(title),
            _fileView,
          ]);
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
