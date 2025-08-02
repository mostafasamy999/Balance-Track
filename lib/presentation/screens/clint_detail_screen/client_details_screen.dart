import 'package:client_ledger/presentation/moc_models.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/add_transaction_dialog.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/client_summary_footer.dart';
import 'package:client_ledger/presentation/screens/clint_detail_screen/widget/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/detail_cubit/detail_cubit.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ClientUi client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  @override
  void initState() {
    super.initState();
    print('🔵 [ClientDetailsScreen] Initializing for client: ${widget.client.name} (ID: ${widget.client.id})');

    // Check if client ID is not null before loading details
    if (widget.client.id != null) {
      print('🔵 [ClientDetailsScreen] Loading client details for ID: ${widget.client.id}');
      context.read<DetailCubit>().loadClientDetails(widget.client.id!);
    } else {
      print('🔴 [ClientDetailsScreen] Client ID is null, cannot load details');
    }
  }

  void _showAddTransactionDialog() {
    print('🔵 [ClientDetailsScreen] Showing add transaction dialog');

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext dialogContext) {
        print('🟡 [ClientDetailsScreen] Dialog context created, providing BlocProvider');

        // Provide the existing cubit to the dialog
        return BlocProvider<DetailCubit>.value(
          value: context.read<DetailCubit>(),
          child: AddTransactionDialog(
            client: widget.client,
            onTap: () {
              print('🟡 [ClientDetailsScreen] Transaction dialog onTap called');
              // Refresh data after adding transaction
              if (widget.client.id != null) {
                print('🔵 [ClientDetailsScreen] Refreshing client details after transaction');
                context.read<DetailCubit>().loadClientDetails(widget.client.id!);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: widget.client.id != null
                ? () {
              print('🔵 [ClientDetailsScreen] Refresh button pressed');
              context.read<DetailCubit>().loadClientDetails(widget.client.id!);
            }
                : null,
          ),
        ],
      ),
      body: widget.client.id == null
          ? const Center(
        child: Text(
          'Invalid client: ID is missing',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      )
          : BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          print('🟡 [ClientDetailsScreen] BlocBuilder state: ${state.runtimeType}');

          // Handle Loading State
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle Error State
          if (state is DetailError) {
            print('🔴 [ClientDetailsScreen] Error state: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.client.id != null
                        ? () {
                      print('🔵 [ClientDetailsScreen] Retry button pressed');
                      context.read<DetailCubit>().loadClientDetails(widget.client.id!);
                    }
                        : null,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle Loaded State
          if (state is DetailLoaded) {
            print('🟢 [ClientDetailsScreen] Loaded state: ${state.transactions.length} transactions, balance: ${state.clientBalance}');

            return Column(
              children: <Widget>[
                // Action buttons row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 30),
                        onPressed: widget.client.id != null ? _showAddTransactionDialog : null,
                      ),
                      // Add more action buttons as needed
                    ],
                  ),
                ),

                // Table Header
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

                // Transaction List
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(
                    child: Text(
                      'No transactions found for this client.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final transaction = state.transactions[index];

                      // Calculate running balance for display
                      double runningBalance = 0.0;
                      for (int i = 0; i <= index; i++) {
                        final trans = state.transactions[i];
                        runningBalance += trans.isAddition ? trans.amount : -trans.amount;
                      }

                      return TransactionListItem(
                        transaction: transaction.toUi(balanceAfterTransaction: runningBalance),
                      );
                    },
                  ),
                ),

                // Summary Footer
                ClientSummaryFooter(
                  summary: ClientSummary(
                    currencySymbol: '\$',
                    netBalance: state.clientBalance,
                    totalAdded: state.totalAdded,
                    totalSubtracted: state.totalSubtracted,
                  ),
                ),
              ],
            );
          }

          // Default case
          return const Center(child: Text('Select a client to see details.'));
        },
      ),
      floatingActionButton: widget.client.id != null
          ? FloatingActionButton.extended(
        onPressed: _showAddTransactionDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        backgroundColor: Colors.blue,
      )
          : null,
    );
  }
}