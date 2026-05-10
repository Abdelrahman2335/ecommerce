import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/models/user_model.dart';
import '../../../manager/cubits/user_registration/user_registration_bloc.dart';

class SelectGender extends StatelessWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRegistrationBloc, UserRegistrationState>(
      builder: (context, state) {
        return DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(21),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(PhosphorIcons.genderMale()),
            ),
          ),
          items: [
            for (Genders currentGender in Genders.values)
              DropdownMenuItem(
                value: currentGender,
                child: FittedBox(
                  child: Text(currentGender.string,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
          ],
          initialValue: state.gender,
          onChanged: (value) {
            if (value == null) return;
            context
                .read<UserRegistrationBloc>()
                .add(RegistrationGenderChanged(value));
          },
        );
      },
    );
  }
}
