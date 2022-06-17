import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';

class FileView extends StatefulWidget {
  const FileView({Key? key}) : super(key: key);

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  final _list = <FileInfo>[];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: buildItem,
      itemCount: _list.length + 1,
    );
  }

  Widget buildItem(content, index) {
    return _list.isEmpty
        ? Container(
            width: 100.sp,
            height: 80.sp,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 40.sp,
              color: Colors.blue,
            ),
          )
        : InkWell(
            onTap: addSelectFile,
            child: SizedBox(
              width: 100.sp,
              height: 80.sp,
              child: Icon(
                Icons.add,
                size: double.infinity,
                color: Colors.blue,
              ),
            ),
          );
  }

  void addSelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        final fileName = result.files.single.name;
        final fileBytes = result.files.single.bytes;
        final fileInfo = FileInfo("web_$fileName", bytes: fileBytes);
        setState(() {
          _list.add(fileInfo);
        });
        // String text = String.fromCharCodes(fileBytes!);
        // final text = const Utf8Decoder().convert(fileBytes!);
        // result.files.single.path
      } else {
        // File file = File(result.files.single.path!);
        // String s = await file.readAsString(encoding: utf8);
        // print(s);
        final fileInfo = FileInfo(result.files.single.path!);
        setState(() {
          _list.add(fileInfo);
        });
      }
    } else {}
  }
}
