import 'package:intl/intl.dart';

Duration parseDurationFromHours(String durationText) {
  final dateTime = DateFormat.Hms().parse(durationText);
  return Duration(
      hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second);
}

String writeDurationToHours(Duration duration) {
  return '${duration.inHours / 24}:${duration.inMinutes / 60}:${duration.inSeconds / 60}';
}
