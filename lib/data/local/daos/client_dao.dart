import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/client.dart';
import '../tables/transaction.dart';

part 'client_dao.g.dart';

@DriftAccessor(tables: [ClientTable, TransactionTable])
class ClientDao extends DatabaseAccessor<AppDatabase> with _$ClientDaoMixin {
  ClientDao(AppDatabase db) : super(db);

  Future<List<ClientTableData>> getAllClients() => select(clientTable).get();

  Stream<List<ClientTableData>> watchAllClients() => select(clientTable).watch();

  Future<int> insertClient(ClientTableCompanion client) =>
      into(clientTable).insert(client);

  // ✅ Query with total amount per client
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
            () => ClientWithTotal(client: clientTable, totalAmount: 0),
      );
      if (transaction != null) {
        grouped[client.id] =
            grouped[client.id]!.copyWithAddedAmount(transaction.amount);
      }
    }
    return grouped.values.toList();
  }
}

// DTO
class ClientWithTotal {
  final ClientTable client;
  final double totalAmount;

  ClientWithTotal({required this.client, required this.totalAmount});

  ClientWithTotal copyWithAddedAmount(double amt) =>
      ClientWithTotal(client: client, totalAmount: totalAmount + amt);
}
