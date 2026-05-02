import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegistrationFields extends StatelessWidget {
  const RegistrationFields({super.key});

  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'^[0-9+]+$');

    return Form(
        child: Column(
          spacing: 21,
          children: [
            CustomField(
              textCapitalization: TextCapitalization.words,
              label: "Full Name",
              icon: Icon(PhosphorIcons.user()),
              isSecure: false,
              isValid: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please Enter Valid a Name";
                }
                return null;
              },
            ),
            CustomField(
              keyboardType: TextInputType.phone,
              label: "Phone Number",
              maxLength: 11,
              icon: Icon(PhosphorIcons.phone()),
              isSecure: false,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              isValid: (String? value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    regex.hasMatch(value) == false ||
                    value.length < 10) {
                  return "Please Enter a valid phone number";
                }
                return null;
              },
            ),
            CustomField(
              keyboardType: TextInputType.phone,
              label: "Age",
              icon: Icon(PhosphorIcons.cake()),
              isSecure: false,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              isValid: (String? value) {
                if (value == null ||
                    regex.hasMatch(value) == false ||
                    value.length > 10) {
                  return "Please Enter a valid age";
                }
                return null;
              },
            ),
          ],
        ));
  }
}
