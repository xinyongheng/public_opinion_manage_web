import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/page/add_public_opinion.dart';
import 'package:public_opinion_manage_web/page/press_type_create.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  final _images = <Widget>[];

  @override
  Widget build(BuildContext context) {
    // _images.add(Image.asset('images/placeholder.jpg'));
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadAccountItem('账号：'),
          SizedBox(height: 15.sp),
          loadPasswordItem('密码：'),
          SizedBox(height: 30.sp),
          ..._images,
          TextButton(
            onPressed: () async {
              /* showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                selectableDayPredicate: (datetime) {
                  print(datetime);
                  return false;
                },
              ); */
              Config.startPage(context, const CreatePressType());
              /*final xFile =
                  await ImagePicker().pickVideo(source: ImageSource.camera);
              if (null != xFile) {
                final view = VTImageView(
                  videoUrl: xFile.path,
                  assetPlaceHolder: 'images/placeholder.jpg',
                  width: 100.sp,
                  height: 100.sp,
                );
                setState((){
                  _images.add(view);
                });
              }*/
            },
            style: Config.loadPerformButtonStyle(),
            child: const Text('登录'),
          ),
          SizedBox(height: 300.h),
        ],
      ),
    );
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
}
