import 'package:coffee_app/business/model/cart_item.dart';
import 'package:coffee_app/definitions/time_parser.dart';

class Cart {
  List<CartItem> items;
  String storeId;
  String deliveryAddress;
  DateTime deliveryDate;

  Cart({this.items, this.storeId, this.deliveryAddress, this.deliveryDate});

  Map<String, dynamic> toJson() {
    return {
      "deliveryDate": deliveryDate != null ? writeDateTime(deliveryDate) : null,
      "deliveryAddress": deliveryAddress,
      "storeId": storeId,
      "items": items.map((x) => x.toJson()).toList(),
    };
  }
}