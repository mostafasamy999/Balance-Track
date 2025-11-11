import 'package:client_ledger/data/local/daos/transaction_dao.dart';
import 'package:client_ledger/presentation/ui_models/client_transactions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/local/database.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionDao transactionDao;

  TransactionCubit(this.transactionDao) : super(InitialState());

  void getTransactionList(int clientId) async {
    emit(LoadingState());
    try {
      final List<TransactionTableData> transaction =
      await transactionDao.getAllTransactions(clientId);
      emit(GetDataSuccessState(transaction.toUiModel()));
    } catch (e) {
      emit(ErrorState("Failed to load transactions"));
    }
  }

  Future<void> addTransaction({
    required int clientId,
    required double amount,
    required String status,
  }) async {
    emit(LoadingState());
    try {
      await transactionDao.insertTransaction(
        clientId: clientId,
        amount: amount,
        status: status,
      );

      // refresh list
      getTransactionList(clientId);
    } catch (e) {
      emit(ErrorState("Failed to add transaction"));
    }
  }

  Future<void> editTransaction({
    required int id,
    required int clientId,
    required double amount,
    required String status,
  }) async {
    emit(LoadingState());
    try {
      await transactionDao.updateTransaction(
        id: id,
        clientId: clientId,
        amount: amount,
        status: status,
      );

      // refresh list
      getTransactionList(clientId);
    } catch (e) {
      emit(ErrorState("Failed to edit transaction"));
    }
  }

  Future<void> deleteTransaction(int id, int clientId) async {
    emit(LoadingState());
    try {
      await transactionDao.deleteTransaction(id);
      getTransactionList(clientId);
    } catch (e) {
      emit(ErrorState("Failed to delete transaction"));
    }
  }
}
