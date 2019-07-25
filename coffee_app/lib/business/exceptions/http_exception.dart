class HttpException {
  final int statusCode;
  final String message;

  const HttpException(this.statusCode, {this.message = 'Unexpected HTTP response status code'});
}