import 'package:flutter/material.dart';

class XonTheme {
  static const primaryGold = Color(0xFFD4AF37);
  static const darkBg = Color(0xFF0F0F0F);
  
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBg,
    primaryColor: primaryGold,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
    ),
  );
}

