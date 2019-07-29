import 'package:coffee_app/business/model/cart_item.dart';

class Cart {
  List<CartItem> items;
  String storeId;
  String deliveryAddress;
  DateTime deliveryDate;

  Cart({this.items, this.storeId});
}