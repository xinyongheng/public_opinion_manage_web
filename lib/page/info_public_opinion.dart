import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/check_box.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';

class ListInfoPage extends StatelessWidget {
  const ListInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('舆情列表'),
      body: ListInfoWidget(),
    );
  }
}

class ListInfoWidget extends StatefulWidget {
  final bool? canSelect;
  final select_list = <PublicOpinionBean>[];

  ListInfoWidget({Key? key, this.canSelect}) : super(key: key);

  @override
  State<ListInfoWidget> createState() => _ListInfoWidgetState();
}

class _ListInfoWidgetState extends State<ListInfoWidget> {
  final List<PublicOpinionBean> _list = [];
  final wordLength = 20.sp;
  @override
  void initState() {
    // TODO: implement initState
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40.sp,
          height: 30.sp,
          child: Center(child: Text('编辑')),
        ),
        childItemView('序号', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('事件名称', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('媒体类型', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('发布时间', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('发现时间', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('舆情类别', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('责任单位', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('反馈时间', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('上级通报时间', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('报刊类型', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('是否迟报', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('领导批示', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('批示内容', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('是否完结', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
        childItemView('详情', '',
            color: Colors.white, bgColor: Colors.blue, height: 30.sp),
      ],
    );
  }

  Widget tableRowView(PublicOpinionBean bean) {
    bool tag = bean.leaderName == null;
    print(tag);
    String leaderInstructions =
        tag ? '添加' : "${bean.leaderName}\n${bean.leaderInstructionsTime}";
    int index = bean.no! - 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        childItemView(bean.no?.toString() ?? '-', '序号',
            width: 2 * wordLength, index: index),
        childItemView(bean.name.toString(), '事件名称',
            width: 4 * wordLength, index: index),
        childItemView(bean.mediaType.toString(), '媒体类型',
            width: 4 * wordLength, index: index),
        childItemView(bean.linkPublishTime.toString(), '发布时间',
            width: 4 * wordLength, index: index),
        childItemView(bean.findTime.toString(), '发现时间',
            width: 4 * wordLength, index: index),
        childItemView(bean.publicOpinionType.toString(), '舆情类别',
            width: 4 * wordLength, index: index),
        childItemView(bean.dutyUnit?.toString() ?? '指定', '责任单位',
            width: 4 * wordLength, index: index),
        childItemView(bean.feedbackTime.toString(), '反馈时间',
            width: 4 * wordLength, index: index),
        childItemView(bean.superiorNoticeTime.toString(), '上级通报时间',
            width: 5 * wordLength, index: index),
        childItemView(bean.pressType.toString(), '报刊类型',
            width: 4 * wordLength, index: index),
        childItemView(
            bean.isLateReport == 1 ? '是' : (bean.isLateReport == 0 ? '否' : '-'),
            '是否迟报',
            width: 4 * wordLength,
            index: index),
        childItemView(leaderInstructions, '领导批示',
            width: 4 * wordLength, index: index),
        childItemView(bean.leaderInstructionsContent ?? "-", '批示内容',
            width: 4 * wordLength, index: index),
        childItemView(bean.isComplete == 1 ? '是' : '否', '是否完结',
            width: 2 * wordLength, index: index),
        childItemView('查看', '详情', width: 2 * wordLength, index: index),
      ],
    );
  }

  Widget childItemView(String data, String tag,
      {color = Colors.black,
      bgColor = Colors.white,
      double? width,
      double? height,
      int? index}) {
    const clickTag = ',添加,指定,查看,编辑,';
    bool canClick = clickTag.contains(data);
    final child = Text(data, style: Config.loadDefaultTextStyle(color: color));
    return Container(
      alignment: Alignment.center,
      // color: bgColor,
      width: width ?? data.length * wordLength,
      height: height ?? 30.sp,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: canClick
          ? TextButton(
              onPressed: () => viewClick(tag, index ?? 0), child: child)
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
