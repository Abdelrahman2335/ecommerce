import 'dart:developer';

import 'package:ecommerce/data/models/address_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/firebase_service.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../../main.dart';
import '../models/user_model.dart';

class UserDataRepositoryImpl implements UserDataRepository {

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> personalInfo(String name, String phone, User user) async {
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

      // hasInfo = true;
      // sliderValue = 0.50;
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    }
  }

  @override

  Future addressInfo(AddressModel address, User user) async {
    UserModel newUser = UserModel(
      address: address,
    );
    try {
      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update(newUser.addressToJson());

      // sliderValue = 0.75;
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    }
  }

  @override
  Future<void> optionalInfo(User? user, String? selectedGender, String age) async{

    try{
    await _firebaseService.firestore
        .collection("users")
        .doc(_firebaseService.auth.currentUser!.uid)
        .update({
      "age": age,
      "gender": selectedGender,
    } );}catch(error){
      log("Error in optionalInfo: $error");
      rethrow;
    }
  }



}