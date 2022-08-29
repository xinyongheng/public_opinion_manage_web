import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/page/widget/info_public_opinion.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class DutyUnitInfoListWidget extends StatefulWidget {
  const DutyUnitInfoListWidget({Key? key}) : super(key: key);

  @override
  State<DutyUnitInfoListWidget> createState() => _DutyUnitInfoListWidgetState();
}

class _DutyUnitInfoListWidgetState extends State<DutyUnitInfoListWidget> {
  final List<PublicOpinionBean> _list = [];
  @override
  void initState() {
    super.initState();
    askInternet();
  }

  void askInternet() async {
    final finalMap = <String, dynamic>{};
    finalMap["userId"] = await UserUtil.getUserId();
    ServiceHttp().post("/eventList", data: finalMap, success: (data) {
      setState(() {
        _list.clear();
        _list.addAll(PublicOpinionBean.fromJsonArray(data));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(43.w, 32.w, 0, 39.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('全部信息', style: Config.loadFirstTextStyle()),
          ListInfoWidget(
              selectList: _list, canSelect: false, type: 0, isOnlyShow: true),
        ],
      ),
    );
  }
}
