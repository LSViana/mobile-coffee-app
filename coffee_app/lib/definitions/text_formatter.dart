import 'package:coffee_app/business/model/request_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
  final dateTime = DateTime.parse(dateTimeText);
  return dateTime;
}

String writeRequestStatus(BuildContext context, int value) {
  if (value >= 0 && value <= RequestStatus.values.length - 1) {
    final requestStatusName = RequestStatus.values[value].toString().split('.').last;
    return FlutterI18n.translate(context, 'requestStatus.$requestStatusName');
  }
  return FlutterI18n.translate(context, 'names.unknown');
}
