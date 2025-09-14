import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:ecommerce/core/widgets/snackbar_helper.dart';
import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(27),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot \nPassword?",
                style: AppTextStyles.title29(context),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomField(
                label: "Email address",
                icon: Icon(PhosphorIcons.envelopeSimple()),
                isSecure: false,
                onSaved: (value) async {
                  await context
                      .read<AuthProvider>()
                      .requestPasswordReset(value!);
                  SnackBarHelper.show(message: "Please check your email");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                " We will send you a message to set \n your new password",
                style: AppTextStyles.label12(context),
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                  pressed: () {
                    final valid = formKey.currentState!.validate();
                    if (valid) formKey.currentState!.save();
                  },
                  text: "Submit"),
            ],
          ),
        ),
      ),
    );
  }
}
