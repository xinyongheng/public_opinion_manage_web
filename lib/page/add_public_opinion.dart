import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'dart:io';

class AddPublicOpinion extends StatefulWidget {
  const AddPublicOpinion({Key? key}) : super(key: key);

  @override
  State<AddPublicOpinion> createState() => _AddPublicOpinionState();
}

class _AddPublicOpinionState extends State<AddPublicOpinion> {
  final _controllerMap = <String, TextEditingController>{};

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
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          inputGroupView('舆情名称：', '名称', 'title'),
          inputGroupView('舆情链接：', '链接', 'link'),
          inputGroupView('舆情名称：', '名称', 'title'),
          CachedNetworkImage(
            imageUrl:
                "https://s.cn.bing.net/th?id=OIP-C.P3NSGTdAYdyqy5zJpb5QXQHaEo&w=316&h=197&c=8&rs=1&qlt=90&o=6&dpr=1.25&pid=3.1&rm=2",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          CachedNetworkImage(
            imageUrl:
                "data:image/jpeg;base64,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",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          TextButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null && result.files.isNotEmpty) {
                  if (kIsWeb) {
                    final fileName = result.files.single.name;
                    final fileBytes = result.files.single.bytes;
                    // String text = String.fromCharCodes(fileBytes!);
                    final text = const Utf8Decoder().convert(fileBytes!);
                    print(text);
                  } else {
                    File file = File(result.files.single.path!);
                    String s = await file.readAsString(encoding: utf8);
                    print(s);
                  }
                } else {
                  // User canceled the picker
                }
              },
              child: const Text('提交')),
        ],
      ),
    );
  }

  /// 舆情相关者
  /// 上下排列
  Widget publicOpinionInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        inputGroupView("事件名称：", "事件名称", 'title'),
        inputGroupView("原文链接：", "原文链接", 'link'),
        inputGroupView("媒体类型：", "媒体类型", 'liknType'),
      ],
    );
  }

  /// 原链接图文信息
  Widget linkFileInfo() {
    Widget titleView = firstTitle('原文图文链接：');
    Widget listView = Wrap(
      direction: Axis.horizontal,
    );
    return listView;
  }

  /// 舆情处理
  /// 提交
  ///
  ///

  /// 标题+输入
  Widget inputGroupView(title, explain, key, {double? width}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [firstTitle(title), editText(explain, key, width: width)],
    );
  }

  /// 标题
  Widget firstTitle(title) => Text(title, style: Config.loadFirstTextStyle());

  /// 输入
  Widget editText(explain, key, {double? width}) {
    return Padding(
      padding: EdgeInsets.only(right: 30.sp),
      child: SizedBox(
        width: width ?? 300.sp,
        child: TextField(
          controller: _controllerMap[key],
          maxLength: 100,
          maxLines: 1,
          scrollPadding: EdgeInsets.all(0.sp),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            // label: const Icon(Icons.people),
            // labelText: '请输入$explain',
            border: const OutlineInputBorder(gapPadding: 0),
            contentPadding: EdgeInsets.all(0.sp),
            // helperText: '手机号',
            hintText: "请输入$explain",
            // errorText: '错误',
          ),
        ),
      ),
    );
  }

  final _publicOpinionFiles = [];
  // 舆情基本信息
  Widget publicOpinionFiles() {
    Icons.record_voice_over;
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return index == _publicOpinionFiles.length
            ? Container(
                alignment: Alignment.center,
                child: const Icon(Icons.add),
              )
            : SizedBox(
                child: Image.asset(_publicOpinionFiles[index]),
              );
      },
      itemCount: _publicOpinionFiles.length + 1,
    );
  }
}
