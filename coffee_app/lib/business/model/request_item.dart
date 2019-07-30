import 'package:coffee_app/business/model/product.dart';

class RequestItem {
  String id;
  int amount;
  double price;
  Product product;

  RequestItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    amount = json["amount"];
    if (json["price"] != null) price = json["price"].toDouble();
    if(json["product"] != null) product = Product.fromJson(json["product"]);
  }
}
