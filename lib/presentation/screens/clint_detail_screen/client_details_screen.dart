import 'package:client_ledger/presentation/moc_models.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/add_transaction_dialog.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/client_summary_footer.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/detail_cubit/detail_cubit.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ClientUi client; // Use the entity directly

  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Use `context.read` to call a function on the cubit once
    // You will need to add this `loadClientDetails` method to your cubit
    context.read<DetailCubit>().loadClientDetails(widget.client.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            // Example of calling a method on the cubit
            onPressed: () => context.read<DetailCubit>().loadClientDetails(widget.client.id!),
          ),
        ],
      ),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          // Handle Loading State
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle Error State
          if (state is DetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // Handle Loaded State
          if (state is DetailLoaded) {
            return Column(
              children: <Widget>[
                // ... Your action buttons row ...
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 30),
                        onPressed: () {
                          showDialog(
                            context: context,
                            // TODO: Update AddTransactionDialog to use the cubit
                            builder: (BuildContext context) => AddTransactionDialog(client: widget.client, onTap: () {

                            },),
                          );
                        },
                      ),
                      // ... other IconButtons
                    ],
                  ),
                ),

                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: const <Widget>[
                      Expanded(child: Text("Date", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Details", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Amount", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Balance", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),

                // Transaction List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      // You'll need to adapt TransactionListItem to the new Transaction entity
                      return TransactionListItem(transaction: state.transactions[index].toUi());
                    },
                  ),
                ),

                // Summary Footer
                ClientSummaryFooter(summary: ClientSummary(currencySymbol: '0',netBalance: 0,totalAdded: 0,totalSubtracted: 0)),
              ],
            );
          }

          // Default case
          return const Center(child: Text('Select a client to see details.'));
        },
      ),
    );
  }
}