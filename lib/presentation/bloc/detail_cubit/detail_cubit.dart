import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/get_transactions_by_client.dart';
import '../../../core/error/failures.dart';
import '../../moc_models.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetTransactionsByClient getTransactionsByClientUseCase;

  DetailCubit({
    required this.getTransactionsByClientUseCase,
  }) : super(DetailInitial());

  Future<void> loadClientDetails(int clientId) async {
    emit(DetailLoading());

    // Fetch transactions and balance concurrently for better performance
    final results = await Future.wait([
      getTransactionsByClientUseCase(GetTransactionsByClientParams(clientId: clientId)),
    ]);

    // Cast results safely
    final transactionsResult = results[0] as Either<Failure, List<Transaction>>;

    // Use nested fold to handle both results
    transactionsResult.fold(
          (failure) => emit(DetailError(message: _mapFailureToMessage(failure))),
          (transactions) { // Correct: only one parameter
            emit(DetailLoaded(transactions: transactions));

      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Simple failure mapping
    return failure.toString();
  }
}