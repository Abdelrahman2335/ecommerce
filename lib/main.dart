import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/constants/theme.dart';
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

import 'core/constants/global_keys.dart';
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
import 'presentation/screens/auth/login_screen.dart';
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
    runApp(

        /// This widget is the root of your application.
        MultiProvider(providers: [
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
  /// SharedPreferences is not the best option for login with Firebase
  // final prefs = await SharedPreferences.getInstance();
  // final dummyLoginFlag = prefs.getBool('dummyLoginFlag') ?? false;
  //
  // log("SharedPreferences dummyLoginFlag: $dummyLoginFlag");
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
            return Center(
                child: CircularProgressIndicator()); // Loading indicator
          }
          final user = snapshot.data;
          if (user == null) {
            return LoginScreen(); // No user signed in
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
                ); // Waiting for Firestore
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return LoginScreen(); // If user data doesn't exist, go to login
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;

              /// don't use .isEmpty or you will get Class 'double' has no instance getter 'isEmpty'.
              if (userData["address"] == null) {
                log("address is null & ${userSnapshot.data!.id}");
                return UserLocation(); // Redirect user to complete details
              } else {
                return LayOut(); // Navigate to home if all details exist
              }
            },
          );
        },
      ),
    );
  }
}
