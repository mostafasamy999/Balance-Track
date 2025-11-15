import 'package:client_ledger/presentation/screens/transaction_screen/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/local/database.dart';
import '../../../di/injection.dart';
import '../../bloc/main_cubit/main_screen_cubit.dart';
import '../../bloc/tranaction_cubit/transaction_cubit.dart' as t;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load data once when screen starts
    context.read<MainScreenCubit>().getClientsList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clients with Totals')),
      body: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          print('MainScreen state: $state');
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDataSuccessState) {
            final clients = state.clients;
            if (clients.isEmpty) {
              return const Center(child: Text('No clients found'));
            }
            if (clients.isEmpty) {
              return const Center(child: Text('No clients found'));
            }

            // Calculate grand total across all clients
            double grandTotal = 0;
            for (final c in clients) {
              grandTotal += c.totalAmount; // assume totalAmount is +ve for Put, -ve for Pull
            }

            final grandStatus = grandTotal >= 0 ? 'Put (+)' : 'Pull (-)';
            final grandColor = grandTotal >= 0 ? Colors.green : Colors.red;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: clients.length,
                    itemBuilder: (context, i) {
                      final client = clients[i];

                      final total = client.totalAmount;
                      final totalStatus = total >= 0 ? 'Put (+)' : 'Pull (-)';
                      final totalColor = total >= 0 ? Colors.green : Colors.red;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => t.TransactionCubit(injector()),
                                  child: TransactionScreen(clientId: client.client.id),
                                ),
                              ),
                            ).then((value) {
                              context.read<MainScreenCubit>().getClientsList();
                            });
                          },
                          title: Text(client.client.name),
                          subtitle: Text('Category: ${client.client.category}'),
                          trailing: Text(
                            '${total.abs().toStringAsFixed(0)} ($totalStatus)',
                            style: TextStyle(
                              color: totalColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.fromLTRB(12,12,82,12),
                  child: ListTile(
                    title: const Text(
                      'Grand Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${grandTotal.abs().toStringAsFixed(0)} ($grandStatus)',
                      style: TextStyle(
                        color: grandColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddClientDialog(BuildContext parentContext) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add New Client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final category = categoryController.text.trim();

                if (name.isNotEmpty && category.isNotEmpty) {
                  parentContext.read<MainScreenCubit>().addClient(
                    name: name,
                    category: category,
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

}
