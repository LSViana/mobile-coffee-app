import 'dart:core';

class Authentication {
  String email;
  String password;
  String fcmToken;

  Authentication({this.email, this.password, this.fcmToken});

  Authentication.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
    fcmToken = json["fcmToken"];
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "fcmToken": fcmToken
    };
  }
}
