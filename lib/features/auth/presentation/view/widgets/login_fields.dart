import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:ecommerce/presentation/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<AuthProvider>().formKey,
      child: Column(
        children: [
          CustomField(
            label: "Email Address",
            icon: Icon(PhosphorIcons.user()),
            isSecure: false,
            isValid: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              Provider.of<AuthProvider>(context, listen: false).email = value;
            },
          ),
          const Gap(
            16,
          ),
          CustomField(
            label: "Password",
            icon: Icon(PhosphorIcons.lock()),
            isSecure: true,
            isValid: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length <= 6) {
                return 'Password must be more than 6 characters';
              }
              return null;
            },
            onChanged: (value) {
              Provider.of<AuthProvider>(context, listen: false).password =
                  value;
            },
          ),
        ],
      ),
    );
  }
}
