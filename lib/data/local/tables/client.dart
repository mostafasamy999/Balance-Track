import 'package:drift/drift.dart';

class ClientTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().withLength(min: 1, max: 50)();
}

