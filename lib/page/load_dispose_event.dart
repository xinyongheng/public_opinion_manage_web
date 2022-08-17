import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/file_list_view.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/str_util.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class LoadDisposeEventPage extends StatefulWidget {
  final String? info;
  const LoadDisposeEventPage({Key? key, required this.info}) : super(key: key);

  @override
  State<LoadDisposeEventPage> createState() => _LoadDisposeEventPageState();
}

class _LoadDisposeEventPageState extends State<LoadDisposeEventPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Map eventInfo = {};
  List? files;

  @override
  void initState() {
    super.initState();
    if (!DataUtil.isEmpty(widget.info)) {
      Future.delayed(Duration.zero, () {
        loadToken().then((value) {
          if (DataUtil.isEmpty(value)) {
            loginDialog(context);
          } else {
            askInternet(value);
          }
        });
      });
    }
  }

  void askInternet(map) async {
    // String token = map['token']!;
    int userId = map['userId']!;
    ServiceHttp().post('/loadDisposeEvent',
        data: {
          'userId': userId,
          'info': widget.info!,
        },
        isData: false, success: (data) {
      print(data);
      setState(() {
        files = data['files'];
        eventInfo = data['data'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

// loadDisposeEvent?info=
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataUtil.isEmpty(widget.info)
          ? Center(
              child: Text(
                '信息错误,无法访问',
                style: Config.loadAppBarTextStyle(),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg.png'), fit: BoxFit.fill),
              ),
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 1515.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/banner.png',
                      fit: BoxFit.fill,
                      width: 1424.w,
                      height: 235.w,
                    ),
                    Container(
                      width: 1515.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 68.w),
                          Text(
                            '事件处理反馈',
                            style: Config.loadDefaultTextStyle(
                              fonstSize: 27.w,
                              fontWeight: FontWeight.w500,
                              color: Config.fontColorSelect,
                            ),
                          ),
                          SizedBox(height: 48.w),
                          childItem("事件名称：", eventInfo['description'] ?? ''),
                          childItem("原文链接：", eventInfo['link'] ?? ''),
                          DataUtil.isEmpty(files)
                              ? childItem("原文图文信息：", '')
                              : fileItem("原文图文信息：", files!),
                          childItem("媒体类型：", eventInfo['link'] ?? ''),
                          childItem("媒体类型：", eventInfo['link'] ?? ''),
                          childItem("媒体类型：", eventInfo['link'] ?? ''),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget fileItem(String data, List list) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data,
          style: Config.loadDefaultTextStyle(
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
        FileListWidget(
          list: list,
          width: 624.w,
        ),
      ],
    );
  }

  Widget childItem(String data, String content, {double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 46.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data,
            style: Config.loadDefaultTextStyle(
              color: Colors.black.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            width: 624.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Text(
              content,
              style: Config.loadDefaultTextStyle(
                color: Colors.black.withOpacity(0.65),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> loadToken() async {
    String? token = await UserUtil.getToken();
    int? userId = await UserUtil.getUserId();
    if (DataUtil.isEmpty(token)) return null;
    if (DataUtil.isEmpty(userId)) return null;
    Map<String, dynamic> map = {};
    map['token'] = token!;
    map['userId'] = userId!;
    return map;
  }

  void loginDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        title: Center(
            child: Text(
          '登录',
          style: Config.loadFirstTextStyle(),
        )),
        content: Container(
          width: 500.w,
          height: 400.sp,
          // color: Colors.grey,
          alignment: Alignment.center,
          child: loginWidget(context),
        ),
      ),
    );
  }

  Widget loginWidget(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadAccountItem('账号：'),
        SizedBox(height: 15.sp),
        loadPasswordItem('密码：'),
        SizedBox(height: 30.sp),
        TextButton(
          onPressed: () {
            requestLogin(context);
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blue,
            fixedSize: Size(300.sp, 80.sp),
            textStyle: Config.loadDefaultTextStyle(),
          ),
          child: const Text('登录'),
        ),
      ],
    );
  }

  loadAccountItem(String explain) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(explain),
        SizedBox(
          width: 400.sp,
          child: TextField(
            controller: _controller1,
            maxLength: 11,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              label: Icon(Icons.people),
              // labelText: '请输入账号',
              border: OutlineInputBorder(),
              // helperText: '手机号',
              hintText: '请输入账号',
              // errorText: '错误',
            ),
          ),
        )
      ],
    );
  }

  loadPasswordItem(String explain) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(explain),
        SizedBox(
          width: 400.sp,
          child: TextField(
            controller: _controller2,
            maxLines: 1,
            obscureText: true,
            textInputAction: TextInputAction.go,
            decoration: const InputDecoration(
              label: Icon(Icons.password),
              // labelText: '请输入账号',
              border: OutlineInputBorder(),
              // helperText: '手机号',
              hintText: '请输入密码',
              // errorText: '错误',
            ),
          ),
        )
      ],
    );
  }

  requestLogin(context) {
    try {
      String phone = checkEmpty(_controller1.value.text, '请输入手机号');
      String password = checkEmpty(_controller2.value.text, '请输入密码');
      Map map = <String, String>{};
      map['phone'] = phone;
      map['password'] = password;
      ServiceHttp().post(
        ServiceHttp.loginApi,
        data: map,
        isData: false,
        success: (data) async {
          User user = User.fromJson(data);
          await UserUtil.save(user.data!, token: user.token);
          if (!mounted) return;
          showSuccessDialog('登录成功', dialogDismiss: () {
            Navigator.of(context).pop();
            Map<String, dynamic> map1 = {};
            map1['token'] = user.token!;
            map1['userId'] = user.data!.id!;
            askInternet(map1);
          });
        },
      );
    } catch (e) {
      if (e is AssertionError) {
        toast(e.message!.toString());
      } else {
        toast(e.toString());
      }
    }
  }
}
