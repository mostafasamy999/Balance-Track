import 'package:flutter/material.dart';

import '../../../moc_models.dart';


class CategorySummaryFooter extends StatelessWidget {
  final CategorySummary summary;

  const CategorySummaryFooter({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildSummaryColumn("Debit", summary.totalSubtracted.toStringAsFixed(2), summary.currencySymbol),
            _buildSummaryColumn("Credit", summary.totalAdded.toStringAsFixed(2), summary.currencySymbol),
            _buildSummaryColumn(
              "Balance (${summary.netBalance >= 0 ? 'Credit' : 'Debit'})",
              summary.netBalance.abs().toStringAsFixed(2),
              summary.currencySymbol,
              valueColor: summary.netBalance >= 0 ? Colors.green[700] : Colors.red[700],
            ),
            // IconButton(icon: Icon(Icons.post_add_outlined), onPressed: () { /* TODO: Action for footer */})
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String title, String value, String currency, {Color? valueColor}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          "$value $currency",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: valueColor),
        ),
      ],
    );
  }
}

