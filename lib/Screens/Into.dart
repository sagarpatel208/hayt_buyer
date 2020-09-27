import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;

class Into extends StatefulWidget {
  @override
  _IntoState createState() => _IntoState();
}

class _IntoState extends State<Into> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Introduction",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 200),
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: cnst.appPrimaryMaterialColor, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              elevation: 5.0,
              height: 50,
              minWidth: MediaQuery.of(context).size.width / 1.3,
              color: cnst.appPrimaryMaterialColor,
              child: new Text('LOGIN',
                  style: new TextStyle(fontSize: 16.0, color: Colors.white)),
              onPressed: () {
                Navigator.pushNamed(context, '/Login');
              },
            ),
          ),
          SizedBox(height: 50),
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: cnst.appPrimaryMaterialColor, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              elevation: 5.0,
              height: 30,
              minWidth: MediaQuery.of(context).size.width / 1.3,
              child: new Text('SIGN UP',
                  style: new TextStyle(
                      fontSize: 16.0, color: cnst.appPrimaryMaterialColor)),
              onPressed: () {
                Navigator.pushNamed(context, '/SignUp');
              },
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/TermsAndConditions');
            },
            child: Text(
              "Terms & Coditions",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ));
  }
}
