import 'package:intl/intl.dart';

Duration parseDurationFromHours(String durationText) {
  final dateTime = DateFormat.Hms().parse(durationText);
  return Duration(
      hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second);
}

String writeDurationToHours(Duration duration) {
  return '${duration.inHours / 24}:${duration.inMinutes / 60}:${duration.inSeconds / 60}';
}

String writeDateTime(DateTime dateTime) {
  return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour.toStringAsFixed(2)}:${dateTime.minute.toStringAsFixed(2)}:${dateTime.second.toStringAsFixed(2)}';
}

DateTime parseDateTime(String dateTimeText) {
  final dateTime = DateFormat("M'/'d'/'y h':'m':'s").parse(dateTimeText);
  return dateTime;
}
