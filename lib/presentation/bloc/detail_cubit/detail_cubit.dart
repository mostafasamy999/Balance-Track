import 'package:bloc/bloc.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/add_transaction.dart';
import '../../../domain/usecases/get_clients_balance.dart';
import '../../../domain/usecases/get_transactions_by_client.dart';
import '../../../core/error/failures.dart';
import '../../moc_models.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetTransactionsByClient getTransactionsByClient;
  final GetClientBalance getClientBalance;
  final AddTransaction addTransactionUseCase;

  DetailCubit({
    required this.getTransactionsByClient,
    required this.getClientBalance,
    required this.addTransactionUseCase,
  }) : super(DetailInitial());

  Future<void> loadClientDetails(int clientId) async {
    print('🔵 [DetailCubit] loadClientDetails called with clientId: $clientId');
    emit(DetailLoading());

    try {
      print('🔵 [DetailCubit] Getting transactions for client $clientId');
      // Get transactions
      final transactionsResult = await getTransactionsByClient(
        GetTransactionsByClientParams(clientId: clientId),
      );

      print('🔵 [DetailCubit] Getting balance for client $clientId');
      // Get client balance
      final balanceResult = await getClientBalance(clientId);

      // Handle results
      transactionsResult.fold(
            (failure) {
          print('🔴 [DetailCubit] Failed to get transactions: ${_mapFailureToMessage(failure)}');
          emit(DetailError(_mapFailureToMessage(failure)));
        },
            (transactions) {
          print('🟢 [DetailCubit] Successfully retrieved ${transactions.length} transactions');

          balanceResult.fold(
                (failure) {
              print('🔴 [DetailCubit] Failed to get balance: ${_mapFailureToMessage(failure)}');
              emit(DetailError(_mapFailureToMessage(failure)));
            },
                (balance) {
              print('🟢 [DetailCubit] Successfully retrieved balance: $balance');

              // Calculate totals
              double totalAdded = 0.0;
              double totalSubtracted = 0.0;

              // Sort transactions by date (oldest first) for proper balance calculation
              final sortedTransactions = List<Transaction>.from(transactions)
                ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

              for (final transaction in sortedTransactions) {
                if (transaction.isAddition) {
                  totalAdded += transaction.amount;
                } else {
                  totalSubtracted += transaction.amount;
                }
              }

              print('🟡 [DetailCubit] Calculated totals - Added: $totalAdded, Subtracted: $totalSubtracted, Balance: $balance');

              emit(DetailLoaded(
                transactions: sortedTransactions,
                clientBalance: balance,
                totalAdded: totalAdded,
                totalSubtracted: totalSubtracted,
              ));
            },
          );
        },
      );
    } catch (e) {
      print('🔴 [DetailCubit] Unexpected error in loadClientDetails: $e');
      emit(DetailError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    print('🔵 [DetailCubit] addTransaction called with: $transaction');

    // Show loading state while maintaining current data
    final currentState = state;
    print('🟡 [DetailCubit] Current state: ${currentState.runtimeType}');

    if (currentState is DetailLoaded) {
      print('🟡 [DetailCubit] Emitting loading state while preserving data');
      emit(DetailLoading());
    }

    try {
      print('🔵 [DetailCubit] Calling addTransactionUseCase');
      // Add the transaction
      final result = await addTransactionUseCase(
        AddTransactionParams(transaction: transaction),
      );

      print('🟡 [DetailCubit] AddTransaction use case completed');

      result.fold(
            (failure) {
          print('🔴 [DetailCubit] Failed to add transaction: ${_mapFailureToMessage(failure)}');

          // Restore previous state and show error
          if (currentState is DetailLoaded) {
            print('🟡 [DetailCubit] Restoring previous state');
            emit(currentState);
          }
          emit(DetailError(_mapFailureToMessage(failure)));
        },
            (addedTransaction) {
          print('🟢 [DetailCubit] Transaction added successfully: $addedTransaction');
          print('🔵 [DetailCubit] Reloading client details to refresh data');

          // Reload client details to get updated data
          loadClientDetails(transaction.clientId);
        },
      );
    } catch (e) {
      print('🔴 [DetailCubit] Unexpected error in addTransaction: $e');

      // Restore previous state and show error
      if (currentState is DetailLoaded) {
        print('🟡 [DetailCubit] Restoring previous state after error');
        emit(currentState);
      }
      emit(DetailError('Failed to add transaction: ${e.toString()}'));
    }
  }

  Future<void> deleteTransaction(int transactionId, int clientId) async {
    print('🔵 [DetailCubit] deleteTransaction called with transactionId: $transactionId, clientId: $clientId');

    final currentState = state;
    if (currentState is DetailLoaded) {
      emit(DetailLoading());
    }

    try {
      // TODO: Implement delete transaction use case
      // For now, just reload the data
      print('🟡 [DetailCubit] Delete transaction not implemented, reloading data');
      await loadClientDetails(clientId);
    } catch (e) {
      print('🔴 [DetailCubit] Error in deleteTransaction: $e');

      if (currentState is DetailLoaded) {
        emit(currentState);
      }
      emit(DetailError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    print('🔵 [DetailCubit] updateTransaction called with: $transaction');

    final currentState = state;
    if (currentState is DetailLoaded) {
      emit(DetailLoading());
    }

    try {
      // TODO: Implement update transaction use case
      // For now, just reload the data
      print('🟡 [DetailCubit] Update transaction not implemented, reloading data');
      await loadClientDetails(transaction.clientId);
    } catch (e) {
      print('🔴 [DetailCubit] Error in updateTransaction: $e');

      if (currentState is DetailLoaded) {
        emit(currentState);
      }
      emit(DetailError('Failed to update transaction: ${e.toString()}'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    print('🟡 [DetailCubit] Mapping failure: ${failure.runtimeType}');

    // Map your specific failure types to user-friendly messages
    switch (failure.runtimeType) {
      case DatabaseFailure:
        return 'Database error. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}