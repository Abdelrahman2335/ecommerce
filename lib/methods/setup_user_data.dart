import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/provider/signup_provider.dart';

Widget setupUserData(BuildContext context, nameCon, phoneCon, User? user,
    GlobalKey<FormState> formKey) {
  RegExp regex = RegExp(r'^[0-9+]+$');

  /// Allows only digits (0-9) and "+"


  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.85, // Adjust dynamically

        child: TextFormField(
          // initialValue: user?.displayName.toString(),
          /// Make the keyboard capitalize the first letter of each word
          textCapitalization: TextCapitalization.words,
          autocorrect: true,
          controller: nameCon,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please Enter Valid a Name";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Full Name",
            icon: Icon(
              Icons.person,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: 370,
        child: TextFormField(
          maxLength: 11,

          buildCounter: (context,
                  {required currentLength,
                  required isFocused,
                  required maxLength}) =>
              null,

          /// by using [buildCounter] we have disabled the counter shown under the [textFormField]
          keyboardType: TextInputType.phone,
          controller: phoneCon,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                regex.hasMatch(value) == false ||
                value.length < 10) {
              return "Please Enter a valid phone number";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Phone Number",
            icon: Icon(
              Icons.phone,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              final valid = formKey.currentState!.validate();
              if (valid) {
                context.read<SignUpProvider>().personalInfo(nameCon.text, phoneCon.text, user!);
                nameCon.clear();
                phoneCon.clear();
              }
            },
            child: const Text(
              "Next",
            ),
          ),
        ],
      ),
    ],
  );
}
