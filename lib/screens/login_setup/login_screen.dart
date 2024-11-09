import 'package:ecommerce/screens/login_setup/forgot_password.dart';
import 'package:ecommerce/screens/login_setup/signup.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:ecommerce/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userCon = TextEditingController();
    TextEditingController passCon = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final firebase = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();


    signInWithGoogle() async{
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    }
    void signIn() async {
      final valid = formKey.currentState!.validate();

      try {
        if (valid) {
          final UserCredential userCredential =
              await firebase.signInWithEmailAndPassword(
                  email: userCon.text, password: passCon.text);
        } else {
          return;
        }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication Error!"),
          ),
        );
      }
      formKey.currentState!.save();
    }

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
                  height: 70,
                ),
                Text(
                  "Welcome \nBack!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomField(
                  label: "Email Address",
                  icon: const FaIcon(Icons.person),
                  controller: userCon,
                  isSecure: false,
                  isValid: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter a Valid Email";
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
                    if (value == null || value.trim().isEmpty) {
                      return "You didn't enter a password";
                    }
                    if (value.length <= 6) {
                      return "Invalid Password";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 2,
                  ),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const ForgotPassword()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 13),
                      )),
                ),
                CustomButton(
                  pressed: () {
                    signIn();
                  },
                  text: "Login",
                ),
                const SizedBox(
                  height: 60,
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
                      onPressed: () {},
                      child: const Image(
                        image: AssetImage(
                          "assets/google.png",
                        ),
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
                      "Create An Account",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text("Sign Up"),
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
