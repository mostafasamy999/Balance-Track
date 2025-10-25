import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/local/database.dart';
import '../../bloc/main_screen/main_screen_cubit.dart';

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
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: clients.length,
              itemBuilder: (context, i) {
                final client = clients[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(client.client.name),
                    subtitle: Text('Category: ${client.client.category}'),
                    trailing: Text(
                      client.totalAmount.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
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
}
