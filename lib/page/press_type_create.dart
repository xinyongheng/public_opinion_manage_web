import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

class CreatePressType extends StatefulWidget {
  const CreatePressType({Key? key}) : super(key: key);

  @override
  State<CreatePressType> createState() => _CreatePressTypeState();
}

class _CreatePressTypeState extends State<CreatePressType> {
  final _mapController = <String, TextEditingController>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('chaungjain baokan'),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }

  // public opinion search
  Column searchView() {
    final arr = [
      '',
      '',
      '',
      '',
      '',
      '',
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadFirstTitle('search:'),
        Wrap(
          direction: Axis.horizontal,
          spacing: 30.sp,
          children: [],
        )
      ],
    );
  }

  // first title
  Widget loadFirstTitle(data) => Text(data, style: Config.loadFirstTextStyle());
  // secodn title
  Widget loadSecondTitle(data) =>
      Text(data, style: Config.loadDefaultTextStyle());
  Widget searchItemView(data) {
    if (!_mapController.containsKey(data)) {
      _mapController[data] = TextEditingController();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadSecondTitle(data),
        Padding(
          padding: EdgeInsets.only(right: 30.sp),
          child: SizedBox(
            width: 200.sp,
            height: 50.sp,
            child: Padding(
              padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
              child: data.contains('时间')
                  ? Config.dateInputView(data, _mapController[data])
                  : Config.textInputView(data, _mapController[data]),
            ),
          ),
        ),
      ],
    );
  }
}
