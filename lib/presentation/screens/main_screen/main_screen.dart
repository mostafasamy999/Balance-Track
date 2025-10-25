import 'package:flutter/material.dart';
import 'package:client_ledger/data/local/database.dart';
import 'package:client_ledger/data/local/client_local_data_source.dart';

class ClientTestScreen extends StatefulWidget {
  const ClientTestScreen({super.key});

  @override
  State<ClientTestScreen> createState() => _ClientTestScreenState();
}

class _ClientTestScreenState extends State<ClientTestScreen> {
  late final AppDatabase _db;
  late final ClientLocalDataSourceImpl _dataSource;

  List<ClientTableData> clients = [];
  List<TransactionTableData> transactions = [];

  final nameController = TextEditingController();
  final categoryController = TextEditingController(text: "General");
  final amountController = TextEditingController();
  final statusController = TextEditingController(text: "pending");

  int? selectedClientId;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _dataSource = ClientLocalDataSourceImpl(database: _db);
    _loadClients();
  }

  Future<void> _loadClients() async {
    final list = await _dataSource.getClientsByCategory(categoryController.text);
    setState(() => clients = list);
  }

  Future<void> _addClient() async {
    final client = ClientTableCompanion.insert(
      name: nameController.text,
      category: categoryController.text,
    );
    await _db.into(_db.clientTable).insert(client);
    await _loadClients();
  }

  Future<void> _loadTransactions() async {
    if (selectedClientId == null) return;
    final list = await _dataSource.getTransactionsByClient(selectedClientId!);
    setState(() => transactions = list);
  }

  Future<void> _addTransaction() async {
    if (selectedClientId == null) return;
    final amount = double.tryParse(amountController.text) ?? 0.0;

    final transaction = TransactionTableCompanion.insert(
      clientId: selectedClientId!,
      amount: amount,
      status: statusController.text,
      datetime: DateTime.now(),
    );

    await _db.into(_db.transactionTable).insert(transaction);
    await _loadTransactions();
  }

  Future<void> _clearAll() async {
    await _dataSource.clearAllData();
    setState(() {
      clients = [];
      transactions = [];
      selectedClientId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Ledger Test UI"),
        actions: [
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_forever),
            tooltip: "Clear All Data",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Add Client", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Client Name")),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Category")),
            ElevatedButton(onPressed: _addClient, child: const Text("Add Client")),
            const Divider(),

            const Text("Clients", style: TextStyle(fontWeight: FontWeight.bold)),
            for (final c in clients)
              ListTile(
                title: Text("${c.name} (${c.category})"),
                subtitle: Text("ID: ${c.id}"),
                selected: selectedClientId == c.id,
                onTap: () {
                  setState(() => selectedClientId = c.id);
                  _loadTransactions();
                },
              ),
            const Divider(),

            if (selectedClientId != null) ...[
              Text("Add Transaction for Client #$selectedClientId", style: const TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: "Amount")),
              TextField(controller: statusController, decoration: const InputDecoration(labelText: "Status")),
              ElevatedButton(onPressed: _addTransaction, child: const Text("Add Transaction")),
              const Divider(),

              const Text("Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
              for (final t in transactions)
                ListTile(
                  title: Text("Amount: ${t.amount} | Status: ${t.status}"),
                  subtitle: Text("Date: ${t.datetime.toLocal()}"),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
