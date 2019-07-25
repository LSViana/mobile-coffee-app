import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/business/bloc/store/store_repository.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/subjects.dart';

class StoreBloc {
  StoreRepository _repository;
  BehaviorSubject<Iterable<Store>> _all;

  StoreBloc() {
    _repository = coffeeGetIt<StoreRepository>();
    _all = BehaviorSubject<Iterable<Store>>();
  }

  Stream<Iterable<Store>> get all => _all.stream;

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
}
