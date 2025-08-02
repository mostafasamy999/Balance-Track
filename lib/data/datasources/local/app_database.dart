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

  // Add these debug methods to your AppDatabase class:


// Also add this diagnostic method to your database:
  Future<void> debugDatabaseContents() async {
    print('🔍 [Database] === DATABASE DIAGNOSTIC START ===');

    // Check all categories
    final allCategories = await getAllCategories();
    print('🔍 [Database] Total categories: ${allCategories.length}');
    for (var category in allCategories) {
      print('🔍 [Database] Category: ID=${category.id}, Name="${category.name}"');
    }

    // Check all clients
    final allClients = await getAllClients();
    print('🔍 [Database] Total clients: ${allClients.length}');
    for (var client in allClients) {
      print('🔍 [Database] Client: ID=${client.id}, Name="${client.name}", CategoryID=${client.categoryId}');
    }

    // Check clients by each category
    for (var category in allCategories) {
      final clientsInCategory = await (select(clients)..where((c) => c.categoryId.equals(category.id))).get();
      print('🔍 [Database] Category "${category.name}" (ID=${category.id}) has ${clientsInCategory.length} clients');
      for (var client in clientsInCategory) {
        print('🔍 [Database]   - Client: "${client.name}" (ID=${client.id})');
      }
    }

    print('🔍 [Database] === DATABASE DIAGNOSTIC END ===');
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
// Add these debug methods to your AppDatabase class:


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

// Add these methods to your AppDatabase class:

// Method to move all clients from one category to another
  Future<int> moveClientsToCategory(int fromCategoryId, int toCategoryId) async {
    print('🔧 [Database] Moving clients from category $fromCategoryId to category $toCategoryId');

    final result = await (update(clients)
      ..where((c) => c.categoryId.equals(fromCategoryId)))
        .write(ClientsCompanion(categoryId: Value(toCategoryId)));

    print('🟢 [Database] Moved $result clients to category $toCategoryId');
    return result;
  }

// Auto-fix method that runs when getting clients
  Future<void> _autoFixOrphanedClients() async {
    try {
      final allClients = await getAllClients();
      final allCategories = await getAllCategories();

      if (allClients.isEmpty || allCategories.isEmpty) return;

      final categoryIds = allCategories.map((c) => c.id).toSet();
      final firstCategoryId = allCategories.first.id;

      // Find clients in non-existent categories
      final orphanedClients = allClients.where((client) => !categoryIds.contains(client.categoryId)).toList();

      if (orphanedClients.isNotEmpty) {
        print('🔧 [Database] Found ${orphanedClients.length} orphaned clients, moving to category $firstCategoryId');

        for (var client in orphanedClients) {
          await (update(clients)
            ..where((c) => c.id.equals(client.id)))
              .write(ClientsCompanion(categoryId: Value(firstCategoryId)));

          print('🟢 [Database] Moved client "${client.name}" to category $firstCategoryId');
        }
      }
    } catch (e) {
      print('🔴 [Database] Error in auto-fix: $e');
    }
  }

// Update your getClientsByCategory method to include auto-fix:
  Future<List<Client>> getClientsByCategory(int categoryId) async {
    print('🔵 [Database] getClientsByCategory called with categoryId: $categoryId');

    // Auto-fix orphaned clients first
    await _autoFixOrphanedClients();

    // First, let's see ALL clients in the database
    getAllClients().then((allClients) {
      print('🔍 [Database] ALL clients in database: ${allClients.length}');
      for (var client in allClients) {
        print('🔍 [Database]   - Client ID: ${client.id}, Name: "${client.name}", CategoryID: ${client.categoryId}');
      }
    });

    final query = (select(clients)..where((c) => c.categoryId.equals(categoryId)));
    print('🟡 [Database] Executing query for categoryId: $categoryId');

    return query.get().then((result) {
      print('🟢 [Database] Query result: ${result.length} clients found for categoryId: $categoryId');
      for (var client in result) {
        print('🟢 [Database]   - Found client: ID=${client.id}, Name="${client.name}", CategoryID=${client.categoryId}');
      }
      return result;
    });
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