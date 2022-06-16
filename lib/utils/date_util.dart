import 'package:date_format/date_format.dart';

class DateUtil{
  static final List<String> formats =  [yyyy, "-", mm, "-", dd, " ", HH, ":", nn, ":", ss];
  static String nowDate(){
    return formatDate(DateTime.now(), formats);
  }
}