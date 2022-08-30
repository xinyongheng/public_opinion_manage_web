import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/service/service.dart';

class MakeAccountWidget extends StatefulWidget {
  const MakeAccountWidget({Key? key}) : super(key: key);

  @override
  State<MakeAccountWidget> createState() => _MakeAccountWidgetState();
}

class _MakeAccountWidgetState extends State<MakeAccountWidget> {
  final _controllerPhone = TextEditingController();
  final _controllerUnit = TextEditingController();
  final _controllerPassword = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controllerPhone.dispose();
    _controllerUnit.dispose();
    _controllerPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SizedBox(
          width: 600.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllerPhone,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.number,
                style: Config.loadDefaultTextStyle(),
                maxLength: 11,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
                ],
                // Text('手机号：', style: Config.loadDefaultTextStyle())
                decoration: InputDecoration(
                  icon: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '手机号', style: Config.loadDefaultTextStyle()),
                        TextSpan(
                            text: '空',
                            style: Config.loadDefaultTextStyle(
                                color: Colors.transparent)),
                        TextSpan(
                            text: '：', style: Config.loadDefaultTextStyle()),
                      ],
                    ),
                  ),
                  hintText: '请输入手机号',
                  hintStyle: Config.loadDefaultTextStyle(),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                ),
              ),
              SizedBox(height: 30.sp),
              // TextField(
              //   controller: _controllerPhone,
              //   textInputAction: TextInputAction.newline,
              //   keyboardType: TextInputType.number,
              //   style: Config.loadDefaultTextStyle(),
              //   maxLength: 11,
              //   inputFormatters: [
              //     FilteringTextInputFormatter(RegExp('[0-9X]'), allow: true)
              //   ],
              //   decoration: InputDecoration(
              //       icon: Text('手机号：', style: Config.loadDefaultTextStyle()),
              //       hintText: '请输入手机号',
              //       hintStyle: Config.loadDefaultTextStyle()),
              // ),
              // SizedBox(height: 30.sp),
              TextField(
                controller: _controllerUnit,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.number,
                style: Config.loadDefaultTextStyle(),
                // maxLength: 11,
                decoration: InputDecoration(
                  icon: Text('单位名称：', style: Config.loadDefaultTextStyle()),
                  hintText: '请输入单位',
                  hintStyle: Config.loadDefaultTextStyle(),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                ),
              ),
              SizedBox(height: 60.sp),
              TextButton(
                onPressed: () => requestMakeAccount(),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp)),
                  fixedSize:
                      Size(Config.defaultSize * 10, Config.defaultSize * 3),
                  textStyle: Config.loadDefaultTextStyle(),
                ),
                child: const Text('确定'),
              )
            ],
          ),
        ),
      ),
    );
  }

  requestMakeAccount() {
    String phone = _controllerPhone.value.text;
    if (phone.isEmpty) return toast('请输入手机号');
    String unit = _controllerUnit.value.text;
    if (unit.isEmpty) return toast('请输入单位名称');
    const password = '123456';
    final map = <String, String>{};
    map['phone'] = phone;
    map['unit'] = unit;
    map['password'] = password;
    map['tokenTag'] = 'not need';
    ServiceHttp().post(ServiceHttp.registerApi, data: map, success: (data) {
      _controllerPhone.text = '';
      _controllerUnit.text = '';
      showSuccessDialog('账号生成成功-$phone');
    });
  }
}
