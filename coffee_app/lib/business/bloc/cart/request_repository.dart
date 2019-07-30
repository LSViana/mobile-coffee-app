import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:coffee_app/business/exceptions/http_exception.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/request.dart';
import 'package:coffee_app/definitions/api_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_with_interceptor.dart';

class RequestRepository {
  ApiSettings _apiSettings;

  HttpWithInterceptor _client;

  RequestRepository() {
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

  Future<Iterable<Request>> getMine() async {
    final response = await _client.get('${_apiSettings.base}/requests/mine');
    if(response.statusCode == HttpStatus.ok) {
      final mineJson = jsonDecode(response.body) as List;
      final mine = mineJson.map((item) => Request.fromJson(item));
      return mine;
    } else {
      throw HttpException(response.statusCode);
    }
  }
}
