class CartItem {
  String productId;
  int amount;

  CartItem({this.productId, this.amount});

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "amount": amount
    };
  }
}