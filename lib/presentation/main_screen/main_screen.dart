import 'package:client_ledger/presentation/main_screen/widget/add_new_account_dialog.dart';
import 'package:client_ledger/presentation/main_screen/widget/category_page_widget.dart';
import 'package:flutter/material.dart';

import '../moc_models.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCurrency = "Local";
  final Map<int, CategorySummary> _sampleCategorySummaries = {
    1: CategorySummary(totalAdded: 1600, totalSubtracted: 651.25, netBalance: 948.75),
    2: CategorySummary(totalAdded: 5000, totalSubtracted: 0, netBalance: 5000),
    3: CategorySummary(),
  };

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

  @override
  Widget build(BuildContext context) {
    final categories = _sampleCategories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () { },
          ),
          title: const Text("Clients"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {  },
            ),
            IconButton(
              icon: const Icon(Icons.description_outlined), // Or Icons.picture_as_pdf
              onPressed: () {   },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                  },
                  child: Text("Currency: $_selectedCurrency", style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor ?? Colors.white)),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {},
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



