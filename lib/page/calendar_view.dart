import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calendar'),
      ),
      body: Stack(
        children: <Widget>[
          DateTimePicker(
            controller: _controller,
            type: DateTimePickerType.dateTime,
            dateMask: 'yyyy-MM-dd HH:mm',
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            dateLabelText: '日期',
            onChanged: (val) {
              print("onChanged: $val");
              print('_controller：${_controller.text}');
            },
            validator: (val) {
              print("validator: $val");
              return null;
            },
            onSaved: (val) => print("onSaved: $val"),
          )
        ],
      ),
    );
  }

  handleNewDate(DateTime date) {}
}
