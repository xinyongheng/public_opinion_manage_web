import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

import 'package:public_opinion_manage_web/custom/file_view.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';

class AddPublicOpinion extends StatefulWidget {
  const AddPublicOpinion({Key? key}) : super(key: key);

  @override
  State<AddPublicOpinion> createState() => _AddPublicOpinionState();
}

class _AddPublicOpinionState extends State<AddPublicOpinion> {
  final _controllerMap = <String, TextEditingController>{};
  late FileView _fileView;

  //上级是否通报
  bool _isSuperiorNotice = true;

  // late List<Widget> superiorNoticeViews;
  @override
  void initState() {
    super.initState();
    _controllerMap['link'] = TextEditingController();
    _controllerMap['title'] = TextEditingController();
    _controllerMap['create_time'] = TextEditingController();
    _controllerMap['find_time'] = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerMap.forEach((_, value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('舆情录入'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 100),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        publicOpinionInfo1(),
        publicOpinionInfo2(),
        CachedNetworkImage(
          imageUrl:
              "https://s.cn.bing.net/th?id=OIP-C.P3NSGTdAYdyqy5zJpb5QXQHaEo&w=316&h=197&c=8&rs=1&qlt=90&o=6&dpr=1.25&pid=3.1&rm=2",
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        CachedNetworkImage(
          imageUrl:
              "https://s.cn.bing.net/th?id=OIP-C.qQKiZmNZqM39tKUHPUAkIwHaE5&w=307&h=203&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        TextButton(
            onPressed: () {
              Config.toast('点击提交');
            },
            child: const Text('提交')),
      ],
    );
    // return ;
    // return FileView();
  }

  /// 舆情相关者1
  /// 上下排列
  Widget publicOpinionInfo1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...inputGroupView("事件名称：", "事件名称", 'title'),
        ...inputGroupView("原文链接：", "原文链接", 'link'),
        //图文信息
        ...linkFileInfo(),
        SizedBox(
          width: 100,
          height: 20.sp,
        ),
        ...inputGroupView("媒体类型：", "媒体类型", 'liknType'),
        ...inputGroupView("发布时间：", "发布时间", 'linkPublishTime'),
      ],
    );
  }

  /// 舆情相关者2
  Widget publicOpinionInfo2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...inputGroupView('舆情类别：', "舆情类别", 'publicOpinionType'),
        ...inputGroupView('发现时间：', "发现时间", 'findTime'),
        ...superiorNotice(),
      ],
    );
  }

  /// 原链接图文信息
  List<Widget> linkFileInfo() {
    Widget titleView = firstTitle('原文图文链接：');
    _fileView = FileView();
    return [
      titleView,
      Container(
        width: 300.sp,
        // height: 200.sp,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
          child: _fileView,
        ),
      ),
    ];
  }

  late RadioGroup radioGroup;
  late Offstage offstage;

  List<Widget> superiorNotice() {
    radioGroup = RadioGroup(
      list: const ['通报', '未通报'],
      changeListener: (int v) {
        setState(() {
          _isSuperiorNotice = (v == 0);
          print(radioGroup.groupValue);
        });
      },
    );
    offstage = Offstage(
      offstage: !_isSuperiorNotice,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...inputGroupView('上级通报时间：', "上级通报时间", 'superiorNoticeTime')
        ],
      ),
    );
    final arr = <Widget>[
      firstTitle('上级是否通报：'),
      Padding(
        padding: EdgeInsets.all(20.sp),
        child: radioGroup,
      ),
      offstage,
    ];

    return arr;
  }

  /// 提交
  ///
  ///

  /// 标题+输入
  List<Widget> inputGroupView(title, explain, key, {double? width}) {
    return [firstTitle(title), editText(explain, key, width: width)];
  }

  /// 标题
  Widget firstTitle(title) => Text(title, style: Config.loadFirstTextStyle());

  /// 输入
  Widget editText(explain, key, {double? width}) {
    return Padding(
      padding: EdgeInsets.only(right: 30.sp),
      child: SizedBox(
        width: width ?? 300.sp,
        height: 80.sp,
        child: Padding(
          padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
          child: TextField(
            controller: _controllerMap[key],
            maxLength: 100,
            maxLines: 1,
            scrollPadding: EdgeInsets.all(0.sp),
            textInputAction: TextInputAction.next,
            style: Config.loadDefaultTextStyle(color: Colors.black),
            decoration: InputDecoration(
              // label: const Icon(Icons.people),
              // labelText: '请输入$explain',
              border: const OutlineInputBorder(gapPadding: 0),
              contentPadding: EdgeInsets.only(
                left: 5.sp,
                right: 20.sp,
              ),
              // helperText: '手机号',
              hintText: "请输入$explain",
              hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
              // errorText: '错误',
            ),
          ),
        ),
      ),
    );
  }
}
