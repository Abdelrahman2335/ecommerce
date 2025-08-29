import 'package:ecommerce/domain/entities/user_model.dart';
import 'package:ecommerce/features/auth/presentation/manager/user_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class SelectGender extends StatelessWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserRegistrationProvider>();
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
                    overflow: TextOverflow.ellipsis)),
          ),
      ],
      initialValue: provider.gender,
      onChanged: (value) {
        provider.changeGender(value!);
      },
    );
  }
}
