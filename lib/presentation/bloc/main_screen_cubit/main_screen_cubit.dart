// import 'package:bloc/bloc.dart';
// import 'package:client_ledger/domain/usecases/get_transactions_by_client.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
//
// import '../../../domain/entities/category.dart';
// import '../../../domain/entities/client.dart';
// import '../../../domain/usecases/add_category.dart';
// import '../../../domain/usecases/add_client.dart';
// import '../../../domain/usecases/clear_all_data_use_case.dart';
// import '../../../domain/usecases/get_categories.dart';
// import '../../../core/usecases/usecase.dart';
// import '../../../core/error/failures.dart';
// import '../../../domain/usecases/get_clients_by_category.dart';
// import '../../moc_models.dart';
//
// part 'main_screen_state.dart';
//
// class MainScreenCubit extends Cubit<MainScreenState> {
//   final AddCategory addCategoryUseCase;
//   final GetCategories getCategoriesUseCase;
//   final AddClientUseCase addClientUseCase;
//   final GetClientsByCategory getClientsByCategoryUseCase;
//   final DeleteAllDataUseCase deleteAllDataUseCase;
//
//   List<Category> _categories = [];
//   List<Category> get categories => _categories;
//
//   MainScreenCubit({
//     required this.addCategoryUseCase,
//     required this.getCategoriesUseCase,
//     required this.addClientUseCase,
//     required this.getClientsByCategoryUseCase,
//     required this.deleteAllDataUseCase,
//   }) : super(MainScreenInitial());
//
//   Future<void> loadCategories() async {
//     print('🔵 [MainScreenCubit] loadCategories called');
//     emit(MainScreenLoading());
//
//     final result = await getCategoriesUseCase(NoParams());
//
//     result.fold(
//           (failure) {
//         print('🔴 [MainScreenCubit] loadCategories failed: ${_mapFailureToMessage(failure)}');
//         emit(MainScreenError(message: _mapFailureToMessage(failure)));
//       },
//           (categories) {
//         print('🟢 [MainScreenCubit] loadCategories success: ${categories.length} categories');
//         print('🔍 [DEBUG] All category IDs and names:');
//         for (var category in categories) {
//           print('🔍 [DEBUG]   - Category ID: ${category.id}, Name: "${category.name}"');
//         }
//         _categories = categories;
//         emit(MainScreenCategoriesLoaded(categories: categories));
//       },
//     );
//   }
//
//   Future<void> addCategory(CategoryUi categoryUi) async {
//     print('🔵 [MainScreenCubit] addCategory called: ${categoryUi.name}');
//     emit(MainScreenLoading());
//
//     final result = await addCategoryUseCase(
//         AddCategoryParams(category: Category(name: categoryUi.name))
//     );
//
//     result.fold(
//           (failure) {
//         print('🔴 [MainScreenCubit] addCategory failed: ${_mapFailureToMessage(failure)}');
//         emit(MainScreenError(message: _mapFailureToMessage(failure)));
//       },
//           (category) {
//         print('🟢 [MainScreenCubit] addCategory success: ID=${category.id}, Name="${category.name}"');
//         _categories.add(category);
//         emit(MainScreenCategoryAdded(category: category));
//         // Optionally emit categories loaded state to refresh UI
//         emit(MainScreenCategoriesLoaded(categories: _categories));
//
//         // Print updated categories list
//         print('🔍 [DEBUG] Updated categories list:');
//         for (var cat in _categories) {
//           print('🔍 [DEBUG]   - Category ID: ${cat.id}, Name: "${cat.name}"');
//         }
//       },
//     );
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     // Customize your error messages based on the type of failure
//     // if (failure is ServerFailure) return 'Server Error';
//     // if (failure is CacheFailure) return 'Cache Error';
//     // return 'Unexpected Error';
//     return failure.toString();
//   }
//
//   Future<void> addClient(ClientUi client) async {
//     print('🔵 [MainScreenCubit] addClient called: ${client.name} for categoryId: ${client.categoryId}');
//     emit(MainScreenLoading());
//
//     final result = await addClientUseCase(AddClientParams(client: Client(name: client.name,categoryId: client.categoryId)));
//
//     result.fold(
//           (failure) {
//         print('🔴 [MainScreenCubit] addClient failed: ${_mapFailureToMessage(failure)}');
//         emit(MainScreenError(message: _mapFailureToMessage(failure)));
//       },
//           (client) {
//         print('🟢 [MainScreenCubit] addClient success: ID=${client.id}, Name="${client.name}", CategoryID=${client.categoryId}');
//         emit(MainScreenClientAdded(client: ClientUi(name: client.name, categoryId:client.categoryId)));
//         // Optionally reload clients list here
//       },
//     );
//   }
//
//   Future<void> getClientsByCategory(int categoryId) async {
//     print('🔵 [MainScreenCubit] getClientsByCategory called for categoryId: $categoryId');
//
//     // Print which category we're looking for
//     Category? category;
//     try {
//       category = _categories.firstWhere((c) => c.id == categoryId);
//       print('🔍 [DEBUG] Looking for clients in category: ID=$categoryId, Name="${category.name}"');
//     } catch (e) {
//       print('🔍 [DEBUG] Category with ID=$categoryId NOT FOUND in categories list');
//       print('🔍 [DEBUG] Available categories:');
//       for (var cat in _categories) {
//         print('🔍 [DEBUG]   - Category ID: ${cat.id}, Name: "${cat.name}"');
//       }
//     }
//
//     emit(MainScreenLoading());
//
//     final result = await getClientsByCategoryUseCase(GetClientsByCategoryParams(categoryId: categoryId));
//
//     result.fold(
//           (failure) {
//         print('🔴 [MainScreenCubit] getClientsByCategory failed: ${_mapFailureToMessage(failure)}');
//         emit(MainScreenError(message: _mapFailureToMessage(failure)));
//       },
//           (clients) {
//         print('🟢 [MainScreenCubit] getClientsByCategory success: ${clients.length} clients found for categoryId: $categoryId');
//         print('🔍 [DEBUG] Clients in category $categoryId:');
//         for (var client in clients) {
//           print('🔍 [DEBUG]   - Client ID: ${client.id}, Name: "${client.name}", CategoryID: ${client.categoryId}');
//         }
//
//         final uiClients = clients.map((c) => ClientUi(id: c.id,name: c.name, categoryId: c.categoryId)).toList();
//         emit(MainScreenClientsLoaded(clients: uiClients));
//       },
//     );
//   }
//
//   Future<void> deleteAllData() async {
//     print('🔵 [MainScreenCubit] deleteAllData called');
//     emit(MainScreenLoading());
//
//     await deleteAllDataUseCase();
//     print('🟢 [MainScreenCubit] deleteAllData completed');
//     await loadCategories();
//   }
// }