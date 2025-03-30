import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomField extends StatefulWidget {
  final bool isSecure;
  final String label;
  final FaIcon icon;
  final TextEditingController controller;

  ///Will use it later
  final String? Function(String?) isValid;

  const CustomField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.isSecure,
    required this.isValid,

  });

  @override
  State<CustomField> createState() => _CustomfieldState();
}

class _CustomfieldState extends State<CustomField> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isSecure ? hidePass : false,
      maxLines: 1,
      controller: widget.controller,
      validator: widget.isValid,
      onSaved: (value) => widget.controller.text = value!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelText: widget.label,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15),
          child: widget.icon,
        ),
        suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: widget.isSecure
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hidePass = !hidePass;
                      });
                    },
                    icon: hidePass
                        ? const FaIcon(Icons.remove_red_eye_outlined)
                        : const FaIcon(Icons.remove_red_eye_sharp),
                  )
                : null),
      ),
    );
  }
}
