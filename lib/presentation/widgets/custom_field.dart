import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    required this.isSecure,
    required this.isValid,
    this.labelStyle,
    this.buildCounter,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  final bool isSecure;
  final String label;
  final Icon icon;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final InputCounterWidgetBuilder? buildCounter;
  final int? maxLength;

  ///Will use it later
  final String? Function(String?) isValid;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  late TextEditingController _controller;
  bool hidePass = true;
  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter: widget.buildCounter,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.isSecure ? hidePass : false,
      maxLines: 1,
      maxLength: widget.maxLength,
      controller: _controller,
      validator: widget.isValid,
      onSaved: (value) => _controller.text = value!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        labelText: widget.label,
        labelStyle: widget.labelStyle,
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
                        ? Icon(PhosphorIcons.eyeSlash())
                        : Icon(PhosphorIcons.eye()),
                  )
                : null),
      ),
    );
  }
}
