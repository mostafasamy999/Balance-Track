// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import '../../core/error/failures.dart';
// import '../../core/usecases/usecase.dart';
// import '../entities/transaction.dart';
// import '../repositories/client_repository.dart';
//
// class GetTransactionsByClient implements UseCase<List<Transaction>, GetTransactionsByClientParams> {
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
// class GetTransactionsByClientParams extends Equatable {
//   final int clientId;
//
//   const GetTransactionsByClientParams({required this.clientId});
//
//   @override
//   List<Object> get props => [clientId];
// }