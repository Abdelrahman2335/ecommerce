import 'package:ecommerce/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../methods/userData.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  /// This key manage the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

  @override
  void dispose() {
    nameCon.dispose();
    phoneCon.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    Widget content = personalInfo(context, nameCon, phoneCon,formKey);
    return Scaffold(
      body:  Animate(
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
                  height: MediaQuery.of(context).size.height * 0.41,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: signUpProvider.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : content,
                  ),
                ),
              )),
            ),
    );
  }
}
