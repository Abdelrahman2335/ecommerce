import 'package:ecommerce/features/auth/presentation/manager/user_registration_provider.dart';
import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class RegistrationFields extends StatelessWidget {
  const RegistrationFields({super.key});

  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'^[0-9+]+$');
    final registrationProvider = context.read<UserRegistrationProvider>();

    return Form(
        key: registrationProvider.formKey,
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
              onChanged: (name) => registrationProvider.changeName(name),
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
              onChanged: (phone) => registrationProvider.changePhone(phone),
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
              onChanged: (age) => registrationProvider.changeAge(age),
            ),
          ],
        ));
  }
}
