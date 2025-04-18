import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/core/snackbar_helper.dart';
import 'package:ecommerce/data/repositories/login_repository_impl.dart';
import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

/// This class is responsible for login & logout
class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository);

  final LoginRepositoryImpl _impl = LoginRepositoryImpl();
  final FirebaseService _firebaseService = FirebaseService();
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
      _impl.userDataCheck.data()?["address"] == null
          ? navigatorKey.currentState?.pushReplacementNamed('/user_setup')
          : navigatorKey.currentState?.pushReplacementNamed('/layout');

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
      _isLoading = true;
      notifyListeners();
      await _loginRepository.loginWithGoogle();

      if (_impl.hasInfo && _impl.userExist) {
        navigatorKey.currentState?.pushReplacementNamed('/layout');
      } else if (!_impl.hasInfo && _impl.userExist) {
        navigatorKey.currentState?.pushReplacementNamed('/user_setup');

      } else {
        SnackBarHelper.show(message: "You Don't have an account.");
      }
    } on FirebaseAuthException catch (error) {
      log("an error has occur in the login view model");
      SnackBarHelper.show(message: error.message ?? "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loginRepository.signOut();

      if(!_impl.userExist){
        navigatorKey.currentState?.pushReplacementNamed('/login');
      }else{
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
