class HttpSettings {
  static const String authorizationHeader = 'Authorization';
  static String getAuthorizationHeaderValue(String token) =>
    'Bearer $token';
}