import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/core/snackbar_helper.dart';
import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'check_user_existence.dart';

/// This class is responsible for login & logout
class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository);

  final FirebaseService _firebaseService = FirebaseService();
  final _userExistence = CheckUserExistence();

  bool _isLoading = false;

  String? _user;
  String? _name;

  String? get user => _user;

  String? get name => _name;

  bool get loading => _isLoading;

  Future<void> signIn(
      GlobalKey<FormState> formKey, String passCon, String userCon) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loginRepository.signIn(formKey, passCon, userCon);

      /// we will check if the user have any info or not

      _userExistence.hasInfo
          ? navigatorKey.currentState?.pushReplacementNamed('/layout')
          : navigatorKey.currentState?.pushReplacementNamed('/user_location');

      _user = _firebaseService.auth.currentUser!.email;
      _name = _firebaseService.auth.currentUser!.displayName;
    } catch (error) {
      log("an error has occur in the login view model");

      SnackBarHelper.show(message: "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    try {
      log("Before calling loginWithGoogle  ${_userExistence.hasInfo} and ${ _userExistence.isUserExist}");

      _isLoading = true;
      notifyListeners();
      await _loginRepository.loginWithGoogle();
      log("After calling loginWithGoogle ${_userExistence.hasInfo} and ${ _userExistence.isUserExist}");
      if (_userExistence.isUserExist == null) {
        log(" hasInfo is null and userExist is null");
        return;
      } else if (_userExistence.hasInfo && _userExistence.isUserExist) {
        log("hasInfo is true and userExist is true");
        navigatorKey.currentState?.pushReplacementNamed('/layout');
      } else if (!_userExistence.hasInfo && _userExistence.isUserExist) {
        log("hasInfo is false and userExist is true");
        navigatorKey.currentState?.pushReplacementNamed('/user_setup');
      }else if(_userExistence.hasInfo && !_userExistence.hasLocation) {
        log("hasInfo is true and userExist is false");
        navigatorKey.currentState?.pushReplacementNamed('/user_location');
      }

      else {

        SnackBarHelper.show(message: "You Don't have an account.");
       if(_firebaseService.google.currentUser != null) {
         _firebaseService.auth.currentUser!.delete();
       }else if(_firebaseService.auth.currentUser != null) {
         _firebaseService.google.disconnect();
         log("Signed out in the else");
       }
      }
    } on FirebaseAuthException catch (error) {
      log("an error has occur in the login view model");
      SnackBarHelper.show(message: error.message ?? "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
    notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loginRepository.signOut();

      if (_userExistence.isUserExist == null || false) {
        navigatorKey.currentState?.pushReplacementNamed('/login');
      } else {
        SnackBarHelper.show(message: "Couldn't sign out please try again.");
      }
    } catch (error) {
      log("an error has occur in the login view model error: $error");
      SnackBarHelper.show(message: "Couldn't sign out please try again.");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
}
