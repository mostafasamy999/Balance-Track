import 'package:get_it/get_it.dart';
import '../data/datasources/local/client_local_data_source.dart';
import 'injection.dart';



void registerDataSources() {
  // Data sources
  injector.registerLazySingleton<ClientLocalDataSource>(
        () => ClientLocalDataSourceImpl(database: injector()),
  );
}