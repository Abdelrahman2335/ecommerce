import 'package:ecommerce/widgets/new_address.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool hidePass = true;
  TextEditingController userCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController rePassCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController landCon = TextEditingController();
  final firebase = FirebaseAuth.instance;

  @override
  void dispose() {
    userCon.dispose();
    passCon.dispose();
    rePassCon.dispose();
    addressCon.dispose();
    landCon.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    // GlobalKey formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 14),
          child:
          Text("Profile", style: Theme.of(context).textTheme.labelMedium),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
             Provider.of<LoginProvider>(context, listen: false).signOut();
            },
            icon: const Icon(Icons.exit_to_app_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Badge(
                  padding: const EdgeInsets.all(0),
                  offset: const Offset(-24, -14),
                  backgroundColor: Theme.of(context).primaryColor,
                  alignment: Alignment.bottomRight,
                  label: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  child: const CircleAvatar(
                    maxRadius: 50,
                  ),
                ),
              ),
              Gap(29),
              const Text(
                "Personal Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Gap(18),
              TextFormField(
                controller: userCon,
                decoration: const InputDecoration(
                  hintText: "Email",
                  contentPadding: EdgeInsets.all(9),
                ),
              ),
              Gap(26),
              TextFormField(
                obscureText: hidePass,
                controller: passCon,
                decoration: InputDecoration(
                  labelText: "Password",
                  contentPadding: const EdgeInsets.all(9),
                  suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        },
                        icon: hidePass
                            ? const FaIcon(Icons.remove_red_eye_outlined)
                            : const FaIcon(Icons.remove_red_eye_sharp),
                      )),
                ),
              ),
              Gap(26),
              TextFormField(
                obscureText: hidePass,
                controller: rePassCon,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  contentPadding: const EdgeInsets.all(9),
                  suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        },
                        icon: hidePass
                            ? const FaIcon(Icons.remove_red_eye_outlined)
                            : const FaIcon(Icons.remove_red_eye_sharp),
                      )),
                ),
              ),
              Gap(34),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    context: context,

                    /// Note: The ctx is the context for the BottomSheet, but context is refer to the main context.
                    builder: (ctx) {
                      return SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: NewAddress(
                            addressCon: addressCon,
                            landCon: landCon,
                          ));
                    },
                  );
                },
                child: const Center(child: Text("Change Address")),
              ),
              Gap(24),
              CustomButton(pressed: () {}, text: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}