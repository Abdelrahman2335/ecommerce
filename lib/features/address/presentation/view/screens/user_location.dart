import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/location_map_preview.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/manual_address_form.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final theme = Theme.of(context).primaryColor;

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
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          final isLoading = state.status == AddressStatus.loading;
          return Animate(
              effects: [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                ),
                SlideEffect(
                  begin: const Offset(0.14, 0),
                  end: const Offset(0, 0),
                  duration: Duration(milliseconds: 300),
                )
              ],
              child: Column(
                children: [
                  if (isLoading)
                    Center(
                      child: SizedBox(
                          height: mediaQuery.height * 0.27,
                          child: LoadingAnimationWidget.inkDrop(
                              color: theme, size: 36)),
                    )
                  else if (state.userLocation != null)
                    LocationMapPreview(
                      mediaQuery: mediaQuery,
                      theme: theme,
                      state: state,
                      onContinue: () {
                        GoRouter.of(context)
                            .pushReplacement(AppRouter.kLayoutScreen);
                      },
                    )
                  else
                    ManualAddressForm(
                      formKey: _formKey,
                      onCurrentLocationPressed: () {
                        context.read<AddressBloc>().add(GetCurrentLocation());
                      },
                      onNextPressed: () {
                        final currentAddress = state.currentAddress;
                        final address = AddressModel(
                          city: currentAddress?.city,
                          area: currentAddress?.area,
                          street: currentAddress?.street,
                        );
                        context
                            .read<AddressBloc>()
                            .add(SaveAddressEvent(address));
                        GoRouter.of(context)
                            .pushReplacement(AppRouter.kLayoutScreen);
                      },
                      onCityChanged: (city) {
                        context
                            .read<AddressBloc>()
                            .add(UpdateSelectedCityEvent(city));
                      },
                      onAreaChanged: (area) {
                        context
                            .read<AddressBloc>()
                            .add(AddressAreaChanged(area));
                      },
                      onStreetChanged: (street) {
                        context
                            .read<AddressBloc>()
                            .add(AddressStreetChanged(street));
                      },
                    ),
                ],
              ));
        },
      ),
    );
  }
}
