import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/location_map_preview.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/manual_address_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddressSelector extends StatefulWidget {
  const AddressSelector({super.key, required this.onAddressSelected});

  final void Function(AddressModel address) onAddressSelected;

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        final isLoading = state.status == AddressStatus.loading;
        return Animate(
          effects: [
            FadeEffect(duration: 500.ms),
            SlideEffect(
              begin: const Offset(0.14, 0),
              end: const Offset(0, 0),
              duration: 300.ms,
            )
          ],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: LoadingAnimationWidget.inkDrop(
                            color: Theme.of(context).primaryColor, size: 36),
                      ),
                    )
                  else if (state.userLocation != null &&
                      !state.triggerManualAddress)
                    LocationMapPreview(
                      userLocation: state.userLocation!,
                      onNewAddress: () {
                        context
                            .read<AddressBloc>()
                            .add(TriggerManualAddressEvent(true));
                      },
                      onContinue: () {
                        final currentAddress = state.currentAddress;
                        final address = AddressModel(
                          city: currentAddress?.city,
                          area: currentAddress?.area,
                          street: currentAddress?.street,
                          latitude: state.userLocation?.latitude,
                          longitude: state.userLocation?.longitude,
                        );
                        widget.onAddressSelected(address);
                      },
                    )
                  else
                    ManualAddressForm(
                      formKey: _formKey,
                      onCurrentLocationPressed: () {
                        context
                            .read<AddressBloc>()
                            .add(const GetCurrentLocation());
                      },
                      onNextPressed: () {
                        final currentAddress = state.currentAddress;
                        final address = AddressModel(
                          city: currentAddress?.city,
                          area: currentAddress?.area,
                          street: currentAddress?.street,
                        );
                        widget.onAddressSelected(address);
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
              ),
            ),
          ),
        );
      },
    );
  }
}
