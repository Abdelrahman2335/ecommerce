import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/constants/global_keys.dart';
import 'package:ecommerce/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../data/models/customer_model.dart';
import '../../provider/signup_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController rePassCon = TextEditingController();
  final GlobalKey<FormState> formKey = AppKeys.signupFormKey;
  FirebaseAuth firebase = FirebaseAuth.instance;

  @override
  void dispose() {
    emailCon.dispose();
    passCon.dispose();
    rePassCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpProvider = Provider.of<SignupViewmodel>(context);

    return Scaffold(
      body: Animate(
        effects: [
          FadeEffect(
            duration: Duration(milliseconds: 600),
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(40),
                  Text(
                    "Create an \naccount",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(34),
                  CustomField(
                    label: "Email address",
                    labelStyle: TextStyle(fontSize: 14),
                    icon: Icon(PhosphorIcons.user()),
                    controller: emailCon,
                    isSecure: false,
                    isValid: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Valid a Email";
                      }
                      return null;
                    },
                  ),
                  const Gap(16),
                  CustomField(
                    label: "Password",
                    labelStyle: TextStyle(fontSize: 14),
                    icon: Icon(PhosphorIcons.lock()),
                    controller: passCon,
                    isSecure: true,
                    isValid: (String? value) {
                      if (value == null || value.isEmpty || value.length <= 6) {
                        return "Wrong Password";
                      }
                      return null;
                    },
                  ),
                  const Gap(16),
                  CustomField(
                    label: "Confirm password",
                    labelStyle: TextStyle(fontSize: 14),
                    icon: Icon(PhosphorIcons.lock()),
                    controller: rePassCon,
                    isSecure: true,
                    isValid: (String? value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length <= 6) {
                        return "Wrong Password";
                      }
                      if (value != passCon.text) {
                        return "Password not matched";
                      }
                      return null;
                    },
                  ),
                  const Gap(40),
                  Selector<SignupViewmodel, bool>(
                      selector: (_, selectedValue) => selectedValue.isLoading,
                      builder: (context, isLoading, child) {
                        /// This isLoading not working properly
                        return !isLoading
                            ? CustomButton(

                          bottomWidth: 0.5,
                                pressed: () async {
                                  final valid =
                                      formKey.currentState?.validate();
                                  if (valid == null || valid == false) return;

                                  /// here we are using or operator because if (any of the condition is true) it will be true

                                  await signUpProvider.createUser(
                                    formKey,
                                    passCon.text,
                                    emailCon.text,
                                  );
                                  if (firebase.currentUser != null) {
                                    CustomerModel newUser = CustomerModel(
                                      createdAt: DateTime.now(),
                                    );
                                    String uid = firebase.currentUser!.uid;
                                    await FirebaseFirestore.instance
                                        .collection("customers")
                                        .doc(uid)
                                        .set(newUser.toJson());

                                    /// add user date of join to firestore

                                    navigatorKey.currentState
                                        ?.pushReplacementNamed(
                                      "/user_setup",
                                    );
                                  }
                                },
                                text: "Create Account",
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                              );
                      }),
                  const Gap(46),
                  const Center(
                    child: Text("- OR Continue with -"),
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.all(13),
                          backgroundColor: theme.primaryColor.withAlpha(37),
                          side: BorderSide(color: theme.primaryColor),
                        ),
                        onPressed: () async {
                        await  Provider.of<SignupViewmodel>(
                                  AppKeys.navigatorKey.currentContext!,

                                  /// instead of context
                                  listen: false)
                              .signInWithGoogle();

                          if (firebase.currentUser == null) return;
                          AppKeys.navigatorKey.currentState
                              ?.pushReplacementNamed('/user_setup');
                        },
                        child: const Image(
                          image: AssetImage(
                            "assets/google.png",
                          ),
                          filterQuality: FilterQuality.medium,
                          width: 35,
                          height: 37,
                        ),
                      ),
                      const Gap(14),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: theme.primaryColor.withAlpha(37),
                          padding: const EdgeInsets.all(13),
                          side: BorderSide(color: theme.primaryColor),
                        ),
                        onPressed: () {},
                        child: const Image(
                          image: AssetImage(
                            "assets/facebook.png",
                          ),
                          filterQuality: FilterQuality.medium,
                          width: 38,
                          height: 38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I Already Have an Account",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Login"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
