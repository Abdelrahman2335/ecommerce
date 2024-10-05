import 'package:ecommerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/custom_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(27),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot \nPassword?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomField(
                label: "Username or Email",
                icon: const FaIcon(Icons.mail_rounded),
                controller: emailCon,
                isSecure: false,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                " We will send you a message to set \n your new password",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 24,),
              CustomButton(pressed: () {}, text: "Submit"),
            ],
          ),
        ),
      ),
    );
  }
}
