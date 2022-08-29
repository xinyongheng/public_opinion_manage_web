import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/service/service.dart';

typedef ItemPress = void Function(int index);
typedef DialogDismiss = void Function();

showBottomDialog(
  BuildContext context, {
  required List<String> list,
  required ItemPress itemPress,
}) {
  List<Widget> items = [];
  for (int i = 0; i < list.length; i++) {
    var element = list[i];
    items.add(_itemView(element, i, () {
      Navigator.of(context).pop(true);
      itemPress(i);
    }));
    if (i < list.length - 1) {
      items.add(_lineView());
    }
  }
  final radius = Radius.circular(50.sp);
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...items,
              Container(
                  color: const Color.fromARGB(255, 244, 244, 244),
                  height: 10.w),
              _itemView('取消', -1, () => Navigator.of(context).pop(false)),
            ],
          ));
}

Widget _lineView() =>
    Container(color: const Color.fromARGB(255, 223, 222, 222), height: 1);

Widget _itemView(String data, int index, onPress) => InkWell(
      onTap: onPress,
      child: SizedBox(
        height: Config.defaultSize * 4,
        child: Center(
          child: Text(data, style: Config.loadDefaultTextStyle()),
        ),
      ),
    );

showCenterNoticeDialog(BuildContext context,
    {Widget? contentWidget,
    String? title,
    String? contentString,
    GestureTapCallback? onPress,
    bool isNeedTitle = true,
    bool isNeedActions = true,
    bool barrierDismissible = true}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (content) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      title: isNeedTitle
          ? Center(
              child: Text(
              title ?? '温馨提示',
              style: Config.loadFirstTextStyle(),
            ))
          : null,
      content: contentWidget ??
          Container(
            width: 400.w,
            height: 50.sp,
            // color: Colors.grey,
            alignment: Alignment.center,
            child: SelectableText(
              contentString ?? '请输入提示文体',
              style: Config.loadDefaultTextStyle(),
            ),
          ),
      actionsAlignment: MainAxisAlignment.center,
      actions: isNeedActions
          ? [
              TextButton(
                child: Text(
                  "取消",
                  style: Config.loadDefaultTextStyle(color: null),
                ),
                onPressed: () {
                  // 关闭 返回 false
                  Navigator.of(context).pop(false);
                },
              ),
              SizedBox(width: 45.sp),
              // Container(width: 1,color: Colors.grey,height: 30.sp),
              SizedBox(width: 45.sp),
              TextButton(
                child: Text(
                  "确定",
                  style: Config.loadDefaultTextStyle(color: null),
                ),
                onPressed: () {
                  //关闭 返回true
                  Navigator.of(context).pop(true);
                  onPress?.call();
                },
              ),
            ]
          : null,
    ),
  );
}

showWaitDialog() {
  EasyLoading.show(
    status: '访问中...',
    dismissOnTap: false,
    maskType: EasyLoadingMaskType.black,
  );
}

showNoticeDialog(msg, {int seconds = 3, bool dismissOnTap = false}) {
  EasyLoading.showInfo(
    msg,
    duration: Duration(seconds: seconds),
    dismissOnTap: dismissOnTap,
    maskType: EasyLoadingMaskType.black,
  );
}

dismissDialog() {
  EasyLoading.dismiss();
}

toast(String msg) {
  // EasyLoading.showToast(msg);
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.CENTER,
    webPosition: 'center',
  );
}

showSuccessDialog(msg,
    {int seconds = 3,
    bool dismissOnTap = false,
    DialogDismiss? dialogDismiss}) {
  if (null != dialogDismiss) {
    ServiceHttp().callback = (status) {
      if (status == EasyLoadingStatus.dismiss) {
        if (null != ServiceHttp().callback) {
          EasyLoading.removeCallback(ServiceHttp().callback!);
          ServiceHttp().callback = null;
        }
        dialogDismiss.call();
      }
    };
    EasyLoading.addStatusCallback(ServiceHttp().callback!);
  }
  EasyLoading.showSuccess(
    msg,
    duration: Duration(seconds: seconds),
    dismissOnTap: dismissOnTap,
    maskType: EasyLoadingMaskType.black,
  );
}
