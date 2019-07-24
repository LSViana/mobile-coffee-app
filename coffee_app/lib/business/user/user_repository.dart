import 'dart:convert';

import 'package:coffee_app/business/model/user.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/definitions/storage_keys.dart';
import 'package:coffee_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  ApiSettings _apiSettings;

  UserRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
  }

  Future<bool> isAuthenticated() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(StorageKeys.user);
  }

  Future<User> getCurrent() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userJson = jsonDecode(sharedPreferences.getString(StorageKeys.user));
    final user = User.fromJson(userJson);
    return user;
  }

  Future<void> setCurrent(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(StorageKeys.user, userJson);
  }

  getText() => _apiSettings.base;
}
