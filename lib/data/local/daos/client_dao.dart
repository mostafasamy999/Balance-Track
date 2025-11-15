import 'package:drift/drift.dart';
import '../../../presentation/ui_models/client_with_total.dart';
import '../database.dart';
import '../tables/client.dart';
import '../tables/transaction.dart';

part 'client_dao.g.dart';

@DriftAccessor(tables: [ClientTable, TransactionTable])
class ClientDao extends DatabaseAccessor<AppDatabase> with _$ClientDaoMixin {
  ClientDao(AppDatabase db) : super(db);

  Future<int> insertClient({required String name,required  String category}) =>
      into(clientTable).insert(ClientTableCompanion(name: Value(name), category: Value(category)));


  Future<List<ClientWithTotal>> getClientsWithTotal() async {
    final query = select(clientTable).join([
      leftOuterJoin(
        transactionTable,
        transactionTable.clientId.equalsExp(clientTable.id),
      )
    ]);

    final rows = await query.get();

    final grouped = <int, ClientWithTotal>{};
    for (final row in rows) {
      final client = row.readTable(clientTable);
      final transaction = row.readTableOrNull(transactionTable);

      grouped.putIfAbsent(
        client.id,
            () => ClientWithTotal(client: client, totalAmount: 0),
      );

      if (transaction != null) {
        final newAmount = (transaction.status)?transaction.amount: -transaction.amount;
        grouped[client.id] =
            grouped[client.id]!.copyWithAddedAmount(newAmount);
      }
    }
    return grouped.values.toList();
  }

}

