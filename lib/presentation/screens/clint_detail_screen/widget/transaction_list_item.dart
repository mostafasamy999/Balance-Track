import 'package:flutter/material.dart';
import '../../../moc_models.dart';

// transaction_list_item
class TransactionListItem extends StatelessWidget {
  final TransactionUi transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color amountColor = transaction.isAddition ? Colors.green : Colors.red;
    final Color amountBgColor = transaction.isAddition ? Colors.green[50]! : Colors.red[50]!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2, // Date
              child: Text(
                // Format date to show only YYYY-MM-DD
                "${transaction.dateTime.year}-${transaction.dateTime.month.toString().padLeft(2, '0')}-${transaction.dateTime.day.toString().padLeft(2, '0')}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2, // Amount
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: amountBgColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: amountColor.withOpacity(0.5)),
                ),
                child: Text(
                  transaction.amount.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Details
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  transaction.details,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            Expanded(
              flex: 2, // Balance After Transaction
              child: Text(
                transaction.balanceAfterTransaction.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
