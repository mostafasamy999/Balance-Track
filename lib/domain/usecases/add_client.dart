import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class AddClient implements UseCase<Client, AddClientParams> {
  final ClientRepository repository;

  AddClient(this.repository);

  @override
  Future<Either<Failure, Client>> call(AddClientParams params) async {
    return await repository.addClient(params.client);
  }
}

class AddClientParams extends Equatable {
  final Client client;

  const AddClientParams({required this.client});

  @override
  List<Object> get props => [client];
}