import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ServiceDetails.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  bool isLoading = true;
  List _services = [];

  @override
  void initState() {
    getVIPProducts();
    super.initState();
  }

  translate(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String name = "",
          placeofservice = "",
          city = "",
          district = "",
          description = "";
      AppServices.Transalate(pr[i]["name"]).then((data) async {
        name = data.data;
        setState(() {
          pr[i]["name"] = name;
        });
      }, onError: (e) {
        showMsg("sa${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["placeofservice"]).then((data) async {
        placeofservice = data.data;
        setState(() {
          pr[i]["placeofservice"] = placeofservice;
        });
      }, onError: (e) {
        showMsg("sa${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["city"]).then((data) async {
        city = data.data;
        setState(() {
          pr[i]["city"] = city;
        });
      }, onError: (e) {
        showMsg("sa${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["district"]).then((data) async {
        district = data.data;
        setState(() {
          pr[i]["district"] = district;
        });
      }, onError: (e) {
        showMsg("sa${cnst.SomethingWrong}");
      });

      AppServices.Transalate(pr[i]["description"]).then((data) async {
        description = data.data;
        setState(() {
          pr[i]["description"] = description;
        });
      }, onError: (e) {
        showMsg("sa${cnst.SomethingWrong}");
      });
    }
    setState(() {
      _services = pr;
    });
  }

  getVIPProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetAllServices({}).then((data) async {
          if (data.data == "0") {
            List service = data.value;
            /*  List dt = [];
            for (int i = 0; i < service.length; i++) {
              dt.add(service[i]);
            }
            if (dt.length > 0) {
              await translate(dt);
            } else {
              _services.clear();
            }*/
            setState(() {
              isLoading = false;
              _services = data.value;
            });
          } else {
            setState(() {
              isLoading = false;
              _services.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _services.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _services.clear();
      });
      showMsg("${cnst.NoInternet}");
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : _services.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _services.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getListItemUI(index);
                })
            : Center(
                child: Text(
                "${cnst.NoData}",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
  }

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetails(
                      _services[index],
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: <Widget>[
            // Max Size
            _services[index]["picture"] == null ||
                    _services[index]["picture"] == "" ||
                    _services[index]["picture"].length == 0 ||
                    _services[index]["picture"]["images"].length == 0 ||
                    _services[index]["picture"]["images"] == null
                ? Image.asset(
                    "assets/background.png",
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "assets/background.png",
                    image: _services[index]["picture"]["images"][0],
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 7, bottom: 7),
                  child: Text(
                    "${_services[index]["name"]}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
