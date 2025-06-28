import 'package:client_ledger/presentation/clint_detail_screen/widget/add_transaction_dialog.dart';
import 'package:client_ledger/presentation/clint_detail_screen/widget/client_summary_footer.dart';
import 'package:client_ledger/presentation/clint_detail_screen/widget/transaction_list_item.dart';
import 'package:flutter/material.dart';

import '../moc_models.dart';


// client_details_screen
class ClientDetailsScreen extends StatelessWidget {
  final ClientUi client;

  ClientDetailsScreen({super.key, required this.client});

  final Map<int, List<Transaction>> _sampleTransactions = {
    101: [
      Transaction(clientId: 101, amount: 1500, isAddition: true, details: "Initial Deposit", dateTime: DateTime(2023, 1, 15, 10, 0), balanceAfterTransaction: 1500),
      Transaction(clientId: 101, amount: 250.75, isAddition: false, details: "Utility Bill", dateTime: DateTime(2023, 1, 20, 14, 30), balanceAfterTransaction: 1249.25), // Note: balanceAfterTransaction should be accurate
    ],
    102: [
      Transaction(clientId: 102, amount: 100, isAddition: true, details: "Refund", dateTime: DateTime(2023, 2, 1, 9, 0), balanceAfterTransaction: 100),
      Transaction(clientId: 102, amount: 400.50, isAddition: false, details: "Purchase", dateTime: DateTime(2023, 2, 5, 16, 0), balanceAfterTransaction: -300.50),
    ],
    201: [
      Transaction(clientId: 201, amount: 5000, isAddition: true, details: "Project Payment", dateTime: DateTime(2023, 3, 10, 11, 0), balanceAfterTransaction: 5000),
    ],
  };


  final Map<int, ClientSummary> _sampleClientSummaries = {
    101: ClientSummary(totalAdded: 1500, totalSubtracted: 250.75, netBalance: 1249.25),
    102: ClientSummary(totalAdded: 100, totalSubtracted: 400.50, netBalance: -300.50),
    201: ClientSummary(totalAdded: 5000, totalSubtracted: 0, netBalance: 5000),
  };
  @override
  Widget build(BuildContext context) {
    // In a real app, transactions and summary would come from a BLoC/Cubit
    final transactions = _sampleTransactions[client.id] ?? [];
    final clientSummary = _sampleClientSummaries[client.id] ?? ClientSummary();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(client.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () { /* TODO: Implement search in transactions */ },
          ),
          IconButton(
            icon: const Icon(Icons.file_present_outlined),
            onPressed: () { /* TODO: Implement export transactions */ },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 30), onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AddTransactionDialog(client: client),
                  );
                }),
                IconButton(icon: const Icon(Icons.message_outlined, color: Colors.blue, size: 30), onPressed: () { /* TODO: Implement message client */ }),
                IconButton(icon: const Icon(Icons.call_outlined, color: Colors.blue, size: 30), onPressed: () { /* TODO: Implement call client */ }),
                IconButton(icon: const Icon(Icons.monetization_on_outlined, color: Colors.blue, size: 30), onPressed: () { /* TODO: Implement payment action */ }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: const <Widget>[
                Expanded(child: Text("Date", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text("Amount", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text("Details", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text("Balance", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionListItem(transaction: transactions[index]);
              },
            ),
          ),
          ClientSummaryFooter(summary: clientSummary),
        ],
      ),
      // floatingActionButton: FloatingActionButton( // Alternative FAB for adding transaction
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) => AddTransactionDialog(client: client),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}