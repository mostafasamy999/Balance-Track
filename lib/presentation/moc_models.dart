
import '../domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class Equatable {
  final List<Object?> props;
  const Equatable(this.props);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Equatable &&
              runtimeType == other.runtimeType &&
              _listEquals(props, other.props);

  @override
  int get hashCode => props.fold(0, (previousValue, element) => previousValue ^ element.hashCode);

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class TransactionUi extends Equatable {
  final int? id;
  final int clientId;
  final double amount;
  final bool isAddition; // true for credit (for client), false for debit (on client)
  final String details;
  final DateTime dateTime;
  final double balanceAfterTransaction; // Added for display in transaction list

  const TransactionUi({
    this.id,
    required this.clientId,
    required this.amount,
    required this.isAddition,
    required this.details,
    required this.dateTime,
    this.balanceAfterTransaction = 0.0, // Default, should be calculated
  }) : super(const []); // Simplified Equatable props for this conceptual code

  @override
  List<Object?> get props => [id, clientId, amount, isAddition, details, dateTime, balanceAfterTransaction];

  double get value => isAddition ? amount : -amount;
}


extension TransactionMapper on Transaction {
  TransactionUi toUi({double balanceAfterTransaction = 0.0}) {
    return TransactionUi(
      id: id,
      clientId: clientId,
      amount: amount,
      isAddition: isAddition,
      details: details,
      dateTime: dateTime,
      balanceAfterTransaction: balanceAfterTransaction,
    );
  }
}




class ClientUi extends Equatable {
  final int? id;
  final String name;
  final int categoryId;
  final int transactionCount; // Added for display
  final double finalBalance; // Added for display

  const ClientUi({
    this.id,
    required this.name,
    required this.categoryId,
    this.transactionCount = 0,
    this.finalBalance = 0.0,
  }) : super(const []);

  @override
  List<Object?> get props => [id, name, categoryId, transactionCount, finalBalance];
}

class CategoryUi extends Equatable {
  final int? id;
  final String name;

  const CategoryUi({
    this.id,
    required this.name,
  }) : super(const []);

  @override
  List<Object?> get props => [id, name];
}

// Placeholder summary data classes
class CategorySummary {
  final double totalAdded;
  final double totalSubtracted;
  final double netBalance;
  final String currencySymbol;

  CategorySummary({
    this.totalAdded = 0.0,
    this.totalSubtracted = 0.0,
    this.netBalance = 0.0,
    this.currencySymbol =
    ", // Default to empty or use a global constant"
  });
}

class ClientSummary {
  final double totalAdded;
  final double totalSubtracted;
  final double netBalance;
  final String currencySymbol;

  ClientSummary({
    this.totalAdded = 0.0,
    this.totalSubtracted = 0.0,
    this.netBalance = 0.0,
    this.currencySymbol = "",
  });
}