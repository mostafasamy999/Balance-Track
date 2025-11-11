
import '../../data/local/database.dart';

class ClientTransactions {
  final int id;
  final int clientId;
  final double amount;
  final String status;
  final DateTime datetime;

  ClientTransactions({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.status,
    required this.datetime,
  });
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