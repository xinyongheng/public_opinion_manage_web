import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/public_opinion.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class NewPublicOpinionListWidget extends StatefulWidget {
  const NewPublicOpinionListWidget({super.key});
  @override
  State<NewPublicOpinionListWidget> createState() =>
      _NewPublicOpinionListWidgetState();
}

class _NewPublicOpinionListWidgetState
    extends State<NewPublicOpinionListWidget> {
  List<PublicOpinionBean>? _list;
  @override
  void initState() {
    super.initState();
    Config.eventBus.on<UpdateEventListBean>().listen((event) {
      if (event.needUpdate && mounted) {
        askInternet(null);
      }
    });
    askInternet(null);
  }

  // 请求网络列表
  void askInternet(Map<String, dynamic>? map) async {
    final finalMap = <String, dynamic>{};
    if (null != map) {
      finalMap.addAll(map);
    }
    finalMap["userId"] = await UserUtil.getUserId();
    ServiceHttp().post("/eventList", data: finalMap, success: (data) {
      if (mounted) {
        setState(() {
          _list = PublicOpinionBean.fromJsonArray(data);
          print('11111111');
          print(_list!.length);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // height: 1000.w,
      child: PaginatedDataTable(
        columns: [
          DataColumn(
              label: SizedBox(
            width: 300.w,
            child: Text(
              '事件描述',
              style: Config.loadDefaultTextStyle(),
              maxLines: 2,
            ),
          )),
          DataColumn(label: Text('媒体类型', style: Config.loadDefaultTextStyle())),
          DataColumn(label: Text('事件类型', style: Config.loadDefaultTextStyle())),
        ],
        source: MyDataTableSource(_list),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this.data);

  final List<PublicOpinionBean>? data;

  @override
  DataRow? getRow(int index) {
    if (index >= (data?.length ?? 0)) {
      return null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(SizedBox(
            width: 300.w,
            child: Text(
              data![index].description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ))),
        DataCell(Text('${data![index].mediaType}')),
        DataCell(Text('${data![index].type}')),
      ],
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data?.length ?? 0;
  }
}
