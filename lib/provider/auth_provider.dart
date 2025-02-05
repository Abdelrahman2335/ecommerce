import 'package:ecommerce/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This class is responsible for login & signing
class LoginProvider extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;
  GoogleSignIn google = GoogleSignIn();
  final GoogleSignIn googleSignIn = GoogleSignIn();

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

  Future signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      isLoading = false;
      notifyListeners();
      return;
    } else {
      try {
        isLoading = true;
        notifyListeners();
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        firebase.signInWithCredential(authCredential);
      } on FirebaseAuthException catch (error) {
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
    }
  }


  void  signOut() async {
    try {
      await firebase.signOut();
      await google.signOut();

    } catch (error) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Couldn't sign out please try again. $error"),
        ),
      );
    }
  }
}
