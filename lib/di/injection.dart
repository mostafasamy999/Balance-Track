import 'package:client_ledger/data/local/daos/client_dao.dart';
import 'package:get_it/get_it.dart';
import '../data/local/database.dart';
import '../presentation/bloc/main_screen/main_screen_cubit.dart';

final injector = GetIt.instance;

Future<void> init() async {

  injector.registerLazySingleton<AppDatabase>(() => AppDatabase());
  injector.registerLazySingleton<ClientDao>(() => ClientDao(injector()));
  injector.registerLazySingleton<MainScreenCubit>(() => injector());


}