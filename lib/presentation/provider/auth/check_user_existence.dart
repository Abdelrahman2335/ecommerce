import 'dart:developer';
import '../../../core/services/firebase_service.dart';

class CheckUserExistence {
  final FirebaseService _firebaseService = FirebaseService();

  static bool? _isUserExist;
  static bool _hasInfo = false;
  static bool _hasLocation = false;

  get isUserExist => _isUserExist;

  get hasInfo => _hasInfo;

  get hasLocation => _hasLocation;

  set isUserExist(value) => _isUserExist = value;

  Future<String?> checkUserExistence() async {
    if (_firebaseService.auth.currentUser != null ||
        _firebaseService.google.currentUser != null) {
      try {
        log("in checkUserExistence");
        log("uid: ${_firebaseService.auth.currentUser?.uid}");
        log("google id: ${_firebaseService.google.currentUser?.id}");
        Map<String, dynamic>? doc = await _firebaseService.firestore
            .collection("customers")
            .doc(_firebaseService.auth.currentUser!.uid)
            .get()
            .then((value) => value.data());
        await userInfo();

        _isUserExist = doc?["createdAt"] == null ? false : true;
        log("isUserExist: $_isUserExist");
        return _isUserExist! ? "User exist" : "User doesn't exist";
      } catch (error) {
        log("Error in the checkUserExistence constructor: $error");
        return "An error has occur";
      }
    } else {
      return null;
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

      if (doc.data()!["address"] != null) {
        _hasLocation = true;
      }
    }
  }
}
