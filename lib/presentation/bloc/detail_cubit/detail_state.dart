// part of 'detail_cubit.dart';
//
// // States
// abstract class DetailState  {
//   const DetailState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class DetailInitial extends DetailState {}
//
// class DetailLoading extends DetailState {}
//
// class DetailLoaded extends DetailState {
//   final List<Transaction> transactions;
//   final double clientBalance;
//   final double totalAdded;
//   final double totalSubtracted;
//
//   const DetailLoaded({
//     required this.transactions,
//     required this.clientBalance,
//     required this.totalAdded,
//     required this.totalSubtracted,
//   });
//
//   @override
//   List<Object> get props => [transactions, clientBalance, totalAdded, totalSubtracted];
// }
//
// class DetailError extends DetailState {
//   final String message;
//
//   const DetailError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
//
// class DetailTransactionAdding extends DetailState {
//   final List<Transaction> transactions;
//   final double clientBalance;
//   final double totalAdded;
//   final double totalSubtracted;
//
//   const DetailTransactionAdding({
//     required this.transactions,
//     required this.clientBalance,
//     required this.totalAdded,
//     required this.totalSubtracted,
//   });
//
//   @override
//   List<Object> get props => [transactions, clientBalance, totalAdded, totalSubtracted];
// }
//
// class DetailTransactionAdded extends DetailState {
//   final Transaction addedTransaction;
//
//   const DetailTransactionAdded(this.addedTransaction);
//
//   @override
//   List<Object> get props => [addedTransaction];
// }