import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.comeFrom});
  final String? comeFrom;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int? oldType;

  /// 验证码 密文
  String codeCiphertext = '';

  /// 验证码图片
  String imageData = '';
  final AsyncMemoizer<Map<String, dynamic>?> _loadTokenCode = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null) {
              return _errorView(snapshot.error?.toString() ?? '异常');
            }
            Map<String, dynamic>? map = snapshot.data;
            if (map != null) {
              // 非空
              String? token = map['token'];
              if (token == null) {
                String? mapCodeCiphertext = map['codeCipher'];
                if (null == mapCodeCiphertext || mapCodeCiphertext.isEmpty) {
                  return _errorView('信息错误-code');
                }
                String? data = map['data'];
                if (null == data || data.isEmpty) {
                  return _errorView('信息错误-imagedata');
                }
                if (imageData.isEmpty) {
                  imageData = data;
                  codeCiphertext = mapCodeCiphertext;
                }

                return _bodyView(imageData);
              }
              int type = map['type'];
              // 管理员
              if (type == 1) return ManageHomePage(token: token);
              // 非管理员
              return DutyUnitHomePage(token: token);
            } else {
              return _errorView('信息错误-result');
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
      future: loadCodeOrToken(),
    );
  }

  Widget _errorView(String msg) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0591FC), Color.fromARGB(255, 28, 205, 240)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Text(
          msg,
          style: Config.loadDefaultTextStyle(),
        ),
      ),
    );
  }

  Widget _bodyView(String imageData) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0591FC), Color.fromARGB(255, 28, 205, 240)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          // width: ScreenUtil().screenWidth,
          height: 1080.h,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '智慧网信',
                  style: Config.loadDefaultTextStyle(
                      color: Colors.white, fonstSize: 50.w),
                ),
                Text(
                  '信息化管理系统',
                  style: Config.loadDefaultTextStyle(
                    color: Colors.white,
                    fonstSize: 70.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _spaceView(),
                _spaceView(),
                _spaceView(),
                //账号
                _rectBoxView(
                  600.w,
                  controller: accountController,
                  explain: '账号',
                  suffixIcon: Image.asset(
                    'images/icon_user.png',
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.fill,
                  ),
                ),
                _spaceView(),
                //密码
                _rectBoxView(
                  600.w,
                  controller: passwordController,
                  explain: '密码',
                  suffixIcon: Image.asset(
                    'images/icon_password.png',
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.fill,
                  ),
                ),
                _spaceView(),
                // 验证码
                _codeView(600.w, imageData),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 600.w,
                  height: 60.w,
                  child: _refreshText(),
                ),
                _spaceView(),
                _loginView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isObscure = true;
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    accountController.dispose();
    passwordController.dispose();
    codeController.dispose();
  }

  Widget _refreshText() {
    return InkWell(
      onTap: () {
        loadCode().then((value) {
          setState(() {
            imageData = value['data'];
            codeCiphertext = value['codeCipher'];
            // print(codeCiphertext);
          });
        });
      },
      child: Text(
        '看不清楚，换一张',
        style: Config.loadDefaultTextStyle(color: Colors.white),
      ),
    );
  }

  Widget _codeView(double width, String imageData) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          _rectBoxView(
            300.w,
            explain: '计算结果',
            controller: codeController,
            suffixIcon: Icon(
              Icons.code,
              size: 30.w,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          svgImage(imageData),
        ],
      ),
    );
  }

  Widget svgImage(String data) {
    // print(data);
    if (data.startsWith('<svg')) {
      return Container(
        decoration: BoxDecoration(
          // border: Border.all(),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        width: 200.w,
        height: 50.w,
        child: SvgPicture.string(
          data,
          width: 200.w,
          height: 50.w,
          fit: BoxFit.contain,
        ),
      );
    }
    return base64Image(data);
  }

  Widget base64Image(String data) {
    if (data.startsWith('data:image/png;base64,')) {
      data = data.split(',')[1];
    }
    Uint8List? bytes;
    try {
      bytes = const Base64Decoder().convert(data);
    } catch (e) {
      bytes = null;
    }
    var child =
        bytes != null ? Image.memory(bytes, fit: BoxFit.contain) : Container();
    return SizedBox(
      width: 200.w,
      height: 50.w,
      child: child,
    );
  }

  Widget _spaceView() => SizedBox(height: 20.w);

  Widget _rectBoxView(double width,
      {TextEditingController? controller,
      String explain = '',
      Widget? suffixIcon}) {
    return Container(
      width: width,
      height: 50.w,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(5.w),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: 10.w),
          suffixIcon ?? const SizedBox(width: 0, height: 0),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: explain == '密码' && _isObscure,
              style: Config.loadDefaultTextStyle(
                fontWeight: FontWeight.w400,
                fonstSize: 22.w,
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '请输入$explain',
                hintStyle: Config.loadDefaultTextStyle(
                  color: Config.borderColor,
                  fontWeight: FontWeight.w400,
                  fonstSize: 22.w,
                ),
                contentPadding: EdgeInsets.zero,
                // contentPadding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                isCollapsed: false,
                isDense: false,
                // suffixIcon: null,
                suffixIcon: explain == '密码'
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          // size: 20.w,
                        ),
                        padding: EdgeInsets.only(right: 5.w),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.tealAccent),
                        focusColor: Colors.grey,
                        constraints:
                            BoxConstraints(maxWidth: 20.w, maxHeight: 20.w),
                        iconSize: 20.w,
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _loginView() {
    return TextButton(
        onPressed: _toLogin,
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          fixedSize: Size(300.w, 50.w),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          textStyle: Config.loadDefaultTextStyle(),
        ),
        child: const Text('登录'));
  }

  /// 防止重复访问
  Future<Map<String, dynamic>?> loadCodeOrToken() {
    return _loadTokenCode.runOnce(() => _loadCodeOrToken());
  }

  /// 加载token 或code
  Future<Map<String, dynamic>?> _loadCodeOrToken() async {
    if (widget.comeFrom == UserUtil.reLogin) {
      oldType = await UserUtil.getType();
      await UserUtil.clearUser();
      return await loadCode();
    }
    String? token = await UserUtil.getToken();
    int? type = await UserUtil.getType();
    if (DataUtil.isEmpty(token)) {
      return await loadCode();
    }
    if (DataUtil.isEmpty(type)) {
      return await loadCode();
    }
    Map<String, dynamic> map = {};
    map['token'] = token;
    map['type'] = type;
    return map;
  }

  Future<Map<String, dynamic>> loadCode() {
    final completer = Completer<Map<String, dynamic>>();
    ServiceHttp().post(
      ServiceHttp.loadCode,
      isData: false,
      success: (data) {
        completer.complete(data as Map<String, dynamic>);
      },
      error: (msg, data) => completer.completeError(msg),
    );
    return completer.future;
  }

  ///去登录
  void _toLogin() {
    String account = accountController.text;
    if (account.isEmpty) {
      showNoticeDialog('请输入账号');
      return;
    }
    String password = passwordController.text;
    if (password.isEmpty) {
      showNoticeDialog('请输入密码');
      return;
    }
    String code = codeController.text;
    if (code.isEmpty) {
      showNoticeDialog('请输入验证码计算结果');
      return;
    }
    Map map = <String, String>{};
    map['phone'] = account;
    map['password'] = password;
    map['loginCode'] = code;
    map['codeCipher'] = codeCiphertext;
    ServiceHttp().post(
      ServiceHttp.loginApi,
      data: map,
      isData: false,
      success: (data) async {
        User user = User.fromJson(data);
        await UserUtil.save(user.data!,
            token: user.token, loginTime: user.loginTime ?? '');
        if (!mounted) return;
        if (widget.comeFrom == UserUtil.reLogin &&
            null != oldType &&
            oldType == user.data!.type) {
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
  }
}
