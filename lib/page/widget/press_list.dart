import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/add_press_word_file.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/page/press_page.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';
import 'package:dio/dio.dart' as dio;

class PressListWidget extends StatefulWidget {
  const PressListWidget({Key? key}) : super(key: key);

  @override
  State<PressListWidget> createState() => _PressListWidgetState();
}

class _PressListWidgetState extends State<PressListWidget> {
  final _frontColor = Colors.black.withOpacity(0.85);
  final TextEditingController _filterController = TextEditingController();
  final List _list = <dynamic>[];
  String? _pressType;
  @override
  void dispose() {
    super.dispose();
    _filterController.dispose();
  }

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
                Text('新版',
                    style: Config.loadDefaultTextStyle(color: _frontColor))
              ],
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
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
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 7.w),
                textStyle: Config.loadDefaultTextStyle(fonstSize: 19.w),
              ),
              child: const Text('筛选'),
            ),
            const Spacer(),
            Text(
              '创建报刊：',
              style: Config.loadDefaultTextStyle(color: _frontColor),
            ),
            SizedBox(
              width: 213.w,
              height: 44.w,
              child: DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                      value: '专报',
                      // onTap: () {},
                      child: Text('专报', style: Config.loadDefaultTextStyle())),
                  DropdownMenuItem(
                      value: '周报',
                      // onTap: () {},
                      child: Text('周报', style: Config.loadDefaultTextStyle())),
                  DropdownMenuItem(
                      value: '快报',
                      // onTap: () {},
                      child: Text('快报', style: Config.loadDefaultTextStyle())),
                ],
                decoration: Config.defaultInputDecoration(
                    suffixIcon: Image.asset(
                  'images/icon_down.png',
                )),
                onChanged: (String? value) {
                  setState(() {
                    _pressType = value;
                  });
                },
                value: _pressType,
                hint: Text(
                  '请选择',
                  style: Config.loadDefaultTextStyle(color: Config.borderColor),
                ),
                style: Config.loadDefaultTextStyle(),
                // isDense: true,
                // isExpanded: true,
                icon: Visibility(
                  visible: false,
                  child: Image.asset(
                    'images/icon_down.png',
                    width: 10.w,
                    height: 10.w,
                  ),
                ),
                iconSize: 0,
                elevation: 0,
                dropdownColor: const Color(0xFFDADADA),
              ),
            ),
            SizedBox(width: 50.w),
            TextButton(
              onPressed: () {
                createPress();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Config.fontColorSelect,
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 7.w),
                textStyle: Config.loadDefaultTextStyle(fonstSize: 19.w),
              ),
              child: const Text('创建'),
            ),
            SizedBox(width: 35.w),
          ]),
          Padding(
            padding: EdgeInsets.only(left: 35.w, top: 34.w),
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
        tableView('标题', 370.w),
        tableView('报刊类型', 190.w), //63
        tableView('创建时间', 402.w), //169
        tableView('详情', 84.w), //26
        tableView('附件', 294.w),
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
        tableChildView(listViewItemText(item['title']), 370.w),
        tableChildView(listViewItemText(item['pressType']), 190.w), //63
        tableChildView(listViewItemText(item['utime']), 402.w), //169
        InkWell(
            onTap: () {
              clickPress(item['id']);
            },
            child: tableChildView(listViewItemText('查看'), 84.w)), //26
        InkWell(
            onTap: () {
              clickFile(item['file'], item['id']);
            },
            child: tableChildView(
                listViewItemText(DataUtil.isEmpty(item['file']) ? '添加' : '查看'),
                294.w)),
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
    /* _list.add({
      'title': '专报22期',
      'pressType': '专报',
      'utime': '2022-06-01',
    });
    _list.add({
      'title': '专报22期',
      'pressType': '专报',
      'utime': '2022-06-01',
    });
    _list.add({
      'title': '专报22期',
      'pressType': '专报',
      'utime': '2022-06-01',
    }); */
    loadList('');
  }

  void createPress() {
    if (DataUtil.isEmpty(_pressType)) {
      toast('请选择创建报刊类型');
      return;
    }
    Config.startPage(context, PressPage(pressType: _pressType!));
    switch (_pressType) {
      case '专报':
        break;
      case '快报':
        break;
      default:
    }
  }

  void filterPress() {
    String filter = _filterController.value.text;
    loadList(filter);
  }

  void loadList(String filter) async {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['userId'] = await UserUtil.getUserId();
    if (!DataUtil.isEmpty(filter)) {
      map['filter'] = filter;
    }
    ServiceHttp().post('/pressList', data: map, success: (data) {});
  }

  void clickPress(id) {
    // Config.startPage(context, page);
  }

  void clickFile(file, id) {
    if (null == file) {
      showAddFileDialog(id);
    } else {
      Config.launch('${ServiceHttp.parentUrl}/${file['path']}');
    }
  }

  void showAddFileDialog(id) {
    showCenterNoticeDialog(
      context,
      isNeedTitle: false,
      isNeedActions: false,
      barrierDismissible: false,
      contentWidget: AddPressWordFileWidget(
        uploadFileCallback: (fileInfoBean, desprice) {
          uploadFile(fileInfoBean, desprice, id);
        },
      ),
    );
  }

  void uploadFile(fileInfoBean, desprice, id) async {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['userId'] = await UserUtil.getUserId();
    map['description'] = desprice;
    map['pressId'] = id;
    final arr = [];
    arr.add(dio.MultipartFile.fromBytes(fileInfoBean.bytes!,
        filename: Uri.encodeComponent(fileInfoBean.name!)));
    map['file'] = arr;
    ServiceHttp().post(
      '/addPressFile',
      data: dio.FormData.fromMap(map),
      success: (data) {
        filterPress();
        showSuccessDialog('上传成功', dialogDismiss: () {
          //关闭上传弹窗
          //Config.finishPage(context);
        });
      },
    );
  }
}
