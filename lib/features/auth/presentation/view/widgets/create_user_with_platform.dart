import 'package:ecommerce/core/utils/global_keys.dart';
import 'package:ecommerce/features/auth/presentation/manager/create_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CreateUserWithPlatform extends StatelessWidget {
  const CreateUserWithPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            await Provider.of<CreateUserProvider>(
                    AppKeys.navigatorKey.currentContext!,
                    listen: false)
                .signUpWithGoogle();
          },
          child: const Image(
            image: AssetImage(
              "assets/google.png",
            ),
            filterQuality: FilterQuality.medium,
            width: 35,
            height: 37,
          ),
        ),
        const Gap(14),
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
            filterQuality: FilterQuality.medium,
            width: 38,
            height: 38,
          ),
        ),
      ],
    );
  }
}
