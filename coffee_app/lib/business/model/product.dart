class Product {
  String id;
  String name;
  String description;
  String imageUrl;
  double price;
  String categoryId;

  Product(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.price,
      this.categoryId});

  Product.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    name = json["name"];
    description = json["description"];
    imageUrl = json["imageUrl"];
    price = json["price"].toDouble();
    categoryId = json["categoryId"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
      "categoryId": categoryId,
    };
  }
}
