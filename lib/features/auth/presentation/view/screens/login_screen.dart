import 'package:ecommerce/features/auth/data/repository/auth_repo_impl.dart';
import 'package:ecommerce/features/auth/presentation/manager/auth_provider.dart';
import 'package:ecommerce/features/auth/presentation/view/widgets/login_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => AuthProvider(LoginRepositoryImpl()),
        child: const LoginScreenBody(),
      ),
    );
  }
}
