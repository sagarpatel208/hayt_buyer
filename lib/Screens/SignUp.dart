import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../Common/AppServices.dart';
import '../Common/Constants.dart' as cnst;

class SignUp extends StatefulWidget {
  @override
  _signUpValidationState createState() => _signUpValidationState();
}

class _signUpValidationState extends State<SignUp> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtSurname = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtPhone = new TextEditingController();
  TextEditingController edtDOB = new TextEditingController();
  TextEditingController edtPassword = new TextEditingController();
  TextEditingController edtConfirmPassword = new TextEditingController();
  String dob = "";

  ProgressDialog pr;
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  setDob(String Date) {
    var date = Date.toString().split(" ");
    var dt = date[0].split("-");
    String month = "";
    switch (dt[1]) {
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "June";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
    return "${dt[2]} ${month},${dt[0]}";
  }

  _signUpValidation() {
    if (edtName.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter your Name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtSurname.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter your Surname",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtEmail.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter your Email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtPhone.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter your Phone Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (dob == "" || dob == null) {
      Fluttertoast.showToast(
          msg: "Please select your Date of Birth",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtPassword.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter your Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtConfirmPassword.text == "") {
      Fluttertoast.showToast(
          msg: "Please confirm your Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (edtPassword.text != edtConfirmPassword.text) {
      Fluttertoast.showToast(
          msg: "Your Password and Confirm Password not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      print("e");
      _AdminSignUp(); //Navigator.pushReplacementNamed(context, '/Home');
    }
  }

  _AdminSignUp() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();

        FormData d = FormData.fromMap({
          "name": edtName.text,
          "surname": edtSurname.text,
          "dob": dob,
          "phoneno": edtPhone.text,
          "email": edtEmail.text,
          "password": edtPassword.text,
        });

        AppServices.BuyreSignUp(d).then((data) async {
          pr.hide();
          if (data.data == "0") {
            Fluttertoast.showToast(
                msg: data.message,
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, '/Login');
          } else {
            Fluttertoast.showToast(
                msg: data.message,
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Hayt Buyer"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/Login');
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 30),
              Text("Create account with us",
                  style: TextStyle(fontSize: 20, color: Colors.black54)),
              SizedBox(height: 30),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtName,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  hintText: "Name",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtSurname,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  hintText: "Surname",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please enter valid Email",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )),
              SizedBox(height: 3),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtEmail,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  hintText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtPhone,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  counterText: "",
                  hintText: "Phone",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(DateTime.now().year - 100, 1, 1),
                      maxTime: DateTime(DateTime.now().year + 1, 12, 31),
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      dob = date.toString();
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dob == "" || dob == null
                              ? "DOB"
                              : setDob(dob.toString()),
                          style: TextStyle(
                            color: dob == "" || dob == null
                                ? Colors.grey.shade600
                                : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),
              SizedBox(
                height: 7,
              ),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtPassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  hintText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password size should minimum 6 character",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )),
              SizedBox(height: 3),
              TextFormField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                cursorColor: cnst.appPrimaryMaterialColor,
                controller: edtConfirmPassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.1),
                  hintText: "Confirm Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                elevation: 5.0,
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                color: cnst.appPrimaryMaterialColor,
                child: new Text('CREATE ACCOUNT',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {
                  _signUpValidation();
                },
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/Login');
                },
                child: Text(
                  "Already Registered Sign in now",
                  style: TextStyle(
                      fontSize: 15, color: cnst.appPrimaryMaterialColor),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
}
