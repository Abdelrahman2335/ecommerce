import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginRepositoryImpl implements LoginRepository {
  final FirebaseService _firebaseService = FirebaseService();

  static DocumentSnapshot<Map<String, dynamic>>? _userDataCheck;
  static bool _userExist = false;
  static bool _hasInfo = false;

  get userDataCheck => _userDataCheck;

  get userExist => _userExist;

  get hasInfo => _hasInfo;

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

        _userDataCheck = await FirebaseFirestore.instance
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
          final data = await _firebaseService.firestore
              .collection("customers")
              .doc(userCredential.user!.uid)
              .get();

          /// if the userId is not in the doc create it
          if (!data.exists) {
            _userExist = false;
            _hasInfo = false;
            return;
          } else if (data.data()?["phone"] == null ||
              data.data()?["longitude"] == null) {
            _userExist = true;
            _hasInfo = false;
          } else {
            _hasInfo = true;
            _userExist = true;
          }
        }
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
        await _firebaseService.auth.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with google Null");
      } else {
        await _firebaseService.auth.signOut();
        log(FirebaseAuth.instance.currentUser?.providerData[0].providerId ??
            "Logged out successfully with Null");
      }

      if (_firebaseService.auth.currentUser == null) {
        _userExist = false;
      }
    } catch (error) {
      log("signOut error: $error");
    }
  }
}
