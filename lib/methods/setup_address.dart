import 'package:ecommerce/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../data/cities.dart';
import '../main.dart';
import '../models/address_model.dart';
import '../provider/location_provider.dart';

String selectedCity = egyptCities[0];

Widget setupAddress(BuildContext context, areaCon, streetCon, user,
    GlobalKey<FormState> formKey) {
  SignUpProvider signUpProvider = context.watch<SignUpProvider>();

  /// Both are the same
  // SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
  LocationProvider locationProvider = context.watch<LocationProvider>();

  /// Getting the location manually
  /// previewContent is the content of the page
  Widget previewContent = Column(
    children: [
      Row(
        children: [
          Icon(
            Icons.location_pin,
            color: Colors.grey,
          ),
          Gap(14),

          /// The dropdown button for the cities.
          /// using Expanded to make the dropdown button take the remaining space (Important)
          Expanded(
            child: DropdownButtonFormField(
              items: [
                for (String city in egyptCities)
                  DropdownMenuItem(
                    value: city,

                    /// [FittedBox] adjusts its child based on the available space while maintaining the child’s aspect ratio.
                    child: FittedBox(
                        child: Text(
                      city,

                      /// if the text is too long, it will be ellipsis (...)
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
              ],
              value: selectedCity,
              onChanged: (value) {
                selectedCity = value!;
              },
            ),
          ),
        ],
      ),
      const Gap(18),
      SizedBox(
        width: 370,
        child: TextFormField(
          controller: areaCon,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please Enter valid area";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter you area name",
            icon: Icon(
              Icons.map,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
      const Gap(18),
      SizedBox(
        width: 370,
        child: TextFormField(
          controller: streetCon,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please Enter valid street";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter your street name",
            icon: Icon(
              Icons.location_city,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // minimumSize: Size(100, 40), /// Change the size of the button,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              /// Change the padding of the button (the space inside the button)
              /// Don't forget to change other buttons as well
            ),
            onPressed: locationProvider.getCurrentLocation,
            child: const Text("Get Current Location"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              AddressModel address = AddressModel(
                area: areaCon.text,
                city: selectedCity,
                street: streetCon.text,
              );
              final valid = formKey.currentState!.validate();
              if (valid) {
                ///  Here we are going to update the address information
                signUpProvider.addressInfo(address, user);
                areaCon.clear();
                streetCon.clear();
              }
            },
            child: const Text(
              "Next",
            ),
          ),
        ],
      ),
    ],
  );

  /// the content of the map
  if (locationProvider.isGettingLocation) {
    previewContent = Center(
        child: LoadingAnimationWidget.inkDrop(
            color: Theme.of(context).primaryColor, size: 36));
  }
  if (locationProvider.userLocation != null) {
    previewContent = Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
          )),
          child: FlutterMap(
              options: MapOptions(
                /// The initial center is the user location
                initialCenter: locationProvider.userLocation!,
                initialZoom: 16,

                /// making the map fixed
                // maxZoom: 16,
                // minZoom: 16,
              ),
              children: [
                /// OSM does not track your location, it just provides the map images
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(markers: [
                  Marker(
                      point: locationProvider.userLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        color: Colors.red,
                        Icons.location_pin,
                      ))
                ])
              ]),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            /// for now we will navigate to layout, but next we will edit this page to go to the optional info page (age, gender)
            navigatorKey.currentState?.pushReplacementNamed('/layout');
          },
          child: const Text(
            "Next",
          ),
        ),
      ],
    );
  }

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
          previewContent,
        ],
      ));
}
