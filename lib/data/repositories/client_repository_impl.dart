import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local/client_local_data_source.dart';
import '../models/category_model.dart';
import '../models/client_model.dart';
import '../models/transaction_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource localDataSource;

  ClientRepositoryImpl({required this.localDataSource});

  // Categories
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      final result = await localDataSource.addCategory(categoryModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  // Clients
  @override
  Future<Either<Failure, List<Client>>> getClientsByCategory(int categoryId) async {
    try {
      final clients = await localDataSource.getClientsByCategory(categoryId);
      return Right(clients);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Client>> addClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final result = await localDataSource.addClient(clientModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  // Transactions
  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByClient(int clientId) async {
    try {
      final transactions = await localDataSource.getTransactionsByClient(clientId);
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.addTransaction(transactionModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  // Summary data
  @override
  Future<Either<Failure, double>> getClientBalance(int clientId) async {
    try {
      final balance = await localDataSource.getClientBalance(clientId);
      return Right(balance);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategoryTotals(int categoryId) async {
    try {
      final totals = await localDataSource.getCategoryTotals(categoryId);
      return Right(totals);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}