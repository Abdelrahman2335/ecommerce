import 'package:ecommerce/main.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:ecommerce/screens/login_setup/user_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.email, required this.password});

  final String email;
  final String password;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  /// This key manage the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

  @override
  void dispose() {
    nameCon.dispose();
    phoneCon.dispose();

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

  Container buildContainer(
      BuildContext context, SignUpProvider signUpProvider) {
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
      height: MediaQuery.of(context).size.height * 0.41,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          children: [
            const Text(
              "Personal Information",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "Step ${signUpProvider.counter} of 2",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.85, // Adjust dynamically

              child: TextFormField(
                /// Make the keyboard capitalize the first letter of each word
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                controller: nameCon,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter Valid a Name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Full Name",
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 370,
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneCon,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter a valid phone number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  icon: Icon(
                    Icons.phone,
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
                    final valid = formKey.currentState!.validate();
                    if (valid) {
                      navigatorKey.currentState?.push(

                        MaterialPageRoute(
                          builder: (context) => UserAddress(
                              email: widget.email,
                              password: widget.password,
                              name: nameCon.text,
                              phone: phoneCon.text),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Next",
                  ),
                ),
              ],
            ),
            Spacer(),
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
