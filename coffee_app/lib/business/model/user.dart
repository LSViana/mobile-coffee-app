class User {
  String id;
  String name;
  String deliveryAddress;
  String email;
  String password;

  User(this.id, this.name, this.email, this.password);

  User.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    name = json["name"];
    email = json["email"];
    password = json["password"];
    deliveryAddress = json["deliveryAddress"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "deliveryAddress": deliveryAddress,
    };
  }
}
