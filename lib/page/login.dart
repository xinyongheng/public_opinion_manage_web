import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/str_util.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'homepage.dart';

// Stepper Sstep
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
          color: Colors.yellow,
          width: 1200.w,
          height: double.infinity,
          child: Image.asset(
            'images/login_left.png',
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '欢迎登录',
                  style: Config.loadDefaultTextStyle(
                    fonstSize: 32.w,
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 50.w),
                Image.asset(
                  "images/logo_text.png",
                  width: 232.w,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 30.w),
                loadAccountItem('账号'),
                SizedBox(height: 30.w),
                loadPasswordItem('密码'),
                SizedBox(height: 30.w),
                ..._images,
                TextButton(
                  onPressed: () {
                    requestLogin();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Config.fontColorSelect,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    textStyle: Config.loadDefaultTextStyle(
                      fonstSize: 22.w,
                      fontWeight: FontWeight.w400,
                    ),
                    fixedSize: Size(500.w, 60.w),
                  ),
                  child: const Text('登录'),
                ),
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

  bool _isObscure = true;

  Widget loadEditText(String explain, controller) {
    return Container(
      width: 500.w,
      height: 60.w,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(5.w),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Image.asset(
              explain == '账号'
                  ? 'images/icon_user.png'
                  : 'images/icon_password.png',
              width: 30.w,
              height: 30.w,
              fit: BoxFit.fill),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: explain == '密码' && _isObscure,
              style: Config.loadDefaultTextStyle(
                fontWeight: FontWeight.w400,
                fonstSize: 22.w,
              ),
              decoration: InputDecoration(
                hintText: '请输入$explain',
                hintStyle: Config.loadDefaultTextStyle(
                  color: Config.borderColor,
                  fontWeight: FontWeight.w400,
                  fonstSize: 22.w,
                ),
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                isDense: true,
                suffix: explain == '密码'
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          size: 20.w,
                        ),
                        padding: EdgeInsets.zero,
                      )
                    : null,
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  loadAccountItem(String explain) {
    return loadEditText(explain, _controller1);
  }

  loadPasswordItem(String explain) {
    return loadEditText(explain, _controller2);
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
            final int? type = user.data?.type;
            if (null == type) {
              showSuccessDialog("账号类型错误！");
              return;
            }
            if (type == 1) {
              Config.startPage(context, ManageHomePage(token: user.token!));
            } else {
              Config.startPage(context, DutyUnitHomePage(token: user.token!));
            }
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
