import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';

class HistoryPressFileWidget extends StatefulWidget {
  const HistoryPressFileWidget({Key? key}) : super(key: key);

  @override
  State<HistoryPressFileWidget> createState() => _HistoryPressFileWidgetState();
}

class _HistoryPressFileWidgetState extends State<HistoryPressFileWidget> {
  final _frontColor = Colors.black.withOpacity(0.85);
  final TextEditingController _filterController = TextEditingController();
  final List _list = <dynamic>[];
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
                filterPress();
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
        const Spacer(),
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
        tableChildView(listViewItemText(item['fileName']), 647.w),
        tableChildView(listViewItemText(item['utime']), 175.w), //63
        const Spacer(),
        tableChildView(
            InkWell(
                onTap: () {},
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
    // TODO: implement initState
    super.initState();
    _list.add({
      'fileName': '专报22期专报22期专报22期.docx',
      'utime': '2022-07-01',
    });
    _list.add({
      'fileName': '专报22期专报22期.docx',
      'utime': '2022-07-01',
    });
    _list.add({
      'fileName': '专报22期.docx',
      'utime': '2022-07-01',
    });
    _list.add({
      'fileName': '专报22期专报22期专报22期专报22期.docx',
      'utime': '2022-07-01',
    });
    _list.add({
      'fileName': '专报22期专报22期.docx',
      'utime': '2022-07-01',
    });
  }

  void filterPress() {
    String filter = _filterController.value.text;
    if (filter.isEmpty) {
      toast('请输入筛选条件');
      return;
    }
  }
}
