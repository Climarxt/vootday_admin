import 'package:vootday_admin/config/colors.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
        foregroundColor: white,
      ),
    ),
    scaffoldBackgroundColor: white,
    primaryIconTheme: const IconThemeData(color: Colors.black),
    iconTheme: const IconThemeData(color: Colors.black),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: const Color(0xFFE84545))
        .copyWith(background: const Color(0xFFF4F4F4)),
  );
}
