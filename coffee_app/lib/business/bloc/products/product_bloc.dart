import 'package:coffee_app/business/bloc/products/product_repository.dart';
import 'package:coffee_app/business/model/product.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  ProductRepository _repository;
  BehaviorSubject<Iterable<Product>> _byStore;

  ProductBloc() {
    _repository = coffeeGetIt<ProductRepository>();
    _byStore = BehaviorSubject<Iterable<Product>>();
  }

  Stream<Iterable<Product>> get byStore => _byStore.stream;

  Future<void> dispose() async {
    _byStore.close();
  }

  Future<Iterable<Product>> listByStore(String storeId) async {
    try {
      _byStore.sink.add(null);
      final byStore = await _repository.listByStore(storeId);
      _byStore.sink.add(byStore);
      return byStore;
    } catch (e) {
      _byStore.sink.addError(e);
      return null;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    await _repository.toggleFavorite(productId);
    _byStore.sink.add(_byStore.value);
  }
}