import 'dart:developer';

import 'package:flutter/material.dart';

import '../../domain/repositories/signup_repository.dart';

class SignupViewmodel extends ChangeNotifier {
  final SignupRepository _signupRepository;

  SignupViewmodel(this._signupRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  checkUserExistence() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository.checkUserExistence();
    } catch (error) {
      log("an error occur when checking user existence: $error");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository.signInWithGoogle();
    } catch (error) {
      log("an error occur when sign-in with google: $error");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository.createUser(formKey, passCon, userCon);
    } catch (error) {
      log("an error occur when creating user: $error");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }


}
