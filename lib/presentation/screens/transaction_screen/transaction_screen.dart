import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      body: BlocConsumer<TransactionCubit, TransactionState>(
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

            // ---- Calculate put & pull ----
            final double totalPut = transactions
                .where((t) => t.status == true)
                .fold(0, (sum, t) => sum + t.amount);

            final double totalPull = transactions
                .where((t) => t.status == false)
                .fold(0, (sum, t) => sum + t.amount);

            final double finalTotal = totalPut - totalPull;
            return Column(children: [
              // ----------------- TOP SUMMARY BOX -----------------
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Put (+)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${totalPut.toStringAsFixed(2)} EGP",
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Pull (-)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${totalPull.toStringAsFixed(2)} EGP",
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Final Total",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${finalTotal.toStringAsFixed(2)} EGP",
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return Card(
                    child: ListTile(
                      title: Text("${t.amount.toStringAsFixed(2)} EGP",
                        style: TextStyle(
                          color: t.status ? Colors.green : Colors.red, // green for Put, red for Pull
                          fontWeight: FontWeight.bold,
                        ),),
                      subtitle: Text(t.status ? "Put (+)" : "Pull (-)",
                        style: TextStyle(
                          color: t.status ? Colors.green : Colors.red, // green for Put, red for Pull
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing:Text(
                        DateFormat('dd/MM/yyyy hh:mm a').format(t.datetime),
                        style: const TextStyle(fontSize: 12),
                      ),


                      onTap: () => _showAddEditDialog(
                        context,
                        edit: t,
                        clientId: widget.clientId,
                      ),
                    ),
                  );
                },
              ))
            ]);
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showAddEditDialog(BuildContext context,
      {ClientTransactions? edit, required int clientId}) {
    final TextEditingController amountCon =
        TextEditingController(text: edit?.amount.toString() ?? "");

    // true = put , false = pull
    bool status = edit?.status ?? true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title:
                  Text(edit == null ? "Add Transaction" : "Edit Transaction"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountCon,
                    decoration: const InputDecoration(labelText: "Amount"),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // ----------------------- RADIO BUTTONS -----------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: status,
                            onChanged: (val) {
                              setState(() => status = val!);
                            },
                          ),
                          const Text("Put (+)"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: status,
                            onChanged: (val) {
                              setState(() => status = val!);
                            },
                          ),
                          const Text("Pull (-)"),
                        ],
                      ),
                    ],
                  ),
                  // --------------------------------------------------------------
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    final cubit = context.read<TransactionCubit>();

                    if (edit == null) {
                      await cubit.addTransaction(
                        clientId: clientId,
                        amount: double.tryParse(amountCon.text) ?? 0,
                        status: status,
                      );
                    } else {
                      await cubit.editTransaction(
                        id: edit.id,
                        clientId: clientId,
                        amount: double.tryParse(amountCon.text) ?? edit.amount,
                        status: status,
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
      },
    );
  }
}
