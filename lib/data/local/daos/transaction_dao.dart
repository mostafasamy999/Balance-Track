import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transaction.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<TransactionTableData>> getAllTransactions() =>
      select(transactionTable).get();

  Future<int> insertTransaction(TransactionTableCompanion transaction) =>
      into(transactionTable).insert(transaction);
}
