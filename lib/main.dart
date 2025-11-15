import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
//flutter pub run intl_utils:generate
