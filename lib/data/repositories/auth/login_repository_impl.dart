import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:ecommerce/presentation/provider/auth/check_user_existence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final CheckUserExistence _userExistence = CheckUserExistence();

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
        await _userExistence.checkUserExistence();
        log("User data check: hasInfo = ${_userExistence.hasInfo}, isUserExist = ${_userExistence.isUserExist}");

      }
    } catch (error) {
      log("signIn error: $error");
    }

    formKey.currentState!.save();
  }

  @override
  Future<void> loginWithGoogle() async {
    log("Starting Google login process");

    // Sign out of Google if already signed in
    if (_firebaseService.google.currentUser != null) {
      await _firebaseService.google.signOut();
    }

    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await _firebaseService.google.signIn();
    } catch (error) {
      log("Error during Google sign in: $error");
      return;
    }

    if (googleSignInAccount == null) {
      log("Google sign-in canceled by user");
      return;
    }

    try {
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;



        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await _firebaseService.auth.signInWithCredential(authCredential);
      await _userExistence.checkUserExistence();
      log("User data check: hasInfo = ${_userExistence.hasInfo}, isUserExist = ${_userExistence.isUserExist}");
        log("Successfully signed in with Firebase");

    } catch (error) {
      log("Error during login process: $error");
      if (_firebaseService.auth.currentUser != null) {
        await _firebaseService.auth.signOut();
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

        if (_firebaseService.google.currentUser != null) {
          await _firebaseService.google.disconnect();
        }

        /// You have to use auth when logout from any account
        await _firebaseService.auth.signOut();

        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with google Null");
      } else {
        await _firebaseService.auth.signOut();
        _userExistence.isUserExist = false;
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with Null");
      }

      if (_firebaseService.auth.currentUser == null) {
        _userExistence.isUserExist = null;
      }
      log("After logout ${_firebaseService.auth.currentUser?.uid ?? "null"}");
    } catch (error) {
      log("signOut error: $error");
    }
  }
}
