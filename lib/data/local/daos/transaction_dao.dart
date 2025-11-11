import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transaction.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);


  Future<List<TransactionTableData>> getAllTransactions(int clientId) {
    return (select(transactionTable)
      ..where((t) => t.clientId.equals(clientId)))
        .get();
  }

  Future<int> insertTransaction({
    required int clientId,
    required double amount,
    required String status,
  }) {
    return into(transactionTable).insert(
      TransactionTableCompanion.insert(
        clientId: clientId,
        amount: amount,
        status: status,
        datetime: DateTime.now(),
      ),
    );
  }

  Future<int> updateTransaction({
    required int id,
    required int clientId,
    required double amount,
    required String status,
  }) {
    return (update(transactionTable)
      ..where((t) => t.id.equals(id)))
        .write(TransactionTableCompanion(
      clientId: Value(clientId),
      amount: Value(amount),
      status: Value(status),
    ));
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactionTable)
      ..where((t) => t.id.equals(id)))
        .go();
  }
}
