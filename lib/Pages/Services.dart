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
  bool isLoading = false;
  List _vipProducts = [];

  @override
  void initState() {
    getVIPProducts();

    super.initState();
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
            setState(() {
              isLoading = false;
            });
            List service = data.value;
            for (int i = 0; i < service.length; i++) {
              _vipProducts.add(service[i]);
            }
          } else {
            setState(() {
              isLoading = false;
              _vipProducts.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _vipProducts.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _vipProducts.clear();
      });
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : _vipProducts.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _vipProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getListItemUI(index);
                })
            : Center(
                child: Text(
                "No Services Found",
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
                      _vipProducts[index],
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: <Widget>[
            // Max Size
            _vipProducts[index]["picture"] == null ||
                    _vipProducts[index]["picture"] == "" ||
                    _vipProducts[index]["picture"].length == 0
                ? Image.asset(
                    "assets/background.png",
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "assets/background.png",
                    image: _vipProducts[index]["picture"]["images"][0],
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),

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
                    "${_vipProducts[index]["name"]}",
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
