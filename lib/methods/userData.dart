import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/signup_provider.dart';


 Widget personalInfo(BuildContext context, nameCon, phoneCon,GlobalKey<FormState> formKey)  {
  SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);

  return Column(
    children: [
      const Text(
        "Personal Information",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      Text(
        "Step ${signUpProvider.counter} of 2",
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.85, // Adjust dynamically

        child: TextFormField(
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
          keyboardType: TextInputType.phone,
          controller: phoneCon,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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
                signUpProvider.personalInfo(nameCon.text, phoneCon.text);
              }
            },
            child: const Text(
              "Next",
            ),
          ),
        ],
      ),
      Text("Progress ${signUpProvider.sliderValue.toStringAsFixed(0)}%"),
      Expanded(
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            /// Making onChange null this will make the slider read only
            value: signUpProvider.sliderValue,
            onChanged: null,
            min: 0,
            max: 1,
          ),
        ),
      )
    ],
  );
}
