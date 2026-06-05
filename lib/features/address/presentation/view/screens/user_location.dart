import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/address_selector.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserLocation extends StatelessWidget {
  const UserLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<LoginLogoutBloc>().add(LogoutRequested());
            },
            icon: Icon(PhosphorIcons.signOut()),
          ),
        ],
      ),
      body: AddressSelector(
        onAddressSelected: (address) {
          context.read<AddressBloc>().add(SaveAddressEvent(address));
          GoRouter.of(context).pushReplacement(AppRouter.kLayoutScreen);
        },
      ),
    );
  }
}
