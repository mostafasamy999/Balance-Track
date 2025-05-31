import 'package:flutter/material.dart';

import 'main_screen/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App UI Concept',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF00AEEF), // Example blue
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00AEEF),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Roboto', // Example font
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}








