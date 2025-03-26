import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget optionalInfo(BuildContext context, nameCon, ageCon,User? user,
    GlobalKey<FormState> formKey) {
  RegExp regex = RegExp(r'^[0-9+]+$');

  /// Allows only digits (0-9) and "+"
  String? selectedGender;
  Future updateUser(User? user, String? selectedGender, String age) async {
    if (user == null) return;
   await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        UserModel(
          age: ageCon.text,
          gender: selectedGender,).toJson()
    );
  }

  /// Both are the same
  //  SignUpProvider signUpProvider = context.watch<SignUpProvider>();

  return SizedBox(
    height: MediaQuery
        .of(context)
        .size
        .height * 0.30,
    child: Column(
      children: [
        // SizedBox(height: 26,),
        Flexible(
          flex: 1,
          child: TextFormField(
            maxLength: 2,

            buildCounter: (context,
                {required currentLength,
                  required isFocused,
                  required maxLength}) =>
            null,

            /// by using [buildCounter] we have disabled the counter shown under the [textFormField]
            keyboardType: TextInputType.phone,
            controller: ageCon,
            validator: (value) {
              if (value == null ||
                  regex.hasMatch(value) == false ||
                  value.length > 10) {
                return "Please Enter a valid age";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Age",
              icon: Icon(
                Icons.cake_outlined,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ),
        ),

        Gap(9),

        /// Will be tested
        Expanded(
          flex: 1,
          child: DropdownButtonFormField(
            hint: const Text("Gender"),
            items: [
              for (String gender in ["Male", "Female"])
                DropdownMenuItem(value: gender, child: Text(gender)),
            ],
            value: selectedGender,
            onChanged: (value) {
              selectedGender = value!;
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme
                    .of(context)
                    .primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                // minimumSize: Size(100, 40), /// Change the size of the button,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                /// Change the padding of the button (the space inside the button)
                /// Don't forget to change other buttons as well
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/layout");
              },
              child: const Text("Skip"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                final valid = formKey.currentState?.validate();
                if (valid == null || valid == false) return;
               await updateUser(user, selectedGender, ageCon.text);


                Navigator.pushReplacementNamed(context, "/layout");
              },
              child: const Text(
                "Finish",
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
