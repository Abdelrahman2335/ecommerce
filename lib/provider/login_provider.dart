import 'package:ecommerce/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This class is responsible for login & signing
class LoginProvider extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;
  bool isLoading = false;

  /// To use [Selector] you have to create getter.

  get loading => isLoading;

  void signIn(GlobalKey<FormState> formKey, TextEditingController passCon,
      TextEditingController userCon) async {
    final valid = formKey.currentState!.validate();
    isLoading = true;
    notifyListeners();

    try {
      if (!valid) {
        isLoading = false;
        notifyListeners();

        return;
      } else {
        final UserCredential userCredential =
            await firebase.signInWithEmailAndPassword(
                email: userCon.text, password: passCon.text);
      }
    } on FirebaseAuthException catch (error) {
      /// Important to know that we are using Scaffold global Key from the main.dart
      /// This allow us to don't use context + make the work more easy and effectuation.
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
    formKey.currentState!.save();
  }
}
