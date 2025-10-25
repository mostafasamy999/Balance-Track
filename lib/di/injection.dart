import 'package:get_it/get_it.dart';
import '../data/local/client_local_data_source.dart';
import '../data/local/database.dart';

final injector = GetIt.instance;

Future<void> init() async {

  injector.registerLazySingleton<AppDatabase>(() => AppDatabase());

  injector.registerLazySingleton<ClientLocalDataSource>(
        () => ClientLocalDataSourceImpl(database: injector<AppDatabase>()),
  );
}