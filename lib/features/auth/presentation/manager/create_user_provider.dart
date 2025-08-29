import 'dart:developer';

import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/create_user_repo/create_user_repo.dart';
import 'package:flutter/material.dart';

/// This class is responsible for user registration/signup
class CreateUserProvider extends ChangeNotifier {
  final SignupRepository _signupRepository;

  CreateUserProvider(this._signupRepository);

  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  String? _errMessage;
  String? _user;
  String? _name;

  String? _email;
  String? _password;
  bool _isNewUser = false;

  // Getters
  String? get user => _user;
  String? get name => _name;
  String? get errMessage => _errMessage;
  bool get loading => _isLoading;
  bool get isNewUser => _isNewUser;

  // Setters

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  // Helper to check if there's an error
  bool get hasError => _errMessage != null && _errMessage!.isNotEmpty;

  // Helper to check if user is logged in
  bool get isLoggedIn => _user != null;

  /// Create user with email and password
  Future<void> createUser() async {
    _isLoading = true;
    _errMessage = null;
    _isNewUser = false;
    notifyListeners();

    final result = await _signupRepository.createUser(_password!, _email!);

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
    }, (userCredential) {
      // Check if user is new
      _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

      // Set user data
      _user = _firebaseService.auth.currentUser?.email;
      _name = _firebaseService.auth.currentUser?.displayName;

      log("User created successfully. isNewUser: $_isNewUser");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Create user account with Google
  Future<void> signUpWithGoogle() async {
    _isLoading = true;
    _errMessage = null;
    _isNewUser = false;
    notifyListeners();

    final result = await _signupRepository.createAccountWithGoogle();

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
    }, (userCredential) {
      // Check if user is new
      _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // Set user data
      _user = _firebaseService.auth.currentUser?.email;
      _name = _firebaseService.auth.currentUser?.displayName;

      log("Google signup completed. isNewUser: $_isNewUser");
    });

    _isLoading = false;
    notifyListeners();
  }
}
