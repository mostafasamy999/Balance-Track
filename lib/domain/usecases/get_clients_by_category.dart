import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetClientsByCategory implements UseCase<List<Client>, GetClientsByCategoryParams> {
  final ClientRepository repository;

  GetClientsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Client>>> call(GetClientsByCategoryParams params) async {
    return await repository.getClientsByCategory(params.categoryId);
  }
}

class GetClientsByCategoryParams extends Equatable {
  final int categoryId;

  const GetClientsByCategoryParams({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}