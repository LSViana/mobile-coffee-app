import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:coffee_app/business/exceptions/http_exception.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_with_interceptor.dart';

class CartRepository {
  ApiSettings _apiSettings;

  HttpWithInterceptor _client;

  CartRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
    _client = coffeeGetIt<HttpWithInterceptor>();
  }

  Future<void> send(Cart cart) async {
    final response = await _client.post(
      '${_apiSettings.base}/requests',
      body: jsonEncode(cart.toJson())
    );
    if(response.statusCode == HttpStatus.ok) {
      // Request successfully created
    } else {
      throw HttpException(response.statusCode);
    }
  }
}
