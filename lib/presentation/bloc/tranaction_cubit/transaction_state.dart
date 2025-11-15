part of 'transaction_cubit.dart';

sealed class TransactionState {}

final class InitialState extends TransactionState {}
final class LoadingState extends TransactionState {}
final class ErrorState extends TransactionState {
  final String message;
  ErrorState(this.message);
}
final class GetDataSuccessState extends TransactionState {
  final List<ClientTransactions> transactions;
  final double total;

  GetDataSuccessState(this.transactions,this.total);


}
