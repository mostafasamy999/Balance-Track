import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/client_repository.dart';

class DeleteAllDataUseCase  {
  final ClientRepository repository;

  DeleteAllDataUseCase(this.repository);

  Future<void> call() async {
    return await repository.clearAllData();
  }
}