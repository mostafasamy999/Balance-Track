
import 'package:drift/drift.dart';
import 'client.dart';

class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId =>
      integer().references(ClientTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()(); // you can use decimal package if needed
  TextColumn get status => text().withLength(min: 1, max: 20)();
  DateTimeColumn get datetime => dateTime()();
}
