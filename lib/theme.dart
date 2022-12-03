import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/main.dart';

ThemeData themeProject(Color primaryTextColor) {
  return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(
            color: secondaryTextColor,
          )),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryVariant: primaryVariant,
        background: const Color(0xffF3F5F8),
        onSurface: primaryTextColor,
        onBackground: primaryTextColor,
        secondary: primaryColor,
        onSecondary: Colors.white,
      ));
}