import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/theme/theme_config.dart';
import 'package:ecommerce/features/auth/data/create_user_repo/create_user_repo_impl.dart';
import 'package:ecommerce/features/auth/data/user_registration_repo/user_registration_repo_impl.dart';
import 'package:ecommerce/data/repositories/order_repository_impl.dart';
import 'package:ecommerce/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:ecommerce/features/home/data/repository/home_repo_impl.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/features/auth/presentation/manager/create_user_provider.dart';
import 'package:ecommerce/features/home/presentation/manager/home_provider.dart';
import 'package:ecommerce/presentation/provider/order_viewmodel.dart';
import 'package:ecommerce/presentation/provider/payment_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/paymob_repository_impl.dart';
import 'data/repositories/wishlist_repository_impl.dart';
import 'features/auth/presentation/manager/auth_provider.dart';
import 'features/auth/presentation/manager/user_registration_provider.dart';
import 'presentation/provider/cart_viewmodel.dart';
import 'presentation/provider/location_viewmodel.dart';
import 'presentation/provider/payment_provider.dart';
import 'presentation/provider/wishlist_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: 'e-commerce-2699c',
    );
    await Firebase.initializeApp();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) => CreateUserProvider(SignupRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => AuthProvider(LoginRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => UserRegistrationProvider(UserRegistrationRepoImpl())),
      ChangeNotifierProvider(
        create: (_) => HomeProvider(HomeRepoImpl()),
      ),

      ChangeNotifierProvider(
          create: (_) => CartViewModel(CartRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => WishListViewModel(WishListRepositoryImpl())),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
      // ChangeNotifierProvider(create: (_) => UnsplashViewModel(UnsplashRepositoryImpl())),
      ChangeNotifierProvider(
        create: (_) => PaymentViewModel(PaymentRepositoryImpl()),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => OrderViewModel(OrderRepositoryImpl()),
      ),
    ], child: const MyApp()));
  } catch (error) {
    log("Error in the main function: $error");
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeDataConfig.themeData,
      debugShowCheckedModeBanner: false,
    );
  }
}
