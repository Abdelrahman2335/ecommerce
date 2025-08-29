import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/create_user_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/create_user_with_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../manager/create_user_provider.dart';
import '../../../../../presentation/widgets/custom_button.dart';

class CreateUserScreenBody extends StatelessWidget {
  const CreateUserScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final createUserProvider = context.read<CreateUserProvider>();
    return Animate(
      effects: [FadeEffect(duration: Duration(milliseconds: 600))],
      child: Padding(
        padding: const EdgeInsets.all(27),
        child: SingleChildScrollView(
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
              Selector<CreateUserProvider, bool>(
                  selector: (_, selectedValue) => selectedValue.loading,
                  builder: (context, isLoading, child) {
                    return !isLoading
                        ? CustomButton(
                            bottomWidth: 0.5,
                            pressed: () async {
                              if (createUserProvider.validationForm()) {
                                await createUserProvider.createUser();
                                if (!createUserProvider.hasError) {
                                  GoRouter.of(context).pushReplacement(
                                      AppRouter.kUserSetupScreen);
                                }
                              }
                            },
                            text: "Create Account",
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: theme.primaryColor),
                          );
                  }),
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
                    "I Already Have an Account",
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
    );
  }
}
