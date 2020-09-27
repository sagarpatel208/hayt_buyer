import 'package:flutter/material.dart';

const String API_URL = "http://haytadmin.thecompletesoftech.com/index.php/API/";
const String INR = "₹";
Map<int, Color> appPrimaryColors = {
  50: Color.fromRGBO(27, 9, 84, .1),
  100: Color.fromRGBO(27, 9, 84, .2),
  200: Color.fromRGBO(27, 9, 84, .3),
  300: Color.fromRGBO(27, 9, 84, .4),
  400: Color.fromRGBO(27, 9, 84, .5),
  500: Color.fromRGBO(27, 9, 84, .6),
  600: Color.fromRGBO(27, 9, 84, .7),
  700: Color.fromRGBO(27, 9, 84, .8),
  800: Color.fromRGBO(27, 9, 84, .9),
  900: Color.fromRGBO(27, 9, 84, 1),
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFF1b0954, appPrimaryColors);

class Session {
  static const String id = "id";
  static const String firstname = "firstname";
  static const String lastname = "lastname";
  static const String shopname = "shopname";
  static const String dob = "dob";
  static const String phone = "phone";
  static const String email = "email";
  static const String password = "password";
  static const String status = "status";
  static const String lagunage = "language";
  static const String setLagunage = "setLagunage";
}
