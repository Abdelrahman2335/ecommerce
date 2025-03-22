import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class SignUpProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final firebase = FirebaseAuth.instance;

  double sliderValue = 0.0;

  /// used when creating account
  int counter = 1;

  /// used when creating account

  bool isLoading = false;

  get loading => isLoading;

  void signInWithGoogle() async {
    /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return;
    } else {
      try {
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        firebase.signInWithCredential(authCredential);
      } catch (error) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("Authentication Error!"),
          ),
        );
      }
    }
  }

  personalInfo(String name, String phone) async {
    isLoading = true;
    notifyListeners();
    UserModel newUser = UserModel(
      name: name,
      phone: phone,
      role: "user",
      createdAt: DateTime.now(),
    );
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc()
          .set(newUser.toJson());
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    final valid = formKey.currentState!.validate();

    try {
      if (valid) {
        final UserCredential userCredential = await firebase
            .createUserWithEmailAndPassword(email: userCon, password: passCon);
      } else {
        log("We are going back");
        return;
      }
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    }
    formKey.currentState!.save();
  }
}
