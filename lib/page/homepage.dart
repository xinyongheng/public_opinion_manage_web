import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/page/widget/duty_unit_info_list.dart';
import 'package:public_opinion_manage_web/page/widget/save_event_info.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'new_login.dart';
import 'widget/history_press_file.dart';
import 'widget/home_menu.dart';
import 'widget/info_public_opinion.dart';
import 'widget/make_account.dart';
import 'widget/press_list.dart';
import 'widget/statistics.dart';

///管理员首页
class ManageHomePage extends StatefulWidget {
  final String token;

  const ManageHomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<ManageHomePage> createState() => _ManageHomePageState();
}

class _ManageHomePageState extends State<ManageHomePage> {
  int newNoticeNum = 0;
  int sumNoticeNum = 0;
  int _nowIndex = 1;
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
      const StatisticsWidget(),
      const MakeAccountWidget(),
    ];
    Config.eventBus.on<ChangeHomepage>().listen((event) {
      if (event.index > 0) {
        setState(() {
          _nowIndex = event.index;
        });
      }
    });
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
            height: 50.w,
            width: 20.w,
            color: Colors.transparent,
          ),
          // SizedBox(width: 10.sp),
          Text('智慧网信系统', style: Config.loadFirstTextStyle()),
          const Spacer(),

          /* Text('($newNoticeNum/$sumNoticeNum)',
              style: Config.loadDefaultTextStyle()), 
          Image.asset(
            'images/notice.png',
            height: 21.w,
            width: 21.w,
          ),*/
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
          homeMenu(
            '蒙城县委网信办',
            offset: Offset(0, 45.w),
            padding: EdgeInsets.zero,
          ),
          SizedBox(width: 32.w),
        ],
      ),
    ];
  }

  final arr = ['舆情录入', '舆情列表', '舆情报刊', '舆情统计', '生成账号'];

  Widget leftMenuView() {
    List<Widget> leftArr = <Widget>[];
    for (var i = 0; i < arr.length; i++) {
      leftArr.add(leftListItem(i));
      leftArr.add(SizedBox(height: 10.w));
    }
    return SizedBox(
      // width: 373.w,
      width: 160.w,
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

  void unLogin() {
    ServiceHttp().get("/unlogin", success: (data) {
      UserUtil.clearUser().then((value) {
        Config.startPageAndFinishOther(context, const LoginPage());
      });
    });
  }
}

///处理单位首页
class DutyUnitHomePage extends StatefulWidget {
  final String token;

  const DutyUnitHomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<DutyUnitHomePage> createState() => _DutyUnitHomePageState();
}

class _DutyUnitHomePageState extends State<DutyUnitHomePage> {
  int newNoticeNum = 0;
  int sumNoticeNum = 0;
  int _nowIndex = 0;
  int _pressIndex = 0;
  final Color lineColor = Colors.grey;
  final arr = ['全部信息', '未处理', '已处理'];
  String unit = "";
  List<PublicOpinionBean>? allList;
  List<PublicOpinionBean>? weiChuLiList;
  List<PublicOpinionBean>? tongGuoList;
  List<PublicOpinionBean>? weiTongGuoList;
  List<PublicOpinionBean>? daiShenHeList;
  @override
  void initState() {
    super.initState();
    askInternet();
    UserUtil.getUnit().then((value) => setState(() => unit = value));
    Config.eventBus.on<DutyEventUpdateHomeData>().listen((event) {
      if (event.needUpdate && mounted) {
        askInternet();
      }
    });
  }

  void askInternet() async {
    final finalMap = <String, dynamic>{};
    finalMap["userId"] = await UserUtil.getUserId();
    ServiceHttp().post("/eventList", data: finalMap, success: (data) {
      allList = PublicOpinionBean.fromJsonArray(data);
      weiChuLiList = fileterList(allList, '未处理');
      tongGuoList = fileterList(allList, '通过');
      weiTongGuoList = fileterList(allList, '未通过');
      daiShenHeList = fileterList(allList, '待审核');
      setState(() {
        newNoticeNum = weiChuLiList!.length + weiTongGuoList!.length;
        sumNoticeNum = allList!.length;
        // print("$newNoticeNum/$sumNoticeNum");
      });
    });
  }

  List<PublicOpinionBean> fileterList(
      List<PublicOpinionBean>? allList, String filter) {
    final List<PublicOpinionBean> filterList = [];
    // int needDutyCout = 0;
    allList?.forEach((element) {
      if (element.passState == filter) {
        filterList.add(element);
      }
    });
    return filterList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          headView(),
          Expanded(
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
                              ? loadCenterWidget(_nowIndex)
                              : loadCenterWidget(_nowIndex + _pressIndex)),
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

  Widget loadCenterWidget(int index) {
    switch (index) {
      case 0:
        return DutyUnitInfoListWidget(title: '全部信息', list: allList);
      case 1:
        return DutyUnitInfoListWidget(title: '未处理', list: weiChuLiList);
      case 2:
        return DutyUnitInfoListWidget(title: '通过', list: tongGuoList);
      case 3:
        return DutyUnitInfoListWidget(title: '未通过', list: weiTongGuoList);
      default:
        return DutyUnitInfoListWidget(title: '待审核', list: daiShenHeList);
    }
  }

  Widget headView() {
    return Row(
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
          height: 75.sp,
          width: 20.w,
          color: Colors.transparent,
        ),
        // SizedBox(width: 10.sp),
        Text('智慧网信系统', style: Config.loadFirstTextStyle()),
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
        homeMenu(
          unit,
          offset: Offset(0, 45.w),
          padding: EdgeInsets.zero,
        ),
        SizedBox(width: 32.w),
      ],
    );
  }

  Widget leftMenuView() {
    List<Widget> leftArr = <Widget>[];
    for (var i = 0; i < arr.length; i++) {
      leftArr.add(leftListItem(i));
      leftArr.add(SizedBox(height: 10.w));
    }
    return SizedBox(
      width: 160.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: leftArr,
      ),
    );
  }

  Widget leftIcon(String text, int index) {
    String imageName;
    switch (text) {
      case '全部信息':
        imageName = 'op_all';
        break;
      case '未处理':
        imageName = 'op_list';
        break;
      case '已处理':
        imageName = 'op_press';
        break;
      default:
        imageName = 'op_statics';
    }
    return Image.asset(
      "images/$imageName.png",
      color: index == _nowIndex ? Config.fontColorSelect : Colors.black,
      width: 21.w,
      height: 21.w,
      fit: BoxFit.fill,
    );
  }

  Widget leftListItem(int index) {
    final text = arr[index];
    if (text != '已处理') {
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
                      child: Text('通过',
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
                      child: Text('未通过',
                          style: Config.loadDefaultTextStyle(
                              fonstSize: 19.sp,
                              color: _pressIndex == 1
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
                      if (_pressIndex != 2) {
                        setState(() {
                          _pressIndex = 2;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Text('待审核',
                          style: Config.loadDefaultTextStyle(
                              fonstSize: 19.sp,
                              color: _pressIndex == 2
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

  void menuItemClick(String text, int index) {
    if (_nowIndex == index) return;
    setState(() {
      _nowIndex = index;
    });
    /* toast(text);
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
    } */
  }

  void unLogin() {
    ServiceHttp().get("/unlogin", success: (data) {
      UserUtil.clearUser().then((value) {
        Config.startPageAndFinishOther(context, const LoginPage());
      });
    });
  }
}
