import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';

class UserRepository {
  ApiSettings _apiSettings;

  UserRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
  }

  getText() => _apiSettings.base;
}
