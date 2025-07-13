import 'package:get_it/get_it.dart';
import '../domain/usecases/add_category.dart';
import '../domain/usecases/add_client.dart';
import '../domain/usecases/add_transaction.dart';
import '../domain/usecases/get_categories.dart';
import '../domain/usecases/get_clients_by_category.dart';
import '../domain/usecases/get_transactions_by_client.dart';
import 'injection.dart';


void registerUseCases() {
  // Use cases
  injector.registerLazySingleton(() => GetCategories(injector()));
  injector.registerLazySingleton(() => AddCategory(injector()));
  injector.registerLazySingleton(() => GetClientsByCategory(injector()));
  injector.registerLazySingleton(() => AddClientUseCase(injector()));
  injector.registerLazySingleton(() => GetTransactionsByClient(injector()));
  injector.registerLazySingleton(() => AddTransaction(injector()));
}