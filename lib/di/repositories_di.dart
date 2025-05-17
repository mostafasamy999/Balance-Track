import 'package:get_it/get_it.dart';
import '../data/repositories/client_repository_impl.dart';
import '../domain/repositories/client_repository.dart';
import 'injection.dart';


void registerRepositories() {
  // Repositories
  sl.registerLazySingleton<ClientRepository>(
        () => ClientRepositoryImpl(localDataSource: sl()),
  );
}