import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:ecommerce/features/address/presentation/view/widgets/address_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        final userAddress = state.currentAddress;

        if (state.status == AddressStatus.loading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(-2, 3),
                  ),
                ]),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(-2, 3),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 3,
                  child: Text("Address:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  top: 34,
                  left: 4,
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      "City: ${userAddress?.city == null || userAddress!.city!.isEmpty ? 'Not set' : userAddress.city}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 44,
                  left: 2,
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      "Area: ${userAddress?.area == null || userAddress!.area!.isEmpty ? 'Not set' : userAddress.area}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 11,
                  left: 2,
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      "Street: ${userAddress?.street == null || userAddress!.street!.isEmpty ? 'Not set' : userAddress.street}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -6,
                  child: Opacity(
                    opacity: 1.0,
                    child: IconButton(
                      iconSize: 19,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (ctx) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
                              child: AddressSelector(
                                onAddressSelected: (newAddress) {
                                  context
                                      .read<AddressBloc>()
                                      .add(SaveAddressEvent(newAddress));
                                  Navigator.pop(ctx);
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
