import 'dart:developer';

import 'package:ecommerce/methods/setup_address.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../methods/setup_user_data.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  /// This key manage the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    Widget personalContent = setupUserData(
        context, firstController, secondController, user, formKey);
    Widget addressContent =
        setupAddress(context, firstController, secondController, user, formKey);
    int counter = signUpProvider.hasInfo ? 2 : 1;
    return PopScope(
      /// If hasInfo info is true and the user want to go back we will set it to false
      /// so we will update the ui to go back
      /// but he actually can't pop because canPop is false
      canPop: false,
      onPopInvokedWithResult: (bool result, value) {
        if (signUpProvider.hasInfo) signUpProvider.onPop();
        log(signUpProvider.hasInfo.toString());
      },
      child: Scaffold(
        body: Animate(
          effects: [
            FadeEffect(
              duration: Duration(milliseconds: 1000),
            )
          ],
          child: Center(
              child: Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(-2, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: signUpProvider.hasInfo
                  ? MediaQuery.of(context).size.height * 0.49
                  : MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(children: [
                  Text(
                    signUpProvider.hasInfo
                        ? "Address Information"
                        : "Personal Information",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Step $counter of 2",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  signUpProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : signUpProvider.hasInfo
                          ? addressContent
                          : personalContent,
                  Spacer(),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      /// Making onChange null this will make the slider read only
                      value: signUpProvider.sliderValue,
                      onChanged: null,
                      min: 0,
                      max: 1,
                    ),
                  ),
                ]),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
