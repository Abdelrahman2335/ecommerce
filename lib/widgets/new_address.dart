import 'package:ecommerce/data/cities.dart';
import 'package:flutter/material.dart';

class NewAddress extends StatelessWidget {
  final TextEditingController addressCon;
  final TextEditingController landCon;

  const NewAddress(
      {super.key, required this.addressCon, required this.landCon});

  @override
  Widget build(BuildContext context) {
    String selectedCity = egyptCities[0];
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
                  controller: addressCon,
                  decoration: const InputDecoration(
                    hintText: "Address",
                    contentPadding: EdgeInsets.all(9),
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
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
          const SizedBox(
            height: 19,
          ),
          TextFormField(
            maxLines: 1,
            controller: landCon,
            decoration: const InputDecoration(
              hintText: "More Details",
              contentPadding: EdgeInsets.all(9),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text(
                  "Add Address",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              OutlinedButton(
                onPressed: () {
                  addressCon.clear();
                  landCon.clear();
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
