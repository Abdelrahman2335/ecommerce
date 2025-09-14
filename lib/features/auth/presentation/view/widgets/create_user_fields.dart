import 'package:ecommerce/features/auth/presentation/manager/create_user_provider.dart';
import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateUserFields extends StatelessWidget {
  const CreateUserFields({super.key});

  @override
  Widget build(BuildContext context) {
    final createUserProvider = context.read<CreateUserProvider>();
    String? password;

    return Form(
      key: createUserProvider.formKey,
      child: Column(
        spacing: 16,
        children: [
          CustomField(
            label: "Email address",
            labelStyle: TextStyle(fontSize: 14),
            icon: Icon(PhosphorIcons.user()),
            isSecure: false,
            onChanged: (value) {
              createUserProvider.email = value;
            },
          ),
          CustomField(
            label: "Password",
            labelStyle: TextStyle(fontSize: 14),
            icon: Icon(PhosphorIcons.lock()),
            isSecure: true,
            isValid: (String? value) {
              if (value == null || value.isEmpty || value.length <= 6) {
                return "Wrong Password";
              }
              return null;
            },
            onChanged: (value) {
              createUserProvider.password = value;
              password = value;
            },
          ),
          CustomField(
            label: "Confirm password",
            labelStyle: TextStyle(fontSize: 14),
            icon: Icon(PhosphorIcons.lock()),
            isSecure: true,
            isValid: (String? value) {
              if (value == null || value.trim().isEmpty || value.length <= 6) {
                return "Wrong Password";
              }
              if (value != password) {
                return "Password not matched";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
