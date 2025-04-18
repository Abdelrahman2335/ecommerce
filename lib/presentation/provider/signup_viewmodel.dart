import 'dart:developer';

import 'package:ecommerce/core/snackbar_helper.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/signup_repository.dart';

class SignupViewmodel extends ChangeNotifier {
  final SignupRepository _signupRepository;

  SignupViewmodel(this._signupRepository);

  bool _isLoading = false;

  bool userExist = false;

  bool get isLoading => _isLoading;



  checkUserExistence() async {
    try {
      _isLoading = true;
      notifyListeners();
     userExist = await _signupRepository.checkUserExistence();
    } catch (error) {
      log("an error occur when checking user existence: $error");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _signupRepository.signInWithGoogle();

      if(!userExist) SnackBarHelper.show(message: "User already exist!");

    } catch (error) {
      log("an error occur when sign-in with google: $error");
      SnackBarHelper.show(message: "Authentication Error!");
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
      SnackBarHelper.show(message: "Authentication Error!");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }


}
