import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/layout.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/provider/location_provider.dart';
import 'package:ecommerce/provider/payment_provider.dart';
import 'package:ecommerce/screens/login_setup/forgot_password.dart';
import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:ecommerce/screens/login_setup/profile_screen.dart';
import 'package:ecommerce/screens/login_setup/signup.dart';
import 'package:ecommerce/screens/login_setup/user_details_screen.dart';
import 'package:ecommerce/screens/payment/payment_configuration.dart';
import 'package:ecommerce/screens/place_order/cart_screen.dart';
import 'package:ecommerce/screens/place_order/check_out.dart';
import 'package:ecommerce/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'provider/e_provider.dart';
import 'provider/signup_provider.dart';
import 'provider/wishList_provider.dart';

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
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(
        create: (_) => ItemProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LoginProvider(),
      ),
      ChangeNotifierProvider(create: (_) => WishListProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ChangeNotifierProvider(
        create: (_) => PaymentConfiguration(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),


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
        '/user_setup': (context) => const UserDetailsScreen(),
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
                .collection("users")
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

              /// don't user .isEmpty or you will get Class 'double' has no instance getter 'isEmpty'.
              if (userData["city"] == null) {
                return UserDetailsScreen(); // Redirect user to complete details
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
