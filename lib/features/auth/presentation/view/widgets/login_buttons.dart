import 'package:ecommerce/main.dart';
import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:ecommerce/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Selector, Provider;

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
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
              onPressed: () {
                navigatorKey.currentState!.pushNamed("/forgot");
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 13),
              )),
        ),
        Selector<AuthProvider, bool>(
            selector: (_, selectedValue) => selectedValue.loading,
            builder: (context, isLoading, child) {
              return !isLoading
                  ? CustomButton(
                      pressed: () {
                        final valid = formKey.currentState!.validate();
                        valid
                            ? Provider.of<AuthProvider>(context, listen: false)
                                .loginUser()
                            : null;
                      },
                      text: "Login",
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    );
            }),
      ],
    );
  }
}
