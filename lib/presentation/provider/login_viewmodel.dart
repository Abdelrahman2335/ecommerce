import 'dart:developer';

import 'package:ecommerce/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/login_repository_impl.dart';

/// This class is responsible for login & logout
class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository);

  final LoginRepositoryImpl _loginRepositoryImpl = LoginRepositoryImpl();
  bool _isLoading = false;

  User? _user;
  String? _name;


  User? get user => _user;

  String? get name => _name;

  bool get loading => _isLoading;

  Future<void> signIn(
      GlobalKey<FormState> formKey, String passCon, String userCon) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loginRepository.signIn(formKey, passCon, userCon);

      _user = _loginRepositoryImpl.user;
      _name = _loginRepositoryImpl.name;
    } catch (error) {
      log("an error has occur in the login view model");
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

      _user = _loginRepositoryImpl.user;
      _name = _loginRepositoryImpl.name;
    } catch (error) {
      log("an error has occur in the login view model");
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

      _user = _loginRepositoryImpl.user;
      _name = _loginRepositoryImpl.name;
    } catch (error) {
      log("an error has occur in the login view model");
      rethrow;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
}
