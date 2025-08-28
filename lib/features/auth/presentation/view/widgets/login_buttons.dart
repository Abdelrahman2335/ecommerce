import 'package:ecommerce/main.dart';
import 'package:ecommerce/presentation/provider/auth/login_viewmodel.dart';
import 'package:ecommerce/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Selector;

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 2,
          ),
          child: TextButton(
              onPressed: () {
                navigatorKey.currentState!.pushNamed("/forgot");
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 13),
              )),
        ),
        Selector<LoginViewModel, bool>(
            selector: (_, selectedValue) => selectedValue.loading,
            builder: (context, isLoading, child) {
              return !isLoading
                  ? CustomButton(
                      pressed: () async {
                        //   final valid = formKey.currentState!.validate();
                        //   valid?
                        //  await Provider.of<LoginViewModel>(context,
                        //           listen: false)
                        //       .signIn(formKey, passCon.text,
                        //           userCon.text): null;
                      },
                      text: "Login",
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    );
            }),
      ],
    );
  }
}
