import 'package:coffee_app/business/exceptions/http_exception.dart';

class NotFoundException extends HttpException {
  NotFoundException({String message}) : super(statusCode: 404, message: message);
}