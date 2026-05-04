import 'dart:developer';

import 'package:ecommerce/core/di/injection.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/theme/theme_config.dart';
import 'package:ecommerce/features/auth/data/user_registration_repo/user_registration_repo_impl.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_cubit/create_user_cubit.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_cubit/login_logout_cubit.dart';
import 'package:ecommerce/features/order_management/data/repository/order_repo_impl.dart';
import 'package:ecommerce/features/home/data/repository/home_repo_impl.dart';
import 'package:ecommerce/features/checkout/data/repository/checkout_repository_impl.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_address_provider.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/features/home/presentation/manager/home_provider.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/cart/data/repository/cart_repository_impl.dart';
import 'features/payment/data/repository/paymob_repository_impl.dart';
import 'features/wishlist/data/repository/wishlist_repository_impl.dart';
import 'features/auth/presentation/manager/address_provider.dart';
import 'features/auth/presentation/manager/user_registration_provider.dart';
import 'features/cart/presentation/manager/cart_provider.dart';
import 'presentation/provider/location_viewmodel.dart';
import 'features/wishlist/presentation/manager/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: 'e-commerce-2699c',
    );

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) => UserRegistrationProvider(UserRegistrationRepoImpl())),
      ChangeNotifierProvider(
          create: (_) => AddressProvider(UserRegistrationRepoImpl())),
      ChangeNotifierProxyProvider<AddressProvider, CheckoutAddressProvider>(
        create: (context) => CheckoutAddressProvider(
          Provider.of<AddressProvider>(context, listen: false),
        ),
        update: (context, addressProvider, checkoutAddressProvider) =>
            checkoutAddressProvider ?? CheckoutAddressProvider(addressProvider),
      ),
      ChangeNotifierProvider(
        create: (_) => HomeProvider(HomeRepoImpl()),
      ),

      ChangeNotifierProvider(create: (_) => CartProvider(CartRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => WishlistProvider(WishListRepositoryImpl())),
      // ChangeNotifierProvider(create: (_) => UnsplashViewModel(UnsplashRepositoryImpl())),
      ChangeNotifierProvider(
        create: (_) => PaymentProvider(PaymentRepositoryImpl()),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => OrderProvider(OrderRepositoryImpl()),
      ),
      ChangeNotifierProvider(
        create: (_) => CheckoutProvider(CheckoutRepositoryImpl()),
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

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<SignupCubit>(),
          ),
          BlocProvider(create: (context) => getIt<LoginLogoutCubit>(),
          )
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeDataConfig.themeData,
          debugShowCheckedModeBanner: false,
        ));
  }
}
