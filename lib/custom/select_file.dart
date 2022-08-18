import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';
import 'package:public_opinion_manage_web/utils/str_util.dart';

///添加本地文件
class AddFileWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String explain;
  final double width;
  final double height;
  const AddFileWidget({
    Key? key,
    required this.onPressed,
    required this.explain,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AspectRatio(aspectRatio: null,);
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onPressed,
            child: Image.asset(
              'images/upload.png',
              width: 105.w,
              height: 105.w,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              primary: Config.fontColorSelect,
              backgroundColor: Colors.white,
              fixedSize: Size(150.w, 44.w),
              padding: EdgeInsets.zero,
              textStyle: Config.loadDefaultTextStyle(),
            ),
            child: const Text('点击上传文件'),
          ),
          Text(
            explain,
            style: Config.loadDefaultTextStyle(fonstSize: 16.w),
          )
        ],
      ),
    );
  }
}

class FileListWidget extends StatefulWidget {
  final List<FileInfoBean> list = <FileInfoBean>[];
  final String explain;
  final double? width;
  final double? height;
  final List<String>? allowedExtensions;
  final int? maxSize;
  FileListWidget({
    Key? key,
    this.explain = '支持上传图片，视频，word的doc，excel以及文本txt',
    this.width,
    this.height,
    this.allowedExtensions,
    this.maxSize,
  })  : assert(maxSize == null || maxSize > 0),
        super(key: key);

  @override
  State<FileListWidget> createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  // final List _list = <FileInfoBean>[];
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? AddFileWidget(
            onPressed: () {
              addSelectFile();
            },
            explain: widget.explain,
            width: widget.width ?? 624.w,
            height: widget.height ?? 245.w,
          )
        : listFileView();
  }

  Widget listFileView() {
    return SizedBox(
      width: 689.w,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 37.w,
          thickness: 37.w,
          color: Colors.transparent,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == widget.list.length) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 25.w, color: Config.fontColorSelect),
                // SizedBox(width: 5.sp),
                TextButton(
                  onPressed: () {
                    addSelectFile();
                  },
                  style: TextButton.styleFrom(
                    primary: Config.fontColorSelect,
                    backgroundColor: Colors.white,
                    fixedSize: Size(80.w, 29.w),
                    padding: EdgeInsets.zero,
                    textStyle: Config.loadDefaultTextStyle(),
                  ),
                  child: const Text('上传文件'),
                )
              ],
            );
          }
          final item = widget.list[index];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => imageClick(item),
                child: Container(
                    width: 45.w,
                    height: 45.w,
                    color: const Color(0xFFD9D9D9),
                    child: imageWidget(item)),
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name!,
                      style: Config.loadDefaultTextStyle(
                          color: const Color(0xFF333333), fonstSize: 19.w)),
                  Text("${formatNum(item.size! / 1204, 1)}K",
                      style: Config.loadDefaultTextStyle(
                          color: const Color(0xFF333333), fonstSize: 19.w)),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  showDeleteDialog(context, index);
                },
                style: TextButton.styleFrom(
                  primary: Config.fontColorSelect,
                  backgroundColor: Colors.white,
                  fixedSize: Size(40.w, 29.w),
                  padding: EdgeInsets.zero,
                  textStyle: Config.loadDefaultTextStyle(),
                ),
                child: const Text('删除'),
              ),
            ],
          );
        },
        itemCount: widget.list.length + 1,
      ),
    );
  }

  void imageClick(FileInfoBean bean) {
    if (bean.type != 'image') {
      toast('不支持预览');
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('预览', style: Config.loadDefaultTextStyle()),
            content: Container(
              width: 450.w,
              height: 450.w,
              color: const Color(0xFFD9D9D9),
              child: Image.memory(bean.bytes!),
            ),
          );
        });
  }

  void showDeleteDialog(context, index) {
    const typeS = '文件';
    showCenterNoticeDialog(context, contentString: '确定删除第${index + 1}个$typeS么？',
        onPress: () {
      setState(() {
        widget.list.removeAt(index);
      });
    });
  }

  Image imageWidget(FileInfoBean bean) {
    if (bean.type == 'image') {
      return Image.memory(bean.bytes!);
    }
    if (bean.type == 'video') {
      return Image.asset('images/ic_txt.png');
    }
    return Image.asset('images/ic_xls.png');
  }

  void addSelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: widget.allowedExtensions, type: FileType.custom);
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        // html.File file = html.File();
        final fileName = result.files.single.name;
        final fileBytes = result.files.single.bytes;
        final fileInfo = FileInfoBean("web_$fileName",
            bytes: fileBytes, name: fileName, size: result.files.single.size);
        setState(() {
          widget.list.add(fileInfo);
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
          widget.list.add(fileInfo);
        });
      }
    } else {}
  }
}
