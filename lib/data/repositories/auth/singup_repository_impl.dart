import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/signup_repository.dart';
import 'package:ecommerce/presentation/provider/auth/check_user_existence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/customer_model.dart';

class SignupRepositoryImpl implements SignupRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final _userExistence = CheckUserExistence();

  bool? userExist;

  @override
  signInWithGoogle() async {
    if(_firebaseService.google.currentUser != null) {
      await _firebaseService.google.disconnect();
    }
    GoogleSignInAccount? googleSignInAccount;

    try {
      googleSignInAccount = await _firebaseService.google.signIn();

      await _userExistence.checkUserExistence();
      userExist = _userExistence.isUserExist;

    } catch (error) {
      log("error: $error");
    }
    if (googleSignInAccount == null || userExist == null) {
      return;
    }
    else if(userExist == true){
     log("User already exist");
      return;
    }
    else {
      try {
        log("signInWithGoogle: GoogleSignInAccount is not null");

        if (!userExist!) {
          GoogleSignInAuthentication googleAuth =
              await googleSignInAccount.authentication;

          AuthCredential authCredential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          _firebaseService.auth.signInWithCredential(authCredential);
          await _firebaseService.firestore
              .collection("customers")
              .doc(_firebaseService.auth.currentUser?.uid)
              .set(CustomerModel(
                createdAt: DateTime.now(),
                role: "customer",
              ).toJson());
        } else {
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

          userExist = false;
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
