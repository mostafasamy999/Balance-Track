import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/client.dart';
import '../entities/transaction.dart';

abstract class ClientRepository {
  // Categories
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> addCategory(Category category);

  // Clients
  Future<Either<Failure, List<Client>>> getClientsByCategory(int categoryId);
  Future<Either<Failure, Client>> addClient(Client client);

  // Transactions
  Future<Either<Failure, List<Transaction>>> getTransactionsByClient(int clientId);
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);

  // Summary data
  Future<Either<Failure, double>> getClientBalance(int clientId);
  Future<Either<Failure, Map<String, double>>> getCategoryTotals(int categoryId);
}