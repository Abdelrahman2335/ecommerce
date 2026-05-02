import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_cubit/create_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateUserFields extends StatelessWidget {
  const CreateUserFields({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

    return BlocBuilder<SignupCubit, SignupCubitState>(
      builder: (context, state) {
        final formState = state is SignupCubitFormState
            ? state
            : SignupCubitFormState(email: '', password: '');

        return Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: Column(
            spacing: 16,
            children: [
              CustomField(
                label: "Email address",
                labelStyle: TextStyle(fontSize: 14),
                icon: Icon(PhosphorIcons.user()),
                isSecure: false,
                onChanged: (email) {
                  context.read<SignupCubit>().emailChnage(email);
                },
              ),
              CustomField(
                label: "Password",
                labelStyle: TextStyle(fontSize: 14),
                icon: Icon(PhosphorIcons.lock()),
                isSecure: true,
                
                onChanged: (password) {
                  context.read<SignupCubit>().emailChnage(password);
                },
              ),
              CustomField(
                label: "Confirm password",
                labelStyle: TextStyle(fontSize: 14),
                icon: Icon(PhosphorIcons.lock()),
                isSecure: true,
                isValid: (String? value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length <= 6) {
                    return "Wrong Password";
                  }
                  if (value != formState.password) {
                    return "Password not matched";
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
