import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';
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
      appBar: AppBar(title: Text(S.of(context).transactions_appbar)),
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
              return Center(child: Text(S.of(context).no_transactions_found));
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
                        Text(S.of(context).total_put,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            S
                                .of(context)
                                .currency_egp(totalPut.toStringAsFixed(0)),
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            S
                                .of(context)
                                .total_pull,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            S
                                .of(context)
                                .currency_egp(totalPull.toStringAsFixed(0)),
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).final_total,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            S
                                .of(context)
                                .currency_egp(finalTotal.toStringAsFixed(0)),
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
                      title: Text(
                        S.of(context).currency_egp(t.amount.toStringAsFixed(0)),
                        style: TextStyle(
                          color: t.status ? Colors.green : Colors.red,
                          // green for Put, red for Pull
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        t.status
                            ? S.of(context).status_put
                            : S.of(context).status_pull,
                        style: TextStyle(
                          color: t.status ? Colors.green : Colors.red,
                          // green for Put, red for Pull
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
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
              title: Text(edit == null
                  ? S.of(context).add_transaction
                  : S.of(context).edit_transaction),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountCon,
                    decoration:
                        InputDecoration(labelText: S.of(context).amount_label),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // ----------------------- RADIO BUTTONS -----------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        S.of(context).status_label,
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
                          Text(S.of(context).status_put),
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
                          Text(S.of(context).status_pull),
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
                    child: Text(S.of(context).cancel)),
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
                  child: Text(
                      edit == null ? S.of(context).add : S.of(context).update),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
