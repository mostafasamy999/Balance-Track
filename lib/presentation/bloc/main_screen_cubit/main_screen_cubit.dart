import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/usecases/add_category.dart';
import '../../../domain/usecases/add_client.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/get_clients_by_category.dart';
import '../../moc_models.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  final AddCategory addCategoryUseCase;
  final GetCategories getCategoriesUseCase;
  final AddClient addClientUseCase;
  final GetClientsByCategory getClientsByCategoryUseCase;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  MainScreenCubit({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.addClientUseCase,
    required this.getClientsByCategoryUseCase,
  }) : super(MainScreenInitial());

  Future<void> loadCategories() async {
    emit(MainScreenLoading());

    final result = await getCategoriesUseCase(NoParams());

    result.fold(
          (failure) => emit(MainScreenError(message: _mapFailureToMessage(failure))),
          (categories) {
        _categories = categories;
        emit(MainScreenCategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> addCategory(CategoryUi categoryUi) async {
    emit(MainScreenLoading());

    final result = await addCategoryUseCase(
        AddCategoryParams(category: Category(name: categoryUi.name))
    );

    result.fold(
          (failure) => emit(MainScreenError(message: _mapFailureToMessage(failure))),
          (category) {
        _categories.add(category);
        emit(MainScreenCategoryAdded(category: category));
        // Optionally emit categories loaded state to refresh UI
        emit(MainScreenCategoriesLoaded(categories: _categories));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize your error messages based on the type of failure
    // if (failure is ServerFailure) return 'Server Error';
    // if (failure is CacheFailure) return 'Cache Error';
    // return 'Unexpected Error';
    return failure.toString();
  }
  Future<void> addClient(ClientUi client) async {
    emit(MainScreenLoading());

    final result = await addClientUseCase(AddClientParams(client: Client(name: client.name,categoryId: client.categoryId)));

    result.fold(
          (failure) => emit(MainScreenError(message: _mapFailureToMessage(failure))),
          (client) {
        emit(MainScreenClientAdded(client: ClientUi(name: client.name, categoryId:client.categoryId)));
        // Optionally reload clients list here
      },
    );
  }
  Future<void> getClientsByCategory(int categoryId) async {
    emit(MainScreenLoading());

    final result = await getClientsByCategoryUseCase(GetClientsByCategoryParams(categoryId: categoryId));

    result.fold(
          (failure) => emit(MainScreenError(message: _mapFailureToMessage(failure))),
          (clients) {
        final uiClients = clients.map((c) => ClientUi(name: c.name, categoryId: c.categoryId)).toList();
        emit(MainScreenClientsLoaded(clients: uiClients));
      },
    );
  }

}