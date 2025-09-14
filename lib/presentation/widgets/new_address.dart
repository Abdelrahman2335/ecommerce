import 'package:ecommerce/data/cities.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../data/models/address_model.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key, required this.addAddress});

  final void Function(AddressModel address) addAddress;

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  TextEditingController areaCon = TextEditingController();
  TextEditingController streetCon = TextEditingController();
  String selectedCity = egyptCities[0];

  @override
  dispose() {
    areaCon.dispose();
    streetCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  maxLength: 50,
                  controller: areaCon,
                  decoration: const InputDecoration(
                    hintText: "Area",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                  ),
                ),
              ),
              const Gap(
                6,
              ),
              Expanded(
                child: DropdownButtonFormField(
                  isDense: true, // Make the dropdown more compact
                  isExpanded: true, // Force the dropdown to fill its container
                  items: [
                    for (String city in egyptCities)
                      DropdownMenuItem(
                          value: city,
                          child: Text(
                            city,
                            overflow: TextOverflow.ellipsis,
                          )),
                  ],
                  value: selectedCity,
                  onChanged: (value) {
                    selectedCity = value!;
                  },
                ),
              ),
            ],
          ),
          const Gap(
            19,
          ),
          TextFormField(
            maxLines: 1,
            controller: streetCon,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: "Street",
              contentPadding: EdgeInsets.all(14),
            ),
          ),
          const Gap(
            26,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.addAddress(AddressModel(
                      city: selectedCity,
                      area: areaCon.text,
                      street: streetCon.text));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text(
                  "Add Address",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Gap(
                14,
              ),
              OutlinedButton(
                onPressed: () {
                  areaCon.clear();
                  streetCon.clear();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
