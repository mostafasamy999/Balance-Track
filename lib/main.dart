import 'package:flutter/material.dart';

//region Data Models (as provided by user, with minor adjustments for conceptual use)

// Using a placeholder for Equatable as it's an external package
// In a real project, add `equatable` to pubspec.yaml
class Equatable {
  final List<Object?> props;
  const Equatable(this.props);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Equatable &&
              runtimeType == other.runtimeType &&
              _listEquals(props, other.props);

  @override
  int get hashCode => props.fold(0, (previousValue, element) => previousValue ^ element.hashCode);

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class Transaction extends Equatable {
  final int? id;
  final int clientId;
  final double amount;
  final bool isAddition; // true for credit (for client), false for debit (on client)
  final String details;
  final DateTime dateTime;
  final double balanceAfterTransaction; // Added for display in transaction list

  const Transaction({
    this.id,
    required this.clientId,
    required this.amount,
    required this.isAddition,
    required this.details,
    required this.dateTime,
    this.balanceAfterTransaction = 0.0, // Default, should be calculated
  }) : super(const []); // Simplified Equatable props for this conceptual code

  @override
  List<Object?> get props => [id, clientId, amount, isAddition, details, dateTime, balanceAfterTransaction];

  double get value => isAddition ? amount : -amount;
}

class Client extends Equatable {
  final int? id;
  final String name;
  final int categoryId;
  final int transactionCount; // Added for display
  final double finalBalance; // Added for display

  const Client({
    this.id,
    required this.name,
    required this.categoryId,
    this.transactionCount = 0,
    this.finalBalance = 0.0,
  }) : super(const []);

  @override
  List<Object?> get props => [id, name, categoryId, transactionCount, finalBalance];
}

class Category extends Equatable {
  final int? id;
  final String name;

  const Category({
    this.id,
    required this.name,
  }) : super(const []);

  @override
  List<Object?> get props => [id, name];
}

// Placeholder summary data classes
class CategorySummary {
  final double totalAdded;
  final double totalSubtracted;
  final double netBalance;
  final String currencySymbol;

  CategorySummary({
    this.totalAdded = 0.0,
    this.totalSubtracted = 0.0,
    this.netBalance = 0.0,
    this.currencySymbol =
    ", // Default to empty or use a global constant"
  });
}

class ClientSummary {
  final double totalAdded;
  final double totalSubtracted;
  final double netBalance;
  final String currencySymbol;

  ClientSummary({
    this.totalAdded = 0.0,
    this.totalSubtracted = 0.0,
    this.netBalance = 0.0,
    this.currencySymbol = "",
  });
}

//endregion Data Models

//region Placeholder Data (for conceptual UI rendering)

final List<Category> _sampleCategories = [
  const Category(id: 1, name: "Category A"),
  const Category(id: 2, name: "Category B"),
  const Category(id: 3, name: "Category C"),
];

final Map<int, List<Client>> _sampleClients = {
  1: [
    const Client(id: 101, name: "John Doe", categoryId: 1, transactionCount: 5, finalBalance: 1250.75),
    const Client(id: 102, name: "Alice Smith", categoryId: 1, transactionCount: 3, finalBalance: -300.50),
  ],
  2: [
    const Client(id: 201, name: "Bob Johnson", categoryId: 2, transactionCount: 8, finalBalance: 5000.00),
  ],
  3: [],
};

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

final Map<int, CategorySummary> _sampleCategorySummaries = {
  1: CategorySummary(totalAdded: 1600, totalSubtracted: 651.25, netBalance: 948.75),
  2: CategorySummary(totalAdded: 5000, totalSubtracted: 0, netBalance: 5000),
  3: CategorySummary(),
};

final Map<int, ClientSummary> _sampleClientSummaries = {
  101: ClientSummary(totalAdded: 1500, totalSubtracted: 250.75, netBalance: 1249.25),
  102: ClientSummary(totalAdded: 100, totalSubtracted: 400.50, netBalance: -300.50),
  201: ClientSummary(totalAdded: 5000, totalSubtracted: 0, netBalance: 5000),
};

//endregion Placeholder Data

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App UI Concept',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Use a specific blue similar to the images if possible
        // primaryColor: const Color(0xFF00AEEF), // Example blue
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Color(0xFF00AEEF),
        //   foregroundColor: Colors.white,
        // ),
        fontFamily: 'Roboto', // Example font
        // For LTR by default, but can be explicit
        // textDirection: TextDirection.ltr,
      ),
      home: const MainScreen(),
      // In a real app, use a robust routing solution like GoRouter or AutoRoute
      // For simplicity, direct navigation or simple named routes might be shown here.
    );
  }
}

//region Main Screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Placeholder for selected currency
  String _selectedCurrency = "Local";

  @override
  Widget build(BuildContext context) {
    // In a real app, categories would come from a BLoC/Cubit/Provider
    final categories = _sampleCategories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () { /* TODO: Implement drawer or menu action */ },
          ),
          title: const Text("Clients"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () { /* TODO: Implement search action */ },
            ),
            IconButton(
              icon: const Icon(Icons.description_outlined), // Or Icons.picture_as_pdf
              onPressed: () { /* TODO: Implement export action */ },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement currency change logic if needed
                  },
                  child: Text("Currency: $_selectedCurrency", style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor ?? Colors.white)),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) { /* TODO: Handle more options */ },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'option1',
                  child: Text('Option 1'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              isScrollable: categories.length > 3, // Example condition
              tabs: categories.map((Category category) => Tab(text: category.name)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: categories.map((Category category) {
                  // Fetch clients and summary for this category
                  // In a real app, this would be managed by state (BLoC/Cubit)
                  final clientsForCategory = _sampleClients[category.id] ?? [];
                  final categorySummary = _sampleCategorySummaries[category.id] ?? CategorySummary();
                  return CategoryPageView(
                    category: category,
                    clients: clientsForCategory,
                    summary: categorySummary,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => const AddNewAccountDialog(),
            );
          },
          backgroundColor: Colors.blue, // Use Theme.of(context).primaryColor or specific blue
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CategoryPageView extends StatelessWidget {
  final Category category;
  final List<Client> clients;
  final CategorySummary summary;

  const CategoryPageView({
    super.key,
    required this.category,
    required this.clients,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.group_outlined),
              const SizedBox(width: 8),
              Text("Clients (${clients.length})"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (BuildContext context, int index) {
              return ClientListItem(client: clients[index]);
            },
          ),
        ),
        CategorySummaryFooter(summary: summary),
      ],
    );
  }
}

class ClientListItem extends StatelessWidget {
  final Client client;

  const ClientListItem({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientDetailsScreen(client: client),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              // const Spacer(), // Use Expanded on Text or Spacer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue, // Theme.of(context).primaryColor
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  client.transactionCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                client.finalBalance.toStringAsFixed(2),
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_drop_down_circle, color: Colors.red[400]), // Placeholder icon
            ],
          ),
        ),
      ),
    );
  }
}

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
//endregion Main Screen




//region Client Details Screen
class ClientDetailsScreen extends StatelessWidget {
  final Client client;

  const ClientDetailsScreen({super.key, required this.client});

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

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color amountColor = transaction.isAddition ? Colors.green : Colors.red;
    final Color amountBgColor = transaction.isAddition ? Colors.green[50]! : Colors.red[50]!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2, // Date
              child: Text(
                // Format date to show only YYYY-MM-DD
                "${transaction.dateTime.year}-${transaction.dateTime.month.toString().padLeft(2, '0')}-${transaction.dateTime.day.toString().padLeft(2, '0')}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2, // Amount
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: amountBgColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: amountColor.withOpacity(0.5)),
                ),
                child: Text(
                  transaction.amount.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Details
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  transaction.details,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            Expanded(
              flex: 2, // Balance After Transaction
              child: Text(
                transaction.balanceAfterTransaction.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientSummaryFooter extends StatelessWidget {
  final ClientSummary summary;

  const ClientSummaryFooter({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // Similar to CategorySummaryFooter, but for a single client
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildSummaryColumn("Total Debit", summary.totalSubtracted.toStringAsFixed(2), summary.currencySymbol),
            _buildSummaryColumn("Total Credit", summary.totalAdded.toStringAsFixed(2), summary.currencySymbol),
            _buildSummaryColumn(
              "Balance (${summary.netBalance >= 0 ? 'Credit' : 'Debit'})",
              summary.netBalance.abs().toStringAsFixed(2),
              summary.currencySymbol,
              valueColor: summary.netBalance >= 0 ? Colors.green[700] : Colors.red[700],
            ),
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
//endregion Client Details Screen

//region Dialogs

// Add New Account/Client Dialog
class AddNewAccountDialog extends StatefulWidget {
  const AddNewAccountDialog({super.key});

  @override
  State<AddNewAccountDialog> createState() => _AddNewAccountDialogState();
}

class _AddNewAccountDialogState extends State<AddNewAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  double _initialAmount = 0.0;
  String _currency = 'Local'; // Default or from settings
  DateTime _selectedDate = DateTime.now();
  String _details = '';
  String _phoneNumber = '';
  bool _isInitialBalanceAddition = true; // true for Credit, false for Debit

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.person_add_alt_1_outlined, color: Colors.blue),
          SizedBox(width: 10),
          Text("Add New Account"),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "Account Name", prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => value == null || value.isEmpty ? 'Please enter account name' : null,
                onSaved: (value) => _accountName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Initial Amount", prefixIcon: Icon(Icons.calculate_outlined)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
                onSaved: (value) => _initialAmount = double.parse(value!),
              ),
              // In a real app, currency might be a dropdown or based on global settings
              TextFormField(
                initialValue: _currency,
                decoration: const InputDecoration(labelText: "Currency", prefixIcon: Icon(Icons.edit_outlined)),
                // readOnly: true, // If currency is fixed
                onSaved: (value) => _currency = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Details", prefixIcon: Icon(Icons.notes_outlined)),
                onSaved: (value) => _details = value ?? '',
                maxLines: null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value ?? '',
              ),
              const SizedBox(height: 15),
              const Text("Initial Balance Type:", style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("Credit"),
                      value: true,
                      groupValue: _isInitialBalanceAddition,
                      onChanged: (bool? value) {
                        setState(() {
                          _isInitialBalanceAddition = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("Debit"),
                      value: false,
                      groupValue: _isInitialBalanceAddition,
                      onChanged: (bool? value) {
                        setState(() {
                          _isInitialBalanceAddition = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // TODO: Implement save logic (e.g., call BLoC/Cubit event)
              // print("New Account: $_accountName, Amount: $_initialAmount, Credit: $_isInitialBalanceAddition, Date: $_selectedDate, Phone: $_phoneNumber");
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

// Add Transaction Dialog
class AddTransactionDialog extends StatefulWidget {
  final Client client; // Client for whom the transaction is being added

  const AddTransactionDialog({super.key, required this.client});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;
  String _currency = 'Local'; // Default or from client/settings
  DateTime _selectedDate = DateTime.now();
  String _details = '';
  bool _isTransactionAddition = true; // true for Credit, false for Debit

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.post_add_outlined, color: Colors.blue),
          SizedBox(width: 10),
          Text("Add Transaction"),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: widget.client.name,
                decoration: const InputDecoration(labelText: "Client Name", prefixIcon: Icon(Icons.person_outline)),
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Amount", prefixIcon: Icon(Icons.calculate_outlined)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              TextFormField(
                initialValue: _currency, // Inherit from client or app settings
                decoration: const InputDecoration(labelText: "Currency", prefixIcon: Icon(Icons.edit_outlined)),
                readOnly: true, // Typically fixed for a transaction
                onSaved: (value) => _currency = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Details", prefixIcon: Icon(Icons.notes_outlined)),
                onSaved: (value) => _details = value ?? '',
                maxLines: null,
              ),
              const SizedBox(height: 15),
              const Text("Transaction Type:", style: TextStyle(fontSize: 16)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("Credit"),
                      value: true,
                      groupValue: _isTransactionAddition,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTransactionAddition = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("Debit"),
                      value: false,
                      groupValue: _isTransactionAddition,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTransactionAddition = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade300),
              child: const Text("Save & New"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // TODO: Implement save logic (e.g., call BLoC/Cubit event)
                  // print("New Transaction for ${widget.client.name}: Amount: $_amount, Credit: _isTransactionAddition, Date: $_selectedDate");
                  // Reset form for new entry if needed, or re-open dialog
                  _formKey.currentState!.reset();
                  setState(() {
                    _selectedDate = DateTime.now();
                    _isTransactionAddition = true;
                  });
                  // Potentially keep dialog open or show a quick success message
                }
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              child: const Text("Save & Exit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // TODO: Implement save logic
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        )
      ],
    );
  }
}

//endregion Dialogs

