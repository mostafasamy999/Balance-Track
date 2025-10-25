import 'package:client_ledger/presentation/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Ledger Test',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const ClientTestScreen(),
    );
  }
}
