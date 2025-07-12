import 'package:client_ledger/presentation/main_screen/widget/add_new_account_dialog.dart';
import 'package:client_ledger/presentation/main_screen/widget/category_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../bloc/add_client/add_client_cubit.dart';
import '../bloc/main_screen_cubit/main_screen_cubit.dart';
import '../moc_models.dart';
import '../../../domain/entities/category.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  Map<int, List<ClientUi>> _clientsByCategory = {};
  Map<int, CategorySummary> _sampleCategorySummaries =
      {};
  int _selectedCategoryId = 1;

  @override
  void initState() {
    super.initState();
    context.read<MainScreenCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
        if (state is MainScreenError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is MainScreenCategoryAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Category "${state.category.name}" added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MainScreenClientAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Client "${state.client.name}" added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Optionally re-fetch clients after adding
          final currentCategoryId = _getCurrentCategoryId();
          if (currentCategoryId != null) {
            context
                .read<MainScreenCubit>()
                .getClientsByCategory(currentCategoryId);
          }
        } else if (state is MainScreenClientsLoaded) {
          _clientsByCategory[_getCurrentCategoryId() ?? 0] = state.clients;
          if (state.clients.isEmpty)
            _selectedCategoryId = 1;
          else
            _selectedCategoryId = state.clients.first.categoryId;
        }
      },
      builder: (context, state) {
        final cubit = context.read<MainScreenCubit>();

        List<Category> categories = [];
        if (state is MainScreenCategoriesLoaded) {
          categories = state.categories;
          _setupTabController(categories);
          // Trigger first load
          if (categories.isNotEmpty) {
            context
                .read<MainScreenCubit>()
                .getClientsByCategory(categories[0].id ?? 0);
          }
        } else if (cubit.categories.isNotEmpty) {
          categories = cubit.categories;
          _setupTabController(categories);
        }

        if (state is MainScreenLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (categories.isEmpty) {
          return _buildEmptyState(context);
        }

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Clients"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddCategoryDialog(context, (category) {
                    context.read<MainScreenCubit>().addCategory(category);
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<MainScreenCubit>().loadCategories(),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: categories.length > 3,
                onTap: (index) {
                  final categoryId = categories[index].id ?? 0;
                  context
                      .read<MainScreenCubit>()
                      .getClientsByCategory(categoryId);
                },
                tabs: categories.map((c) => Tab(text: c.name)).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                final clients = _clientsByCategory[category.id] ?? [];
                final summary =
                    _sampleCategorySummaries[category.id] ?? CategorySummary();
                return CategoryPageView(
                  category:
                      CategoryUi(id: category.id ?? 0, name: category.name),
                  clients: clients,
                  summary: summary,
                );
              }).toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return BlocProvider<AddClientCubit>(
                    create: (_) => AddClientCubit(addClientUseCase: injector()),
                    child: AddNewAccountDialog(
                      onTap: (client) => _insertClient(client),
                      selectedCategoryId: _selectedCategoryId,
                    ),
                  );
                },
              ),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _setupTabController(List<Category> categories) {
    if (_tabController == null || _tabController!.length != categories.length) {
      _tabController = TabController(length: categories.length, vsync: this);
    }
  }

  void _showAddCategoryDialog(
      BuildContext context, Function(CategoryUi) onTap) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter category name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                onTap(CategoryUi(id: 0, name: name));
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  // In MainScreen class
  void _insertClient(ClientUi newClient) {
    // REMOVE THIS LINE:
    // context.read<MainScreenCubit>().addClient(newClient);

    // Only refresh the category
    context.read<MainScreenCubit>().getClientsByCategory(newClient.categoryId);
  }

  int? _getCurrentCategoryId() {
    if (_tabController == null) return null;
    final index = _tabController!.index;
    final categories = context.read<MainScreenCubit>().categories;
    if (index < categories.length) {
      return categories[index].id;
    }
    return null;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clients"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context, (category) {
              context.read<MainScreenCubit>().addCategory(category);
            }),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No categories found',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Add a category to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, (category) {
          context.read<MainScreenCubit>().addCategory(category);
        }),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
