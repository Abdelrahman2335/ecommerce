import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_bloc/create_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateUserFields extends StatelessWidget {
  const CreateUserFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupBlocState>(
      builder: (context, state) {
        return Column(
          spacing: 16,
          children: [
            CustomField(
              label: "Email address",
              labelStyle: TextStyle(fontSize: 14),
              icon: Icon(PhosphorIcons.user()),
              isSecure: false,
              onChanged: (email) {
                context.read<SignupBloc>().add(SignupEmailChanged(email));
              },
            ),
            CustomField(
              label: "Password",
              labelStyle: TextStyle(fontSize: 14),
              icon: Icon(PhosphorIcons.lock()),
              isSecure: true,
              onChanged: (password) {
                context.read<SignupBloc>().add(SignupPasswordChanged(password));
              },
            ),
            CustomField(
              label: "Confirm password",
              labelStyle: TextStyle(fontSize: 14),
              icon: Icon(PhosphorIcons.lock()),
              isSecure: true,
              onChanged: (password) {
                context
                    .read<SignupBloc>()
                    .add(SignupConfirmPasswordChanged(password));
              },
            ),
          ],
        );
      },
    );
  }
}
