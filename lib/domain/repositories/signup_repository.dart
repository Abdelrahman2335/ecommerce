import 'package:flutter/material.dart';

abstract class SignupRepository {

  Future<void> signInWithGoogle();

  Future<void> createUser(
      GlobalKey<FormState> formKey,
      String passCon,
      String userCon,);
}
