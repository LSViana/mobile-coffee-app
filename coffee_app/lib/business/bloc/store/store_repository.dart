import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:coffee_app/business/exceptions/http_exception.dart';
import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_with_interceptor.dart';

class StoreRepository {
  ApiSettings _apiSettings;
  HttpWithInterceptor _client;

  StoreRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
    _client = coffeeGetIt<HttpWithInterceptor>();
  }

  Future<Iterable<Store>> get() async {
    final response = await _client.get('${_apiSettings.base}/stores');
    if(response.statusCode == HttpStatus.ok) {
      final jsonList = jsonDecode(response.body) as List;
      final all = jsonList.map((value) => Store.fromJson(value));
      return all;
    } else {
      throw HttpException(response.statusCode);
    }
  }
}