import 'package:client_ledger/presentation/main_screen/widget/add_new_account_dialog.dart';
import 'package:client_ledger/presentation/main_screen/widget/category_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/main_screen_cubit/main_screen_cubit.dart';
import '../moc_models.dart';
import '../../../domain/entities/category.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Map<int, CategorySummary> _sampleCategorySummaries = {
    1: CategorySummary(
        totalAdded: 1600, totalSubtracted: 651.25, netBalance: 948.75),
    2: CategorySummary(totalAdded: 5000, totalSubtracted: 0, netBalance: 5000),
    3: CategorySummary(),
  };

  final Map<int, List<ClientUi>> _sampleClients = {
    1: [
      const ClientUi(
          id: 101,
          name: "John Doe",
          categoryId: 1,
          transactionCount: 5,
          finalBalance: 1250.75),
      const ClientUi(
          id: 102,
          name: "Alice Smith",
          categoryId: 1,
          transactionCount: 3,
          finalBalance: -300.50),
    ],
    2: [
      const ClientUi(
          id: 201,
          name: "Bob Johnson",
          categoryId: 2,
          transactionCount: 8,
          finalBalance: 5000.00),
    ],
    3: [],
  };

  @override
  void initState() {
    super.initState();
    // Load categories when screen initializes
    context.read<MainScreenCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
        if (state is MainScreenError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
       else if (state is MainScreenCategoryAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "${state.category.name}" added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }else if (state is MainScreenClientAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Client "${state.client.name}" added successfully!'),
                backgroundColor: Colors.green,
              ));}
      },
      builder: (context, state) {
        if (state is MainScreenLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<Category> categories = [];
        if (state is MainScreenCategoriesLoaded) {
          categories = state.categories;
        } else if (context.read<MainScreenCubit>().categories.isNotEmpty) {
          categories = context.read<MainScreenCubit>().categories;
        }

        if (categories.isEmpty && state is! MainScreenLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Clients"),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showAddCategoryDialog(context, (category) {
                      context.read<MainScreenCubit>().addCategory(category);
                    });
                  },
                ),
              ],
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No categories found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a category to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showAddCategoryDialog(context, (category) {
                  context.read<MainScreenCubit>().addCategory(category);
                });
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          );
        }

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Clients"),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showAddCategoryDialog(context, (category) {
                      context.read<MainScreenCubit>().addCategory(category);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<MainScreenCubit>().loadCategories();
                  },
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                TabBar(
                  isScrollable: categories.length > 3,
                  tabs: categories
                      .map((Category category) => Tab(text: category.name))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.map((Category category) {
                      // Convert Category to CategoryUi for compatibility
                      final categoryUi = CategoryUi(
                        id: category.id ?? 0,
                        name: category.name,
                      );

                      final clientsForCategory =
                          _sampleClients[category.id] ?? [];
                      final categorySummary =
                          _sampleCategorySummaries[category.id] ??
                              CategorySummary();

                      return CategoryPageView(
                        category: categoryUi,
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
                  builder: (BuildContext context) =>
                   AddNewAccountDialog(onTap: (ClientUi newClient){
                    _insertClient(newClient);

                  }),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context, Function(CategoryUi category) onTap) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter category name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final category = CategoryUi(id: 0, name: name);
                  onTap(category);
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _insertClient(ClientUi newClient) {
    context.read<MainScreenCubit>().addClient(newClient);
  }
}