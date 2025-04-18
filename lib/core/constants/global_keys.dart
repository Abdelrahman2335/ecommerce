import 'package:flutter/material.dart';

class AppKeys{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> userDataFormKey = GlobalKey<FormState>();
}