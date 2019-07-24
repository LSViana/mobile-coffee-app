import 'package:coffee_app/business/api/api_settings_dev.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:get_it/get_it.dart';

void main() {
  run(_registerDevServices);
}

void _registerDevServices(GetIt getIt) {
  getIt.registerLazySingleton<ApiSettings>(() => ApiSettingsDev());
}