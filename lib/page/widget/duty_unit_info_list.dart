import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/page/widget/info_public_opinion.dart';

class DutyUnitInfoListWidget extends StatefulWidget {
  final ValueChanged? valueChanged;
  final String title;
  final List<PublicOpinionBean>? list;
  const DutyUnitInfoListWidget(
      {Key? key, required this.title, this.valueChanged, required this.list})
      : super(key: key);

  @override
  State<DutyUnitInfoListWidget> createState() => DutyUnitInfoListWidgetState();
}

class DutyUnitInfoListWidgetState extends State<DutyUnitInfoListWidget> {
  // final List<PublicOpinionBean> _list = [];

  // void updateList(List<PublicOpinionBean> list) {
  //   _list.clear();
  //   setState(() {
  //     print("${widget.title}: ${list.length}");
  //     _list.addAll(list);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(43.w, 32.w, 0, 39.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: Config.loadFirstTextStyle()),
          SizedBox(height: 30.w),
          ListInfoWidget(
              selectList: widget.list ?? [],
              canSelect: false,
              type: 0,
              isOnlyShow: true),
        ],
      ),
    );
  }
}
