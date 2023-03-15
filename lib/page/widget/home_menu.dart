import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/page/new_login.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

PopupMenuButton homeMenu(String data,
    {String tooltip = '菜单',
    Offset? offset,
    EdgeInsets padding = EdgeInsets.zero}) {
  return PopupMenuButton(
    tooltip: tooltip,
    offset: offset ?? Offset.zero,
    padding: padding,
    color: const Color(0xFFFAFAFA),
    child: Text(data, style: Config.loadDefaultTextStyle()),
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          onTap: () {
            // PopupMenuItem 的 handleTap 会自动调用Navigator.pop方法，导致弹窗无法启动
            Future.delayed(const Duration(), () => _changePassword(context));
          },
          height: 35,
          value: "changePassword",
          padding: EdgeInsets.only(left: 50.w),
          child: Text(
            "修改密码",
            style: Config.loadDefaultTextStyle(fonstSize: 13.w),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            _unLogin(context);
          },
          height: 35,
          value: "logitOut",
          padding: EdgeInsets.only(left: 50.w),
          child: Text(
            "退出登录",
            style: Config.loadDefaultTextStyle(fonstSize: 13.w),
          ),
        ),
      ];
    },
  );
}

///退出登录
void _unLogin(context) {
  ServiceHttp().get("/unlogin", success: (data) {
    UserUtil.clearUser().then((value) {
      Config.startPageAndFinishOther(context, const LoginPage());
    });
  });
}

GlobalKey<_ChangePasswordWidgetState> _globalKey = GlobalKey();

///修改密码
void _changePassword(context) {
  print(context);
  final contentWidget = ChangePasswordWidget(key: _globalKey);
  showCenterNoticeDialog(
    context,
    // title: '修改密码',
    isNeedTitle: false,
    barrierDismissible: false,
    clickDismiss: false,
    contentWidget: contentWidget,
    onPress: () => _globalKey.currentState!.requestUpdatePassword(context),
  );
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _newAgainController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _oldController.dispose();
    _newController.dispose();
    _newAgainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 400.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.w),
          itemView('旧密码：', '请输入旧密码', _oldController),
          itemView('新密码：', '请输入新密码', _newController),
          itemView('新密码：', '请再次输入新密码', _newAgainController),
        ],
      ),
    );
  }

  Widget itemView(
      String data, String explain, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.w),
            child: Text(
              data,
              style: Config.loadDefaultTextStyle(fonstSize: 16.w),
            ),
          ),
          SizedBox(
            width: 300.w,
            child: Config.textInputView(
              explain,
              controller,
              maxLength: 11,
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }

  void requestUpdatePassword(context) async {
    String oldPs = _oldController.text;
    if (oldPs.isEmpty) {
      showNoticeDialog('请输入旧密码');
      return;
    }
    String newPs = _newController.text;
    if (newPs.length < 6) {
      showNoticeDialog('新密码长度应大于6位');
      return;
    }
    if (newPs.length > 11) {
      showNoticeDialog('新密码长度应小于11位');
      return;
    }
    String againNewPs = _newAgainController.text;
    if (againNewPs.isEmpty) {
      showNoticeDialog('请再次输入新密码');
      return;
    }
    if (oldPs == newPs) {
      showNoticeDialog('新密码和旧密码相同');
      return;
    }
    if (newPs != againNewPs) {
      showNoticeDialog('两次输入的新密码不一致');
      return;
    }
    final map = await UserUtil.makeUserIdMap();
    map['oldPassword'] = oldPs;
    map['password'] = newPs;
    map['phone'] = await UserUtil.getAccount();
    ServiceHttp().post('/updatePassword', data: map, success: (data) {
      Navigator.of(context).pop(true);
      showSuccessDialog('密码修改成功');
    });
  }
}
