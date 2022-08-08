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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(43.w, 32.w, 0, 39.w),
          child: Text('舆情列表', style: Config.loadFirstTextStyle()),
        ),
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
          ],
        )
      ],
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
                prefix: Image.asset(
                  'image/icon_date.png',
                  width: 19.w,
                  height: 19.w,
                ),
              ),
            ),
          )
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

class _ListInfoWidgetState extends State<ListInfoWidget> {
  final List<PublicOpinionBean> _list = [];
  final wordLength = 20.sp;
  @override
  void initState() {
    super.initState();
    _list.addAll(PublicOpinionBean.create());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true, //内容适配
      itemBuilder: itemView,
      itemCount: _list.length + 1,
    );
  }

  Widget itemView(BuildContext context, int index) {
    return index == 0 ? firstTableRowView() : tableRowView(_list[index - 1]);
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
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('事件名称', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('媒体类型', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('发布时间', '',
          width: 5 * wordLength,
          color: Colors.white,
          bgColor: Colors.blue,
          height: 30.sp),
      childItemView('发现时间', '',
          width: 5 * wordLength,
          color: Colors.white,
          bgColor: Colors.blue,
          height: 30.sp),
      childItemView('舆情类别', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('责任单位', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('反馈时间', '',
          width: 5 * wordLength,
          color: Colors.white,
          bgColor: Colors.blue,
          height: 30.sp),
      childItemView('上级通报时间', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('报刊类型', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('是否迟报', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('领导批示', '',
          width: 5 * wordLength,
          color: Colors.white,
          bgColor: Colors.blue,
          height: 30.sp),
      childItemView('批示内容', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('是否完结', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      childItemView('详情', '',
          color: Colors.white, bgColor: Colors.blue, height: 30.sp),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: arr,
    );
  }

  Widget tableRowView(PublicOpinionBean bean) {
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
      childItemView(null == bean.no ? "-" : ("${bean.no! + 1}"), '序号',
          width: 2 * wordLength, index: index),
      childItemView(bean.name.toString(), '事件名称',
          width: 4 * wordLength, index: index),
      childItemView(bean.mediaType.toString(), '媒体类型',
          width: 4 * wordLength, index: index),
      childItemView(bean.linkPublishTime.toString(), '发布时间',
          width: 5 * wordLength, index: index),
      childItemView(bean.findTime.toString(), '发现时间',
          width: 5 * wordLength, index: index),
      childItemView(bean.publicOpinionType.toString(), '舆情类别',
          width: 4 * wordLength, index: index),
      childItemView(bean.dutyUnit ?? '指定', '责任单位',
          width: 4 * wordLength, index: index),
      childItemView(bean.feedbackTime ?? '-', '反馈时间',
          width: 5 * wordLength, index: index),
      childItemView(bean.superiorNoticeTime ?? '-', '上级通报时间',
          width: 6 * wordLength, index: index),
      childItemView(bean.pressType ?? '-', '报刊类型',
          width: 4 * wordLength, index: index),
      childItemView(
          bean.isLateReport == 1 ? '是' : (bean.isLateReport == 0 ? '否' : '-'),
          '是否迟报',
          width: 4 * wordLength,
          index: index),
      childItemView(leaderInstructions, '领导批示',
          width: 5 * wordLength, index: index),
      childItemView(bean.leaderInstructionsContent ?? "-", '批示内容',
          width: 4 * wordLength, index: index),
      childItemView(bean.isComplete == 1 ? '是' : '否', '是否完结',
          width: 4 * wordLength, index: index),
      childItemView('查看', '详情', width: 2 * wordLength, index: index),
    ];
    if (widget.canSelect != true) {
      arr.removeAt(0);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: arr,
    );
  }

  Widget childItemView(String data, String tag,
      {color = Colors.black,
      bgColor = Colors.white,
      double? width,
      double? height,
      int? index}) {
    const clickTag = ',添加,指定,查看,编辑,';
    bool canClick = clickTag.contains(data) || (data != '-' && tag == '批示内容');
    final child = Text(
      data,
      textAlign: TextAlign.center,
      style: Config.loadDefaultTextStyle(color: color),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return Container(
      alignment: Alignment.center,
      // color: bgColor,
      width: width ?? data.length * wordLength,
      height: height ?? 60.sp,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.black, width: 0.5),
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
