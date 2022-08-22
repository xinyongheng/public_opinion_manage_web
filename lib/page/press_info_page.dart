import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'widget/info_public_opinion.dart';

class PressInfoPage extends StatefulWidget {
  final String pressType;
  final int pressId;
  const PressInfoPage(
      {Key? key, required this.pressType, required this.pressId})
      : super(key: key);

  @override
  State<PressInfoPage> createState() => _PressInfoPageState();
}

class _PressInfoPageState extends State<PressInfoPage> {
  List<PublicOpinionBean>? _list;

  @override
  void initState() {
    super.initState();
    //初始化list
    requestInfo();
  }

  void requestInfo() async {
    int userId = await UserUtil.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pressType, style: Config.loadDefaultTextStyle()),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/bg.png')),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 46.w),
          child: SingleChildScrollView(
            child: Container(
              width: 1515.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.w),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  headContentView(),
                  SizedBox(height: 52.w),
                  Text(
                    '舆情列表',
                    style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.85),
                      fonstSize: 27.w,
                    ),
                  ),
                  SizedBox(height: 16.w),
                  ListInfoWidget(
                      canSelect: false, selectList: _list ?? [], type: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headContentView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            titleView('报刊类型：', widget.pressType),
            SizedBox(height: 49.w),
            titleView('标题：', ''),
            SizedBox(height: 49.w),
            titleView('日期：', ''),
          ],
        ),
        SizedBox(width: 170.w),
        Text('内容：', style: _textStyle()),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Config.borderColor, width: 1.33.w),
            borderRadius: BorderRadius.circular(5.w),
          ),
          height: 227.w,
          width: 624.w,
          child: SingleChildScrollView(
            child: widget.pressType != '周报'
                ? Text(
                    '',
                    style: _textStyle(),
                  )
                : const WeekPressInfoWidget(
                    list: [],
                  ),
          ),
        )
      ],
    );
  }

  Widget titleView(data, content) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data,
            style: _textStyle(),
          ),
          Container(
            width: 312.w,
            decoration: BoxDecoration(
              border: Border.all(color: Config.borderColor, width: 1.33.w),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.w),
              child: Text(
                content,
                style: _textStyle(),
              ),
            ),
          ),
        ],
      );

  TextStyle _textStyle() => Config.loadDefaultTextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.85),
      );
}

class WeekPressInfoWidget extends StatelessWidget {
  final List? list;
  const WeekPressInfoWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _view(),
          weekList(),
        ],
      ),
    );
  }

  Widget _view() {
    final arr = [];
    //总体情况
    Widget? view1 = contentView('总体情况：', '');
    // 重点舆情
    Widget? view2 = contentView('重点舆情：', '');
    if (view1 != null) arr.add(view1);
    if (view2 != null) arr.add(view2);
    if (arr.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('上周舆情总述', style: _textStyle()),
          ...arr,
        ],
      );
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }

  Widget? contentView(data, content) {
    if (DataUtil.isEmpty(content)) return null;
    return Padding(
      padding: EdgeInsets.only(bottom: 42.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 35.w),
          Text(data, style: _textStyle()),
          Text(content, style: _textStyle())
        ],
      ),
    );
  }

  TextStyle _textStyle() => Config.loadDefaultTextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.85),
      );
  Widget weekList() {
    if (DataUtil.isEmpty(list)) return const SizedBox(width: 0, height: 0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('一周舆情观察', style: _textStyle()),
        Padding(
          padding: EdgeInsets.only(left: 35.w),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text('一级标题', style: _textStyle()),
                children: childListView(list![index]['second']),
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list!.length,
          ),
        ),
      ],
    );
  }

  List<Widget> childListView(List list) {
    List<Widget> views = [];
    list.forEach((element) {
      String title = '标题';
      String content = '内容';
      views.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: _textStyle()),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(content, style: _textStyle()),
          ),
        ],
      ));
    });
    return views;
  }
}
