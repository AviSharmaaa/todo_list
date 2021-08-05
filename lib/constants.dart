import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor bgColor = MaterialColor(0xFF0923B0, color);
final kPrimaryColor = Color(0xFF0923B0);
final kTileColor = Color(0xFFD9DDE5);
final kTextColor = Color(0xFF30303D);
final kTextColor2 = Color(0xFFD9DDE5);

final kGradient = LinearGradient(
    colors: [Color(0xFF2A2A72), kPrimaryColor.withOpacity(0.74)]);
