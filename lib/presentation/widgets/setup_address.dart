import 'dart:developer';

import 'package:ecommerce/presentation/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/constants/global_keys.dart';
import '../../data/cities.dart';
import '../../data/models/address_model.dart';
import '../provider/location_viewmodel.dart';
import '../provider/auth/user_data_viewmodel.dart';

String selectedCity = egyptCities[0];

Widget setupAddress(
    BuildContext context, firstCon, secondCon, GlobalKey<FormState> formKey) {
  /// Both are the same
  // SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);

  final theme = Theme.of(context).primaryColor;
  final mediaQuery = MediaQuery.of(context).size;
  final userLocation = Provider.of<LocationProvider>(context).userLocation;
  /// Getting the location manually
  /// previewContent is the content of the page
  Widget previewContent = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Form(
      key: formKey,
      child: Column(
        spacing: 19,
        children: [
          /// The dropdown button for the cities.
          /// using Expanded to make the dropdown button take the remaining space (Important)
          const Gap(90),
          DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(PhosphorIcons.city()),
              ),
            ),
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


          CustomField(
            controller: firstCon,
            isValid: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please Enter valid area";
              }
              return null;
            },
            label: 'Enter you area name',
            isSecure: false,
            icon: Icon(PhosphorIcons.buildingApartment()),
          ),


          CustomField(
            controller: secondCon,
            isValid: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please Enter valid street";
              }
              return null;
            },
            label: 'Enter you street',
            icon: Icon(PhosphorIcons.roadHorizon()),
            isSecure: false,
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  // minimumSize: Size(100, 40), /// Change the size of the button,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                  /// Change the padding of the button (the space inside the button)
                  /// Don't forget to change other buttons as well
                ),
                onPressed: context.read<LocationProvider>().getCurrentLocation,
                child: const Text("Current location"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final valid = formKey.currentState?.validate();
                  if (valid != null && valid) {
                    AddressModel address = AddressModel(
                      area: firstCon.text,
                      city: selectedCity,
                      street: secondCon.text,
                    );

                    ///  Here we are going to update the address information
                    context.read<UserViewModel>().addressInfo(address);
                    firstCon.clear();
                    secondCon.clear();
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
    ),
  );

  /// the content of the map
  if (context.watch<LocationProvider>().isGettingLocation) {
    previewContent = Center(
      child: SizedBox(
          height: mediaQuery.height * 0.27,
          child: LoadingAnimationWidget.inkDrop(color: theme, size: 36)),
    );
  }
  if (userLocation != null) {
    previewContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Column(

        children: [
          const Gap(70),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
            height: mediaQuery.height * 0.27,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(-2, 3),
                  ),
                ],
                border: Border.all(
                  color: theme.withAlpha(20),
                )),
            child: FlutterMap(
                options: MapOptions(
                  /// The initial center is the user location
                  initialCenter: userLocation,
                  initialZoom: 16,

                  /// making the map fixed
                  // maxZoom: 16,
                  // minZoom: 16,
                ),
                children: [
                  /// OSM does not track your location, it just provides the map images
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        point: userLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          color: Colors.red,
                          Icons.location_pin,
                        ))
                  ])
                ]),
          ),
          Container(
            height: mediaQuery.height * 0.1,
            width: mediaQuery.width * 0.8,
            padding: EdgeInsets.only(right: 20, top: 34),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: theme,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                if (context.read<LocationProvider>().userLocation != null) {
                  AppKeys.navigatorKey.currentState
                      ?.pushReplacementNamed('/layout');
                  log("Valid");
                }else {
                  log("Invalid");
                }
              },
              child: const Text(
                "Continue",
              ),
            ),
          ),
        ],
      ),
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
