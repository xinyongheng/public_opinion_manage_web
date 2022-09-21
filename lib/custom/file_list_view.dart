import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/file_info.dart';
import 'package:public_opinion_manage_web/service/service.dart';

class ShowFileListWidget extends StatelessWidget {
  final double width;
  final List list;
  final int crossAxisCount;
  const ShowFileListWidget(
      {Key? key,
      required this.width,
      required this.list,
      this.crossAxisCount = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: 100.w,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return fileView(list[index]['path'], list[index]['description']);
        },
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 163 / 43.0,
          crossAxisSpacing: 5,
        ),
      ),
    );
  }

  Widget fileView(String path, String name) {
    String type = FileInfoBean.fileType(path);
    String endString = name;
    if (!name.contains('.')) {
      int pointIndex = path.lastIndexOf('.');
      if (pointIndex > -1) {
        endString = name + path.substring(pointIndex);
        // print("${endString}---urlPath=" + path);
      }
    }
    Widget image;
    final urlPath = "${ServiceHttp.parentUrl}/$path";
    if (type == "image") {
      // print("urlPath=" + urlPath);
      image = Image.network(urlPath);
    } else {
      image = Image.asset("images/ic_xls.png");
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45.w,
          height: 43.w,
          color: Colors.grey,
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              Config.launch(urlPath);
            },
            child: image,
          ),
        ),
        SizedBox(width: 11.w),
        SizedBox(
          width: 107.w,
          child: Text(
            endString,
            style: Config.loadDefaultTextStyle(
              fontWeight: FontWeight.w400,
              color: Config.fontColorSelect,
            ),
          ),
        )
      ],
    );
  }
}
