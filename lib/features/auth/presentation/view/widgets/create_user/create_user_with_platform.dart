import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_cubit/create_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateUserWithPlatform extends StatelessWidget {
  const CreateUserWithPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignupCubit, SignupCubitState>(
      builder: (context, state) {
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
                await context.read<SignupCubit>().signUpWithGoogle();

                if (state.status == SignupStatus.success) {
                  if (!state.isNewUser) {
                    GoRouter.of(context)
                        .pushReplacement(AppRouter.kLayoutScreen);
                  } else {
                    GoRouter.of(context)
                        .pushReplacement(AppRouter.kUserSetupScreen);
                  }
                }
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
      },
    );
  }
}
