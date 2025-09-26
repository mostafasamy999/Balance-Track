import '../entities/client.dart';
import '../entities/transaction.dart';

abstract class ClientRepository {
  Future<List<Client>> getClientsByCategory(String category);
  Future<Client> addClient(Client client);

  Future<List<Transaction>> getTransactionsByClient(int clientId);
  Future<Transaction> addTransaction(Transaction transaction);

  Future<double> getClientBalance(int clientId);
  Future<Map<String, double>> getCategoryTotals(String category);

  Future<void> clearAllData();
}
