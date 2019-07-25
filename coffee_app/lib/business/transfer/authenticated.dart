class Authenticated {
  String id;
  String name;
  String email;
  String token;

  Authenticated({this.id, this.name, this.email, this.token});

  Authenticated.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "token": token,
    };
  }
}
