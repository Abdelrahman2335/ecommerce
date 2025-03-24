import 'package:ecommerce/main.dart';
import 'package:ecommerce/methods/optional_info.dart';
import 'package:ecommerce/methods/setup_address.dart';
import 'package:ecommerce/provider/location_provider.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../methods/setup_user_data.dart';

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

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Using provider like this not the best, in terms of performance.
    ///But we are using the value of the [signUpProvider] many times in the widget tree.
    ///If we use the [Consumer] or [Selector] widget, the code will be hard to read.
    final signUpProvider = context.watch<SignUpProvider>();
    Widget personalContent = setupUserData(
        context, firstController, secondController, user, formKey);
    Widget addressContent =
        setupAddress(context, firstController, secondController, user, formKey);
    int counter = signUpProvider.hasInfo ? 2 : 1;
 counter = context.read<LocationProvider>().nextPageValue ? counter + 1 : counter;
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
              duration: Duration(milliseconds: 500),
            ),
            SlideEffect(
              begin: const Offset(0.14, 0),
              end: const Offset(0, 0),
              duration: Duration(milliseconds: 500),
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
                    "Step $counter of 3",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Gap(7),

                  /// If we have info (phone number) about the user we will show the address form
                  /// if the nextPageValue is true (which will not happen, unless the user went to the address screen) we will show the optional info
                  signUpProvider.hasInfo
                      // true
                      ? addressContent
                      : context.read<LocationProvider>().nextPageValue
                          ? optionalInfo(context, firstController, secondController, user, formKey)
                          : personalContent,
                  Expanded(
                      flex: 2,

                      /// we are using TweenAnimationBuilder to make some animation to the slider.
                      child: TweenAnimationBuilder(
                        tween: Tween(begin: 0, end: signUpProvider.sliderValue),
                        duration: Duration(milliseconds: 1000),
                        builder: (ctx, value, child) => Slider(
                          value: value.toDouble(),

                          /// Making onChange null this will make the slider read only
                          onChanged: null,
                          min: 0,
                          max: 1,
                        ),
                      )),
                ]),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
