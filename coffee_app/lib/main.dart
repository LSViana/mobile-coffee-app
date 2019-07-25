import 'package:coffee_app/business/user/user_bloc.dart';
import 'package:coffee_app/business/user/user_repository.dart';
import 'package:coffee_app/coffee_app.dart';
import 'package:coffee_app/definitions/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt coffeeGetIt;

void run(registerEnvironmentServices) {
  // Create service container
  coffeeGetIt = GetIt();
  // Register received services
  registerEnvironmentServices(coffeeGetIt);
  // Register services
  registerGeneralServices();
  registerUser();
  // Run the application
  runApp(CoffeeApp());
}

void registerGeneralServices() {
  coffeeGetIt.registerLazySingleton(() => createHttpClient());
}

void registerUser() {
  coffeeGetIt.registerLazySingleton(() => UserRepository());
  coffeeGetIt.registerLazySingleton(() => UserBloc());
}
