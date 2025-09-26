// import 'package:client_ledger/presentation/screens/main_screen/widget/add_new_account_dialog.dart';
// import 'package:client_ledger/presentation/screens/main_screen/widget/category_page_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../di/injection.dart';
// import '../../bloc/add_client/add_client_cubit.dart';
// import '../../bloc/main_screen_cubit/main_screen_cubit.dart';
// import '../../moc_models.dart';
// import '../../../domain/entities/category.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
//   TabController? _tabController;
//   Map<int, List<ClientUi>> _clientsByCategory = {};
//   Map<int, CategorySummary> _sampleCategorySummaries = {};
//   int _selectedCategoryId = 1;
//   bool _hasLoadedInitialClients = false;
//
//   @override
//   void initState() {
//     super.initState();
//     print('🔵 [MainScreen] initState - Loading categories');
//     context.read<MainScreenCubit>().loadCategories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<MainScreenCubit, MainScreenState>(
//       listener: (context, state) {
//         print('🟡 [MainScreen] BlocConsumer listener - State: ${state.runtimeType}');
//
//         if (state is MainScreenError) {
//           print('🔴 [MainScreen] Error state: ${state.message}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//           );
//         } else if (state is MainScreenCategoryAdded) {
//           print('🟢 [MainScreen] Category added: ${state.category.name}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Category "${state.category.name}" added successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           // After adding a category, reload categories to refresh the view
//           context.read<MainScreenCubit>().loadCategories();
//         } else if (state is MainScreenClientAdded) {
//           print('🟢 [MainScreen] Client added: ${state.client.name}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Client "${state.client.name}" added successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           // Refresh clients for the current category after adding
//           final currentCategoryId = _getCurrentCategoryId();
//           if (currentCategoryId != null) {
//             print('🔵 [MainScreen] Refreshing clients for category: $currentCategoryId');
//             context.read<MainScreenCubit>().getClientsByCategory(currentCategoryId);
//           }
//         } else if (state is MainScreenClientsLoaded) {
//           print('🟢 [MainScreen] Clients loaded: ${state.clients.length} clients for category');
//           final currentCategoryId = _getCurrentCategoryId();
//           if (currentCategoryId != null) {
//             _clientsByCategory[currentCategoryId] = state.clients;
//             if (state.clients.isNotEmpty) {
//               _selectedCategoryId = currentCategoryId;
//             }
//           }
//         } else if (state is MainScreenCategoriesLoaded) {
//           print('🟢 [MainScreen] Categories loaded: ${state.categories.length} categories');
//
//           // Load clients for the first category automatically
//           if (state.categories.isNotEmpty && !_hasLoadedInitialClients) {
//             final firstCategoryId = state.categories[0].id ?? 0;
//             print('🔵 [MainScreen] Auto-loading clients for first category: $firstCategoryId');
//             _hasLoadedInitialClients = true;
//             _selectedCategoryId = firstCategoryId;
//
//             // Add a small delay to ensure the tab controller is set up
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               context.read<MainScreenCubit>().getClientsByCategory(firstCategoryId);
//             });
//           }
//         }
//       },
//       builder: (context, state) {
//         print('🟡 [MainScreen] BlocConsumer builder - State: ${state.runtimeType}');
//
//         final cubit = context.read<MainScreenCubit>();
//
//         List<Category> categories = [];
//
//         // Get categories from the current state or from the cubit
//         if (state is MainScreenCategoriesLoaded) {
//           categories = state.categories;
//           print('🟡 [MainScreen] Using categories from state: ${categories.length}');
//         } else if (cubit.categories.isNotEmpty) {
//           categories = cubit.categories;
//           print('🟡 [MainScreen] Using categories from cubit: ${categories.length}');
//         }
//
//         // Set up tab controller when we have categories
//         if (categories.isNotEmpty) {
//           _setupTabController(categories);
//         }
//
//         if (state is MainScreenLoading) {
//           print('🟡 [MainScreen] Showing loading state');
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (categories.isEmpty) {
//           print('🟡 [MainScreen] No categories found, showing empty state');
//           return _buildEmptyState(context);
//         }
//
//         print('🟡 [MainScreen] Building main UI with ${categories.length} categories');
//
//         return DefaultTabController(
//           length: categories.length,
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text("Clients"),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () => _showAddCategoryDialog(context, (category) {
//                     print('🔵 [MainScreen] Adding new category: ${category.name}');
//                     context.read<MainScreenCubit>().addCategory(category);
//                   }),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () => _showDeleteAllDialog(context, () {
//                     print('🔵 [MainScreen] Deleting all data');
//                     context.read<MainScreenCubit>().deleteAllData();
//                   }),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: () {
//                     print('🔵 [MainScreen] Refresh button pressed');
//                     _hasLoadedInitialClients = false;
//                     context.read<MainScreenCubit>().loadCategories();
//                   },
//                 ),
//               ],
//               bottom: TabBar(
//                 controller: _tabController,
//                 isScrollable: categories.length > 3,
//                 onTap: (index) {
//                   final categoryId = categories[index].id ?? 0;
//                   print('🔵 [MainScreen] Tab tapped - Loading clients for category: $categoryId');
//                   _selectedCategoryId = categoryId;
//                   context.read<MainScreenCubit>().getClientsByCategory(categoryId);
//                 },
//                 tabs: categories.map((c) => Tab(text: c.name)).toList(),
//               ),
//             ),
//             body: TabBarView(
//               controller: _tabController,
//               children: categories.map((category) {
//                 final clients = _clientsByCategory[category.id] ?? [];
//                 final summary = _sampleCategorySummaries[category.id] ?? CategorySummary();
//
//                 print('🟡 [MainScreen] Building CategoryPageView for ${category.name}: ${clients.length} clients');
//
//                 return CategoryPageView(
//                   category: CategoryUi(id: category.id ?? 0, name: category.name),
//                   clients: clients,
//                   summary: summary,
//                 );
//               }).toList(),
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 print('🔵 [MainScreen] FloatingActionButton pressed - Selected category: $_selectedCategoryId');
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return BlocProvider<AddClientCubit>(
//                       create: (_) => AddClientCubit(addClientUseCase: injector()),
//                       child: AddNewAccountDialog(
//                         onTap: (client) => _insertClient(client),
//                         selectedCategoryId: _selectedCategoryId,
//                       ),
//                     );
//                   },
//                 );
//               },
//               backgroundColor: Colors.blue,
//               child: const Icon(Icons.add),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _setupTabController(List<Category> categories) {
//     if (_tabController == null || _tabController!.length != categories.length) {
//       print('🟡 [MainScreen] Setting up TabController with ${categories.length} tabs');
//       _tabController?.dispose();
//       _tabController = TabController(length: categories.length, vsync: this);
//
//       // Set the initial tab to match the selected category
//       if (categories.isNotEmpty) {
//         final selectedIndex = categories.indexWhere((c) => c.id == _selectedCategoryId);
//         if (selectedIndex != -1) {
//           _tabController!.index = selectedIndex;
//         }
//       }
//     }
//   }
//
//   void _showAddCategoryDialog(BuildContext context, Function(CategoryUi) onTap) {
//     final controller = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Add New Category'),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           decoration: const InputDecoration(hintText: 'Enter category name'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final name = controller.text.trim();
//               if (name.isNotEmpty) {
//                 onTap(CategoryUi(id: 0, name: name));
//               }
//               Navigator.of(ctx).pop();
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteAllDialog(BuildContext context, Function() onTap) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete All'),
//         content: const Text('Are you sure you want to delete all data?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               onTap();
//               Navigator.of(ctx).pop();
//             },
//             child: const Text('Delete'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _insertClient(ClientUi newClient) {
//     print('🔵 [MainScreen] Client dialog completed - Refreshing category: ${newClient.categoryId}');
//
//     // Only refresh the clients for the category where the client was added
//     context.read<MainScreenCubit>().getClientsByCategory(newClient.categoryId);
//
//     // Update the selected category if needed
//     if (_selectedCategoryId != newClient.categoryId) {
//       _selectedCategoryId = newClient.categoryId;
//
//       // Switch to the correct tab if needed
//       final categories = context.read<MainScreenCubit>().categories;
//       final categoryIndex = categories.indexWhere((c) => c.id == newClient.categoryId);
//       if (categoryIndex != -1 && _tabController != null) {
//         _tabController!.animateTo(categoryIndex);
//       }
//     }
//   }
//
//   int? _getCurrentCategoryId() {
//     final categories = context.read<MainScreenCubit>().categories;
//     if (_tabController != null && categories.isNotEmpty) {
//       final index = _tabController!.index;
//       if (index < categories.length) {
//         final categoryId = categories[index].id;
//         print('🟡 [MainScreen] Current category ID from tab: $categoryId');
//         return categoryId;
//       }
//     }
//     print('🟡 [MainScreen] Current category ID fallback: $_selectedCategoryId');
//     return _selectedCategoryId;
//   }
//
//   Widget _buildEmptyState(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Clients"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddCategoryDialog(context, (category) {
//               context.read<MainScreenCubit>().addCategory(category);
//             }),
//           ),
//         ],
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.category, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('No categories found', style: TextStyle(fontSize: 18, color: Colors.grey)),
//             SizedBox(height: 8),
//             Text('Add a category to get started', style: TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddCategoryDialog(context, (category) {
//           context.read<MainScreenCubit>().addCategory(category);
//         }),
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
// }