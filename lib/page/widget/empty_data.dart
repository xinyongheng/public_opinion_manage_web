import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

Widget emptyWidget() {
  return Container(
      constraints: BoxConstraints(maxWidth: 250.w, minHeight: 300.w),
      child: Center(widthFactor: 198.w, child: EmptyDataWidget(width: 198.w)));
}

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key, this.width = 198})
      : height = width * 236 / 198;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/empty_data_icon.png',
            width: width,
            height: width,
            fit: BoxFit.fill,
          ),
          SizedBox(width: width, height: width * 16 / 198),
          Text(
            '暂无数据',
            style: Config.loadDefaultTextStyle(
              color: const Color(0xFF969799),
              fonstSize: 16.w,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
