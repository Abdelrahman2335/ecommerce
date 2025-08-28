import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/global_keys.dart';
import '../../../features/auth/presentation/manager/auth_provider.dart';
import '../../../features/auth/presentation/manager/user_data_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class NewUserInfoScreen extends StatefulWidget {
  const NewUserInfoScreen({super.key});

  @override
  State<NewUserInfoScreen> createState() => _NewUserInfoScreenState();
}

class _NewUserInfoScreenState extends State<NewUserInfoScreen> {
  final GlobalKey<FormState> formKey = AppKeys.userDataFormKey;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'^[0-9+]+$');

    List genders = const ["male", "female"];
    String selectedGender = genders[0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context,).signOut();
            },
            icon: Icon(PhosphorIcons.signOut()),
          ),
        ],
      ),
      body: Animate(
        effects: [
          FadeEffect(
            duration: Duration(milliseconds: 600),
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Gap(
                    70,
                  ),
                  CustomField(
                    textCapitalization: TextCapitalization.words,
                    label: "Full Name",
                    icon: Icon(PhosphorIcons.user()),
                    controller: nameController,
                    isSecure: false,
                    isValid: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Valid a Name";
                      }
                      return null;
                    },
                  ),
                  const Gap(
                    21,
                  ),
                  CustomField(
                    keyboardType: TextInputType.phone,
                    label: "Phone Number",
                    maxLength: 11,
                    icon: Icon(PhosphorIcons.phone()),
                    controller: phoneController,
                    isSecure: false,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null,
                    isValid: (String? value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          regex.hasMatch(value) == false ||
                          value.length < 10) {
                        return "Please Enter a valid phone number";
                      }
                      return null;
                    },
                  ),
                  const Gap(
                    21,
                  ),
                  CustomField(
                    keyboardType: TextInputType.phone,
                    label: "Age",
                    icon: Icon(PhosphorIcons.cake()),
                    controller: ageController,
                    isSecure: false,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null,
                    isValid: (String? value) {
                      if (value == null ||
                          regex.hasMatch(value) == false ||
                          value.length > 10) {
                        return "Please Enter a valid age";
                      }
                      return null;
                    },
                  ),
                  const Gap(21),

                  /// The dropdown button for the cities.
                  /// using Expanded to make the dropdown button take the remaining space (Important)

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Icon(PhosphorIcons.genderMale()),
                      ),
                    ),
                    items: [
                      for (String gender in genders)
                        DropdownMenuItem(
                          value: gender,

                          /// [FittedBox] adjusts its child based on the available space while maintaining the child’s aspect ratio.
                          child: FittedBox(
                              child: Text(
                            gender,

                            /// if the text is too long, it will be ellipsis (...)
                            overflow: TextOverflow.ellipsis,
                          )),
                        ),
                    ],
                    value: selectedGender,
                    onChanged: (value) {
                      selectedGender = value!;
                    },
                  ),

                  const Gap(26),
                  Selector<UserViewModel, bool>(
                      selector: (_, selectedValue) => selectedValue.isLoading,
                      builder: (context, loading, child) {
                        return !loading
                            ? CustomButton(
                                pressed: () {
                                  final valid =
                                      formKey.currentState!.validate();
                                  if (valid) {
                                    context.read<UserViewModel>().personalInfo(
                                        nameController.text,
                                        phoneController.text,
                                        selectedGender,
                                        ageController.text);
                                  }
                                },
                                text: "Continue",
                              )
                            : Center(
                                child: const CircularProgressIndicator(),
                              );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
