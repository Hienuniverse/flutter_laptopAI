import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(num value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(value);
  }
}
