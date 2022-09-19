import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/week_press.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'widget/info_public_opinion.dart';

class PressInfoPage extends StatefulWidget {
  final String pressType;
  final String? filePath;
  final Map report;
  final List<WeekPressBean>? list;
  const PressInfoPage(
      {Key? key,
      required this.pressType,
      required this.report,
      this.filePath,
      this.list})
      : super(key: key);

  @override
  State<PressInfoPage> createState() => _PressInfoPageState();
}

class _PressInfoPageState extends State<PressInfoPage> {
  List<PublicOpinionBean>? _list;
  List<WeekPressBean>? _weekList;
  @override
  void initState() {
    super.initState();
    //初始化list
    requestInfo();
  }

  void requestInfo() async {
    final map = await UserUtil.makeUserIdMap();
    map['reportId'] = widget.report['id'];
    ServiceHttp().post("/loadReportEventInfo", data: map, success: (data) {
      setState(() {
        _list = PublicOpinionBean.fromJsonArray(data['eventList']);
        _weekList = WeekPressBean.fromJsonList(data['weekList']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.pressType,
              style: Config.loadDefaultTextStyle(
                color: Colors.black,
                fonstSize: Config.appBarTitleSize,
              )),
          iconTheme: const IconThemeData(
            color: Colors.black, //修改颜色
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 46.w),
            child: Container(
              width: 1515.w,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.w),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.w),
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
                    _list?.isNotEmpty == true
                        ? ListInfoWidget(
                            canSelect: false, selectList: _list!, type: 1)
                        : const SizedBox(width: 0, height: 0),
                  ],
                ),
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
            titleView('标题：', widget.report['title']),
            SizedBox(height: 49.w),
            titleView('日期：', widget.report['creteDate']),
          ],
        ),
        SizedBox(width: 170.w),
        Text('内容：', style: _textStyle()),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Config.borderColor, width: 1.33.w),
            borderRadius: BorderRadius.circular(5.w),
          ),
          height: widget.pressType != '周报' ? 260.w : 300.w,
          width: 624.w,
          child: SingleChildScrollView(
            child: widget.pressType != '周报'
                ? Text(
                    widget.report['content'],
                    style: _textStyle(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WeekPressInfoWidget(
                      list: _weekList,
                      lastWeekFocusContent:
                          widget.report['lastWeekFocusContent'],
                      lastWeekWholeContent:
                          widget.report['lastWeekWholeContent'],
                    ),
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
              padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 7.w),
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
  final List<WeekPressBean>? list;
  final String lastWeekWholeContent;
  //重点舆情
  final String lastWeekFocusContent;
  const WeekPressInfoWidget(
      {Key? key,
      required this.list,
      required this.lastWeekFocusContent,
      required this.lastWeekWholeContent})
      : super(key: key);

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
    Widget? view1 = contentView('总体情况：', lastWeekWholeContent);
    // 重点舆情
    Widget? view2 = contentView('重点舆情：', lastWeekFocusContent);
    if (view1 != null) arr.add(view1);
    if (view2 != null) arr.add(view2);
    if (arr.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 35.w),
          Text(data, style: _textStyle()),
          SizedBox(width: 470.w, child: Text(content, style: _textStyle()))
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('一周舆情观察', style: _textStyle()),
        Padding(
          padding: EdgeInsets.only(left: 35.w),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(list![index].firstRankTitle! + "：",
                    style: _textStyle()),
                children: childListView(list![index].secondRank!),
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

  List<Widget> childListView(List<SecondRank> list) {
    List<Widget> views = [];
    for (SecondRank element in list) {
      String title = element.secondRankTitle! + "：";
      String content = element.content!;
      views.add(Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _textStyle()),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(content, style: _textStyle()),
          ),
        ],
      ));
    }
    return views;
  }
}
