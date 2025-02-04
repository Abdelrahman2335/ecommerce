import 'package:ecommerce/screens/login_setup/forgot_password.dart';
import 'package:ecommerce/screens/login_setup/signup.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:ecommerce/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firebase = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  void dispose() {
    passCon.dispose();
    userCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void signInWithGoogle() async {
      setState(() => isLoading = true);

      /// We could use this code only to signIn with google, but we wanted to use another way so we have to get the authCredential
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() => isLoading = false);
        return;
      } else {
        try {
          setState(() => isLoading = true);
          GoogleSignInAuthentication googleAuth =
              await googleSignInAccount.authentication;

          AuthCredential authCredential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          firebase.signInWithCredential(authCredential);
        } catch (error) {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                Text("Authentication Error!: $error"),
          );
        } finally {
          setState(() => isLoading = false);
        }
      }
    }



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(27),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(
                    70,
                  ),
                  Text(
                    "Welcome \nBack!",
                    style: theme.textTheme.titleLarge,
                  ),
                  const Gap(
                    30,
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
                  const Gap(
                     16,
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
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 13),
                        )),
                  ),
                  !isLoading
                      ? CustomButton(
                          pressed: () {
                            // signIn();
                          },
                          text: "Login",
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                          ),
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
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          side: BorderSide(color: theme.primaryColor),
                        ),
                        onPressed: signInWithGoogle,
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
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          padding: const EdgeInsets.all(13),
                          side: BorderSide(color: theme.primaryColor),
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
                        style: theme.textTheme.labelSmall,
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
          ],
        ),
      ),
    );
  }
}
