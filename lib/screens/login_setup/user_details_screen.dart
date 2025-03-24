import 'package:ecommerce/main.dart';
import 'package:ecommerce/methods/setup_address.dart';
import 'package:ecommerce/provider/location_provider.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../methods/setup_user_data.dart';
import '../../models/address_model.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  /// This key manage the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    GetCurrentLocationProvider locationProvider = context.watch<GetCurrentLocationProvider>();
    Widget personalContent = setupUserData(
        context, firstController, secondController, user, formKey);
    Widget addressContent =
        setupAddress(context, firstController, secondController, user, formKey);
    int counter = signUpProvider.hasInfo ? 2 : 1;

    /// counter for the steps
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool canPop, dynamic result) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("You can't go back 😈")),
        );
      },
      child: Scaffold(
        body: Animate(
          effects: [
            FadeEffect(
              duration: Duration(milliseconds: 1000),
            ),
            SlideEffect(
              begin: const Offset(0.14, 0),
              end: const Offset(0, 0),
              duration: Duration(milliseconds: 1000),
            )
          ],
          child: Center(
              child: Form(
            key: formKey,
            child: Container(
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
              height: signUpProvider.hasInfo
                  ? MediaQuery.of(context).size.height * 0.54
                  : MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(children: [
                  Text(
                    signUpProvider.hasInfo
                        ? "Address Information"
                        : "Personal Information",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Step $counter of 2",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  signUpProvider.isLoading
                      // true
                      ? Center(
                          heightFactor: 7,
                          child: LoadingAnimationWidget.inkDrop(
                              color: Theme.of(context).primaryColor, size: 34),
                        )
                      :
                  signUpProvider.hasInfo
                  // true
                          ? addressContent
                          : personalContent,

                  locationProvider.isGettingLocation ?

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        /// for now we will navigate ro layout, but next we will edit this page to go to the optional info page (age, gender)
                        navigatorKey.currentState?.pushNamed('/layout');
                      },
                      child: const Text(
                        "Next",
                      ),
                    ),
                  ) : SizedBox(),
                  Expanded(
                    flex: 2,
                    child: Slider(
                      value: signUpProvider.sliderValue,

                      /// Making onChange null this will make the slider read only
                      onChanged: null,
                      min: 0,
                      max: 1,
                    ),
                  ),
                ]),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
