import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/check_box.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';

///舆情列表
class PublicOpinionListWidget extends StatefulWidget {
  const PublicOpinionListWidget({Key? key}) : super(key: key);

  @override
  State<PublicOpinionListWidget> createState() =>
      _PublicOpinionListWidgetState();
}

class _PublicOpinionListWidgetState extends State<PublicOpinionListWidget> {
  final controllerMap = <String, TextEditingController>{};
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(43.w, 32.w, 0, 39.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('舆情列表', style: Config.loadFirstTextStyle()),
            SizedBox(height: 38.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...filterWidget('事件名称：', 'descriptionFilter'),
                SizedBox(width: 45.w),
                ...filterWidget('舆情类别：', 'typeFilter'),
                SizedBox(width: 45.w),
                ...filterWidget('舆情报刊类型：', 'pressTypeFilter'),
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
                loadTextButton('查 询', () {}),
                SizedBox(width: 33.w),
                loadTextButton(
                  '重 置',
                  () {},
                  primary: Config.fontColorSelect,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
            SizedBox(width: 45.w, height: 60.w),
            ListInfoWidget(canSelect: false),
          ],
        ),
      ),
    );
  }

  TextButton loadTextButton(
    data,
    onPressed, {
    Color? primary = Colors.white,
    Color? backgroundColor = Config.fontColorSelect,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: primary,
        backgroundColor: backgroundColor,
        textStyle: Config.loadDefaultTextStyle(fonstSize: 19.sp),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
        minimumSize: Size(87.sp, 43.sp),
        side: backgroundColor == Colors.white
            ? const BorderSide(width: 0.5)
            : null,
        shape: RoundedRectangleBorder(
          side: backgroundColor == Colors.white
              ? const BorderSide(color: Color(0xFFD9D9D9))
              : BorderSide.none,
          borderRadius: BorderRadius.circular(2.sp),
        ),
      ),
      child: Text(data, textAlign: TextAlign.center),
    );
  }

  TextEditingController loadController(String key) {
    if (!controllerMap.containsKey(key)) {
      controllerMap[key] = TextEditingController();
    }
    return controllerMap[key]!;
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
                  'images/op_save.png',
                  width: 5.sp,
                  height: 5.sp,
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
                  'images/op_save.png',
                  width: 5.sp,
                  height: 5.sp,
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
}

class ListInfoWidget extends StatefulWidget {
  final bool? canSelect;
  final selectList = <PublicOpinionBean>[];

  ListInfoWidget({Key? key, this.canSelect}) : super(key: key);

  @override
  State<ListInfoWidget> createState() => _ListInfoWidgetState();
}

class _ListInfoWidgetState extends State<ListInfoWidget>
    with TickerProviderStateMixin {
  final List<PublicOpinionBean> _list = [];
  final wordLength = 16.w;
  @override
  void initState() {
    super.initState();
    _list.addAll(PublicOpinionBean.create());
    _list.addAll(PublicOpinionBean.create());
  }

  final _physics = const NeverScrollableScrollPhysics();
  final ScrollController _scrollController = ScrollController();
  bool _slideLeftTag = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 42.w),
      child: Stack(children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, //内容适配
          itemBuilder: itemView,
          itemCount: _list.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE8E8E8),
            );
          },
        ),
        Positioned(
          right: _slideLeftTag ? null : 0,
          left: _slideLeftTag ? 0 : null,
          top: 0,
          child: slideLeftWidget(),
        )
      ]),
    );
  }

  Widget slideLeftWidget() {
    return Card(
      // color: Colors.grey,
      elevation: 10,
      child: InkWell(
        onTap: () {
          // print(_scrollController.position.maxScrollExtent);
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          if (_slideLeftTag) {
            _scrollController.jumpTo(0);
          } else {
            _scrollController.animateTo(1800.w,
                duration: const Duration(seconds: 3), curve: const SawTooth(5));
          }
          setState(() {
            _slideLeftTag = !_slideLeftTag;
          });
        },
        child: Container(
          height: 60.w,
          width: 27.w,
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: _slideLeftTag ? -pi : 0,
            child: Image.asset('images/slide_left.png'),
          ),
        ),
      ),
    );
  }

// RotationTransition
  Widget itemView(BuildContext context, int index) {
    return index == 0
        ? firstTableRowView()
        : tableRowView(_list[index - 1], index);
  }

  Widget firstTableRowView() {
    final arr = [
      SizedBox(
        width: 40.sp,
        height: 30.sp,
        child: Center(
          child: InkWell(
              onTap: () {
                print('asdf');
              },
              child: const Text('选择')),
        ),
      ),
      childItemView('序号', '',
          width: 4 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('事件描述', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('媒体类型', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('发布时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('发现时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('舆情类别', '',
          width: 6 * wordLength,
          color: Colors.black,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('责任单位', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('反馈时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('上级通报时间', '',
          width: 8 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('报刊类型', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('是否迟报', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('领导批示', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('批示内容', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('是否完结', '',
          width: 6 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
      childItemView('详情', '',
          width: 4 * wordLength,
          bgColor: const Color(0xFFFAFAFA),
          height: 72.w),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: _physics,
      controller: _scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: arr,
      ),
    );
  }

  Widget tableRowView(PublicOpinionBean bean, int indexNo) {
    bool tag = bean.leaderName == null;
    String leaderInstructions =
        tag ? '添加' : "${bean.leaderName}\n${bean.leaderInstructionsTime}";
    int index = bean.no!;
    final arr = [
      Container(
        width: 40.sp,
        height: 30.sp,
        alignment: Alignment.center,
        child: CheckBoxWidget(
          boxTag: bean.no!,
          value: false,
          // onChanged: (bool? value) {},
        ),
      ),
      childItemView("$indexNo", '序号', width: 4 * wordLength, index: index),
      childItemView(bean.name.toString(), '事件名称',
          width: 8 * wordLength, index: index),
      childItemView(bean.mediaType.toString(), '媒体类型',
          width: 8 * wordLength, index: index),
      childItemView(bean.linkPublishTime.toString(), '发布时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.findTime.toString(), '发现时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.publicOpinionType.toString(), '舆情类别',
          width: 6 * wordLength, index: index),
      childItemView(bean.dutyUnit ?? '指定', '责任单位',
          width: 8 * wordLength, index: index),
      childItemView(bean.feedbackTime ?? "—", '反馈时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.superiorNoticeTime ?? "—", '上级通报时间',
          width: 8 * wordLength, index: index),
      childItemView(bean.pressType ?? "—", '报刊类型',
          width: 6 * wordLength, index: index),
      childItemView(
          bean.isLateReport == 1 ? '是' : (bean.isLateReport == 0 ? '否' : "—"),
          '是否迟报',
          width: 6 * wordLength,
          index: index),
      childItemView(leaderInstructions, '领导批示',
          width: 6 * wordLength, index: index),
      childItemView(bean.leaderInstructionsContent ?? "—", '批示内容',
          width: 6 * wordLength, index: index),
      childItemView(bean.isComplete == 1 ? '是' : '否', '是否完结',
          width: 6 * wordLength, index: index),
      childItemView('查看', '详情', width: 4 * wordLength, index: index),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: _physics,
      controller: _scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: arr,
      ),
    );
  }

  Widget childItemView(String data, String tag,
      {color = Colors.black,
      bgColor = const Color(0xFFFDFDFD),
      double? width,
      double? height,
      int? index}) {
    const clickTag = ',添加,指定,查看,编辑,';
    bool isClick = clickTag.contains(data);
    final canClick = isClick || (data != "—" && tag == '批示内容');
    final child = Text(
      data,
      textAlign: TextAlign.center,
      style: Config.loadDefaultTextStyle(
        color: isClick ? Config.fontColorSelect : color,
        fonstSize: wordLength,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return Container(
      alignment: Alignment.center,
      // color: bgColor,
      width: width ?? data.length * wordLength,
      height: height ?? 60.w,
      decoration: BoxDecoration(
        color: bgColor,
        // border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: canClick
          ? InkWell(onTap: () => viewClick(tag, index ?? 0), child: child)
          : child,
    );
  }

  void viewClick(String data, int index) {
    final bean = _list[index];
    switch (data) {
      case '责任单位':
        break;
      case '上级通报时间':
        break;
      case '报刊类型':
        break;
      case '领导批示':
        break;
      case '是否完结':
        break;
      default:
      //详情
    }
  }
}
