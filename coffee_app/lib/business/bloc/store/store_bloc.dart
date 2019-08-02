import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/business/bloc/store/store_repository.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/subjects.dart';

class StoreBloc {
  StoreRepository _repository;
  BehaviorSubject<Iterable<Store>> _all;
  BehaviorSubject<Iterable<Store>> _byUser;

  StoreBloc() {
    _repository = coffeeGetIt<StoreRepository>();
    _all = BehaviorSubject<Iterable<Store>>();
    _byUser = BehaviorSubject<Iterable<Store>>();
  }

  Stream<Iterable<Store>> get all => _all.stream;
  Stream<Iterable<Store>> get byUser => _byUser.stream;

  Future<void> dispose() async {
    _all.close();
    _byUser.close();
  }

  Future<Iterable<Store>> get() async {
    try {
      _all.sink.add(null);
      final all = await _repository.get();
      _all.sink.add(all);
      return all;
    } catch (e) {
      _all.sink.addError(e);
      return null;
    }
  }

  Future<Iterable<Store>> getByUser(String userId) async {
    try {
      _byUser.sink.add(null);
      final byUser = await _repository.getByUser(userId);
      _byUser.sink.add(byUser);
      return byUser;
    } catch (e) {
      _all.sink.addError(e);
      return null;
    }
  }
}
