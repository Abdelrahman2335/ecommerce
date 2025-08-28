import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class AppTextStyles {
  // Title styles
  static TextStyle title29(BuildContext context) => GoogleFonts.poppins(
        fontSize: 29,
        color: AppColor.getPrimaryTextColor(context),
      );

  static TextStyle title22(BuildContext context) => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.normal,
        color: AppColor.getPrimaryTextColor(context),
      );

  static TextStyle title18(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColor.getBackgroundColor(context),
      );

  // Label styles
  static TextStyle label14(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.getBackgroundColor(context),
      );

  static TextStyle label16(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColor.getBackgroundColor(context),
      );

  static TextStyle label12(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColor.getSecondaryTextColor(context),
      );

  // Body styles
  static TextStyle body16(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColor.getSecondaryTextColor(context),
      );

  static TextStyle body14(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.getPrimaryTextColor(context),
      );

  static TextStyle body12(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: AppColor.getPrimaryTextColor(context),
      );

  // Custom utility styles
  static TextStyle text26(BuildContext context) => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColor.getPrimaryTextColor(context),
      );

  static TextStyle text19(BuildContext context) => GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColor.getPrimaryTextColor(context),
      );

  static TextStyle text16 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Button text styles
  static TextStyle button16(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle button14(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Price text styles
  static TextStyle price18(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.primary,
      );

  static TextStyle discount14(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.getSecondaryTextColor(context),
        decoration: TextDecoration.lineThrough,
      );
}
