import 'package:ecommerce/core/widgets/custom_field.dart';
import 'package:ecommerce/data/cities.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManualAddressForm extends StatelessWidget {
  const ManualAddressForm({
    super.key,
    required this.formKey,
    required this.onCurrentLocationPressed,
    required this.onNextPressed,
    required this.onCityChanged,
    required this.onAreaChanged,
    required this.onStreetChanged,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onCurrentLocationPressed;
  final VoidCallback onNextPressed;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<String> onStreetChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;

    return Padding(
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
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
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
              initialValue: egyptCities.first,
              onChanged: (value) {
                if (value == null) return;
                onCityChanged(value);
              },
            ),

            CustomField(
              label: 'Enter you area name',
              isSecure: false,
              icon: Icon(PhosphorIcons.buildingApartment()),
              onChanged: onAreaChanged,
            ),

            CustomField(
              label: 'Enter you street',
              icon: Icon(PhosphorIcons.roadHorizon()),
              isSecure: false,
              onChanged: onStreetChanged,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),

                    /// Change the padding of the button (the space inside the button)
                    /// Don't forget to change other buttons as well
                  ),
                  onPressed: onCurrentLocationPressed,
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
                      onNextPressed();
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
  }
}
