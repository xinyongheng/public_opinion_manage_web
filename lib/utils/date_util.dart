import 'package:date_format/date_format.dart';

class DateUtil {
  static final List<String> formats = [
    yyyy,
    "-",
    mm,
    "-",
    dd,
    " ",
    HH,
    ":",
    nn,
    ":",
    ss
  ];
  static String nowDate() {
    return formatDate(DateTime.now(), formats);
  }

  static String subDate(String time) {
    // yyyy-mm-dd
    if (time.length > 10) return time.substring(0, 10);
    return time;
  }
}
