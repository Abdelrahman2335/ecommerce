import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/user_registration/registration_fields.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/user_registration/select_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../manager/cubits/user_registration/user_registration_bloc.dart';
import '../../../../../../core/widgets/custom_button.dart';

class UserRegistrationScreenBody extends StatefulWidget {
  const UserRegistrationScreenBody({super.key});

  @override
  State<UserRegistrationScreenBody> createState() =>
      _UserRegistrationScreenBodyState();
}

class _UserRegistrationScreenBodyState
    extends State<UserRegistrationScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: BlocListener<UserRegistrationBloc,UserRegistrationState>(
          listener: (context, state){
            if(state.isUserRegistered){
             GoRouter.of(context).pushReplacement(AppRouter.kUserLocationScreen);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(70),
                RegistrationFields(formKey: _formKey),
                const Gap(21),
                const SelectGender(),
                const Gap(26),
                BlocBuilder<UserRegistrationBloc, UserRegistrationState>(
                  builder: (context, state) {
                    final isLoading =
                        state.status == UserRegistrationStatus.loading;
                    return !isLoading
                        ? CustomButton(
                            pressed: () {
                              final valid =
                                  _formKey.currentState?.validate() ?? false;
                              if (valid) {
                                context
                                    .read<UserRegistrationBloc>()
                                    .add(UserRegistrationSubmitted());
                              }
                            },
                            text: "Continue",
                          )
                        : Center(
                            child: const CircularProgressIndicator(),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
