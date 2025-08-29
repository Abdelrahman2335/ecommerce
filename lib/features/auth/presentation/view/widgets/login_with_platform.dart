import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginWithPlatform extends StatelessWidget {
  const LoginWithPlatform({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.read<AuthProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(13),
            backgroundColor: theme.primaryColor.withAlpha(37),
            side: BorderSide(color: theme.primaryColor),
          ),
          onPressed: () async {
            await authProvider.loginWithGoogle();
            if (!authProvider.hasError) {
              if (authProvider.isNewUser) {
                GoRouter.of(context)
                    .pushReplacement(AppRouter.kUserSetupScreen);
              } else {
                GoRouter.of(context).pushReplacement(AppRouter.kLayoutScreen);
              }
            }
          },
          child: const Image(
            image: AssetImage(
              "assets/google.png",
            ),
            width: 35,
            height: 37,
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: theme.primaryColor.withAlpha(37),
            padding: const EdgeInsets.all(13),
            side: BorderSide(color: theme.primaryColor),
          ),
          onPressed: () {},
          child: const Image(
            image: AssetImage(
              "assets/facebook.png",
            ),
            width: 38,
            height: 38,
          ),
        ),
      ],
    );
  }
}
