import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Pages/Favourite.dart';
import 'package:hayt_buyer/Pages/Home.dart';
import 'package:hayt_buyer/Pages/Profile.dart';
import 'package:hayt_buyer/Pages/Services.dart';
import 'package:hayt_buyer/Pages/Timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  PageController _pageController;
  String home = "Home",
      services = "Services",
      timeline = "Timeline",
      favorite = "Favorite",
      profile = "Profile";
  String selLanguage = "";
  DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //_setTitle();
  }

  _setTitle() {
    AppServices.Transalate("Home").then((data) async {
      setState(() {
        home = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Services").then((data) async {
      setState(() {
        services = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Timeline").then((data) async {
      setState(() {
        timeline = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Favorite").then((data) async {
      setState(() {
        favorite = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Profile").then((data) async {
      setState(() {
        profile = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    _getLocal();
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

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selLanguage = prefs.getString(cnst.Session.language);
    });
  }

  _onSelectLanguage(Object value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cnst.Session.language, value);
    setState(() {
      selLanguage = value;
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Dashboard', (Route<dynamic> route) => false);
    //  _setData();
  }

  _setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString(cnst.Session.language);
    final translator = GoogleTranslator();
    var translation = await translator.translate("No Data Available",
        from: 'en', to: language);
    cnst.NoData = translation.text.toString();
    var translation1 = await translator.translate("Something went wrong.",
        from: 'en', to: language);
    cnst.SomethingWrong = translation1.text.toString();
    var translation2 = await translator.translate("No Internet Connection.",
        from: 'en', to: language);
    cnst.NoInternet = translation2.text.toString();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Dashboard', (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit app");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton(
            onSelected: _onSelectLanguage,
            itemBuilder: (context) {
              var list = List<PopupMenuEntry<Object>>();
              list.add(
                PopupMenuItem(
                  enabled: selLanguage == "en" ? false : true,
                  child: Text("English"),
                  value: "en",
                ),
              );
              list.add(
                PopupMenuItem(
                  enabled: selLanguage == "tk" ? false : true,
                  child: Text("Turkmen"),
                  value: "tk",
                ),
              );
              list.add(
                PopupMenuItem(
                  enabled: selLanguage == "ru" ? false : true,
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
                title: Text('${home}'),
                icon: Icon(
                  Icons.home,
                  color: cnst.appPrimaryMaterialColor,
                )),
            BottomNavyBarItem(
                activeColor: cnst.appPrimaryMaterialColor[500],
                title: Text('${services}'),
                icon: Icon(
                  Icons.spa,
                  color: cnst.appPrimaryMaterialColor,
                )),
            BottomNavyBarItem(
                activeColor: cnst.appPrimaryMaterialColor[500],
                title: Text('${timeline}'),
                icon: Icon(
                  Icons.timeline,
                  color: cnst.appPrimaryMaterialColor,
                )),
            BottomNavyBarItem(
                activeColor: cnst.appPrimaryMaterialColor[500],
                title: Text('${favorite}'),
                icon: Icon(
                  Icons.favorite,
                  color: cnst.appPrimaryMaterialColor,
                )),
            BottomNavyBarItem(
                activeColor: cnst.appPrimaryMaterialColor[500],
                title: Text('${profile}'),
                icon: Icon(
                  Icons.person,
                  color: cnst.appPrimaryMaterialColor,
                )),
          ],
        ),
      ),
    );
  }
}
