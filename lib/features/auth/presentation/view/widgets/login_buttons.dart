import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/utils/snackbar_helper.dart';
import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:ecommerce/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show Selector, Provider;

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
        Selector<AuthProvider, bool>(
            selector: (_, selectedValue) => selectedValue.loading,
            builder: (context, isLoading, child) {
              return !isLoading
                  ? CustomButton(
                      pressed: () async {
                        if (authProvider.validationForm()) {
                          await authProvider.loginUser();
                          if (!authProvider.hasError) {
                            GoRouter.of(context)
                                .pushReplacement(AppRouter.kLayoutScreen);
                          } else {
                            SnackBarHelper.show(
                                message: authProvider.errMessage!);
                          }
                        }
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
