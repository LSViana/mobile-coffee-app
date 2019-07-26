import 'dart:io';

import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/definitions/http_settings.dart';
import 'package:coffee_app/main.dart';
import 'package:http_interceptor/http_interceptor.dart';

HttpWithInterceptor createHttpClient() {
  final _client =
      HttpWithInterceptor.build(interceptors: [_CoffeeInterceptor()]);
  return _client;
}

class _CoffeeInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    await _handlerUserSection(data);
    return data;
  }

  Future<void> _handlerUserSection(RequestData data) async {
    final _userBloc = coffeeGetIt<UserBloc>();
    if (await _userBloc.isAuthenticated()) {
      final authenticated = await _userBloc.getAuthenticated();
      data.headers[HttpHeaders.authorizationHeader] =
          HttpSettings.getAuthorizationHeaderValue(authenticated.token);
    }
    if (data.body is String) {
      data.headers[HttpHeaders.contentTypeHeader] = "application/json";
    }
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
