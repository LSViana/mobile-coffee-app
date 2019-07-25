class HttpSettings {
  static String getAuthorizationHeaderValue(String token) =>
    'Bearer $token';
}