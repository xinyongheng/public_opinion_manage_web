import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';

import 'widget/info_public_opinion.dart';

/// 统计图事件列表
class StatisticsEventInfoPage extends StatelessWidget {
  final String title;
  final List<PublicOpinionBean> list;
  const StatisticsEventInfoPage(
      {Key? key, required this.title, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Config.pageScaffold(
      title: '统计图事件列表',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50.w),
          Text(
            title,
            style: Config.loadDefaultTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fonstSize: 25.w,
            ),
          ),
          SizedBox(height: 50.w),
          ListInfoWidget(
              selectList: list, canSelect: false, type: 1, isOnlyShow: true),
        ],
      ),
    );
  }
}
