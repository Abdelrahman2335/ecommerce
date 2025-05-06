import 'dart:developer';

import 'package:ecommerce/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/firebase_service.dart';
import '../../../domain/repositories/user_data_repository.dart';
import '../../models/customer_model.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> personalInfo(
      String name, String phone, String? selectedGender, String age) async {
    CustomerModel newUser = CustomerModel(
      name: name,
      phone: phone,
      role: "customer",
      age: age,
      gender: selectedGender,
    );
    try {
      await _firebaseService.firestore
          .collection("customers")
          .doc(_firebaseService.auth.currentUser!.uid)
          .update(newUser.toJson());
    } catch (error) {
      log("error in the personalInfo: $error");
    }
  }

  @override
  Future addressInfo(AddressModel address) async {
    // TODO: We don't have the address yet
    try {

    } on FirebaseAuthException catch (error) {
      log("Error in addressInfo: $error");
    }
  }
}
