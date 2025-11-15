
import '../../data/local/database.dart';
class ClientTransactionsResult {
  final List<ClientTransactions> transactions;
  final double total;

  ClientTransactionsResult({
    required this.transactions,
    required this.total,
  });
}
extension ToClientTransactionsResult on List<TransactionTableData> {
  ClientTransactionsResult toResult() {
    final items = toUiModel();

    double total = 0;
    for (final tx in items) {
      total += tx.status ? tx.amount : -tx.amount;
    }

    return ClientTransactionsResult(
      transactions: items.map((e) => ClientTransactions(
        id: e.id,
        clientId: e.clientId,
        amount: e.amount,
        status: e.status,
        datetime: e.datetime,
      )).toList(),
      total: total,
    );
  }
}

extension ClientTransactionsTotal on List<ClientTransactions> {
  double calculateTotal() {
    double total = 0;

    for (final tx in this) {
      if (tx.status) {
        total += tx.amount; // true = put
      } else {
        total -= tx.amount; // false = pull
      }
    }

    return total;
  }
}



class ClientTransactions {
  final int id;
  final int clientId;
  final double amount;
  final bool status;
  final DateTime datetime;

  ClientTransactions({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.status,
    required this.datetime,
  });
  @override
  String toString() {
    return  'ClientTransactions{id: $id, clientId: $clientId, amount: $amount, status: $status, datetime: $datetime}';
  }
}

extension ConvertTansactionList on List<TransactionTableData> {
  List<ClientTransactions> toUiModel() {
    return map((e) => e.toUiModel()).toList();
  }
}
extension on TransactionTableData {
  ClientTransactions toUiModel() {
    return ClientTransactions(
      id: id,
      clientId: clientId,
      amount: amount,
      status: status,
      datetime: datetime,
    );
  }
}