import 'package:ecommerce/core/utils/global_keys.dart';
import 'package:ecommerce/presentation/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = AppKeys.loginFormKey;

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomField(
            label: "Email Address",
            icon: Icon(PhosphorIcons.user()),
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
            icon: Icon(PhosphorIcons.lock()),
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
        ],
      ),
    );
  }
}
