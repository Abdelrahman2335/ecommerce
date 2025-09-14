import 'package:ecommerce/features/auth/presentation/view/widgets/forget_password_body.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ForgetPasswordBody(),
    );
  }
}
