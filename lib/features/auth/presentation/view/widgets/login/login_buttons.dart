import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.onLoginPressed,
    required this.isLoading,
  });

  final VoidCallback onLoginPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 2,
          ),
          child: TextButton(
              onPressed: () =>
                  GoRouter.of(context).push(AppRouter.kForgotPasswordScreen),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 13),
              )),
        ),
        !isLoading
            ? CustomButton(
                pressed: onLoginPressed,
                text: "Login",
              )
            : Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              ),
      ],
    );
  }
}
