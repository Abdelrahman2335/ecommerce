import 'dart:developer';

import 'package:ecommerce/core/utils/snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/services/firebase_service.dart';
import '../../../domain/repositories/signup_repository.dart';
import '../../../main.dart';
import 'check_user_existence.dart';

class SignupViewmodel extends ChangeNotifier {
  final SignupRepository _signupRepository;

  SignupViewmodel(this._signupRepository);

  final _userExistence = CheckUserExistence();
  final _firebaseService = FirebaseService ();


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository.signInWithGoogle();
      if (_userExistence.isUserExist != null && _userExistence.isUserExist) {
        SnackBarHelper.show(message: "User already exist");
        if (_firebaseService.google.currentUser != null) {
          _firebaseService.auth.signOut();
        } else if (_firebaseService.auth.currentUser != null) {
          _firebaseService.google.disconnect();
        }
        return;
      }else{

      navigatorKey.currentState?.pushReplacementNamed(
          "/user_setup",
        );
      }
    } catch (error) {
      log("an error occur when sign-in with google: $error");
      SnackBarHelper.show(message: "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository
          .createUser(formKey, passCon, userCon)
          .onError((error, stackTrace) {
        /// Important to know that you have to rethrow the error to be able to use onError
        if (error is FirebaseAuthException) {
          log("Error code: ${error.code}");

          if (error.code == 'email-already-in-use') {
            SnackBarHelper.show(message: "Email already in use!");
            return;
          }
        } else {
          log("Stack trace: $stackTrace");
          log("Unknown error: $error");
        }
      });
      // navigatorKey.currentState?.pushReplacementNamed('/user_setup');
    } on FirebaseException catch (error) {
      log("an error occur when creating user: $error");
      SnackBarHelper.show(message: "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
}
