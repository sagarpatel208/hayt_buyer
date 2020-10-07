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
  void initState() {
    setData();
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

  setData() async {
    String to = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString(cnst.Session.language);
    /*if (language == "" || language == null) {
      prefs.setString(cnst.Session.language, "en");
      to = "en";
    } else {
      to = prefs.getString(cnst.Session.language);
    }
    print("tooo: ${to}");
    final translator = GoogleTranslator();
    var t = await translator.translate("Sagar", from: 'en', to: 'en');
    print("SagarssS:::::: ${t.text.toString()}");
    if (to == "en") {
      var translation =
          await translator.translate("No Data Available", from: 'en', to: 'en');
      cnst.NoData = translation.text.toString();
      var translation1 = await translator.translate("Something went wrong.",
          from: 'en', to: 'en');
      cnst.SomethingWrong = translation1.text.toString();
      var translation2 = await translator.translate("No Internet Connection.",
          from: 'en', to: 'en');
      cnst.NoInternet = translation2.text.toString();
    } else if (to == "tk") {
      var translation =
          await translator.translate("No Data Available", from: 'en', to: 'tk');
      cnst.NoData = translation.text.toString();
      var translation1 = await translator.translate("Something went wrong.",
          from: 'en', to: 'tk');
      cnst.SomethingWrong = translation1.text.toString();
      var translation2 = await translator.translate("No Internet Connection.",
          from: 'en', to: 'tk');
      cnst.NoInternet = translation2.text.toString();
    } else if (to == "ru") {
      var translation =
          await translator.translate("No Data Available", from: 'en', to: 'ru');
      cnst.NoData = translation.text.toString();
      var translation1 = await translator.translate("Something went wrong.",
          from: 'en', to: 'ru');
      cnst.SomethingWrong = translation1.text.toString();
      var translation2 = await translator.translate("No Internet Connection.",
          from: 'en', to: 'ru');
      cnst.NoInternet = translation2.text.toString();
    }*/
    cnst.SomethingWrong = "Something went wrong.";
    cnst.NoData = "No Data Available";
    cnst.NoInternet = "No Internet Connection.";
    print("no data: ${cnst.NoData}");
    print("wrong: ${cnst.SomethingWrong}");
    print("no internet: ${cnst.NoInternet}");
  }

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
}
