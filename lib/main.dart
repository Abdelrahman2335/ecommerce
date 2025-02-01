import 'dart:developer';

import 'package:ecommerce/layout.dart';
import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'e-commerce-2699c',
  );
  await Firebase.initializeApp();
  runApp(const MyApp());}catch(error){
    log("Error in the main function: $error");
  }
}

final ColorScheme _colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xfff83758),
  surface: const Color(0xFFF9F9F9),
  brightness: Brightness.light,
  primary: const Color(0xfff83758),
  secondary: const Color(0xFF4392F9),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: _colorScheme.surface,
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          titleSmall: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
          ),
          titleLarge:
              GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 34),
          labelSmall: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            color: const Color(-11053225),
          ),
          labelMedium: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4392F9),
              fontSize: 18),
          labelLarge: GoogleFonts.roboto(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
          bodySmall: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: CartScreen(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
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
