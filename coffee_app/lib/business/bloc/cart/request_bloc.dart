import 'package:coffee_app/business/bloc/cart/request_repository.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/cart_delivery.dart';
import 'package:coffee_app/business/model/cart_item.dart';
import 'package:coffee_app/business/model/request.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/rxdart.dart';

class RequestBloc {
  BehaviorSubject<Cart> _cart;
  RequestRepository _repository;
  BehaviorSubject<Iterable<Request>> _mine;
  BehaviorSubject<Iterable<Request>> _byStore;

  RequestBloc() {
    _repository = coffeeGetIt<RequestRepository>();
    _cart = BehaviorSubject<Cart>();
    _mine = BehaviorSubject<Iterable<Request>>();
    _byStore = BehaviorSubject<Iterable<Request>>();
    _startDefaultValues();
  }

  void _startDefaultValues() {
    _cart.sink.add(Cart(
        items: [],
        storeId: null,
        deliveryAddress: '',
        deliveryDate: DateTime.now()));
  }

  Stream<Cart> get cart => _cart.stream;
  Stream<Iterable<Request>> get mine => _mine.stream;
  Stream<Iterable<Request>> get byStore => _byStore.stream;

  Future<void> dispose() async {
    await Future.wait([
      _cart.close(),
      _byStore.close(),
      _mine.close(),
    ]);
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

  void restore() {
    if (_cart.hasValue) {
      _cart.sink.add(Cart(
        items: [],
        storeId: _cart.value.storeId,
        deliveryAddress: null,
        deliveryDate: null,
      ));
    }
  }

  Future<Iterable<Request>> getMine() async {
    try {
      _mine.sink.add(null);
      final mine = await _repository.getMine();
      _mine.sink.add(mine);
      return mine;
    } catch(e) {
      _mine.sink.addError(e);
      return null;
    }
  }

  Future<Iterable<Request>> getByStore(String storeId) async {
    try {
      _byStore.sink.add(null);
      final byStore = await _repository.getByStore(storeId);
      _byStore.sink.add(byStore);
      return byStore;
    } catch (e) {
      _byStore.sink.addError(e);
      return null;
    }
  }

  Future<void> updateStatus(Request request) async {
    if(_byStore.hasValue) {
      await _repository.updateStatus(request.id, request.status);
      // TODO Fix forcing recreation to update UI
      final byStore = _byStore.value.toList();
      _byStore.sink.add(byStore);
    }
  }
}
