import 'package:ecommerce/features/auth/presentation/view/widgets/registration_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/select_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../manager/user_registration_provider.dart';
import '../../../../../presentation/widgets/custom_button.dart';

class UserRegistrationScreenBody extends StatelessWidget {
  const UserRegistrationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationProvider = context.read<UserRegistrationProvider>();
    return Animate(
      effects: [
        FadeEffect(
          duration: Duration(milliseconds: 600),
        )
      ],
      child: Padding(
        padding: const EdgeInsets.all(27),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(70),
              const RegistrationFields(),
              const Gap(21),
              const SelectGender(),
              const Gap(26),
              Selector<UserRegistrationProvider, bool>(
                  selector: (_, selectedValue) => selectedValue.isLoading,
                  builder: (context, loading, child) {
                    return !loading
                        ? CustomButton(
                            pressed: () {
                              if (registrationProvider.validationForm()) {
                                registrationProvider.userRegistration();
                              }
                            },
                            text: "Continue",
                          )
                        : Center(
                            child: const CircularProgressIndicator(),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
