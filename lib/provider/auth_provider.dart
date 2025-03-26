import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/models/user_model.dart';
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
    } catch (error) {
      /// Important to know that we are using Scaffold global Key from the main.dart
      /// This allow us to don't use context + make the work more easy and effectuation.
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      isLoading = false;
    }

    formKey.currentState!.save();
    notifyListeners();
  }

  Future loginWithGoogle() async {
    isLoading = true;
    notifyListeners();

    /// to update the UI you have to use [notifyListeners()] even if you are using in many times in the function.
    /// (this is may lead to unnecessary rebuild)

    GoogleSignInAccount? googleSignInAccount;
    try {
      /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
      googleSignInAccount = await googleSignIn.signIn();
    } catch (error) {
      log("loginWithGoogle: $error");
    }
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

        final userCredential =
            await firebase.signInWithCredential(authCredential);

        if (userCredential.user != null) {
          var data = await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();
          if (data.exists) {
            navigatorKey.currentState?.pushReplacementNamed('/layout');
          }
         await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set(UserModel(createdAt: DateTime.now()).toJson());
          navigatorKey.currentState?.pushReplacementNamed('/user_setup');
        } else {
          log("loginWithGoogle: ${userCredential.user}");
        }
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
    notifyListeners();
  }

  void signOut() async {
    isLoading = true;
    try {
      if (isGoogleAccount) {
        log("Google Account");

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
