import 'dart:developer';


import '../../../core/services/firebase_service.dart';

class CheckUserExistence {
  final FirebaseService _firebaseService = FirebaseService();

  static  bool? _isUserExist;
  static bool _hasInfo = false;
  static bool _hasLocation = false;

  get isUserExist => _isUserExist;
  get hasInfo => _hasInfo;
  get hasLocation => _hasLocation;

  set isUserExist(value) => _isUserExist = value;
  Future<String?> checkUserExistence() async {
    if (_firebaseService.auth.currentUser == null || _firebaseService.google.currentUser == null) return null;
    try {
      Map<String, dynamic>? doc = await _firebaseService.firestore
          .collection("customers")
          .doc(_firebaseService.auth.currentUser!.uid)
          .get()
          .then((value) => value.data());

      _isUserExist = doc?["createdAt"] == null ? false : true;
      log("hasInfo: $_isUserExist");
      return _isUserExist! ? "User exist" : "User doesn't exist";
    } catch (error) {
      log("Error in the signUpProvider constructor: $error");
      return "An error has occur";
    }
  }

  Future<void> userInfo() async {
    if (_firebaseService.auth.currentUser == null) return;
   final doc = await _firebaseService.firestore
        .collection("customers")
        .doc(_firebaseService.auth.currentUser!.uid)
        .get();

    if (doc.exists) {
      _hasInfo = true;

      if(doc.data()!["address"] != null) {
        _hasLocation = true;
      }
    }

  }
}
