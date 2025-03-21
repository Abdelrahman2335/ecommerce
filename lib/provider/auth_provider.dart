import 'dart:developer';

import 'package:ecommerce/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This class is responsible for login & logout
class LoginProvider extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;
  GoogleSignIn google = GoogleSignIn();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;

  /// will be used to update the UI

  bool isGoogleAccount =
      FirebaseAuth.instance.currentUser?.providerData[0].providerId ==
          'google.com';

  /// Will check if the user sign in with google

  /// To use [Selector] you have to create getter.

  get loading => isLoading;

  void signIn(
      GlobalKey<FormState> formKey, String passCon, String userCon) async {
    final valid = formKey.currentState!.validate();
    isLoading = true;

    try {
      if (!valid) {
        isLoading = false;

        return;
      } else {
        await firebase
            .signInWithEmailAndPassword(email: userCon, password: passCon)
            .then((value) {
          return value.user != null
              ? navigatorKey.currentState?.pushReplacementNamed('/layout')
              : null;
        });
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
    }

    formKey.currentState!.save();
    notifyListeners();
  }

  Future signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    /// to update the UI you have to use [notifyListeners()] even if you are using in many times in the function.
    /// (this is may lead to unnecessary rebuild)

    /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      isLoading = false;
      notifyListeners();

      /// to update the UI you have to use [notifyListeners()] even if you are using in many times in the function.
      /// (this is may lead to unnecessary rebuild)

      return;
    } else {
      try {
        isLoading = true;
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        firebase.signInWithCredential(authCredential).then((value) {
        return  value.user != null
              ? navigatorKey.currentState?.pushReplacementNamed('/layout')
              : null;
        });
      } on FirebaseAuthException catch (error) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication Error!"),
          ),
        );
      } finally {
        isLoading = false;
      }
    }
    notifyListeners();
  }

  void signOut() async {
    isLoading = true;
    try {
      if (isGoogleAccount) {
        log("Google Account");

        /// Forces account chooser next time, This means that if the user sign out it will be forced to sign in again.
        await google.signOut();
        await firebase.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "log: Null");
      } else {
        await firebase.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "log: Null");
      }

      if (firebase.currentUser == null) {
        navigatorKey.currentState?.pushReplacementNamed('/login');
      } else {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text("Couldn't sign out please try again."),
        ));
      }
    } catch (error) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Couldn't sign out please try again. $error"),
        ),
      );
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
}
