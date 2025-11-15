
import 'package:drift/drift.dart';
import 'client.dart';
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get clientId =>
      integer().references(ClientTable, #id, onDelete: KeyAction.cascade)();

  RealColumn get amount => real()();

  // true = put, false = pull
  BoolColumn get status => boolean()();

  DateTimeColumn get datetime => dateTime()();
}
