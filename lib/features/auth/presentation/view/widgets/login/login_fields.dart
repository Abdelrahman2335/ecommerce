import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_cubit/login_logout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            context.read<LoginLogoutCubit>().emailChange(value);
          },
        ),
        const Gap(
          16,
        ),
        CustomField(
          label: "Password",
          icon: Icon(PhosphorIcons.lock()),
          isSecure: true,
          
          onChanged: (value) {
            context.read<LoginLogoutCubit>().passwordChange(value);
          },
        ),
      ],
    );
  }
}
