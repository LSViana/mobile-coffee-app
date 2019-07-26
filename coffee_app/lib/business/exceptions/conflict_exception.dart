import 'package:coffee_app/business/exceptions/http_exception.dart';

class ConflictException extends HttpException {
  ConflictException({String message}) : super(409, message: message);
}