import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/client.dart';
import 'tables/transaction.dart';
import 'daos/client_dao.dart';
import 'daos/transaction_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [ClientTable, TransactionTable],
  daos: [ClientDao, TransactionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'balance.sqlite'));
    return NativeDatabase(file);
  });
}
