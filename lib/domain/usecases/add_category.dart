import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/client_repository.dart';

class AddCategory implements UseCase<Category, AddCategoryParams> {
  final ClientRepository repository;

  AddCategory(this.repository);

  @override
  Future<Either<Failure, Category>> call(AddCategoryParams params) async {
    return await repository.addCategory(params.category);
  }
}

class AddCategoryParams extends Equatable {
  final Category category;

  const AddCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}