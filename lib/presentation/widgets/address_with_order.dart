import 'package:flutter/material.dart';

import '../../data/models/address_model.dart';
import 'new_address.dart';

class AddressWithOrder extends StatefulWidget {
  const AddressWithOrder({
    super.key,
  });

  @override
  State<AddressWithOrder> createState() => _AddressWithOrderState();
}

class _AddressWithOrderState extends State<AddressWithOrder> {
  AddressModel address = AddressModel(city: '', area: '', street: '');

  void getAddress(AddressModel newAddress) {
    /// Change the setState later
    setState(() {
      address = newAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-2, 3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 3,
              child: const Text("Address:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Positioned(
              top: 34,
              left: 4,
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  "City: ${address.city}",
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
                  "Area: ${address.area}",
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
                  "Street: ${address.street}",
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      context: context,
                      sheetAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                        reverseDuration: Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 600),
                      ),

                      /// Note: The ctx is the context for the BottomSheet, but context is refer to the main context.
                      builder: (ctx) {
                        return SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: NewAddress(
                              addAddress: getAddress,
                            ));
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
  }
}
