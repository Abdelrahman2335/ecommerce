import 'package:flutter/material.dart';

/// creating abstract class is the best practice, and this force the implementation of all the methods.
/// for more please check this: https://chatgpt.com/c/67ebdcec-4df0-800f-8f37-2b951ae61f78
abstract class LoginRepository {
  Future<void> signIn(
      GlobalKey<FormState> formKey, String passCon, String userCon);

  Future<void> loginWithGoogle();

  Future<void> signOut();
}
