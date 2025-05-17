import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';
// if any update then run :
//        dart run build_runner build


// Tables
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
}

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().references(Categories, #id)();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get clientId => integer().references(Clients, #id)();

  RealColumn get amount => real()();

  BoolColumn get isAddition => boolean()();

  TextColumn get details => text().withLength(min: 1, max: 500)();

  DateTimeColumn get transactionDateTime => dateTime()();
}
@DriftDatabase(tables: [Categories, Clients, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Categories CRUD
  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<Category> addCategory(CategoriesCompanion entry) {
    return into(categories).insertReturning(entry);
  }

  // Clients CRUD
  Future<List<Client>> getClientsByCategory(int categoryId) {
    return (select(clients)..where((c) => c.categoryId.equals(categoryId))).get();
  }
  Future<Client> addClient(ClientsCompanion entry) {
    return into(clients).insertReturning(entry);
  }

  // Transactions CRUD
  Future<List<Transaction>> getTransactionsByClient(int clientId) {
    return (select(transactions)
      ..where((t) => t.clientId.equals(clientId))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDateTime, mode: OrderingMode.desc)]))
        .get();
  }
  Future<Transaction> addTransaction(TransactionsCompanion entry) {
    return into(transactions).insertReturning(entry);
  }

  // Calculated fields
  Future<double> getClientBalance(int clientId) async {
    final clientTransactions = await getTransactionsByClient(clientId);
    double balance = 0;
    for (var transaction in clientTransactions) {
      balance += transaction.isAddition ? transaction.amount : -transaction.amount;
    }
    return balance;
  }

  Future<Map<String, double>> getCategoryTotals(int categoryId) async {
    final clients = await getClientsByCategory(categoryId);
    double totalAdded = 0;
    double totalSubtracted = 0;

    for (var client in clients) {
      final transactions = await getTransactionsByClient(client.id);
      for (var transaction in transactions) {
        if (transaction.isAddition) {
          totalAdded += transaction.amount;
        } else {
          totalSubtracted += transaction.amount;
        }
      }
    }

    return {
      'totalAdded': totalAdded,
      'totalSubtracted': totalSubtracted,
      'finalTotal': totalAdded - totalSubtracted,
    };
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'client_ledger.sqlite'));
    return NativeDatabase(file);
  });
}