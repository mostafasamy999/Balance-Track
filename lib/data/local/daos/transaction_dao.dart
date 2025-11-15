import 'package:client_ledger/presentation/ui_models/client_transactions.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transaction.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<ClientTransactionsResult> getClientTransactionsWithTotal(
      int clientId) async {
    final txList = await (select(transactionTable)
          ..where((t) => t.clientId.equals(clientId)))
        .get();

    final uiList = txList.toUiModel();
    final total = uiList.calculateTotal();

    return ClientTransactionsResult(
      transactions: uiList,
      total: total,
    );
  }

  Future<int> insertTransaction({
    required int clientId,
    required double amount,
    required bool status,
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

  Future<void> updateTransaction({
    required int id,
    required int clientId,
    required double amount,
    required bool status,
  }) async {

    final c= await getClientTransactionsWithTotal(clientId);
    c.transactions.forEach((e){
      print ("Before Update - $e");
    });

    final updatedRows = await (update(transactionTable)
      ..where((t) => t.id.equals(id)))
        .write(TransactionTableCompanion(
      amount: Value(amount),
      status: Value(status),
    ));

    print('Updated rows: $updatedRows');





    final c2= await getClientTransactionsWithTotal(clientId);
    c2.transactions.forEach((e){
      print ("Before Update - $e");
    });

  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactionTable)..where((t) => t.id.equals(id))).go();
  }
}
