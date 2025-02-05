import 'dart:developer';

import 'package:ecommerce/screens/login_setup/login_screen.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:ecommerce/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseAuth.instance;
    TextEditingController userCon = TextEditingController();
    TextEditingController passCon = TextEditingController();
    TextEditingController rePassCon = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(27),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Create an \naccount",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 34,
                ),
                CustomField(
                  label: "Username or Email",
                  icon: const FaIcon(Icons.person),
                  controller: userCon,
                  isSecure: false,
                  isValid: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter Valid a Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  pressed: () {
                    /// Will add the provider her + loading indicator.
                  },
                  text: "Create Account",
                ),
                const SizedBox(
                  height: 46,
                ),
                const Center(
                  child: Text("- OR Continue with -"),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(13),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        /// Will add the provider her + loading indicator.
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
                    const SizedBox(
                      width: 14,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        padding: const EdgeInsets.all(13),
                        side: BorderSide(color: Theme.of(context).primaryColor),
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
    );
  }
}
