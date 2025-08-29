import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login_buttons.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login_with_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          duration: Duration(milliseconds: 600),
        )
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(70),
              Text(
                "Welcome \nBack!",
                style: AppTextStyles.title29(context),
              ),
              const Gap(30),
              const LoginFields(),
              const LoginButtons(),
              const Gap(40),
              const Center(child: Text("- OR Continue with -")),
              const Gap(24),
              const LoginWithPlatform(),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create An Account",
                    style: AppTextStyles.label12(context),
                  ),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kCreateUserScreen);
                    },
                    child: const Text("Sign Up"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
