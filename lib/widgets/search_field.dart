
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

TextField searchField() {
  return TextField(
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(16),

      hintText: "Search any Product..",
      hintStyle: const TextStyle(color: Color(0xA8575757),),
      /// Note if you don't want to make any OutlineBorder so you HAVE to write the next line.
      border: InputBorder.none,

      /// then if you want to make the text field circle you HAVE to write the following lines.
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0x0a000000),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0x0a000000),
        ),
      ),
      fillColor: const Color(0x0a000000),
      filled: true,
      prefixIcon: const Icon(
        FontAwesomeIcons.magnifyingGlass,
        size: 16,
        color: Color(0xFFBBBBBB),
      ),
      suffixIcon: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.mic_none_rounded,
          size: 23,
          color: Color(0xFFBBBBBB),

        ),
      ),

    ),
  );
}