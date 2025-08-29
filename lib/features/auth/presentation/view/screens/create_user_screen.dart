import 'package:ecommerce/features/auth/presentation/view/widgets/create_user_screen_body.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateUserScreenBody(),
    );
  }
}
