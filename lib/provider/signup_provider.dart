import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class SignUpProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final firebase = FirebaseAuth.instance;

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

  void createUser(GlobalKey<FormState> formKey, TextEditingController passCon,
      TextEditingController userCon, rePassCon) async {
    final valid = formKey.currentState!.validate();

    try {
      if (valid) {
        final UserCredential userCredential =
            await firebase.createUserWithEmailAndPassword(
                email: userCon.text, password: rePassCon.text);
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
