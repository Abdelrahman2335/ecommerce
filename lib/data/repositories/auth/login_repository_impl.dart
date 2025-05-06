import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

        await FirebaseFirestore.instance
            .collection("customers")
            .doc(_firebaseService.auth.currentUser!.uid)
            .get();
      }
    } catch (error) {
      log("signIn error: $error");
    }

    formKey.currentState!.save();
  }

  @override
  Future<void> loginWithGoogle() async {
    log("we are in");
    if (_firebaseService.google.currentUser != null) {
      await _firebaseService.google.disconnect();
    }

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
        await _userExistence.checkUserExistence();
        if (_userExistence.isUserExist == false) return;

        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await _firebaseService.auth.signInWithCredential(authCredential);
      } on FirebaseAuthException catch (error) {
        log("loginWithGoogle: $error");
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
        _userExistence.isUserExist = null;

        if (_firebaseService.google.currentUser != null) {
          await _firebaseService.google.disconnect();
        }

        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with google Null");
      } else {
        await _firebaseService.auth.signOut();
        _userExistence.isUserExist = false;
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with Null");
      }

      if (_firebaseService.auth.currentUser == null) {}
    } catch (error) {
      log("signOut error: $error");
    }
  }
}
