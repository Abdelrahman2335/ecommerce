import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'registration_fields.dart';
import 'select_gender.dart';

class UserRegistrationScreenBody extends StatelessWidget {
  const UserRegistrationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
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
              CustomButton(
                pressed: () {},
                text: "Continue"
              )
            ],
          ),
        ),
      ),
    );
  }
}
