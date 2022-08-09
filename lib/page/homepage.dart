import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/page/widget/save_event_info.dart';

import 'widget/history_press_file.dart';
import 'widget/info_public_opinion.dart';
import 'widget/make_account.dart';
import 'widget/press_list.dart';
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
  int _pressIndex = 0;
  late List<Widget> pages;

  final Color lineColor = Colors.grey;
  @override
  void initState() {
    super.initState();
    pages = [
      SaveEventInfoWidget(token: widget.token),
      const PublicOpinionListWidget(),
      const PressListWidget(),
      // Text(arr[3], style: Config.loadFirstTextStyle()),
      const MyTestPage(),
      const MakeAccountWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...headView(),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg.png'), fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 45.w, bottom: 45.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leftMenuView(),
                    Expanded(
                      flex: 1,
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.sp),
                            color: Colors.white,
                          ),
                          child: _nowIndex != 2
                              ? pages[_nowIndex]
                              : (_pressIndex == 0
                                  ? pages[2]
                                  : const HistoryPressFileWidget())),
                    ),
                    SizedBox(width: 32.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> headView() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 23.w),
          Image.asset(
            'images/logo.png',
            width: 44.w,
            height: 53.w,
          ),
          Container(
            height: 75.w,
            width: 20.w,
            color: Colors.transparent,
          ),
          // SizedBox(width: 10.sp),
          Text('舆情台账管理', style: Config.loadFirstTextStyle()),
          const Spacer(),

          Text('($newNoticeNum/$sumNoticeNum)',
              style: Config.loadDefaultTextStyle()),
          Image.asset(
            'images/notice.png',
            height: 21.w,
            width: 21.w,
          ),
          SizedBox(width: 47.w),
          //Icon(Icons.people, size: Config.firstSize, color: Colors.blue),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: Config.fontColorSelect,
            ),
            child: Image.asset(
              'images/logo.png',
              width: 10.w,
              height: 12.w,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(width: 20.w),
          Text('管理员', style: Config.loadDefaultTextStyle()),
          SizedBox(width: 32.w),
        ],
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
    List<Widget> leftArr = <Widget>[];
    for (var i = 0; i < arr.length; i++) {
      leftArr.add(leftListItem(i));
      leftArr.add(SizedBox(height: 10.w));
    }
    return SizedBox(
      width: 373.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: leftArr,
      ),
    );
  }

  Widget leftListItem(int index) {
    final text = arr[index];
    if (text != '舆情报刊') {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 32.w,
            height: 1.sp,
          ),
          leftIcon(text, index),
          SizedBox(width: 4.w),
          InkWell(
              onTap: () {
                menuItemClick(arr[index], index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.sp,
                  horizontal: 5.sp,
                ),
                child: Text(arr[index],
                    style: Config.loadDefaultTextStyle(
                        color: index == _nowIndex
                            ? Config.fontColorSelect
                            : Colors.black,
                        fonstSize: 21.sp)),
              )),
          const Spacer(flex: 1),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            width: 32.w,
            height: 1.sp,
          ),
          leftIcon(text, index),
          SizedBox(width: 4.w),
          InkWell(
              onTap: () {
                setState(() {
                  _nowIndex = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.sp,
                  horizontal: 5.sp,
                ),
                child: Text(arr[index],
                    style: Config.loadDefaultTextStyle(
                        color: index == _nowIndex
                            ? Config.fontColorSelect
                            : Colors.black,
                        fonstSize: 21.sp)),
              )),
          const Spacer(flex: 1),
        ]),
        Visibility(
          visible: _nowIndex == 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 67.w),
                  InkWell(
                    onTap: () {
                      if (_pressIndex != 0) {
                        setState(() {
                          _pressIndex = 0;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Text('新版',
                          style: Config.loadDefaultTextStyle(
                              fonstSize: 19.sp,
                              color: _pressIndex == 0
                                  ? Config.fontColorSelect
                                  : Colors.black)),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 67.w),
                  InkWell(
                    onTap: () {
                      if (_pressIndex != 1) {
                        setState(() {
                          _pressIndex = 1;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Text('旧文件',
                          style: Config.loadDefaultTextStyle(
                              fonstSize: 19.sp,
                              color: _pressIndex == 1
                                  ? Config.fontColorSelect
                                  : Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget leftIcon(String text, int index) {
    String imageName;
    switch (text) {
      case '舆情录入':
        imageName = 'op_save';
        break;
      case '舆情列表':
        imageName = 'op_list';
        break;
      case '舆情报刊':
        imageName = 'op_press';
        break;
      case '舆情统计':
        imageName = 'op_statics';
        break;
      default:
        imageName = 'op_user';
        break;
    }
    return Image.asset(
      "images/$imageName.png",
      color: index == _nowIndex ? Config.fontColorSelect : Colors.black,
      width: 21.w,
      height: 21.w,
      fit: BoxFit.fill,
    );
  }

  void menuItemClick(String text, int index) {
    if (_nowIndex == index) return;
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
