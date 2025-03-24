import 'package:ecommerce/models/user_model.dart';
import 'package:flutter/material.dart';

Widget optionalInfo(
    BuildContext context, nameCon, ageCon, user, GlobalKey<FormState> formKey) {
  RegExp regex = RegExp(r'^[0-9+]+$');

  /// Allows only digits (0-9) and "+"
  String? selectedGender;

  /// Both are the same
  //  SignUpProvider signUpProvider = context.watch<SignUpProvider>();

  return Column(
    children: [
      SizedBox(
        width: 370,
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
                value.trim().isEmpty ||
                regex.hasMatch(value) == false ||
                value.length < 10) {
              return "Please Enter a valid phone number";
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

      /// Will be tested
      Expanded(
        child: DropdownButtonFormField(
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
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // minimumSize: Size(100, 40), /// Change the size of the button,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

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
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () async {
              final valid = formKey.currentState?.validate();
              if (valid == null || valid == false) return;
              await user.update(UserModel(
                age: ageCon.text,
                gender: selectedGender,
              ));

              Navigator.pushReplacementNamed(context, "/layout");
            },
            child: const Text(
              "Finish",
            ),
          ),
        ],
      ),
    ],
  );
}
