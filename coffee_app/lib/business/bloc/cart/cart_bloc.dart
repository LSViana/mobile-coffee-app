import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/cart_item.dart';
import 'package:coffee_app/business/model/product.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  BehaviorSubject<Cart> _cart;

  CartBloc() {
    _cart = BehaviorSubject<Cart>();
    _cart.sink.add(Cart(items: []));
  }

  Stream<Cart> get cart => _cart.stream;

  void addProduct(String productId) {
    final cart = _cart.value;
    final item = cart.items
        .firstWhere((item) => item.productId == productId, orElse: () => null);
    if (item != null) {
      // This item's been added previously, increment the amount
      item.amount++;
    } else {
      // This item's never been added, add it with amount 1
      final item = CartItem(productId: productId, amount: 1);
      cart.items.add(item);
    }
    // Add new value
    _cart.sink.add(cart);
  }

  bool isInCart(String productId) {
    return _cart?.value?.items?.any((item) => item.productId == productId) ??
        false;
  }

  void removeProduct(String productId) {
    final cart = _cart.value;
    cart.items.removeWhere((item) => item.productId == productId);
    _cart.sink.add(cart);
  }
}