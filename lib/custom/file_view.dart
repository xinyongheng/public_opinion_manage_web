import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';

class FileView extends StatefulWidget {
  FileView({Key? key}) : super(key: key);
  final list = <FileInfoBean>[];

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  late List<FileInfoBean> _list;

  @override
  void initState() {
    super.initState();
    _list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15.sp,
        crossAxisSpacing: 15.sp,
        childAspectRatio: 10 / 8,
      ),
      itemBuilder: buildItem,
      itemCount: _list.length + 1,
      shrinkWrap: true,
    );
  }

  Widget buildItem(content, index) {
    return index < _list.length
        ? Container(
            width: 100.sp,
            height: 80.sp,
            // color: Colors.white24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(color: Colors.grey),
            ),
            child: FileInfoBean.getTagIcon(_list[index]),
          )
        : InkWell(
            onTap: addSelectFile,
            child: Container(
              width: 100.sp,
              height: 80.sp,
              decoration: BoxDecoration(
                color: Colors.white10,
                border: Border.all(color: Colors.grey),
              ),
              child: Icon(
                Icons.add,
                size: 50.sp,
                color: Colors.grey,
              ),
            ),
          );
  }

  void addSelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        // html.File file = html.File();
        final fileName = result.files.single.name;
        final fileBytes = result.files.single.bytes;
        final fileInfo =
            FileInfoBean("web_$fileName", bytes: fileBytes, name: fileName);
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
        final fileInfo = FileInfoBean(result.files.single.path!);
        setState(() {
          _list.add(fileInfo);
        });
      }
    } else {}
  }
}
