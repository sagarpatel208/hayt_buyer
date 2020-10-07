import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/CartDBHelper.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  bool isLoading = true;
  List _favList = [];

  @override
  void initState() {
    _getFav();
  }

  _getFav() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);

        AppServices.GetFav(id, {}).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.data == "0") {
            setState(() {
              _favList = data.value;
            });
            print("d: ${_favList}");
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
        : _favList.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _favList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavouriteComponents(_favList[index]);
                })
            : Center(
                child: Text(
                "No Products in Favorite",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
  }
}

class FavouriteComponents extends StatefulWidget {
  var _favItem;
  FavouriteComponents(this._favItem);
  @override
  _FavouriteComponentsState createState() => _FavouriteComponentsState();
}

class _FavouriteComponentsState extends State<FavouriteComponents> {
  final _cartDBHelper = CartDBHelper.instance;
  ProgressDialog pr;
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  void _insertCart(
      String pid, String name, String sellingPrice, String picture) async {
    pr.show();
    // row to insert
    Map<String, dynamic> row = {
      CartDBHelper.columnPID: pid,
      CartDBHelper.columnName: name,
      CartDBHelper.columnQuantity: "1",
      CartDBHelper.columnSelleingPrice: sellingPrice,
      CartDBHelper.columnPicture: picture,
    };
    final id = await _cartDBHelper.insert(row);
    print('inserted row id: $id');
    Fluttertoast.showToast(
        msg: "Product added in Cart",
        textColor: cnst.appPrimaryMaterialColor[700],
        backgroundColor: Colors.grey.shade100,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
    pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          widget._favItem['picture'] == null ||
                  widget._favItem['picture'] == "" ||
                  widget._favItem['picture'].length > 0
              ? Image.asset(
                  "assets/background.png",
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget._favItem['picture']["images"][0],
                  height: 70,
                  width: 70,
                  fit: BoxFit.fill,
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._favItem["name"],
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "${cnst.INR} ${widget._favItem["sellingprice"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget._favItem["sellingprice"]
                              .toString()
                              .contains("-") ||
                          widget._favItem["sellingprice"]
                              .toString()
                              .contains("/")) {
                        Fluttertoast.showToast(
                            msg: "Product can't added in Cart",
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT);
                      } else {
                        _insertCart(
                            widget._favItem["id"].toString(),
                            widget._favItem["name"].toString(),
                            widget._favItem["sellingprice"].toString(),
                            widget._favItem["picture"].toString());
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
