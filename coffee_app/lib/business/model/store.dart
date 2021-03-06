import 'package:coffee_app/business/model/category.dart';
import 'package:coffee_app/definitions/text_formatter.dart';

class Store {
  String id;
  String name;
  String imageUrl;
  bool open;
  Duration openingTime;
  Duration closingTime;
  int workingDays;
  List<Category> categories;

  Store(
      {this.id,
      this.name,
      this.imageUrl,
      this.open,
      this.openingTime,
      this.closingTime,
      this.workingDays,
      this.categories});

  Store.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["id"];
    name = json["name"];
    imageUrl = json["imageUrl"];
    open = json["open"];
    if (json["openingTime"] != null)
      openingTime = parseDurationFromHours(json["openingTime"]);
    if (json["closingTime"] != null)
      closingTime = parseDurationFromHours(json["closingTime"]);
    workingDays = json["workingDays"];
    if (json["categories"] != null)
      categories = json["categories"]
          .map((value) => Category.fromJson(value))
          .cast<Category>()
          .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "open": open,
      "openingTime": writeDurationToHours(openingTime),
      "closingTime": writeDurationToHours(closingTime),
      "workingDays": workingDays,
      "categories": categories?.map((value) => value.toJson()),
    };
  }
}
