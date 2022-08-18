import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/select_file.dart';
import 'package:dio/dio.dart' as dio;
import 'package:public_opinion_manage_web/data/bean/old_press_word.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class HistoryPressFileWidget extends StatefulWidget {
  const HistoryPressFileWidget({Key? key}) : super(key: key);

  @override
  State<HistoryPressFileWidget> createState() => _HistoryPressFileWidgetState();
}

class _HistoryPressFileWidgetState extends State<HistoryPressFileWidget> {
  final _frontColor = Colors.black.withOpacity(0.85);
  final TextEditingController _filterController = TextEditingController();
  final List<OldPressWordFile> _list = <OldPressWordFile>[];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 35.w, top: 32.w, bottom: 46.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('舆情报刊',
                    style: Config.loadDefaultTextStyle(
                        color: Colors.black.withOpacity(0.45))),
                SizedBox(width: 10.w),
                Text('/',
                    style: Config.loadDefaultTextStyle(
                        color: Colors.black.withOpacity(0.45))),
                SizedBox(width: 10.w),
                Text('旧文件',
                    style: Config.loadDefaultTextStyle(color: _frontColor))
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 35.w),
              Text(
                '筛选条件：',
                style: Config.loadDefaultTextStyle(color: _frontColor),
              ),
              SizedBox(
                width: 213.w,
                child: TextField(
                  controller: _filterController,
                  decoration: Config.defaultInputDecoration(),
                  style: Config.loadDefaultTextStyle(),
                ),
              ),
              SizedBox(width: 44.w),
              TextButton(
                onPressed: () {
                  filterPress();
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Config.fontColorSelect,
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 7.w),
                  textStyle: Config.loadDefaultTextStyle(fonstSize: 19.w),
                ),
                child: const Text('确认'),
              ),
            ],
          ),
          SizedBox(height: 50.w),
          Padding(
            padding: EdgeInsets.only(left: 35.w),
            child: TextButton(
              onPressed: () {
                addFileDialog();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Config.fontColorSelect,
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.w),
                textStyle: Config.loadDefaultTextStyle(fonstSize: 19.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 19.sp, color: Colors.white),
                  const Text(' 添加旧文件'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.w, top: 20.w),
            child: listView(),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    return SizedBox(
      width: 1429.w,
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const Divider(height: 1.0, indent: 1, color: Color(0xFFE8E8E8)),
        itemBuilder: (context, index) {
          if (index == 0) return titleRowView();
          return listViewItem(index);
        },
        itemCount: _list.length + 1,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  final tableFrontSize = 16.w;
  Widget titleRowView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        tableView('序号', 70.w),
        tableView('文件名称', 647.w), //291
        tableView('文件上传时间', 175.w), //39
        Expanded(
          child: Container(
              width: double.infinity,
              height: 72.w,
              color: const Color(0xFFFAFAFA)),
        ),
        tableView('附件', 330.w), //150
      ],
    );
  }

  Text tableTitle(data) => Text(data,
      style: TextStyle(
        color: _frontColor,
        fontSize: tableFrontSize,
        fontWeight: FontWeight.w500,
      ));
  Widget tableView(data, width) => Container(
        width: width,
        height: 72.w,
        color: const Color(0xFFFAFAFA),
        alignment: Alignment.center,
        child: tableTitle(data),
      );
  TextStyle listViewItemTextStyle(color) => TextStyle(
        color: color,
        fontSize: tableFrontSize,
        fontWeight: FontWeight.w400,
      );
  Text listViewItemText(data) =>
      Text(data, style: listViewItemTextStyle(Colors.black.withOpacity(0.65)));
  Widget listViewItem(index) {
    final item = _list[index - 1];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        tableChildView(
            Container(
              width: 22.w,
              height: 22.w,
              color: Config.fontColorSelect,
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: listViewItemTextStyle(Colors.white),
              ),
            ),
            70.w),
        tableChildView(listViewItemText(item.wordName), 647.w),
        tableChildView(listViewItemText(item.utime), 175.w), //63
        const Spacer(),
        tableChildView(
            InkWell(
                onTap: () {
                  preReadWord(item.content!, item.path!);
                },
                child: Text('查看',
                    style: listViewItemTextStyle(Config.fontColorSelect))),
            330.w), //26
      ],
    );
  }

  Widget tableChildView(Widget child, double width) => Container(
        width: width,
        height: 72.w,
        alignment: Alignment.center,
        child: child,
      );

  @override
  void initState() {
    super.initState();
  }

  final _fileListWidget = FileListWidget(
    width: 396.w,
    height: 240.w,
    explain: '仅支持上传word文档，一次最多上传10个文件',
    allowedExtensions: const ['doc', 'docx', 'word'],
  );
  void addFileDialog() {
    showCenterNoticeDialog(context,
        barrierDismissible: false,
        title: '添加历史旧报刊',
        contentWidget: Container(
          child: _fileListWidget,
        ), onPress: () {
      sureUploadFile(context);
    });
  }

  void sureUploadFile(context) async {
    final Map<String, dynamic> map = <String, dynamic>{};

    final list = _fileListWidget.list;
    if (list.isEmpty) {
      toast('请选择需要上传的word文件');
      return;
    }
    if (list.length > 10) {
      toast('最多同时上传10个文件');
      return;
    }
    map['userId'] = await UserUtil.getUserId();
    List arr = [];
    for (int i = 0; i < list.length; i++) {
      final element = list[i];
      arr.add(
          dio.MultipartFile.fromBytes(element.bytes!, filename: element.name!));
    }
    map['file'] = arr;
    ServiceHttp().post(
      '/addOldPressWord',
      data: dio.FormData.fromMap(map),
      success: (data) {
        showSuccessDialog('录入成功', dialogDismiss: () {
          Config.finishPage(context);
          _filterController.text = '';
          //刷新文件
          loadOldFileList(null);
        });
      },
    );
  }

  void preReadWord(String wordContent, String path) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Card(
              elevation: 20,
              child: SizedBox(
                width: 747.w,
                height: 784.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          '文件内容预览',
                          style: Config.loadDefaultTextStyle(
                            color: Colors.black.withOpacity(0.85),
                            fonstSize: 21.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Config.finishPage(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 21.w,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.06),
                      width: double.infinity,
                      height: 1,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Text(
                          wordContent,
                          style: Config.loadDefaultTextStyle(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      color: Colors.black.withOpacity(0.06),
                      width: double.infinity,
                      height: 1,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.w, right: 25.w, bottom: 18.w),
                          child: InkWell(
                            onTap: () {
                              Config.launch("${ServiceHttp.parentUrl}/$path");
                            },
                            child: Container(
                              width: 141.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.15)),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('image/download.png',
                                      width: 21.w, height: 21.w),
                                  SizedBox(width: 5.w),
                                  Text(
                                    '下载文件',
                                    style: Config.loadDefaultTextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.65)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void filterPress() {
    String filter = _filterController.value.text;
    if (filter.isEmpty) {
      toast('请输入筛选条件');
      return;
    }
    loadOldFileList(filter);
  }

  void loadOldFileList(String? filter) async {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['userId'] = await UserUtil.getUserId();
    if (!DataUtil.isEmpty(filter)) {
      map['filter'] = filter;
    }
    ServiceHttp().post('/loadOldPressWord', data: map, success: (data) {
      setState(() {
        _list.clear();
        data.forEach((element) {
          _list.add(OldPressWordFile.fromJson(element));
        });
      });
    });
  }
}
