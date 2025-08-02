import 'package:drift/drift.dart';
import '../../../core/error/exceptions.dart';
import '../../models/category_model.dart';
import '../../models/client_model.dart';
import '../../models/transaction_model.dart';
import 'app_database.dart';

abstract class ClientLocalDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> addCategory(CategoryModel category);

  // Clients
  Future<List<ClientModel>> getClientsByCategory(int categoryId);
  Future<ClientModel> addClient(ClientModel client);

  // Transactions
  Future<List<TransactionModel>> getTransactionsByClient(int clientId);
  Future<TransactionModel> addTransaction(TransactionModel transaction);

  // Summary data
  Future<double> getClientBalance(int clientId);
  Future<Map<String, double>> getCategoryTotals(int categoryId);


  // New method to delete all data
  Future<void> clearAllData();
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase database;

  ClientLocalDataSourceImpl({required this.database});

  // Categories
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await database.getAllCategories();
      return categories.map((category) => CategoryModel(
        id: category.id,
        name: category.name,
      )).toList();
    } catch (e) {
      throw DatabaseException('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      final result = await database.addCategory(
        CategoriesCompanion(
          name: Value(category.name),
        ),
      );
      return CategoryModel(
        id: result.id,
        name: result.name,
      );
    } catch (e) {
      throw DatabaseException('Failed to add category: ${e.toString()}');
    }
  }

  // Clients
  @override
  Future<List<ClientModel>> getClientsByCategory(int categoryId) async {
    try {
      final clients = await database.getClientsByCategory(categoryId);
      return clients.map((client) => ClientModel(
        id: client.id,
        name: client.name,
        categoryId: client.categoryId,
      )).toList();
    } catch (e) {
      throw DatabaseException('Failed to get clients: ${e.toString()}');
    }
  }

  @override
  Future<ClientModel> addClient(ClientModel client) async {
    try {
      final result = await database.addClient(
        ClientsCompanion(
          name: Value(client.name),
          categoryId: Value(client.categoryId),
        ),
      );
      return ClientModel(
        id: result.id,
        name: result.name,
        categoryId: result.categoryId,
      );
    } catch (e) {
      throw DatabaseException('Failed to add client: ${e.toString()}');
    }
  }

  // Transactions
  @override
  Future<List<TransactionModel>> getTransactionsByClient(int clientId) async {
    try {
      final transactions = await database.getTransactionsByClient(clientId);
      return transactions.map((transaction) => TransactionModel(
        id: transaction.id,
        clientId: transaction.clientId,
        amount: transaction.amount,
        isAddition: transaction.isAddition,
        details: transaction.details,
        dateTime: transaction.transactionDateTime,
      )).toList();
    } catch (e) {
      throw DatabaseException('Failed to get transactions: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      print('🔵 [LocalDataSource] Adding transaction: ${transaction.toJson()}');
      final result = await database.addTransaction(
        TransactionsCompanion(
          clientId: Value(transaction.clientId),
          amount: Value(transaction.amount),
          isAddition: Value(transaction.isAddition),
          details: Value(transaction.details),
          transactionDateTime: Value(transaction.dateTime),
        ),
      );
      print('🟢 [LocalDataSource] Transaction added successfully: ID=${result.id}, Amount=${result.amount}, Client=${result.clientId}');
      return TransactionModel(
        id: result.id,
        clientId: result.clientId,
        amount: result.amount,
        isAddition: result.isAddition,
        details: result.details,
        dateTime: result.transactionDateTime,
      );
    } catch (e) {
      throw DatabaseException('Failed to add transaction: ${e.toString()}');
    }
  }

  // Summary data
  @override
  Future<double> getClientBalance(int clientId) async {
    try {
      return await database.getClientBalance(clientId);
    } catch (e) {
      throw DatabaseException('Failed to get client balance: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, double>> getCategoryTotals(int categoryId) async {
    try {
      return await database.getCategoryTotals(categoryId);
    } catch (e) {
      throw DatabaseException('Failed to get category totals: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      // Assuming you will create a `deleteAllData` method in your AppDatabase class
      await database.clearAllData();
    } catch (e) {
      throw DatabaseException('Failed to delete all data: ${e.toString()}');
    }
  }
}