import 'package:coffee_app/business/model/request_item.dart';
import 'package:coffee_app/business/model/request_status.dart';
import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/definitions/time_parser.dart';

class Request {
  String id;
  DateTime createdAt;
  DateTime deliveryDate;
  String deliveryAddress;
  int status;
  Store store;
  Iterable<RequestItem> items;

  Request(
      {this.id,
      this.createdAt,
      this.deliveryDate,
      this.deliveryAddress,
      this.status,
      this.store,
      this.items});

  Request.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    if (json["createdAt"] != null) createdAt = parseDateTime(json["createdAt"]);
    if (json["deliveryDate"] != null) createdAt = parseDateTime(json["deliveryDate"]);
    status = json["status"];
    if (json["store"] != null) store = Store.fromJson(json["store"]);
    if (json["items"] != null) {
      items = json["items"]
        .map((item) => RequestItem.fromJson(item))
        .cast<RequestItem>()
        .toList();
    } 
  }
}