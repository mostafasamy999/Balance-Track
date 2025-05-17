import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int? id;
  final int clientId;
  final double amount;
  final bool isAddition;
  final String details;
  final DateTime dateTime;

  const Transaction({
    this.id,
    required this.clientId,
    required this.amount,
    required this.isAddition,
    required this.details,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [id, clientId, amount, isAddition, details, dateTime];

  // Helper method to get the actual value (positive or negative)
  double get value => isAddition ? amount : -amount;
}