import 'package:ecommerce/data/cities.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:ecommerce/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey();
    TextEditingController userCon = TextEditingController();
    TextEditingController passCon = TextEditingController();
    TextEditingController addressCon = TextEditingController();
    String selectedCity = egyptCities[0];
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 14),
          child:
              Text("Profile", style: Theme.of(context).textTheme.labelMedium),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const CircleAvatar(

                  maxRadius: 50,
                ),
                const SizedBox(
                  height: 29,
                ),
                const Text(
                  "Personal Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomField(
                    label: "User Name",
                    icon: const FaIcon(Icons.person),
                    controller: userCon,
                    isSecure: false),
                const SizedBox(
                  height: 26,
                ),
                CustomField(
                    label: "Password",
                    icon: const FaIcon(Icons.lock),
                    controller: passCon,
                    isSecure: true),
                const SizedBox(
                  height: 26,
                ),
                CustomField(
                    label: "Confirm Password",
                    icon: const FaIcon(Icons.lock),
                    controller: passCon,
                    isSecure: true),
                const SizedBox(height: 19,),
                const Divider(endIndent: 20,thickness: 2,color: Colors.grey,),
                const SizedBox(
                  height: 19,
                ),
                const Text("Address Details"),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                  items: [
                    for (String city in egyptCities)
                      DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ),
                  ],
                  value: selectedCity,
                  onChanged: (value) {
                    selectedCity = value!;
                  },
                ),const SizedBox(
                  height: 16,
                ),
                CustomField(
                    label: "Address",
                    icon: const FaIcon(Icons.house),
                    controller: addressCon,
                    isSecure: false),

                const SizedBox(
                  height: 19,
                ),
                CustomButton(pressed: () {}, text: "Save"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
