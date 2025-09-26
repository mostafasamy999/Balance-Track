// import 'package:dartz/dartz.dart';
// import '../../core/error/failures.dart';
// import '../../core/usecases/usecase.dart';
// import '../entities/category.dart';
// import '../repositories/client_repository.dart';
//
// class GetCategories implements UseCase<List<Category>, NoParams> {
//   final ClientRepository repository;
//
//   GetCategories(this.repository);
//
//   @override
//   Future<Either<Failure, List<Category>>> call(NoParams params) async {
//     return await repository.getCategories();
//   }
// }