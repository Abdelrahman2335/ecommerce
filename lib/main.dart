import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

final ColorScheme _colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xfff83758),
  surface: Colors.white,
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
        // scaffoldBackgroundColor: _colorScheme.surface,
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
      home: const LoginScreen(),
    );
  }
}
