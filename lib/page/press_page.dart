import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/week_press.dart';
import 'package:public_opinion_manage_web/page/widget/info_public_opinion.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class PressPage extends StatefulWidget {
  final String pressType;

  const PressPage({Key? key, required this.pressType}) : super(key: key);

  @override
  State<PressPage> createState() => _PressPageState();
}

class _PressPageState extends State<PressPage> {
  int selectSize = 0;
  late PressHeadWidget headWidget;

  late Widget pressWidget;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pressWidget = widget.pressType != '周报'
        ? PressCreateWidget(pressType: widget.pressType)
        : const WeekPressCreateWidget();
  }

  @override
  Widget build(BuildContext context) {
    headWidget = PressHeadWidget(
      valueChanged: <int>(value) {
        setState(() {
          selectSize = value;
        });
      },
    );
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/bg.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //修改颜色
          ),
          title: Text(widget.pressType,
              style: Config.loadDefaultTextStyle(
                color: Colors.black,
                fonstSize: Config.appBarTitleSize,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.w),
            child: SizedBox(
              width: 1515.w,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    headWidget,
                    SizedBox(height: 30.w),
                    Opacity(
                      opacity: selectSize > 0 ? 1 : 0,
                      child: pressWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget parentContainer(Widget child, {double? height}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13.w),
      color: Colors.white,
    ),
    width: 1515.w,
    height: height,
    child: child,
  );
}

class PressHeadWidget extends StatefulWidget {
  final ValueChanged? valueChanged;
  const PressHeadWidget({Key? key, this.valueChanged}) : super(key: key);

  @override
  State<PressHeadWidget> createState() => _PressHeadWidgetState();
}

class _PressHeadWidgetState extends State<PressHeadWidget> {
  final controllerMap = <String, TextEditingController>{};
  late TapGestureRecognizer _tapGestureRecognizer;
  final selectList = <PublicOpinionBean>[];
  List<PublicOpinionBean>? _allList;

  final GlobalKey<ListInfoWidgetState> _key = GlobalKey<ListInfoWidgetState>();

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _resetSelect;
  }

  void requestSearch() async {
    final mapData = <String, dynamic>{};
    controllerMap.forEach((key, value) => fillFilterData(mapData, key, value));
    askInternet(mapData.isEmpty ? null : mapData);
  }

  // 请求网络列表
  void askInternet(Map<String, dynamic>? map) async {
    final finalMap = <String, dynamic>{};
    if (null != map) {
      finalMap.addAll(map);
    }
    finalMap["userId"] = await UserUtil.getUserId();
    ServiceHttp().post("/eventList", data: finalMap, success: (data) {
      selectList.clear();
      setState(() {
        _allList = PublicOpinionBean.fromJsonArray(data);
      });
    });
  }

  void fillFilterData(map, key, value) {
    final data = value.text;
    if (data.isNotEmpty) {
      map[key] = data;
    }
  }

  ListInfoWidget? _listInfoWidget;
  @override
  Widget build(BuildContext context) {
    _listInfoWidget = ListInfoWidget(
      key: _key,
      canSelect: true,
      type: 1,
      selectList: _allList ?? [],
      onChange: (value, tag) {
        selectList.clear();
        setState(() {
          selectList.addAll(tag);
        });
        widget.valueChanged?.call(tag.length);
      },
    );
    return parentContainer(
      Padding(
        padding:
            EdgeInsets.only(left: 38.w, top: 32.w, right: 38.w, bottom: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '舆情筛选',
              style: Config.loadDefaultTextStyle(
                fonstSize: 27.w,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            SizedBox(height: 26.w),
            ...headFilterView(),
            SizedBox(height: 21.w),
            Visibility(
                visible: selectList.isNotEmpty,
                child: selectView(selectList.length)),
            _listInfoWidget!,
            SizedBox(height: 32.w),
            /* TextButton(
              onPressed: () {
                if (selectList.isEmpty) {
                  toast('请选择事件');
                  return;
                }
                setState(() {});
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Config.fontColorSelect,
                textStyle:
                    Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
                minimumSize: const Size(1, 1),
                padding: EdgeInsets.zero,
                fixedSize: Size(87.w, 43.w),
              ),
              child: const Text('确定'),
            ),
            SizedBox(height: 32.w), */
          ],
        ),
      ),
      height: 925.w,
    );
  }

  List<Widget> headFilterView() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...filterWidget('事件名称：', 'descriptionFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('舆情类别：', 'typeFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('舆情报刊类型：', 'pressTypeFilter'),
          SizedBox(width: 45.w),
          ...filterWidget('媒体类型：', 'mediaTypeFilter'),
        ],
      ),
      SizedBox(width: 45.w, height: 21.w),
      timeFilter('发布时间：', 'publishTimeStart', 'publishTimeEnd'),
      SizedBox(width: 45.w, height: 21.w),
      timeFilter('反馈时间：', 'feedbackTimeStart', 'feedbackTimeEnd'),
      SizedBox(width: 45.w, height: 21.w),
      Row(
        children: [
          timeFilter('发现时间：', 'findTimeStart', 'findTimeEnd'),
          SizedBox(width: 33.w),
          sureButton(),
          SizedBox(width: 33.w),
          resetButton(),
        ],
      ),
    ];
  }

  Widget filterTitle(data) {
    return Text(
      data,
      style: Config.loadDefaultTextStyle(),
    );
  }

  List<Widget> filterWidget(data, key) {
    return [
      filterTitle(data),
      loadTextField(key),
    ];
  }

  Widget timeFilter(data, keyStart, keyEnd) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          filterTitle(data),
          SizedBox(
            width: 213.w,
            child: DateTimePicker(
              controller: loadController(keyStart),
              type: DateTimePickerType.date,
              dateMask: 'yyyy-MM-dd',
              firstDate: DateTime(1992),
              lastDate: DateTime.now(),
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: Config.defaultInputDecoration(
                hintText: '年/月/日',
                suffixIcon: Image.asset(
                  'images/icon_date.png',
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Text('至', style: Config.loadDefaultTextStyle()),
          ),
          SizedBox(
            width: 213.w,
            child: DateTimePicker(
              controller: loadController(keyEnd),
              type: DateTimePickerType.date,
              dateMask: 'yyyy-MM-dd',
              firstDate: DateTime(1992),
              lastDate: DateTime.now(),
              textInputAction: TextInputAction.next,
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: Config.defaultInputDecoration(
                hintText: '年/月/日',
                suffixIcon: Image.asset(
                  'images/icon_date.png',
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ]);
  }

  Widget loadTextField(String key, {String hint = '请输入'}) {
    return SizedBox(
      width: 213.w,
      child: TextField(
        controller: loadController(key),
        decoration: Config.defaultInputDecoration(hintText: hint),
        style: Config.loadDefaultTextStyle(color: Colors.black),
      ),
    );
  }

  TextButton sureButton() {
    return TextButton(
      onPressed: () {
        requestSearch();
      },
      style: TextButton.styleFrom(
        textStyle: Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
        minimumSize: const Size(1, 1),
        padding: EdgeInsets.zero,
        fixedSize: Size(89.w, 43.w),
        primary: Colors.white,
        backgroundColor: Config.fontColorSelect,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
      child: const Text('确定'),
    );
  }

  TextButton resetButton() {
    return TextButton(
      onPressed: () {
        _resetFilter();
      },
      style: TextButton.styleFrom(
        textStyle: Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
        minimumSize: const Size(1, 1),
        padding: EdgeInsets.zero,
        fixedSize: Size(89.w, 43.w),
        primary: Config.fontColorSelect,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xFFD9D9D9),
          ),
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
      child: const Text('重置'),
    );
  }

  void _resetFilter() {
    controllerMap.forEach((key, value) {
      value.text = '';
    });
  }

  TextEditingController loadController(String key) {
    if (!controllerMap.containsKey(key)) {
      controllerMap[key] = TextEditingController();
    }
    return controllerMap[key]!;
  }

  @override
  void dispose() {
    super.dispose();
    controllerMap.forEach((key, value) {
      value.dispose();
    });
  }

  Widget selectView(int size) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, top: 43.w, bottom: 27.w),
      child: Container(
        width: 1429.w,
        height: 53.w,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFFBAE7FF),
          border: Border.all(color: const Color(0xFFBAE7FF), width: 1.33.w),
          borderRadius: BorderRadius.circular(5.33.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 33.w),
            Icon(Icons.info, size: 20.w, color: Config.fontColorSelect),
            SizedBox(width: 11.w),
            // Text("$size项", style: Config.loadDefaultTextStyle()),
            Text.rich(TextSpan(
                text: '已选择',
                style: Config.loadDefaultTextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.65),
                ),
                children: [
                  TextSpan(
                      text: " $size ",
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                      )),
                  const TextSpan(text: "项"),
                  TextSpan(
                      text: "空",
                      style: Config.loadDefaultTextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.transparent)),
                  TextSpan(
                      text: "清空",
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: _tapGestureRecognizer),
                ])),
          ],
        ),
      ),
    );
  }

  ///清空选择的事件
  void _resetSelect() {
    setState(() {
      selectList.clear();
      _key.currentState?.clearSelect();
      // _listInfoWidget!.hadSelectList.clear();
    });
    widget.valueChanged?.call(0);
  }
}

class PressCreateWidget extends StatefulWidget {
  final String pressType;
  const PressCreateWidget({
    Key? key,
    required this.pressType,
  }) : super(key: key);

  @override
  State<PressCreateWidget> createState() => _PressCreateWidgetState();
}

class _PressCreateWidgetState extends State<PressCreateWidget> {
  final map = <String, TextEditingController>{};
  @override
  Widget build(BuildContext context) {
    return parentContainer(Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 31.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                '${widget.pressType}编写',
                style: Config.loadDefaultTextStyle(
                  fonstSize: 27.w,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.85),
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 18.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '报刊类型：',
                    style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.85),
                    ),
                  ),
                  Container(
                    width: 624.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      border: Border.all(color: Config.borderColor),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.w, horizontal: 16.w),
                      child: Text(
                        widget.pressType,
                        style: Config.loadDefaultTextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48.w),
              childItem('标题：', 'title'),
              SizedBox(height: 48.w),
              childItem('日期：', 'creteDate'),
              SizedBox(height: 48.w),
              childItem('刊号：', 'pressNo'),
              SizedBox(height: 48.w),
              childItem('内容：', 'context', line: 10),
              SizedBox(height: 22.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '内容：',
                    style: Config.loadDefaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.transparent,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Config.fontColorSelect,
                      minimumSize: const Size(1, 1),
                      padding: EdgeInsets.zero,
                      fixedSize: Size(123.w, 43.w),
                      textStyle: Config.loadDefaultTextStyle(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w)),
                    ),
                    child: const Text('生成word'),
                  ),
                  SizedBox(width: 50.w),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: Config.fontColorSelect,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(1, 1),
                      padding: EdgeInsets.zero,
                      fixedSize: Size(123.w, 43.w),
                      textStyle: Config.loadDefaultTextStyle(),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Config.fontColorSelect),
                          borderRadius: BorderRadius.circular(5.w)),
                    ),
                    child: const Text('提交'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }

  TextEditingController loadController(String key) {
    if (!map.containsKey(key)) {
      map[key] = TextEditingController();
    }
    return map[key]!;
  }

  Row childItem(String title, String key, {int? line}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: line != null && line > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          "空格",
          style: Config.loadDefaultTextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.transparent,
          ),
        ),
        Text(
          title,
          style: Config.loadDefaultTextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.85),
          ),
        ),
        SizedBox(
          width: 624.w,
          child: title.endsWith('日期：')
              ? dateView(title, loadController(key))
              : TextField(
                  controller: loadController(key),
                  maxLines: line,
                  minLines: line,
                  decoration:
                      Config.defaultInputDecoration(hintText: '请输入$title'),
                  style: Config.loadDefaultTextStyle(),
                ),
        )
      ],
    );
  }

  Widget dateView(explain, controller) {
    return DateTimePicker(
      controller: controller,
      type: DateTimePickerType.date,
      dateMask: 'yyyy-MM-dd',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration: Config.defaultInputDecoration(
        hintText: '年/月/日',
        suffixIcon: Image.asset('images/icon_date.png'),
      ),
    );
  }

  void makeWord() async {
    String title = map['title']!.text;
    String creteDate = map['creteDate']!.text;
    String pressNo = map['pressNo']!.text;
    String context = map['context']!.text;
    // 生成后直接下载
  }
}

/// 周报创建
class WeekPressCreateWidget extends StatefulWidget {
  const WeekPressCreateWidget({Key? key}) : super(key: key);

  @override
  State<WeekPressCreateWidget> createState() => _WeekPressCreateWidgetState();
}

class _WeekPressCreateWidgetState extends State<WeekPressCreateWidget> {
  final map = <String, TextEditingController>{};
  @override
  void dispose() {
    super.dispose();
    map.forEach((key, value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.w),
        color: Colors.white,
      ),
      width: 1515.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.w),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                '周报编写',
                style: Config.loadDefaultTextStyle(
                    fonstSize: 27.w,
                    color: Colors.black.withOpacity(0.85),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('报刊类型：', style: _textStyle()),
                Container(
                  width: 624.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    border: Border.all(color: Config.borderColor),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
                    child: Text('周报', style: _textStyle()),
                  ),
                )
              ],
            ),
            childItem('标题：', 'title'),
            SizedBox(height: 42.w),
            dateView('日期：', 'creteDate'),
            SizedBox(height: 42.w),
            childItem('刊号：', 'pressNo'),
            SizedBox(height: 61.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('上周舆情总述', style: _textStyleTitle()),
                SizedBox(width: 638.w),
              ],
            ),
            childItem('总体情况：', '总体情况', line: 3),
            SizedBox(height: 42.w),
            childItem('重点舆情：', '重点舆情', line: 10),
            SizedBox(height: 51.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 364.w),
                Text('一周舆情观察', style: _textStyleTitle()),
                // SizedBox(width: 638.w),
              ],
            ),
            weekViewList(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 194.w),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Config.fontColorSelect,
                    minimumSize: const Size(1, 1),
                    padding: EdgeInsets.zero,
                    fixedSize: Size(123.w, 43.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.w)),
                  ),
                  child: const Text('生成word'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Config.fontColorSelect,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(1, 1),
                    padding: EdgeInsets.zero,
                    fixedSize: Size(123.w, 43.w),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(5.w)),
                  ),
                  child: const Text('提交'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row childItem(String title, String key, {int? line}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title：', style: _textStyle()),
        SizedBox(
          width: 624.w,
          child: TextField(
            minLines: line,
            maxLines: line,
            controller: loadController(key),
            decoration: Config.defaultInputDecoration(hintText: '请输入$title'),
          ),
        )
      ],
    );
  }

  Widget dateView(explain, controller) {
    return DateTimePicker(
      controller: controller,
      type: DateTimePickerType.date,
      dateMask: 'yyyy-MM-dd',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration: Config.defaultInputDecoration(
        hintText: '年/月/日',
        suffixIcon: Image.asset('images/icon_date.png'),
      ),
    );
  }

  TextStyle _textStyle({Color? color}) {
    return Config.loadDefaultTextStyle(
      color: color ?? Colors.black.withOpacity(0.85),
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _textStyleTitle() {
    return Config.loadDefaultTextStyle(
      color: Colors.black.withOpacity(0.85),
      fontWeight: FontWeight.w500,
    );
  }

  TextEditingController loadController(String key) {
    if (!map.containsKey(key)) {
      map[key] = TextEditingController();
    }
    return map[key]!;
  }

  final List<WeekPressBean> _list = [
    WeekPressBean(
      firstRankTitle: '',
      secondRank: [
        SecondRank(secondRankTitle: '', content: ''),
      ],
    )
  ];

  ListView weekViewList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return weekItemView(_list[index], index);
        },
        itemCount: _list.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  Widget weekItemView(WeekPressBean bean, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        weekItemChildView(index, bean.firstRankTitle!, 1),
        SizedBox(height: 42.w),
        ...secondView(index, bean.secondRank!),
      ],
    );
  }

  List<Widget> secondView(int index, List<SecondRank> list) {
    final arr = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      final bean = list[i];
      arr.add(
          weekItemChildView(index, bean.secondRankTitle!, 2, secondIndex: i));
      arr.add(SizedBox(height: 40.w));
      arr.add(weekItemChildView(index, bean.content!, 2,
          secondIndex: i, contentTag: true));
      arr.add(SizedBox(height: 42.w));
    }
    return arr;
  }

  Row weekItemChildView(int index, String title, int rank,
      {int line = 1, int secondIndex = -1, bool contentTag = false}) {
    final arr = [
      Container(
        width: rank == 1 ? 128.w : 194.w,
        alignment: Alignment.centerRight,
        child: Text('$title：', style: _textStyle()),
      ),
      SizedBox(
        width: rank == 1 ? 624.w : 559.w,
        child: TextField(
          minLines: line,
          maxLines: line,
          // controller: loadController(key),
          onChanged: ((value) {
            if (rank == 1) {
              _list[index].firstRankTitle = value;
            } else {
              if (contentTag) {
                _list[index].secondRank![secondIndex].content = value;
              } else {
                _list[index].secondRank![secondIndex].secondRankTitle = value;
              }
            }
          }),
          decoration: Config.defaultInputDecoration(hintText: '请输入$title'),
        ),
      ),
    ];
    if (!contentTag) {
      arr.addAll([
        SizedBox(width: 30.w),
        InkWell(
          onTap: () {
            if (rank == 1) {
              _list.insert(
                index + 1,
                WeekPressBean(
                  firstRankTitle: '',
                  secondRank: [
                    SecondRank(secondRankTitle: '', content: ''),
                  ],
                ),
              );
            } else {
              _list[index].secondRank!.insert(secondIndex + 1,
                  SecondRank(secondRankTitle: '', content: ''));
            }
            setState(() {});
          },
          child: Text(
            '添加',
            style: Config.loadDefaultTextStyle(
              color: Config.fontColorSelect,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 30.w),
        InkWell(
          onTap: () => deleteDialog(rank, index, secondIndex),
          child: Text(
            '删除',
            style: Config.loadDefaultTextStyle(
              color: Config.fontColorSelect,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: arr,
    );
  }

  void deleteDialog(int rank, int index, int secondeIndex) {
    showCenterNoticeDialog(context, contentString: '确定删除么？', onPress: () {
      if (rank == 1) {
        _list.removeAt(index);
      } else {
        _list[index].secondRank!.removeAt(secondeIndex);
      }
      setState(() {});
    });
  }
}
