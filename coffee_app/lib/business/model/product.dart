class Product {
  String id;
  String name;
  String description;
  String imageUrl;
  double price;
  String priceUnit;
  bool favorite;
  bool changing;
  String categoryId;

  Product(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.price,
      this.priceUnit,
      this.favorite,
      this.categoryId,
      this.changing = false});

  Product.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    name = json["name"];
    description = json["description"];
    imageUrl = json["imageUrl"];
    if (json["price"] != null) price = json["price"].toDouble();
    priceUnit = json["priceUnit"];
    favorite = json["favorite"];
    categoryId = json["categoryId"];
    changing = false;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
      "priceUnit": priceUnit,
      "favorite": favorite,
      "categoryId": categoryId,
    };
  }
}
