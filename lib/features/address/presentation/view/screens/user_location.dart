import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:ecommerce/presentation/widgets/setup_address.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';


class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final formKey = GlobalKey<FormState>();

  final firstCon = TextEditingController();
  final secondCon = TextEditingController();
  @override
  void dispose() {
    firstCon.dispose();
    secondCon.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: setupAddress(context, firstCon, secondCon, formKey),
      ),
    );
  }
}



