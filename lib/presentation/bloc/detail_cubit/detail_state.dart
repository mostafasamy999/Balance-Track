part of 'detail_cubit.dart';

@immutable
abstract class DetailState  {
  const DetailState();

}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final List<Transaction> transactions;

  const DetailLoaded({required this.transactions, });

  @override
  List<Object> get props => [transactions, ];
}

class DetailError extends DetailState {
  final String message;

  const DetailError({required this.message});

  @override
  List<Object> get props => [message];
}