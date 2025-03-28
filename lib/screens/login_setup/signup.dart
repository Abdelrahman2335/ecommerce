import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:ecommerce/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/signup_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController rePassCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    final signUpProvider = Provider.of<SignUpProvider>(context);

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
                    label: "Enter email",
                    icon: const FaIcon(Icons.person),
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
                    icon: const FaIcon(Icons.lock),
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
                    label: "Confirm Password",
                    icon: const FaIcon(Icons.lock),
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
                  Selector<SignUpProvider, bool>(
                      selector: (_, selectedValue) => selectedValue.loading,
                      builder: (context, isLoading, child) {
                        /// This isLoading not working properly
                        return !isLoading
                            ? CustomButton(
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
                                    UserModel newUser = UserModel(
                                      createdAt: DateTime.now(),
                                    );
                                    String uid = firebase.currentUser!.uid;
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .set(newUser.toJson());

                                    /// add user date of join to firestore
                                    signUpProvider.hasInfo = false;

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
                        onPressed: () {

                          Provider.of<SignUpProvider>(
                              navigatorKey.currentContext!, /// instead of context
                              listen: false).signInWithGoogle();

                          if (firebase.currentUser == null) return;
                          navigatorKey.currentState
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
