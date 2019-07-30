import 'package:coffee_app/business/bloc/cart/request_bloc.dart';
import 'package:coffee_app/business/bloc/cart/request_repository.dart';
import 'package:coffee_app/business/bloc/products/product_bloc.dart';
import 'package:coffee_app/business/bloc/products/product_repository.dart';
import 'package:coffee_app/business/bloc/store/store_bloc.dart';
import 'package:coffee_app/business/bloc/store/store_repository.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/business/bloc/user/user_repository.dart';
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
  registerStore();
  registerProduct();
  registerCart();
  // Run the application
  runApp(CoffeeApp());
}

void registerGeneralServices() {
  coffeeGetIt.registerLazySingleton(() => createHttpClient());
}

void registerCart() {
  coffeeGetIt.registerLazySingleton(() => RequestBloc());
  coffeeGetIt.registerLazySingleton((() => RequestRepository()));
}

void registerStore() {
  coffeeGetIt.registerLazySingleton(() => StoreRepository());
  coffeeGetIt.registerLazySingleton(() => StoreBloc());
}

void registerProduct() {
  coffeeGetIt.registerLazySingleton(() => ProductRepository());
  coffeeGetIt.registerLazySingleton(() => ProductBloc());
}

void registerUser() {
  coffeeGetIt.registerLazySingleton(() => UserRepository());
  coffeeGetIt.registerLazySingleton(() => UserBloc());
}
