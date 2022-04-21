import 'package:flutter/material.dart';

class CustomColors {
  static Color iconLightColor = const Color.fromRGBO(244, 63, 94, 0.7);
  static Color buttonLightColor = const Color.fromRGBO(244, 63, 94, 0.1);
  static Color accentColor = const Color(0xFFF43F5E);
  static Color blackTextColor = const Color(0xFF09101D);
  static Color grayTextInputBorderColor = const Color(0xFFC7CAD1);
  static Color greyColor = const Color(0xFF393E46);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF7E95), Color(0xFFFF1843)],
    stops: [-0.012, 0.9988],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
