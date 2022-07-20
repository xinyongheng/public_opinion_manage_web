import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/page/widget/save_event_info.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/str_util.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  final String? comeFrom;
  const LoginPage({Key? key, this.comeFrom}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: '17600666716');
    _controller2 = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  final _images = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              String? token = snapshot.data;
              // InfoSaveUtil.save('account', '17600666716').then((value) => null);
              if (snapshot.data?.isNotEmpty == true) {
                // 非空
                // Config.startPage(context, SaveEventInfoWidget(token: token!));
                //return SaveEventInfoWidget(token: token!);
                return ManageHomePage(token: token!);
              } else {
                return loginRowView();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
        future: loadToken(),
      ),
    );
  }

  Row loginRowView() {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_left.png'),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/logo.png', width: 60.sp, height: 60.sp),
              SizedBox(width: 30.sp),
              Text('舆情台账管理系统', style: Config.loadDefaultTextStyle()),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                loadAccountItem('账号：'),
                SizedBox(height: 15.sp),
                loadPasswordItem('密码：'),
                SizedBox(height: 30.sp),
                ..._images,
                TextButton(
                  onPressed: () {
                    requestLogin();
                  },
                  style: Config.loadPerformButtonStyle(),
                  child: const Text('登录'),
                ),
                SizedBox(height: 300.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> loadToken() async {
    if (widget.comeFrom == UserUtil.reLogin) {
      await UserUtil.clearUser();
      return null;
    }
    return await UserUtil.getToken();
  }

  loadAccountItem(String explain) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(explain),
        SizedBox(
          width: 300.sp,
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
          width: 300.sp,
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

  requestLogin() {
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
          if (widget.comeFrom == UserUtil.reLogin) {
            Config.finishPage(context);
          } else {
            Config.startPage(context, SaveEventInfoWidget(token: user.token!));
          }
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
