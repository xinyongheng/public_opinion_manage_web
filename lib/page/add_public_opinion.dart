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
                    String s = await file.readAsString(encoding:utf8);
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
    CachedNetworkImage(
      imageUrl: "http://via.placeholder.com/350x150",
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    CachedNetworkImage(
      imageUrl: "http://via.placeholder.com/350x150",
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return index == _publicOpinionFiles.length
            ? Container(
                alignment: Alignment.center,
                child: Icon(Icons.add_a_photo),
              )
            : SizedBox(
                child: Image.asset(_publicOpinionFiles[index]),
              );
      },
      itemCount: _publicOpinionFiles.length + 1,
    );
  }

  // 舆情相关者
  // 舆情处理
  // 提交
}
