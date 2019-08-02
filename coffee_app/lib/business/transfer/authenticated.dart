class Authenticated {
  String id;
  String name;
  String email;
  String token;
  String fcmToken;

  Authenticated({this.id, this.name, this.email, this.token, this.fcmToken});

  Authenticated.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    token = json["token"];
    fcmToken = json["fcmToken"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "token": token,
      "fcmToken": fcmToken,
    };
  }
}
