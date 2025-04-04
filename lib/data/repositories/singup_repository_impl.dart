import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/signup_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../main.dart';

class SignupRepositoryImpl implements SignupRepository {
  final FirebaseService _firebaseService = FirebaseService();
  bool hasInfo = false;

  double sliderValue = 0.0;
  bool isLoading = false;

  get loading => isLoading;

  @override
  Future<bool> checkUserExistence() async {
    if (_firebaseService.auth.currentUser == null) return false;
    try {
      Map<String, dynamic>? doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(_firebaseService.auth.currentUser!.uid)
          .get()
          .then((value) => value.data());

      hasInfo = doc?["phone"] == null ? false : true;
      log("hasInfo: $hasInfo");
      return hasInfo;
    } catch (error) {
      log("Error in the signUpProvider constructor: $error");
      return false;
    }
  }

  @override
  signInWithGoogle() async {
    isLoading = true;
    GoogleSignInAccount? googleSignInAccount;

    try {
      googleSignInAccount = await _firebaseService.google.signIn();
    } catch (error) {
      log("error: $error");
    }
    if (googleSignInAccount == null) {
      isLoading = false;
      return;
    } else {
      try {
        log("signInWithGoogle: GoogleSignInAccount is not null");
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        _firebaseService.auth.signInWithCredential(authCredential);

        if (!hasInfo) {
          await _firebaseService.firestore
              .collection("users")
              .doc(_firebaseService.auth.currentUser!.uid)
              .set(UserModel(
                createdAt: DateTime.now(),
                role: "user",
              ).toJson());
        }
      } catch (error) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("Authentication Error!"),
          ),
        );
      } finally {
        isLoading = false;
      }
    }
  }

  @override
  Future<void> createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    isLoading = true;
    final valid = formKey.currentState!.validate();

    try {
      if (valid) {
        final UserCredential userCredential = await _firebaseService.auth
            .createUserWithEmailAndPassword(email: userCon, password: passCon);

        UserModel newUser = UserModel(
          createdAt: DateTime.now(),
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await _firebaseService.firestore
              .collection("users")
              .doc(uid)
              .set(newUser.toJson());

          hasInfo = false;
        }
      } else {
        log("createUser not working, We are going back");
        return;
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
    }
    formKey.currentState!.save();
  }

}
