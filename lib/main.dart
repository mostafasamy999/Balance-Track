import 'package:client_ledger/presentation/my_app.dart';
import 'package:flutter/material.dart';

import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
