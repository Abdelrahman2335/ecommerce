import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/address_model.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class SignUpProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final firebase = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;
  bool hasInfo = false;

  /// used when creating account

  /// you can't assign non static value to variable in initializer like [firebaseStore] or [firebase]
  double sliderValue = 0.0;

  bool isLoading = false;

  get loading => isLoading;

  /// used when login and creating account to check if we have any info about the user or not
  Future<bool> checkUserExistence() async {
    if (firebase.currentUser == null) return false;

    /// Don't forget that this is the constructor so this function will always run when the provider is created,
    /// so we have to check if the user is null or not to prevent any errors
    try {
      Map<String, dynamic>? doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebase.currentUser!.uid)
          .get()
          .then((value) => value.data());

      hasInfo = doc?["phone"].isNotEmpty ?? false;
      log("hasInfo: $hasInfo");
      return hasInfo;
    } catch (error) {
      log("Error in the signUpProvider constructor: $error");
      return false;
    }
  }

  SignUpProvider() {
    checkUserExistence();
  }

   signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return;
    } else {
      try {
        log("signInWithGoogle: GoogleSignInAccount is not null");
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        firebase.signInWithCredential(authCredential);

        /// if the user doesn't have any info we have to create it
        if (!hasInfo) {
          await firebaseStore
              .collection("users")
              .doc(firebase.currentUser!.uid)
              .set(UserModel(
                createdAt: DateTime.now(),
                role: "user",
                name: googleSignInAccount.displayName,
              ).toJson());
        }
      } catch (error) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("Authentication Error!"),
          ),
        );
      } finally {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  personalInfo(String name, String phone, User user) async {
    isLoading = true;
    notifyListeners();
    UserModel newUser = UserModel(
      name: name,
      phone: phone,
      role: "user",
    );
    try {
      await firebaseStore
          .collection("users")
          .doc(user.uid)
          .update(newUser.toJson());

      /// update method does not return anything indicate success or fail,
      /// so we have to use try catch, if you want to do something after is ends successfully just write it here
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
      isLoading = false;
    }
    notifyListeners();
  }

  Future addressInfo(AddressModel address, User user) async {
    isLoading = true;
    notifyListeners();
    UserModel newUser = UserModel(
      city: address.city,
      area: address.area,
      street: address.street,
    );
    try {
      await firebaseStore
          .collection("users")
          .doc(user.uid)
          .update(newUser.toJson());

      sliderValue = 0.75;
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future createUser(
    GlobalKey<FormState> formKey,
    String passCon,
    String userCon,
  ) async {
    isLoading = true;
    notifyListeners();
    final valid = formKey.currentState!.validate();

    try {
      if (valid) {
        final UserCredential userCredential = await firebase
            .createUserWithEmailAndPassword(email: userCon, password: passCon);

        UserModel newUser = UserModel(
          createdAt: DateTime.now(),
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firebaseStore
              .collection("users")
              .doc(uid)
              .set(newUser.toJson());

          /// add user date of join to firestore
          hasInfo = false;
        }
      } else {
        log("createUser not working, We are going back");
        return;
      }
    } on FirebaseAuthException catch (error) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication Error!"),
        ),
      );
    } finally {
      isLoading = false;
    }
    formKey.currentState!.save();
    notifyListeners();
  }
}
