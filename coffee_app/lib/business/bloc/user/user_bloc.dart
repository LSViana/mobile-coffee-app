import 'package:coffee_app/business/model/user.dart';
import 'package:coffee_app/business/transfer/authenticated.dart';
import 'package:coffee_app/business/transfer/authentication.dart';
import 'package:coffee_app/business/bloc/user/user_repository.dart';
import 'package:coffee_app/main.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  UserRepository _repository;
  BehaviorSubject<User> _current;

  UserBloc() {
    _repository = coffeeGetIt<UserRepository>();
    _current = BehaviorSubject<User>();
  }

  Stream<User> get current => _current.stream;

  Future<void> dispose() async {
    await _current.close();
  }

  Future<bool> isAuthenticated()
    => _repository.isAuthenticated();

  Future<Authenticated> authenticate(Authentication authentication)
    => _repository.authenticate(authentication);

  Future<void> saveAuthenticated(Authenticated authenticated)
    => _repository.saveAuthenticated(authenticated);

  Future<Authenticated> getAuthenticated()
    => _repository.getAuthenticated();

  Future<User> getCurrent() async {
    try {
      _current.sink.add(null);
      final user = await _repository.getCurrent();
      _current.sink.add(user);
      return user;
    } catch (e) {
      _current.sink.addError(e);
      return null;
    }
  }

  Future<void> removeAuthenticated()
    => _repository.removeAuthenticated();

  String getCurrentDeliveryAddress() {
    return _current?.value?.deliveryAddress ?? '';
  }

  Future<void> removeFcmToken()
    => _repository.removeFcmToken();
}
