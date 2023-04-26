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

  static String subDate(String time, {bool tag = true}) {
    // yyyy-mm-dd HH:mm
    if (tag) {
      if (time.length > 16) return time.substring(0, 16);
    }
    return time;
  }
}
