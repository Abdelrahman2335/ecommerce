import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';
import '../models/user_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseService _firebaseService = FirebaseService();

  static User? _user;
  static String? _name;

  User? get user => _user;

  String? get name => _name;

  @override
  Future<void> signIn(
      GlobalKey<FormState> formKey, String passCon, String userCon) async {
    final valid = formKey.currentState!.validate();
    try {
      if (!valid) {
        return;
      } else {
        await _firebaseService.auth
            .signInWithEmailAndPassword(email: userCon, password: passCon);

        final userDataCheck = await FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseService.auth.currentUser!.uid)
            .get();

        /// we will check if the user have any info or not
        userDataCheck.data()?["city"] == null
            ? navigatorKey.currentState?.pushReplacementNamed('/user_setup')
            : navigatorKey.currentState?.pushReplacementNamed('/layout');
      }
    } catch (error) {
      log(error.toString());

      /// Important to know that we are using Scaffold global Key from the main.dart
      /// This allow us to don't use context + make the work more easy and effectuation.
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Authentication Error!"),
        ),
      );
    }

    formKey.currentState!.save();
  }

  @override
  Future<void> loginWithGoogle() async {
    log("we are in");

    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await _firebaseService.google.signIn();
    } catch (error) {
      log("loginWithGoogle: $error");
    }
    if (googleSignInAccount == null) {
      return;
    } else {
      try {
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        final userCredential =
            await _firebaseService.auth.signInWithCredential(authCredential);
        if (userCredential.user != null) {
          final data = await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

          /// if the userId is not in the doc create it
          if (!data.exists) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userCredential.user!.uid)
                .set(UserModel(createdAt: DateTime.now()).toJson());
            navigatorKey.currentState?.pushReplacementNamed('/user_setup');
          } else if (data.data()?["phone"] == null ||
              data.data()?["longitude"] == null) {
            navigatorKey.currentState?.pushReplacementNamed('/user_setup');
          } else {
            navigatorKey.currentState?.pushReplacementNamed('/layout');
          }
        }
      } on FirebaseAuthException catch (error) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication Error!"),
          ),
        );
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      bool isGoogleAccount =
          _firebaseService.auth.currentUser?.providerData[0].providerId ==
              'google.com';

      if (isGoogleAccount) {
        log("Google Account");
        await _firebaseService.google.signOut();
        await _firebaseService.auth.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with google Null");
      } else {
        await _firebaseService.auth.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with Null");
      }

      if (_firebaseService.auth.currentUser == null) {
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
    }
  }

  userData() async {
    try {
      _user = _firebaseService.auth.currentUser;

      if (_user == null) return;
      final firestore = await _firebaseService.firestore
          .collection("users")
          .doc(_user?.uid)
          .get();

      _name = firestore.data()?["name"];
    } catch (error) {
      log("Error when fetching data: $error");
      rethrow;
    }
  }
}
