// import 'dart:developer';

// import '../../../../core/services/firebase_service.dart';

// class UserValidationService {
//   final FirebaseService _firebaseService = FirebaseService();

//   static bool? _isUserExist;
//   static bool _hasInfo = false;
//   static bool _hasLocation = false;

//   get isUserExist => _isUserExist;

//   get hasInfo => _hasInfo;

//   get hasLocation => _hasLocation;

//   set isUserExist(value) => _isUserExist = value;

//   Future<String?> checkUserExistence() async {
//     try {
//       log("in checkUserExistence");
//       log("uid: ${_firebaseService.auth.currentUser?.uid}");
//       log("google id: ${_firebaseService.google.currentUser?.id}");

//       _firebaseService.auth.currentUser?.email == null;
//       Map<String, dynamic>? doc = await _firebaseService.firestore
//           .collection("customers")
//           .doc(_firebaseService.auth.currentUser?.uid)
//           .get()
//           .then((value) => value.data());

//       _isUserExist = doc?["createdAt"] == null ? false : true;
//       _hasInfo = doc?["name"] == null ? false : true;
//       _hasLocation = doc?["address"] == null ? false : true;
//       log("isUserExist: $_isUserExist");
//       return _isUserExist! ? "User exist" : "User doesn't exist";
//     } catch (error) {
//       log("Error in the checkUserExistence constructor: $error");
//       return "An error has occur";
//     }
//   }
// }
