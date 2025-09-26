// import 'package:flutter/material.dart';
//
// import '../di/injection.dart';
// import 'bloc/add_client/add_client_cubit.dart';
// import 'bloc/main_screen_cubit/main_screen_cubit.dart';
// import '../presentation/screens/main_screen/main_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Financial App UI Concept',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         primaryColor: const Color(0xFF00AEEF), // Example blue
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFF00AEEF),
//           foregroundColor: Colors.white,
//         ),
//         fontFamily: 'Roboto', // Example font
//       ),
//       home:MultiBlocProvider(
//         providers: [
//           BlocProvider<MainScreenCubit>(
//             create: (_) => MainScreenCubit(
//               addCategoryUseCase: injector(),
//               getCategoriesUseCase: injector(),
//               addClientUseCase: injector(),
//               getClientsByCategoryUseCase: injector(),
//               deleteAllDataUseCase: injector(),
//             ),
//           ),
//           BlocProvider<AddClientCubit>(
//             create: (_) => AddClientCubit(
//               addClientUseCase: injector(),
//             ),
//           ),
//         ],
//         child: const MainScreen(),
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
