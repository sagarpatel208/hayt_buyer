import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 200,
          width: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString(cnst.Session.id);
      if (id != null && id != "") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Dashboard', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/Into', (Route<dynamic> route) => false);
      }
    });
  }
}
