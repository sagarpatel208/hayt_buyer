import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/AdminChat.dart';
import 'package:hayt_buyer/Screens/Cart.dart';
import 'package:hayt_buyer/Screens/Category.dart';
import 'package:hayt_buyer/Screens/Chat.dart';
import 'package:hayt_buyer/Screens/Dashboard.dart';
import 'package:hayt_buyer/Screens/Into.dart';
import 'package:hayt_buyer/Screens/Login.dart';
import 'package:hayt_buyer/Screens/MyProfile.dart';
import 'package:hayt_buyer/Screens/OrderHistory.dart';
import 'package:hayt_buyer/Screens/Search.dart';
import 'package:hayt_buyer/Screens/SignUp.dart';
import 'package:hayt_buyer/Screens/Splash.dart';
import 'package:hayt_buyer/Screens/TermsAndConditions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  StreamSubscription iosSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String Title;
  String bodymessage;
  @override
  void initState() {
    // TODO: implement initState

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Title = message["notification"]["title"];
        bodymessage = message["notification"]["body"];
        //Get.to(OverlayScreen(message))
        print("onMessage  $message");
        showNotification('$Title', '$bodymessage');
      },
      onBackgroundMessage: Platform.isIOS ? null : backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      await showNotification(message['data']['title'], message['data']['body']);
      return Future<void>.value();
    }
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails('com.hayt_buyer',
        'Hayt Buyer Notification', 'Hayt Notification Description',
        priority: Priority.High, importance: Importance.Max, playSound: true);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HAYT Buyer",
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/Login': (context) => Login(),
        '/SignUp': (context) => SignUp(),
        '/Dashboard': (context) => Dashboard(),
        '/Cart': (context) => Cart(),
        '/Chat': (context) => Chat(),
        '/TermsAndConditions': (context) => TermsAndConditions(),
        '/Into': (context) => Into(),
        '/OrderHistory': (context) => OrderHistory(),
        '/Category': (context) => Category(),
        '/Search': (context) => Search(),
        '/MyProfile': (context) => MyProfile(),
        '/AdminChat': (context) => AdminChat(),
      },
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: cnst.appPrimaryMaterialColor,
          accentColor: cnst.appPrimaryMaterialColor,
          buttonColor: cnst.appPrimaryMaterialColor),
    );
  }
}
