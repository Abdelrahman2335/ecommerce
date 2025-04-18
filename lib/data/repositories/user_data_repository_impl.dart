import 'dart:developer';

import 'package:ecommerce/data/models/address_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/firebase_service.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../models/customer_model.dart';

class UserDataRepositoryImpl implements UserDataRepository {

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> personalInfo(String name, String phone, String? selectedGender, String age) async {
    UserModel newUser = UserModel(
  Future<void> personalInfo(String name, String phone, User user) async {
    CustomerModel newUser = CustomerModel(
      name: name,
      phone: phone,
      role: "user",

        age: age,
        gender: selectedGender,
    );
    try {
      await _firebaseService.firestore
          .collection("users")
          .doc(user?.uid)
          .update(newUser.toJson());

      // hasInfo = true;
      // sliderValue = 0.50;
    } on FirebaseAuthException catch (error) {
      log("Error in personalInfo: $error");
    }
  }

  @override

  Future addressInfo(AddressModel address, User user) async {
    // TODO: We don't have the address yet
    try {

      // sliderValue = 0.75;
    } on FirebaseAuthException catch (error) {
      log("Error in addressInfo: $error");
    }
  }

}



}