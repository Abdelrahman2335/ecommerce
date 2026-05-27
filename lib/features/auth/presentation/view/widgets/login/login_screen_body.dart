import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:ecommerce/core/widgets/snackbar_helper.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login/login_buttons.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login/login_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login/login_with_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({
    super.key,
  });

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginLogoutBloc, LoginLogoutState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          SnackBarHelper.show(message: state.errorMessage!);
        } else if (state.status == LoginStatus.success) {
          if (state.isNewUser) {
            GoRouter.of(context).pushReplacement(AppRouter.kUserSetupScreen);
          } else {
            GoRouter.of(context).pushReplacement(AppRouter.kLayoutScreen);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;

        return Animate(
          effects: [
            FadeEffect(
              duration: Duration(milliseconds: 600),
            )
          ],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(27),
              child: Form(
                key: _formKey,
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
                    LoginButtons(
                      onLoginPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginLogoutBloc>().add(LoginSubmitted());
                        }
                      },
                      isLoading: isLoading,
                    ),
                    const Gap(40),
                    const Center(child: Text("- OR Continue with -")),
                    const Gap(24),
                    LoginWithPlatform(
                      onLoginPressed: () {
                        context
                            .read<LoginLogoutBloc>()
                            .add(LoginWithGoogleRequested());
                      },
                    ),
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
                            GoRouter.of(context)
                                .push(AppRouter.kCreateUserScreen);
                          },
                          child: const Text("Sign Up"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
