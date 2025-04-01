import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  HomeViewModel() {
    _fetchData();
  }

  bool _isLoading = true;
  bool _removeAdd = false;
  User? _user;
  String? _name;

  bool get isLoading => _isLoading;

  bool get removeAdd => _removeAdd;

  User? get user => _user;

  String? get name => _name;

  void _fetchData() async {
    try {
      _user = _firebaseService.auth.currentUser;

      if (_user == null) return;
      final firestore = await _firebaseService.firestore
          .collection("users")
          .doc(_user?.uid)
          .get();

      _name = firestore.data()?["name"];

      _isLoading = firestore.data() == null;
    } catch (error) {
      log("Error when fetching data: $error");
      rethrow;
    }

    notifyListeners();
  }

  void toggleRemoveAdd() {
    _removeAdd = true;
    notifyListeners();
  }

}
