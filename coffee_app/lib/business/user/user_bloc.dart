import 'package:coffee_app/business/user/user_repository.dart';
import 'package:coffee_app/main.dart';

class UserBloc {
  UserRepository _repository;

  UserBloc() {
    _repository = coffeeGetIt<UserRepository>();
  }

  Future<bool> isAuthenticated() async => _repository.isAuthenticated();

  String getText() => _repository.getText();
}
