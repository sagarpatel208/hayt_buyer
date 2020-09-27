import 'dart:async';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Pages/Favourite.dart';
import 'package:hayt_buyer/Pages/Home.dart';
import 'package:hayt_buyer/Pages/Profile.dart';
import 'package:hayt_buyer/Pages/Services.dart';
import 'package:hayt_buyer/Pages/Timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  PageController _pageController;
  StreamSubscription iosSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String selLang = "";
  @override
  void initState() {
    super.initState();
    _getLocal();
    _configureNotification();
    _pageController = PageController();
  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selLang = prefs.getString(cnst.Session.lagunage);
    });
    if (selLang != null && selLang != "") {}
  }

  _onSelectLanguage(Object value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cnst.Session.lagunage, value);
    setState(() {
      selLang = value;
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Dashboard', (Route<dynamic> route) => false);
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

  _getFCMToken() {
    _firebaseMessaging.getToken().then((String token) {
      print("token: ${token}");
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          onSelected: _onSelectLanguage,
          itemBuilder: (context) {
            var list = List<PopupMenuEntry<Object>>();
            list.add(
              PopupMenuItem(
                enabled: selLang == "en" ? false : true,
                child: Text("English"),
                value: "en",
              ),
            );
            list.add(
              PopupMenuItem(
                enabled: selLang == "tk" ? false : true,
                child: Text("Turkmen"),
                value: "tk",
              ),
            );
            list.add(
              PopupMenuItem(
                enabled: selLang == "ru" ? false : true,
                child: Text("Russian"),
                value: "ru",
              ),
            );
            return list;
          },
          icon: Icon(
            Icons.language,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Cart');
            },
          ),
          IconButton(
            icon: Icon(Icons.apps, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Category');
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Search');
            },
          ),
          /* IconButton(
            icon: Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Chat');
            },
          ),*/
          /*IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Login', (Route<dynamic> route) => false);
            },
          ),*/
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Home(),
            Services(),
            Timeline(),
            Favourite(),
            Profile()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: cnst.appPrimaryMaterialColor[500],
              title: Text('Home'),
              icon: Icon(
                Icons.home,
                color: cnst.appPrimaryMaterialColor,
              )),
          BottomNavyBarItem(
              activeColor: cnst.appPrimaryMaterialColor[500],
              title: Text('Services'),
              icon: Icon(
                Icons.spa,
                color: cnst.appPrimaryMaterialColor,
              )),
          BottomNavyBarItem(
              activeColor: cnst.appPrimaryMaterialColor[500],
              title: Text('Timeline'),
              icon: Icon(
                Icons.timeline,
                color: cnst.appPrimaryMaterialColor,
              )),
          BottomNavyBarItem(
              activeColor: cnst.appPrimaryMaterialColor[500],
              title: Text('Favorite'),
              icon: Icon(
                Icons.favorite,
                color: cnst.appPrimaryMaterialColor,
              )),
          BottomNavyBarItem(
              activeColor: cnst.appPrimaryMaterialColor[500],
              title: Text('Profile'),
              icon: Icon(
                Icons.person,
                color: cnst.appPrimaryMaterialColor,
              )),
        ],
      ),
    );
  }
}
