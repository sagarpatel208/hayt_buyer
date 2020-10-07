import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/ClassList.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = true;
  ProgressDialog pr;
  String selectedCity = "", selectedCityId = "";
  List<String> _city = [], _cityId = [];
  StreamSubscription iosSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcm = "";
  List<String> added = [];
  String currentText = "";
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<City>> key = new GlobalKey();
  static List<City> city = new List<City>();

  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    _city.add("Select City");
    _cityId.add("");

    _getAllCity();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    _configureNotification();
    super.initState();
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails('com.hayt_buyer',
        'Hayt Buyer Notification', 'Hayt Notification Description',
        priority: Priority.High, importance: Importance.Max, playSound: true);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }

  _configureNotification() async {
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) async {
        await _getFCMToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      await _getFCMToken();
    }
  }

  _getFCMToken() async {
    _firebaseMessaging.getToken().then((String token) {
      setState(() {
        fcm = token;
      });
    });
  }

  _getAllCity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetAllCity({}).then((data) async {
          if (data.length > 0) {
            city = loadCity(data);
            for (int i = 0; i < city.length; i++) {
              print("city: ${city[i].id},${city[i].name}");
            }
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("${cnst.NoInternet}");
    }
  }

  static List<City> loadCity(cityList) {
    return cityList.map<City>((json) => City.fromJson(json)).toList();
  }

  Widget row(City city) {
    return Text(
      city.name,
      style: TextStyle(fontSize: 16.0),
    );
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
    } else if (selectedCity == "" || selectedCity == null) {
      Fluttertoast.showToast(
          msg: "Please select City",
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
      print("e:: ${fcm}");
      _buyerSignUp(); //Navigator.pushReplacementNamed(context, '/Home');
    }
  }

  _buyerSignUp() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "name": edtName.text,
          "surname": edtSurname.text,
          "dob": dob,
          "phoneno": edtPhone.text,
          "email": edtEmail.text,
          "password": edtPassword.text,
          "city_id": selectedCity
        });

        AppServices.BuyreSignUp(d).then((data) async {
          pr.hide();
          if (data.data == "0") {
            _buyerLogin();
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
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("${cnst.NoInternet}");
    }
  }

  _buyerLogin() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        FormData d = FormData.fromMap({
          "email": edtEmail.text,
          "password": edtPassword.text,
          "fcm_token": fcm,
        });

        AppServices.BuyerLogin(d).then((data) async {
          pr.hide();
          if (data.data == "0") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(cnst.Session.id, data.value[0]["id"]);
            prefs.setString(cnst.Session.firstname, data.value[0]["firstname"]);
            prefs.setString(cnst.Session.lastname, data.value[0]["lastname"]);
            prefs.setString(cnst.Session.dob, data.value[0]["dob"]);
            prefs.setString(cnst.Session.phone, data.value[0]["phone"]);
            prefs.setString(cnst.Session.email, data.value[0]["email"]);
            prefs.setString(cnst.Session.city, data.value[0]["city_id"]);
            prefs.setString(cnst.Session.password, edtPassword.text);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Dashboard', (Route<dynamic> route) => false);
          } else {
            Fluttertoast.showToast(
                msg: "Invalid username or password",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("${cnst.NoInternet}");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).padding.top + 30),
                        Text("Create account with us",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54)),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                minTime:
                                    DateTime(DateTime.now().year - 100, 1, 1),
                                maxTime:
                                    DateTime(DateTime.now().year + 1, 12, 31),
                                onChanged: (date) {}, onConfirm: (date) {
                              setState(() {
                                dob = date.toString();
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                        /*Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 20),
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.grey, style: BorderStyle.solid, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: <String>[
                      'Select City',
                      'Surat',
                      'Delhi',
                      'Benguluru',
                      'Mumbai',
                      'Vadodara',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: selectedCity,
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                ),
              ),*/
                        searchTextField = AutoCompleteTextField<City>(
                          key: key,
                          clearOnSubmit: false,
                          suggestions: city,
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                            hintText: "Select City",
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          itemFilter: (item, query) {
                            return item.name
                                .toLowerCase()
                                .startsWith(query.toLowerCase());
                          },
                          itemSorter: (a, b) {
                            return a.name.compareTo(b.name);
                          },
                          itemSubmitted: (item) {
                            setState(() {
                              searchTextField.textField.controller.text =
                                  item.name;
                              selectedCity = item.name;
                              selectedCityId = item.id;
                            });
                          },
                          itemBuilder: (context, item) {
                            return row(item);
                          },
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          elevation: 5.0,
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          color: cnst.appPrimaryMaterialColor,
                          child: new Text('CREATE ACCOUNT',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
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
                                fontSize: 15,
                                color: cnst.appPrimaryMaterialColor),
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
