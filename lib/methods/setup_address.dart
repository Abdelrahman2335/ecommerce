import 'package:ecommerce/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../data/cities.dart';
import '../models/address_model.dart';
import '../provider/location_provider.dart';

String selectedCity = egyptCities[0];

Widget setupAddress(BuildContext context, areaCon, streetCon, user,
    GlobalKey<FormState> formKey) {
  SignUpProvider signUpProvider = context.watch<SignUpProvider>();

  /// Both are the same
  // SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
  GetCurrentLocationProvider locationProvider =
      context.watch<GetCurrentLocationProvider>();
  Widget previewContent = Container();
  if (locationProvider.isGettingLocation) {
    previewContent = Center(
        child: LoadingAnimationWidget.inkDrop(
            color: Theme.of(context).primaryColor, size: 36));
  }
  if (locationProvider.userLocation != null) {
    previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: locationProvider.userLocation!,
          initialZoom: 16,
          maxZoom: 18,
          minZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
        ]);
  }
  return Animate(
    effects: [
      FadeEffect(
        duration: Duration(milliseconds: 1000),
      ),
      SlideEffect(
        begin: const Offset(0.14, 0),
        end: const Offset(0, 0),
        duration: Duration(milliseconds: 800),
      )
    ],
    child: locationProvider.isGettingLocation
        ? Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(20),
            )),
            child: previewContent,
          )
        : Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.grey,
                  ),
                  Gap(14),
                  Expanded(
                    child: DropdownButtonFormField(
                      items: [
                        for (String city in egyptCities)
                          DropdownMenuItem(
                            value: city,
                            child: FittedBox(
                                child: Text(
                              city,
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
                            borderRadius: BorderRadius.circular(12))),
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
          ),
  );
}
