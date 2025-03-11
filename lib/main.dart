import 'dart:developer';

import 'package:ecommerce/layout.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/screens/login_setup/forgot_password.dart';
import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:ecommerce/screens/login_setup/signup.dart';
import 'package:ecommerce/screens/login_setup/profile_screen.dart';
import 'package:ecommerce/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce/firebase_options.dart';
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
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(
        create: (_) => ItemProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LoginProvider(),
      ),
      ChangeNotifierProvider(create: (_) => WishListProvider()),
      ChangeNotifierProvider(create: (_)=> CartProvider()),
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
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeDataConfig.themeData,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return const LayOut();
            } else {
              return const LoginScreen();
            }
          })),
    );
  }
}
