import 'dart:developer';

import 'package:ecommerce/main.dart';
import 'package:ecommerce/presentation/widgets/setup_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../provider/user_data_viewmodel.dart';
import '../../provider/login_viewmodel.dart';
import '../../provider/location_viewmodel.dart';

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

    Widget addressContent =
        setupAddress(context, firstController, secondController, user, formKey);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool canPop, dynamic result) {
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("You can't go back 😈")),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<LoginViewModel>(context, listen: false).signOut();
              },
              icon: const Icon(Icons.exit_to_app_outlined),
            ),
          ],
        ),
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
              height: MediaQuery.of(context).size.height * 0.54,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(children: [
                  Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Step 1 of 3",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Gap(7),
                  Expanded(
                      flex: 2,

                      /// we are using TweenAnimationBuilder to make some animation to the slider.
                      child: TweenAnimationBuilder(
                        tween: Tween(begin: 0, end: 0.5),
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
