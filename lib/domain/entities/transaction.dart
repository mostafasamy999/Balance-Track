class Transaction {
  final int id;
  final int clientId;
  final double amount;
  final String status;
  final DateTime datetime;

  Transaction({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.status,
    required this.datetime,
  });
}
