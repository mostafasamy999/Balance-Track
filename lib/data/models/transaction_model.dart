import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.clientId,
    required super.amount,
    required super.isAddition,
    required super.details,
    required super.dateTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      clientId: json['client_id'],
      amount: json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'],
      isAddition: json['is_addition'] == 1,
      details: json['details'],
      dateTime: DateTime.parse(json['date_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'client_id': clientId,
      'amount': amount,
      'is_addition': isAddition ? 1 : 0,
      'details': details,
      'date_time': dateTime.toIso8601String(),
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      clientId: transaction.clientId,
      amount: transaction.amount,
      isAddition: transaction.isAddition,
      details: transaction.details,
      dateTime: transaction.dateTime,
    );
  }
}