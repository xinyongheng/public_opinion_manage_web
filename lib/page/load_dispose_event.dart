import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
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
  @override
  void initState() {
    super.initState();
    if (!DataUtil.isEmpty(widget.info)) {
      Future.delayed(Duration.zero, () {
        loadToken().then((token) {
          if (DataUtil.isEmpty(token)) {
            loginDialog(context);
          }
        });
      });
    }
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
      body: SizedBox(
        child: DataUtil.isEmpty(widget.info)
            ? Center(
                child: Text(
                  '信息错误,无法访问',
                  style: Config.loadAppBarTextStyle(),
                ),
              )
            : Container(),
      ),
    );
  }

  Future<String?> loadToken() async {
    return await UserUtil.getToken();
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
          showSuccessDialog('登录成功');
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
