import 'package:ecommerce/core/constants/global_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();
    GlobalKey<FormState> formKey = AppKeys.forgetPasswordFormKey;
    final firebase = FirebaseAuth.instance;

    void forgetPass(String email) async {
      final valid = formKey.currentState!.validate();

      if (valid) {
        try {
          await firebase.sendPasswordResetEmail(email: email);

        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message!),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(27),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Forgot \nPassword?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomField(
                  label: "Email address",
                  icon:  Icon(PhosphorIcons.envelopeSimple()),
                  controller: emailCon,
                  isSecure: false,
                  isValid: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter a Valid Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  " We will send you a message to set \n your new password",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(

                    pressed: () {
                      forgetPass(emailCon.text);
                    },
                    text: "Submit"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
