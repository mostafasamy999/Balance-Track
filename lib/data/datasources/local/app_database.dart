import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';
// if any update then run :
//        dart run build_runner build --delete-conflicting-outputs

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

  Future<Category?> getCategoryById(int id) async {
    return await (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<Category> addCategory(CategoriesCompanion entry) {
    return into(categories).insertReturning(entry);
  }

  Future<bool> updateCategory(int id, CategoriesCompanion entry) {
    return update(categories).replace(entry.copyWith(id: Value(id)));
  }

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  // Clients CRUD
  Future<List<Client>> getAllClients() => select(clients).get();

  Future<List<Client>> getClientsByCategory(int categoryId) {
    return (select(clients)..where((c) => c.categoryId.equals(categoryId))).get();
  }

  Future<Client?> getClientById(int id) async {
    return await (select(clients)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<Client> addClient(ClientsCompanion entry) {
  print('🔵 [Database] addClient called with: ${entry}');
    return into(clients).insertReturning(entry);
  }

  Future<bool> updateClient(int id, ClientsCompanion entry) {
    return update(clients).replace(entry.copyWith(id: Value(id)));
  }

  Future<int> deleteClient(int id) {
    return (delete(clients)..where((c) => c.id.equals(id))).go();
  }

  // Transactions CRUD
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future<List<Transaction>> getTransactionsByClient(int clientId) {
    return (select(transactions)
      ..where((t) => t.clientId.equals(clientId))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDateTime, mode: OrderingMode.desc)]))
        .get();
  }

  Future<Transaction?> getTransactionById(int id) async {
    return await (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Transaction> addTransaction(TransactionsCompanion entry) {
    return into(transactions).insertReturning(entry);
  }

  Future<bool> updateTransaction(int id, TransactionsCompanion entry) {
    return update(transactions).replace(entry.copyWith(id: Value(id)));
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  // Complex queries with joins
  Future<List<ClientWithCategory>> getClientsWithCategories() {
    final query = select(clients).join([
      leftOuterJoin(categories, categories.id.equalsExp(clients.categoryId)),
    ]);

    return query.map((row) {
      return ClientWithCategory(
        client: row.readTable(clients),
        category: row.readTableOrNull(categories),
      );
    }).get();
  }

  Future<List<TransactionWithClientAndCategory>> getTransactionsWithDetails() {
    final query = select(transactions).join([
      leftOuterJoin(clients, clients.id.equalsExp(transactions.clientId)),
      leftOuterJoin(categories, categories.id.equalsExp(clients.categoryId)),
    ]);

    return query.map((row) {
      return TransactionWithClientAndCategory(
        transaction: row.readTable(transactions),
        client: row.readTableOrNull(clients),
        category: row.readTableOrNull(categories),
      );
    }).get();
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

  Future<Map<int, double>> getAllClientBalances() async {
    final allClients = await getAllClients();
    Map<int, double> balances = {};

    for (var client in allClients) {
      balances[client.id] = await getClientBalance(client.id);
    }

    return balances;
  }

  Future<List<TransactionSummary>> getTransactionSummaryByDateRange(
      DateTime startDate,
      DateTime endDate
      ) async {
    final query = select(transactions).join([
      leftOuterJoin(clients, clients.id.equalsExp(transactions.clientId)),
      leftOuterJoin(categories, categories.id.equalsExp(clients.categoryId)),
    ])..where(transactions.transactionDateTime.isBetweenValues(startDate, endDate));

    final results = await query.get();

    return results.map((row) {
      final transaction = row.readTable(transactions);
      final client = row.readTableOrNull(clients);
      final category = row.readTableOrNull(categories);

      return TransactionSummary(
        transactionId: transaction.id,
        clientName: client?.name ?? 'Unknown',
        categoryName: category?.name ?? 'Unknown',
        amount: transaction.amount,
        isAddition: transaction.isAddition,
        details: transaction.details,
        transactionDateTime: transaction.transactionDateTime,
      );
    }).toList();
  }

  // Utility methods
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'client_ledger.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clearAllData() async {
    await delete(transactions).go();
    await delete(clients).go();
    await delete(categories).go();
  }
}

// Helper classes for complex queries
class ClientWithCategory {
  final Client client;
  final Category? category;

  ClientWithCategory({required this.client, this.category});
}

class TransactionWithClientAndCategory {
  final Transaction transaction;
  final Client? client;
  final Category? category;

  TransactionWithClientAndCategory({
    required this.transaction,
    this.client,
    this.category,
  });
}

class TransactionSummary {
  final int transactionId;
  final String clientName;
  final String categoryName;
  final double amount;
  final bool isAddition;
  final String details;
  final DateTime transactionDateTime;

  TransactionSummary({
    required this.transactionId,
    required this.clientName,
    required this.categoryName,
    required this.amount,
    required this.isAddition,
    required this.details,
    required this.transactionDateTime,
  });
}

// Database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'client_ledger.sqlite'));
    return NativeDatabase(file);
  });
}

// Extension methods for easier data manipulation
extension CategoryExtensions on Category {
  CategoriesCompanion toCompanion() {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }
}

extension ClientExtensions on Client {
  ClientsCompanion toCompanion() {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
    );
  }
}

extension TransactionExtensions on Transaction {
  TransactionsCompanion toCompanion() {
    return TransactionsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      amount: Value(amount),
      isAddition: Value(isAddition),
      details: Value(details),
      transactionDateTime: Value(transactionDateTime),
    );
  }
}