import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  /// تحويل التاريخ إلى وقت نسبي (مثال: منذ 10 دقائق، قبل ساعتين)
  static String timeAgo(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return timeago.format(dateTime, locale: 'ar');
    } catch (e) {
      return '';
    }
  }

  /// تنسيق التاريخ الكامل (مثال: 15 مارس 2026 - 04:30 م)
  static String formatFullDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final formatter = DateFormat('dd MMMM yyyy - hh:mm a', 'ar');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  /// تنسيق الوقت القصير (مثال: 08:30 م)
  static String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final formatter = DateFormat('hh:mm a', 'ar');
      return formatter.format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
