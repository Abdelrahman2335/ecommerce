import 'dart:developer';

import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This class is responsible for login & logout
class AuthProvider extends ChangeNotifier {
  final LoginRepository _loginRepository;

  AuthProvider(this._loginRepository);

  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  String? _errMessage;
  String? _user;
  String? _name;
  String? _email;
  String? _password;
  bool _isNewUser = false;

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  String? get user => _user;
  String? get name => _name;
  String? get errMessage => _errMessage;
  bool get loading => _isLoading;
  bool get isNewUser => _isNewUser;

  // Helper to check if there's an error
  bool get hasError => _errMessage != null && _errMessage!.isNotEmpty;

  // Helper to check if user is logged in
  bool get isLoggedIn => _user != null;

  /// Login user with email and password
  Future<void> loginUser() async {
    _isLoading = true;
    _errMessage = null;
    _isNewUser = false;
    notifyListeners();

    final result = await _loginRepository.loginWithEmail(_password!, _email!);

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
    }, (success) {
      // For email login, we can't determine if it's a new user from void result
      // Set user data
      _user = _firebaseService.auth.currentUser?.email;
      _name = _firebaseService.auth.currentUser?.displayName;

      log("User logged in successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errMessage = null;
    _isNewUser = false;
    notifyListeners();

    final result = await _loginRepository.loginWithGoogle();

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
    }, (userCredential) {
      // Check if user is new
      _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // Set user data
      _user = _firebaseService.auth.currentUser?.email;
      _name = _firebaseService.auth.currentUser?.displayName;

      log("Google login completed. isNewUser: $_isNewUser");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Sign out user
  Future<void> signOut() async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _loginRepository.signOut();

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
    }, (success) {
      // Clear user data on successful sign out
      _user = null;
      _name = null;
      _isNewUser = false;

      log("User signed out successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent to: $email");
    } on FirebaseAuthException catch (error) {
      _errMessage =
          FirebaseFailure.fromFirebaseAuthException(error).errorMessage;
      log("Password reset error: ${error.code}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error messages
  void clearError() {
    _errMessage = null;
    notifyListeners();
  }

  /// Clear new user status after handling
  void clearNewUserStatus() {
    _isNewUser = false;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _isLoading = false;
    _errMessage = null;
    _user = null;
    _name = null;
    _email = null;
    _password = null;
    _isNewUser = false;
    notifyListeners();
  }
}
