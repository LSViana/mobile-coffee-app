import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:coffee_app/business/exceptions/http_exception.dart';
import 'package:coffee_app/business/model/product.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_with_interceptor.dart';

class ProductRepository {
  ApiSettings _apiSettings;
  HttpWithInterceptor _client;

  ProductRepository() {
    _apiSettings = coffeeGetIt<ApiSettings>();
    _client = coffeeGetIt<HttpWithInterceptor>();
  }

  Future<Iterable<Product>> listByStore(String storeId) async {
    final response = await _client.get('${_apiSettings.base}/products/byStore/$storeId');
    if(response.statusCode == HttpStatus.ok) {
      final byStoreJson = jsonDecode(response.body) as List;
      final byStore = byStoreJson.map((value) => Product.fromJson(value));
      return byStore;
    } else {
      throw HttpException(response.statusCode);
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final response = await _client.patch('${_apiSettings.base}/products/togglefavorite/$productId');
    if(response.statusCode == HttpStatus.ok) {
      // Successfully changed, return result;
      return;
    } else {
      throw HttpException(response.statusCode);
    }
  }
}