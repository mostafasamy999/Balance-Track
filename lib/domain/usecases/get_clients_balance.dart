import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetClientBalance  {
  final ClientRepository repository;

  GetClientBalance(this.repository);

  @override
  Future<Either<Failure, double>> call(int clientId) async {
    return await repository.getClientBalance(clientId);
  }
}

