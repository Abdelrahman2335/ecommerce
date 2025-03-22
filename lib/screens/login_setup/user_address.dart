import 'package:ecommerce/models/address_model.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../data/cities.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({super.key,
    });


  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  /// This key manage the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController areaCon = TextEditingController();
  TextEditingController streetCon = TextEditingController();
  String selectedCity = egyptCities[0];

  @override
  void dispose() {
    areaCon.dispose();
    streetCon.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: signUpProvider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Animate(
        effects: [
          FadeEffect(
            duration: Duration(milliseconds: 1000),
          )
        ],
        child: Center(
          child: Form(
            key: formKey,
            child: buildContainer(context, signUpProvider),
          ),
        ),
      ),
    );
  }

  Container buildContainer(BuildContext context,
      SignUpProvider signUpProvider) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(-2, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.70,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.90,
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          children: [
            const Text(
              "Address Information",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "Step ${signUpProvider.counter} of 2",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Row(
              children: [
                Icon(Icons.location_pin),
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
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return "Please Enter a valid area";
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
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return "Please Enter a valid street";
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
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
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
                    }
                  },
                  child: const Text(
                    "Next",
                  ),
                ),
              ],
            ),
            Text("Progress ${signUpProvider.sliderValue.toStringAsFixed(0)}%"),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: SliderComponentShape.noThumb,
              ),
              child: Slider(

                /// Making onChange null this will make the slider read only
                value: signUpProvider.sliderValue,
                onChanged: null,
                min: 0,
                max: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
