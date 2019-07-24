import 'package:coffee_app/business/api/api_settings_release.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:get_it/get_it.dart';

void main() {
  run(_registerReleaseServices);
}

void _registerReleaseServices(GetIt getIt) {
  getIt.registerLazySingleton<ApiSettings>(() => ApiSettingsRelease());
}