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

  Widget weekContainer() {
    return SingleChildScrollView(
      child: Container(
        // constraints:
        //     BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 49.w, height: 49.w),
            SizedBox(
              width: 800.w,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleView('报刊类型：', widget.pressType, width: null),
                    SizedBox(width: 49.w),
                    titleView('日期：', widget.report['creteDate']),
                  ]),
            ),
            SizedBox(height: 23.w),
            SizedBox(
                width: 800.w,
                child: Text('内容：', style: Config.loadDefaultTextStyle())),
            SizedBox(height: 23.w),
            Container(
              constraints: BoxConstraints(maxWidth: 800.w),
              color: Colors.transparent,
              // height: 1000.w,
              child: WeekPressInfoWidget(
                list: _weekList,
                lastWeekFocusContent: widget.report['lastWeekFocusContent'],
                lastWeekWholeContent: widget.report['lastWeekWholeContent'],
              ),
            ),
            SizedBox(height: 16.w),
            _list?.isNotEmpty == true
                ? SizedBox(
                    width: 1615.w,
                    child: ListInfoWidget(
                        canSelect: false,
                        selectList: _list!,
                        type: 1,
                        isOnlyShow: true),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
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
              width: 1630.w,
              height: 1000.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.w),
                color: Colors.white,
              ),
              child: widget.pressType == '周报'
                  ? weekContainer()
                  : SingleChildScrollView(
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
                                  canSelect: false,
                                  selectList: _list!,
                                  type: 1,
                                  isOnlyShow: true)
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
    final arr = [
      titleView('报刊类型：', widget.pressType),
      SizedBox(height: 49.w),
      titleView('日期：', widget.report['creteDate']),
    ];
    if (widget.pressType != '周报') {
      arr.insertAll(2, [
        titleView('标题：', widget.report['title']),
        SizedBox(height: 49.w),
      ]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: arr,
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

  Widget titleView(data, content, {double? width = -1}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data,
            style: _textStyle(),
          ),
          Container(
            width: width == -1 ? 312.w : width,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._view(),
        ...weekList(),
      ],
    );
  }

  List<Widget> _view() {
    final arr = [];
    //总体情况
    Widget? view1 = contentView('总体情况：', lastWeekWholeContent);
    // 重点舆情
    Widget? view2 = contentView('重点舆情：', lastWeekFocusContent);
    if (view1 != null) arr.add(view1);
    if (view2 != null) arr.add(view2);
    if (arr.isNotEmpty) {
      return [
        Text('上周舆情总述：', style: _textStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.w),
        ...arr,
      ];
    } else {
      return [];
    }
  }

  Widget? contentView(data, content) {
    if (DataUtil.isEmpty(content)) return null;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 35.w),
          Text(data, style: _textStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 16.w),
          SizedBox(child: SelectableText(content, style: _textStyle()))
        ],
      ),
    );
  }

  TextStyle _textStyle({FontWeight? fontWeight}) => Config.loadDefaultTextStyle(
        fontWeight: fontWeight ?? FontWeight.w400,
        color: Colors.black.withOpacity(0.85),
      );
  List<Widget> weekList() {
    if (DataUtil.isEmpty(list)) return [];
    var listView = <Widget>[];
    for (var element in list!) {
      listView.add(SelectableText("${element.firstRankTitle!}：",
          style: _textStyle(fontWeight: FontWeight.bold)));
      listView.addAll(childListView(element.secondRank!));
      listView.add(SizedBox(height: 16.w));
    }
    return listView;
  }

  List<Widget> childListView(List<SecondRank> list) {
    List<Widget> views = [];
    for (SecondRank element in list) {
      String title = element.secondRankTitle!;
      String content = element.content!;
      views.add(Padding(
        padding: EdgeInsets.only(left: 30.w, top: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(title,
                style: _textStyle(fontWeight: FontWeight.w500)),
            Padding(
              padding: EdgeInsets.only(left: 30.w, top: 10.w),
              child: SelectableText(content, style: _textStyle()),
            ),
          ],
        ),
      ));
    }
    return views;
  }
}
