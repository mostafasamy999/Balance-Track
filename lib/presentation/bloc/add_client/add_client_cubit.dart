// // add_client_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../core/error/failures.dart';
// import '../../../domain/entities/client.dart';
// import '../../../domain/usecases/add_client.dart';
//
// part 'add_client_state.dart';
//
// class AddClientCubit extends Cubit<AddClientState> {
//   final AddClientUseCase addClientUseCase;
//   Future<void>? _currentOperation; // Track the current operation
//   String? _lastClientName; // Track last submitted client name
//  bool _isProcessing = false;
//
//   AddClientCubit({required this.addClientUseCase}) : super(AddClientInitial());
//
//   Future<void> addNewClient({
//     required String name,
//     required int categoryId,
//   }) async {
//     // If there's already an operation in progress, wait for it or ignore
//     if (_currentOperation != null) {
//       print('🔴 [Cubit] Already processing, ignoring duplicate call');
//       return;
//     }
//
//     // Check if this is the same client that was just added
//     if (_lastClientName == name && state is AddClientSuccess) {
//       print('🔴 [Cubit] Same client just added, ignoring duplicate');
//       return;
//     }
//
//     // Start the operation
//     _currentOperation = _performAddClient(name: name, categoryId: categoryId);
//
//     try {
//       await _currentOperation!;
//     } finally {
//       _currentOperation = null; // Reset when done
//     }
//   }
//
//   Future<void> _performAddClient({
//     required String name,
//     required int categoryId,
//   }) async {
//     print('🔵 [Cubit] Starting addNewClient for: $name');
//     emit(AddClientLoading());
//     _isProcessing = true;
//
//     final client = Client(
//       name: name,
//       categoryId: categoryId,
//     );
//
//     final result = await addClientUseCase(AddClientParams(client: client));
//
//     result.fold(
//           (failure) {
//         print('🔴 [Cubit] Failed to add client: ${_mapFailureToMessage(failure)}');
//         emit(AddClientFailure(_mapFailureToMessage(failure)));
//         _isProcessing = false;
//           },
//           (client) {
//         print('🟢 [Cubit] Successfully added client: ${client.name}');
//         _lastClientName = client.name; // Remember the last successful client
//         emit(AddClientSuccess(client));
//         _isProcessing = false;
//           },
//     );
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case DatabaseFailure:
//         return (failure as DatabaseFailure).message;
//       default:
//         return 'An unexpected error occurred. Please try again.';
//     }
//   }
// // In AddClientCubit class
//   void resetState() {
//     _isProcessing = false;
//     _lastClientName = null;
//     emit(AddClientInitial());
//   }
// }