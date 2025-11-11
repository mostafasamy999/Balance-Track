import 'package:client_ledger/data/local/daos/client_dao.dart';
import 'package:client_ledger/data/local/daos/transaction_dao.dart';
import 'package:client_ledger/presentation/bloc/tranaction_cubit/transaction_cubit.dart';
import 'package:get_it/get_it.dart';
import '../data/local/database.dart';
import '../presentation/bloc/main_cubit/main_screen_cubit.dart';

final injector = GetIt.instance;

Future<void> init() async {

  injector.registerLazySingleton<AppDatabase>(() => AppDatabase());
  injector.registerLazySingleton<ClientDao>(() => ClientDao(injector()));
  injector.registerLazySingleton<TransactionDao>(() => TransactionDao(injector()));

  injector.registerLazySingleton<MainScreenCubit>(() => MainScreenCubit(injector()));
  injector.registerLazySingleton<TransactionCubit>(() => TransactionCubit(injector()));


}