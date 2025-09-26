


import 'package:client_ledger/data/local/database.dart';

import '../../domain/entities/client.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/client_repository.dart';
import '../local/client_local_data_source.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource localDataSource;

  ClientRepositoryImpl({required this.localDataSource});

  // -------- Clients --------
  @override
  Future<List<Client>> getClientsByCategory(String category) async {
    final clients = await localDataSource.getClientsByCategory(category);
    return clients
        .map((c) => Client(id: c.id, name: c.name, category: c.category))
        .toList();
  }

  @override
  Future<Client> addClient(Client client) async {
    final inserted = await localDataSource.addClient(
      ClientTableData(
        id: -1,
        name: client.name,
        category: client.category,
      ),
    );
    return Client(
      id: inserted.id,
      name: inserted.name,
      category: inserted.category,
    );
  }

  // -------- Transactions --------
  @override
  Future<List<Transaction>> getTransactionsByClient(int clientId) async {
    final txns = await localDataSource.getTransactionsByClient(clientId);
    return txns
        .map((t) => Transaction(
      id: t.id,
      clientId: t.clientId,
      amount: t.amount,
      status: t.status,
      datetime: t.datetime,
    ))
        .toList();
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    final inserted = await localDataSource.addTransaction(
      TransactionTableData(
        id: -1,
        clientId: transaction.clientId,
        amount: transaction.amount,
        status: transaction.status,
        datetime: transaction.datetime,
      ),
    );
    return Transaction(
      id: inserted.id,
      clientId: inserted.clientId,
      amount: inserted.amount,
      status: inserted.status,
      datetime: inserted.datetime,
    );
  }

  // -------- Summary --------
  @override
  Future<double> getClientBalance(int clientId) =>
      localDataSource.getClientBalance(clientId);

  @override
  Future<Map<String, double>> getCategoryTotals(String category) =>
      localDataSource.getCategoryTotals(category);

  // -------- Clear --------
  @override
  Future<void> clearAllData() => localDataSource.clearAllData();
}
