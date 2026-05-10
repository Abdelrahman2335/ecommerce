import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/widgets/snackbar_helper.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_bloc/create_user_bloc.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/create_user/create_user_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/create_user/create_user_with_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widgets/custom_button.dart';

class CreateUserScreenBody extends StatefulWidget {
  const CreateUserScreenBody({super.key});

  @override
  State<CreateUserScreenBody> createState() => _CreateUserScreenBodyState();
}

class _CreateUserScreenBodyState extends State<CreateUserScreenBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<SignupBloc, SignupBlocState>(
      listener: (context, state) {
        if (state.status == SignupStatus.error) {
          SnackBarHelper.show(message: state.errorMessage!);
        }
        if (state.status == SignupStatus.success) {
          GoRouter.of(context).pushReplacement(AppRouter.kUserSetupScreen);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignupStatus.loading;
        return Animate(
          effects: [FadeEffect(duration: Duration(milliseconds: 600))],
          child: Padding(
            padding: const EdgeInsets.all(27),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    Text(
                      "Create an \naccount",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(34),
                    const CreateUserFields(),
                    const Gap(40),
                    !isLoading
                        ? CustomButton(
                            bottomWidth: 0.5,
                            pressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<SignupBloc>()
                                    .add(SignupSubmitted());
                              }
                            },
                            text: "Create Account",
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: theme.primaryColor),
                          ),
                    const Gap(46),
                    const Center(
                      child: Text("- OR Continue with -"),
                    ),
                    const Gap(24),
                    const CreateUserWithPlatform(),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I Already have an account",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        TextButton(
                          onPressed: () => GoRouter.of(context).pop(),
                          child: const Text("Login"),
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
