import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/page/add_public_opinion.dart';
import 'package:public_opinion_manage_web/page/info_public_opinion.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(/* text: '17600666716' */);
    _controller2 = TextEditingController(/* text: '123456' */);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadAcountItem('账号：'),
          SizedBox(height: 15.sp),
          loadPasswordItem('密码：'),
          SizedBox(height: 30.sp),
          TextButton(
            onPressed: () {
              Config.startPage(context, const ListInfoWidget());
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.only(
                left: 60.sp,
                top: 15.sp,
                right: 60.sp,
                bottom: 15.sp,
              ),
            ),
            child: const Text('登录'),
          ),
          SizedBox(height: 300.h),
        ],
      ),
    );
  }

  loadAcountItem(String explain) {
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
}
