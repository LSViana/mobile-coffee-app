import 'dart:core';

class Authentication {
  String email;
  String password;

  Authentication(this.email, this.password);

  Authentication.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}