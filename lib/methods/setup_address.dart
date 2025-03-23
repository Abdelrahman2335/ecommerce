
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../data/cities.dart';
import '../models/address_model.dart';

String selectedCity = egyptCities[0];

Widget setupAddress(BuildContext context, areaCon, streetCon, user,
    GlobalKey<FormState> formKey) {
  SignUpProvider signUpProvider = context.watch<SignUpProvider>();

  /// Both are the same
  // SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);

  return Column(
    children: [

      Row(
        children: [
          Icon(Icons.location_pin,color: Colors.grey,),
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
              Icons.streetview,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
}
