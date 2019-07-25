import 'package:coffee_app/business/transfer/authenticated.dart';
import 'package:coffee_app/business/transfer/authentication.dart';
import 'package:coffee_app/business/user/user_repository.dart';
import 'package:coffee_app/main.dart';

class UserBloc {
  UserRepository _repository;

  UserBloc() {
    _repository = coffeeGetIt<UserRepository>();
  }

  Future<bool> isAuthenticated()
    => _repository.isAuthenticated();

  Future<Authenticated> authenticate(Authentication authentication)
    => _repository.authenticate(authentication);

  Future<void> saveCurrentAuthentication(Authenticated authenticated)
    => _repository.saveCurrentAuthenticated(authenticated);

  Future<Authenticated> getCurrentAuthentication()
    => _repository.getCurrentAuthenticated();
}
