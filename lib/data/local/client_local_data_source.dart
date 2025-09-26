import 'package:client_ledger/data/local/tables/client.dart';
import 'package:client_ledger/data/local/tables/transaction.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/transaction.dart';
import 'database.dart';

// Abstract definition
abstract class ClientLocalDataSource {
  // Clients
  Future<List<ClientTableData>> getClientsByCategory(String category);
  Future<ClientTableData> addClient(ClientTableData client);

  // Transactions
  Future<List<TransactionTableData>> getTransactionsByClient(int clientId);
  Future<TransactionTableData> addTransaction(TransactionTableData transaction);

  // Summary data
  Future<double> getClientBalance(int clientId);
  Future<Map<String, double>> getCategoryTotals(String category);

  // New method to delete all data
  Future<void> clearAllData();
}

// Implementation
class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase database;

  ClientLocalDataSourceImpl({required this.database});

  // -------- Clients --------
  @override
  Future<List<ClientTableData>> getClientsByCategory(String category) async {
    final query = database.select(database.clientTable)
      ..where((c) => c.category.equals(category));
    return query.get();
  }

  @override
  Future<ClientTableData> addClient(ClientTableData client) async {
    final id = await database.into(database.clientTable).insert(client);
    final inserted = await (database.select(database.clientTable)
      ..where((c) => c.id.equals(id)))
        .getSingleOrNull();

    if (inserted == null) throw Exception();
    return inserted;
  }

  // -------- Transactions --------
  @override
  Future<List<TransactionTableData>> getTransactionsByClient(int clientId) {
    final query = database.select(database.transactionTable)
      ..where((t) => t.clientId.equals(clientId));
    return query.get();
  }

  @override
  Future<TransactionTableData> addTransaction(TransactionTableData transaction) async {
    final id = await database.into(database.transactionTable).insert(transaction);
    final inserted = await (database.select(database.transactionTable)
      ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (inserted == null) throw Exception();
    return inserted;
  }

  // -------- Summary data --------
  @override
  Future<double> getClientBalance(int clientId) async {
    final result = await (database.customSelect(
      'SELECT SUM(amount) as total FROM transactions_table WHERE client_id = ?',
      variables: [Variable.withInt(clientId)],
      readsFrom: {database.transactionTable},
    ).getSingle());

    return result.data['total'] != null
        ? (result.data['total'] as num).toDouble()
        : 0.0;
  }

  @override
  Future<Map<String, double>> getCategoryTotals(String category) async {
    final result = await (database.customSelect(
      '''
      SELECT c.category, SUM(t.amount) as total
      FROM clients_table c
      JOIN transactions_table t ON c.id = t.client_id
      WHERE c.category = ?
      GROUP BY c.category
      ''',
      variables: [Variable.withString(category)],
      readsFrom: {database.clientTable, database.transactionTable},
    ).get());

    if (result.isEmpty) return {};
    return {
      for (final row in result)
        row.data['category'] as String: (row.data['total'] as num).toDouble(),
    };
  }

  // -------- Delete all data --------
  @override
  Future<void> clearAllData() async {
    await database.transaction(() async {
      await database.delete(database.transactionTable).go();
      await database.delete(database.clientTable).go();
    });
  }
}
