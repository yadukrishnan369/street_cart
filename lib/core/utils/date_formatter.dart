import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToReadableDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date); // Oct 12, 2026
  }

  static String formatToTime(DateTime date) {
    return DateFormat('hh:mm a').format(date); // 02:30 PM
  }

  static String formatToDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  static String formatToLoginDateTime(DateTime date) {
    return DateFormat("MMM dd, yyyy 'at' hh:mm a").format(date);
  }

  static String formatToOrderDateTime(DateTime date) {
    return DateFormat('dd-MM-yyyy hh:mm a').format(date); // 08-07-2026 02:30 PM
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
