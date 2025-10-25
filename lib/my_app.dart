import 'package:client_ledger/di/injection.dart';
import 'package:client_ledger/presentation/bloc/main_screen/main_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_ledger/presentation/screens/main_screen/main_screen.dart';
import 'package:client_ledger/data/local/daos/client_dao.dart';
import 'package:client_ledger/data/local/database.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Client Ledger Test',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home:MultiBlocProvider(
        providers: [
          BlocProvider<MainScreenCubit>(
            create: (_) => MainScreenCubit(injector()),
          ),
         ],
        child: const MainScreen(),
      ),
    );
  }
}
