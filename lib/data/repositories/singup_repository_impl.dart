import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/signup_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/customer_model.dart';

class SignupRepositoryImpl implements SignupRepository {
  final FirebaseService _firebaseService = FirebaseService();

  bool hasInfo = false;

  @override
  Future<bool> checkUserExistence() async {
    if (_firebaseService.auth.currentUser == null) return false;
    try {
      Map<String, dynamic>? doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(_firebaseService.auth.currentUser!.uid)
          .get()
          .then((value) => value.data());

      hasInfo = doc?["createdAt"] == null ? false : true;
      log("hasInfo: $hasInfo");
      return hasInfo;
    } catch (error) {
      log("Error in the signUpProvider constructor: $error");
      return false;
    }
  }

  @override
  signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount;

    try {
      googleSignInAccount = await _firebaseService.google.signIn();
    } catch (error) {
      log("error: $error");
    }
    if (googleSignInAccount == null) {
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
              .doc(_firebaseService.auth.currentUser?.uid)
              .set(CustomerModel(
                createdAt: DateTime.now(),
                role: "customer",
              ).toJson());
        }else{
          return;
        }
      } catch (error) {
        log("error in the signInWithGoogle: $error");
      }
    }
  }

  @override
  Future<void> createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    final valid = formKey.currentState!.validate();

    try {
      if (valid) {
        final UserCredential userCredential = await _firebaseService.auth
            .createUserWithEmailAndPassword(email: userCon, password: passCon);
       await _firebaseService.auth.currentUser!.updateDisplayName(userCon);
        CustomerModel newUser = CustomerModel(
          createdAt: DateTime.now(),
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await _firebaseService.firestore
              .collection("customers")
              .doc(uid)
              .set(newUser.toJson());

          hasInfo = false;
        }
      } else {
        log("createUser not working, We are going back");
        return;
      }
    } on FirebaseAuthException catch (error) {
      log("error in the createUser: $error");
    }
    formKey.currentState!.save();
  }
}