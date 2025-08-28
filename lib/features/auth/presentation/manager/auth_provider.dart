import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/repository/auth_repo.dart';
import 'package:flutter/material.dart';

/// This class is responsible for login & logout
class AuthProvider extends ChangeNotifier {
  final LoginRepository _loginRepository;

  AuthProvider(this._loginRepository);

  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  bool? _hasError;
  String? _user;
  String? _name;
  String? _email;
  String? _password;

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  String? get user => _user;

  String? get name => _name;

  bool? get errMessage => _hasError;

  bool get loading => _isLoading;

  void loginUser() async {
    _isLoading = true;
    notifyListeners();

    final result = await _loginRepository.loginWithEmail(_password!, _email!);

    result.fold((error) {
      _hasError = true;
      return FirebaseFailure(error.errorMessage);
    }, (_) {});
    _user = _firebaseService.auth.currentUser?.email;
    _name = _firebaseService.auth.currentUser?.displayName;

    _isLoading = false;

    notifyListeners();
  }

  void loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    final result = await _loginRepository.loginWithGoogle();

    result.fold((error) {
      _hasError = true;
      return FirebaseFailure(error.errorMessage);
    }, (_) {});
    _user = _firebaseService.auth.currentUser?.email;
    _name = _firebaseService.auth.currentUser?.displayName;

    _isLoading = false;

    notifyListeners();
  }

  void signOut() async {
    _isLoading = true;
    notifyListeners();
    final result = await _loginRepository.signOut();

    result.fold((error) {
      _hasError = true;
      return FirebaseFailure(error.errorMessage);
    }, (_) {
      // Clear user data on successful sign out
      _user = null;
      _name = null;
      _hasError = false;
    });

    _isLoading = false;
    notifyListeners();
  }
}
