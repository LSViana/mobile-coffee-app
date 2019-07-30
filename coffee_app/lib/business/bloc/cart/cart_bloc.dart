import 'package:coffee_app/business/bloc/cart/cart_repository.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/cart_delivery.dart';
import 'package:coffee_app/business/model/cart_item.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  BehaviorSubject<Cart> _cart;
  CartRepository _repository;

  CartBloc() {
    _repository = coffeeGetIt<CartRepository>();
    _cart = BehaviorSubject<Cart>();
    _cart.sink.add(Cart(
        items: [],
        storeId: null,
        deliveryAddress: '',
        deliveryDate: DateTime.now()));
  }

  Stream<Cart> get cart => _cart.stream;

  Future<void> dispose() async {
    await _cart.close();
  }

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
    if (_cart.hasValue) {
      final cart = _cart.value;
      cart.items.removeWhere((item) => item.productId == productId);
      _cart.sink.add(cart);
    }
  }

  CartItem getItem(String productId) {
    return _cart?.value?.items
        ?.firstWhere((item) => item.productId == productId, orElse: () => null);
  }

  String getCurrentDeliveryAddress({String orElse: ''}) {
    return _cart?.value?.deliveryAddress ?? orElse;
  }

  void restoreToStore(String id) {
    if (_cart.value.storeId != id) {
      _cart.sink.add(Cart(
        items: [],
        storeId: id,
        deliveryAddress: null,
        deliveryDate: null,
      ));
    }
  }

  void setScheduleDelivery(CartDelivery value) {
    if (_cart.hasValue) {
      final cart = _cart.value;
      if (value == CartDelivery.now) {
        cart.deliveryDate = null;
      } else if (value == CartDelivery.schedule) {
        cart.deliveryDate = DateTime.now();
      }
      // Updating cart
      _cart.sink.add(cart);
    }
  }

  void updateProductAmount(String productId, int amount) {
    if (_cart.hasValue) {
      final cart = _cart.value;
      final item =
          cart.items.firstWhere((value) => value.productId == productId);
      item.amount = amount;
      // Updating cart
      _cart.sink.add(cart);
    }
  }

  void updateDeliveryAddress(String deliveryAddress) {
    if (_cart.hasValue) {
      final cart = _cart.value;
      cart.deliveryAddress = deliveryAddress;
      // Updating cart
      _cart.sink.add(cart);
    }
  }

  bool isEmpty() {
    return _cart?.value?.items?.isEmpty ?? true;
  }

  Future<void> send() async {
    if(_cart.hasValue) {
      final cart = _cart.value;
      await _repository.send(cart);
    }
  }
}
