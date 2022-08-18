import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';
import 'package:public_opinion_manage_web/utils/str_util.dart';

typedef UploadFileCallback = void Function(
    FileInfoBean fileInfoBean, String desprice);

class AddPressWordFileWidget extends StatefulWidget {
  final UploadFileCallback uploadFileCallback;
  const AddPressWordFileWidget({Key? key, required this.uploadFileCallback})
      : super(key: key);

  @override
  State<AddPressWordFileWidget> createState() => _AddPressWordFileWidgetState();
}

class _AddPressWordFileWidgetState extends State<AddPressWordFileWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440.w,
      // height: 568.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30.w),
          Row(
            children: [
              SizedBox(width: 20.w),
              Text(
                '添加报刊附件',
                style: Config.loadDefaultTextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.85),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Config.finishPage(context);
                  },
                  tooltip: '取消添加附件弹窗',
                  icon: Icon(
                    Icons.close,
                    size: 30.w,
                    color: Colors.grey,
                  )),
            ],
          ),
          SizedBox(height: 20.w),
          SizedBox(
            width: 396.w,
            child: TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 5,
              decoration: Config.defaultInputDecoration(hintText: '添加文件关键词'),
            ),
          ),
          SizedBox(height: 21.w),
          Container(
            width: 396.w,
            height: 240.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(5.w),
            ),
            alignment: Alignment.center,
            child: _fileInfoBean == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.w),
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
                        '仅支持word文件上传',
                        style: Config.loadDefaultTextStyle(
                          fonstSize: 16.w,
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20.w),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 105.w,
                          height: 105.w,
                          color: const Color(0xFFD9D9D9),
                          child: Image.asset('images/ic_xls.png')),
                      SizedBox(width: 8.w),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fileInfoBean!.name!,
                              style: Config.loadDefaultTextStyle(
                                  color: const Color(0xFF333333),
                                  fonstSize: 19.w)),
                          Text("${formatNum(_fileInfoBean!.size! / 1204, 1)}K",
                              style: Config.loadDefaultTextStyle(
                                  color: const Color(0xFF333333),
                                  fonstSize: 19.w)),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          showDeleteDialog(context, 0);
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
                  ),
          ),
          SizedBox(height: 30.w),
          TextButton(
            onPressed: () => uploadFile(),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Config.fontColorSelect,
              textStyle:
                  Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
              fixedSize: Size(87.w, 43.w),
              padding: EdgeInsets.zero,
              minimumSize: const Size(1, 1),
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(context, index) {
    const typeS = '文件';
    showCenterNoticeDialog(context, contentString: '确定删除$typeS么？', onPress: () {
      setState(() {
        _fileInfoBean = null;
      });
    });
  }

  FileInfoBean? _fileInfoBean;
  void onPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['doc', 'docx', 'word'], type: FileType.custom);
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        // html.File file = html.File();
        final fileName = result.files.single.name;
        final fileBytes = result.files.single.bytes;
        final fileInfo = FileInfoBean("web_$fileName",
            bytes: fileBytes, name: fileName, size: result.files.single.size);
        _fileInfoBean = fileInfo;
        // setState(() {});
        // String text = String.fromCharCodes(fileBytes!);
        // final text = const Utf8Decoder().convert(fileBytes!);
        // result.files.single.path
      } else {
        // File file = File(result.files.single.path!);
        // String s = await file.readAsString(encoding: utf8);
        // print(s);
        _fileInfoBean = FileInfoBean(result.files.single.path!);
      }
    } else {}
  }

  void uploadFile() {
    if (null == _fileInfoBean) {
      toast('请选择需要上传的word文件');
      return;
    }
    String describe = _controller.text;
    if (describe.isEmpty) {
      toast('请添加文件关键词');
      return;
    }
    widget.uploadFileCallback.call(_fileInfoBean!, describe);
  }
}
