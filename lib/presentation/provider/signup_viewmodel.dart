import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/firebase_service.dart';
import '../../data/models/address_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/signup_repository.dart';
import '../../main.dart';

class SignupViewmodel extends ChangeNotifier {
  final SignupRepository _signupRepository;

  SignupViewmodel(this._signupRepository);
  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
 bool hasInfo = true;
  double sliderValue = 0.0;

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

  // TODO you have to create another file for these functions.
  personalInfo(String name, String phone, User user) async {
    _isLoading = true;
    UserModel newUser = UserModel(
      name: name,
      phone: phone,
      role: "user",
    );
    try {
      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update(newUser.toJson());

      hasInfo = true;
      sliderValue = 0.50;
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    } finally {
      _isLoading = false;
    }
  }

  Future addressInfo(AddressModel address, User user) async {
    _isLoading = true;
    UserModel newUser = UserModel(
      address: address,
    );
    try {
      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update(newUser.addressToJson());

      sliderValue = 0.75;
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    } finally {
      _isLoading = false;
    }
  }

}
