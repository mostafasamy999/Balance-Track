import 'package:client_ledger/di/injection.dart';
import 'package:client_ledger/presentation/bloc/main_cubit/main_screen_cubit.dart';
import 'package:client_ledger/presentation/bloc/tranaction_cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_ledger/presentation/screens/main_screen/main_screen.dart';
import 'package:client_ledger/data/local/daos/client_dao.dart';
import 'package:client_ledger/data/local/database.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'generated/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Ledger Test',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MainScreenCubit>(create: (_) => injector()),
          BlocProvider<TransactionCubit>(create: (_) => injector()),
        ],
        child: const MainScreen(),
      ),
    );
  }
}
