import 'package:coffee_app/definitions/api_settings.dart';

class ApiSettingsDev extends ApiSettings {
  @override
  String get base => 'http://192.168.1.36:5000/api';
}