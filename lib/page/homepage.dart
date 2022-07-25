import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/page/widget/save_event_info.dart';

import 'info_public_opinion.dart';
import 'widget/make_account.dart';
import 'widget/test.dart';

class ManageHomePage extends StatefulWidget {
  final String token;

  const ManageHomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<ManageHomePage> createState() => _ManageHomePageState();
}

class _ManageHomePageState extends State<ManageHomePage> {
  int newNoticeNum = 0;
  int sumNoticeNum = 0;
  int _nowIndex = 2;

  late List<Widget> pages;

  final Color lineColor = Colors.grey;
  @override
  void initState() {
    super.initState();
    pages = [
      SaveEventInfoWidget(token: widget.token),
      ListInfoWidget(),
      Text(arr[2], style: Config.loadFirstTextStyle()),
      // Text(arr[3], style: Config.loadFirstTextStyle()),
      const MyTestPage(),
      const MakeAccountWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...headView(),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  leftMenuView(),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: lineColor,
                  ),
                  Expanded(flex: 1, child: pages[_nowIndex - 1]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> headView() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100.w),
          Image.asset(
            'images/logo.png',
            width: Config.firstSize,
            height: Config.firstSize,
          ),
          Container(
            height: Config.firstSize,
            width: 1,
            color: Colors.grey,
          ),
          SizedBox(width: 10.sp),
          Text('舆情台账管理', style: Config.loadFirstTextStyle()),
          const Spacer(),
          Text('管理员', style: Config.loadDefaultTextStyle()),
          Icon(Icons.notifications_outlined,
              size: Config.firstSize, color: Colors.grey),
          Text('($newNoticeNum/$sumNoticeNum)',
              style: Config.loadDefaultTextStyle()),
          Icon(Icons.people, size: Config.firstSize, color: Colors.blue),
          SizedBox(width: 100.w),
        ],
      ),
      Container(
        width: double.infinity,
        height: 1,
        color: lineColor,
      ),
    ];
  }

  final arr = ['舆情录入', '舆情列表', '舆情报刊', '舆情统计', '生成账号'];
  final colors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    const Color.fromARGB(255, 12, 47, 107),
    Colors.orange
  ];
  Widget leftMenuView() {
    return SizedBox(
      width: 8 * Config.defaultSize,
      child: ListView.builder(
          itemCount: arr.length + 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 0) return SizedBox(height: 100.h);
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(flex: 1),
                SizedBox(
                  width: 40.sp,
                  height: 40.sp,
                  child: Card(
                      color: colors[index - 1],
                      shadowColor: colors[index - 1],
                      elevation: 20,
                      child: SizedBox(
                        width: 30.sp,
                        height: 30.sp,
                      )),
                ),
                SizedBox(width: 10.sp),
                InkWell(
                    onTap: () {
                      menuItemClick(arr[index - 1], index);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.sp,
                        horizontal: 5.sp,
                      ),
                      child: Text(arr[index - 1],
                          style: Config.loadDefaultTextStyle()),
                    )),
                const Spacer(flex: 1),
              ],
            );
          }),
    );
  }

  void menuItemClick(String text, int index) {
    setState(() {
      _nowIndex = index;
    });
    toast(text);
    switch (text) {
      case '舆情录入':
        break;
      case '舆情列表':
        break;
      case '舆情报刊':
        break;
      case '舆情统计':
        break;
      case '生成账号':
        break;
      default:
        toast('未知类型');
    }
  }
}
