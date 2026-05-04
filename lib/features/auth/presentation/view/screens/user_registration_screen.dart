import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/user_registration/user_registration_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';


class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<LoginLogoutBloc>(context, listen: false).add(LogoutRequested());
            },
            icon: Icon(PhosphorIcons.signOut()),
          ),
        ],
      ),
      body: UserRegistrationScreenBody(),
    );
  }
}



