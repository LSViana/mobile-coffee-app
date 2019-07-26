import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:coffee_app/business/exceptions/http_exception.dart';
import 'package:coffee_app/business/exceptions/not_found_exception.dart';
import 'package:coffee_app/business/model/user.dart';
import 'package:coffee_app/business/transfer/authenticated.dart';
import 'package:coffee_app/business/transfer/authentication.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/definitions/storage_keys.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_with_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  ApiSettings _apiSettings;
  HttpWithInterceptor _client;

  UserRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
    _client = coffeeGetIt<HttpWithInterceptor>();
  }

  Future<bool> isAuthenticated() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(StorageKeys.authenticated);
  }

  Future<void> saveAuthenticated(Authenticated authenticated) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final authenticatedJson = jsonEncode(authenticated.toJson());
    await sharedPreferences.setString(StorageKeys.authenticated, authenticatedJson);
  }

  Future<Authenticated> getAuthenticated() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final authenticatedJson = jsonDecode(sharedPreferences.getString(StorageKeys.authenticated));
    return Authenticated.fromJson(authenticatedJson);
  }

  Future<void> removeAuthenticated() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(StorageKeys.authenticated);
  }

  Future<Authenticated> authenticate(Authentication authentication) async {
    final response = await _client.post('${_apiSettings.base}/authentication/authenticate/jwt',
      body: jsonEncode(authentication.toJson()),
    );
    if(response.statusCode == HttpStatus.ok) {
      final authenticatedJson = jsonDecode(response.body);
      final authenticated = Authenticated.fromJson(authenticatedJson);
      return authenticated;
    } else if(response.statusCode == HttpStatus.notFound) {
      throw NotFoundException(message: 'Invalid credentials');
    } else {
      throw HttpException(response.statusCode);
    }
  }

  Future<User> getCurrent() async {
    final authenticated = await getAuthenticated();
    final response = await _client.get('${_apiSettings.base}/users/${authenticated.id}');
    if(response.statusCode == HttpStatus.ok) {
      final userJson = jsonDecode(response.body);
      final user = User.fromJson(userJson);
      return user;
    } else if(response.statusCode == HttpStatus.notFound) {
      throw NotFoundException(message: 'User not found');
    } else {
      throw HttpException(response.statusCode);
    }
  }
}
