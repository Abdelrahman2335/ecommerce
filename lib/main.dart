import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/theme/theme_config.dart';
import 'package:ecommerce/data/repositories/auth/login_repository_impl.dart';
import 'package:ecommerce/data/repositories/auth/singup_repository_impl.dart';
import 'package:ecommerce/data/repositories/auth/user_data_repository_impl.dart';
import 'package:ecommerce/data/repositories/main_data_repository_impl.dart';
import 'package:ecommerce/data/repositories/order_repository_impl.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/presentation/provider/auth/signup_viewmodel.dart';
import 'package:ecommerce/presentation/provider/item_viewmodel.dart';
import 'package:ecommerce/presentation/provider/order_viewmodel.dart';
import 'package:ecommerce/presentation/provider/payment_viewmodel.dart';
import 'package:ecommerce/presentation/screens/auth/new_user_info_screen.dart';
import 'package:ecommerce/presentation/screens/auth/user_location.dart';
import 'package:ecommerce/presentation/screens/items/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/utils/global_keys.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/paymob_repository_impl.dart';
import 'data/repositories/wishlist_repository_impl.dart';
import 'presentation/provider/auth/login_viewmodel.dart';
import 'presentation/provider/auth/user_data_viewmodel.dart';
import 'presentation/provider/cart_viewmodel.dart';
import 'presentation/provider/location_viewmodel.dart';
import 'presentation/provider/payment_provider.dart';
import 'presentation/provider/wishlist_viewmodel.dart';
import 'presentation/screens/auth/forgot_password.dart';
import 'features/auth/presentation/view/screens/login_screen.dart';
import 'presentation/screens/auth/profile_screen.dart';
import 'presentation/screens/auth/signup.dart';
import 'presentation/screens/place_order/cart_screen.dart';
import 'presentation/screens/place_order/check_out.dart';

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
          create: (_) => SignupViewmodel(SignupRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => UserViewModel(UserDataRepositoryImpl())),
      ChangeNotifierProvider(
        create: (_) => ItemViewModel(ItemRepositoryImpl()),
      ),
      ChangeNotifierProvider(
        create: (_) => LoginViewModel(LoginRepositoryImpl()),
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
    AppKeys.scaffoldMessengerKey;
final GlobalKey<NavigatorState> navigatorKey = AppKeys.navigatorKey;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;

    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/layout': (context) => const LayOut(),
        '/profile': (context) => const ProfileScreen(),
        '/signup': (context) => const SignUp(),
        '/forgot': (context) => const ForgotPassword(),
        '/checkout': (context) => const CheckOutScreen(),
        '/cart': (context) => const CartScreen(),
        '/user_setup': (context) => const NewUserInfoScreen(),
        '/user_location': (context) => const UserLocation(),
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeDataConfig.themeData,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("customers")
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return LoginScreen();
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;

              if (userData["address"] == null) {
                log("address is null & ${userSnapshot.data!.id}");
                return UserLocation();
              } else {
                return LayOut();
              }
            },
          );
        },
      ),
    );
  }
}
