// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import '../../core/error/failures.dart';
// import '../../core/usecases/usecase.dart';
// import 'data/datasources/local/app_database.dart';
// import 'domain/repositories/client_repository.dart';
//
// class AddTransaction  {
//   final ClientRepository repository;
//
//   AddTransaction(this.repository);
//
//   @override
//   Future<Either<Failure, Transaction>> call(AddTransactionParams params) async {
//     return await repository.addTransaction(params.transaction);
//   }
// }
//
// class GetCategories implements  {
//   final ClientRepository repository;
//
//   GetCategories(this.repository);
//
//   @override
//   Future<Either<Failure, List<Category>>> call(NoParams params) async {
//     return await repository.getCategories();
//   }
// }
//
// class GetClientsByCategory  {
//   final ClientRepository repository;
//
//   GetClientsByCategory(this.repository);
//
//   @override
//   Future<Either<Failure, List<Client>>> call(GetClientsByCategoryParams params) async {
//     return await repository.getClientsByCategory(params.categoryId);
//   }
// }
//
//
// class GetTransactionsByClient  {
//   final ClientRepository repository;
//
//   GetTransactionsByClient(this.repository);
//
//   @override
//   Future<Either<Failure, List<Transaction>>> call(GetTransactionsByClientParams params) async {
//     return await repository.getTransactionsByClient(params.clientId);
//   }
// }
//
// class AddClient  {
//   final ClientRepository repository;
//
//   AddClient(this.repository);
//
//   @override
//   Future<Either<Failure, Client>> call(AddClientParams params) async {
//     return await repository.addClient(params.client);
//   }
// }
//
// class AddCategory  {
//   final ClientRepository repository;
//
//   AddCategory(this.repository);
//
//   @override
//   Future<Either<Failure, Category>> call(AddCategoryParams params) async {
//     return await repository.addCategory(params.category);
//   }
// }
//
// class Transaction extends Equatable {
//   final int? id;
//   final int clientId;
//   final double amount;
//   final bool isAddition;
//   final String details;
//   final DateTime dateTime;
//
//   const Transaction({
//     this.id,
//     required this.clientId,
//     required this.amount,
//     required this.isAddition,
//     required this.details,
//     required this.dateTime,
//   });
//
//   @override
//   List<Object?> get props => [id, clientId, amount, isAddition, details, dateTime];
//
//   // Helper method to get the actual value (positive or negative)
//   double get value => isAddition ? amount : -amount;
// }
//
// class Client extends Equatable {
//   final int? id;
//   final String name;
//   final int categoryId;
//
//   const Client({
//     this.id,
//     required this.name,
//     required this.categoryId,
//   });
//
//   @override
//   List<Object?> get props => [id, name, categoryId];
// }
//
// class Category extends Equatable {
//   final int? id;
//   final String name;
//
//   const Category({
//     this.id,
//     required this.name,
//   });
//
//   @override
//   List<Object?> get props => [id, name];
// }