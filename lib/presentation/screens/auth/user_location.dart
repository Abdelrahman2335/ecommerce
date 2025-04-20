import 'package:ecommerce/presentation/widgets/setup_address.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/global_keys.dart';
import '../../provider/login_viewmodel.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final formKey = AppKeys.locationFormKey;
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
              Provider.of<LoginViewModel>(context, listen: false).signOut();
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
