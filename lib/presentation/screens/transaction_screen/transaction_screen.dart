import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tranaction_cubit/transaction_cubit.dart';
import '../../ui_models/client_transactions.dart';

class TransactionScreen extends StatefulWidget {
  final int clientId;

  const TransactionScreen({super.key, required this.clientId});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().getTransactionList(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, clientId: widget.clientId),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<TransactionCubit, TransactionState > (
    listener: (context, state) {
      if (state is ErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }

      if (state is GetDataSuccessState) {
        // example: show a small confirmation snack if needed
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Data Loaded")),
        // );
      }
    },
    builder: (context, state) {
      if (state is LoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ErrorState) {
        return Center(child: Text(state.message));
      }

      if (state is GetDataSuccessState) {
        final transactions = state.transactions;

        if (transactions.isEmpty) {
          return const Center(child: Text("No Transactions Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final t = transactions[index];
            return Card(
              child: ListTile(
                title: Text("${t.amount.toStringAsFixed(2)} EGP"),
                subtitle: Text("Status: ${t.status}"),
                trailing: Text(
                  "${t.datetime.day}/${t.datetime.month}/${t.datetime.year}",
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () =>
                    _showAddEditDialog(
                      context,
                      edit: t,
                      clientId: widget.clientId,
                    ),
              ),
            );
          },
        );
      }

      return const SizedBox();
    },
    ),

    );
  }

  void _showAddEditDialog(BuildContext context,
      {ClientTransactions? edit, required int clientId}) {
    final TextEditingController amountCon = TextEditingController(
        text: edit?.amount.toString() ?? "");
    final TextEditingController statusCon = TextEditingController(
        text: edit?.status ?? "");

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(edit == null ? "Add Transaction" : "Edit Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountCon,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusCon,
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final cubit = context.read<TransactionCubit>();

                if (edit == null) {
                  await cubit.addTransaction(
                    clientId: clientId,
                    amount: double.tryParse(amountCon.text) ?? 0,
                    status: statusCon.text,
                  );
                } else {
                  await cubit.editTransaction(
                    id: edit.id,
                    clientId: edit.clientId,
                    amount: double.tryParse(amountCon.text) ?? edit.amount,
                    status: statusCon.text,
                  );
                }

                cubit.getTransactionList(clientId);
                Navigator.pop(ctx);
              },
              child: Text(edit == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
