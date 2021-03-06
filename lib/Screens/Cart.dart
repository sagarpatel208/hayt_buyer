import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/CartDBHelper.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final dbHelper = CartDBHelper.instance;
  List _cart = [];
  bool isLoading = true;
  int total = 0;
  ProgressDialog pr;
  String title = "Cart", totlaAmount = "Total Amount", checkout = "Checkout";
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    //_setData();
    _query();
  }

  _setData() {
    setState(() {
      isLoading = true;
    });
    AppServices.Transalate("Cart").then((data) async {
      setState(() {
        title = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Totla Amount").then((data) async {
      setState(() {
        totlaAmount = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Checkout").then((data) async {
      setState(() {
        checkout = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    setState(() {
      isLoading = false;
    });
    _query();
  }

  translate(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String name = "", quantity = "", sellingprice = "";
      AppServices.Transalate(pr[i]["name"]).then((data) async {
        name = data.data;
        setState(() {
          pr[i]["name"] = name;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["quantity"]).then((data) async {
        quantity = data.data;
        setState(() {
          pr[i]["quantity"] = quantity;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["sellingprice"]).then((data) async {
        sellingprice = data.data;
        setState(() {
          pr[i]["sellingprice"] = sellingprice;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
    }
    setState(() {
      _cart = pr;
    });
  }

  void _query() async {
    setState(() {
      isLoading = true;
      _cart = [];
      total = 0;
    });
    final allRows = await dbHelper.queryAllRows();
    print("type: ${allRows.runtimeType}");
    List dt = [];
    allRows.forEach((row) {
      int amount = int.parse(row["quantity"].toString()) *
          int.parse(row["sellingprice"].toString());

      setState(() {
        total += amount;
        dt.add(row);
        _cart.add(row);
      });
    });
    /* if (dt.length > 0) {
      await translate(dt);
    } else {
      setState(() {
        _cart.clear();
      });
    }
    print("list: ${_cart}");*/
    setState(() {
      isLoading = false;
    });
  }

  _update(_item, operation) async {
    String qty = "";
    if (operation == "add") {
      qty = (int.parse(_item["quantity"].toString()) + 1).toString();
    } else {
      qty = (int.parse(_item["quantity"].toString()) - 1).toString();
      if (qty == "0") {
        _delete(_item["_id"]);
      }
    }

    Map<String, dynamic> row = {
      CartDBHelper.columnId: _item["_id"],
      CartDBHelper.columnName: _item["name"],
      CartDBHelper.columnQuantity: qty,
      CartDBHelper.columnSelleingPrice: _item["sellingprice"],
      CartDBHelper.columnPicture: _item["picture"],
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
    _query();
  }

  _deleteAll() async {
    final allRows = await dbHelper.queryAllRows();

    allRows.forEach((row) {
      _delete(row["_id"]);
    });
  }

  void _delete(int id) async {
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  _checkOut() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);

        for (int i = 0; i < _cart.length; i++) {
          FormData data = FormData.fromMap({
            "userid": id,
            "cartdetail": "",
            "totalammount": total,
            "status": "",
            "pid": _cart[i]["pid"],
            "name": _cart[i]["name"],
            "quantity": _cart[i]["quantity"],
            "sellingprice": _cart[i]["sellingprice"],
            "picture": _cart[i]["picture"],
          });
          AppServices.CheckOut(data).then((data) async {
            if (data.data == "0") {
              Fluttertoast.showToast(
                  msg: "Order Placed successfully",
                  textColor: cnst.appPrimaryMaterialColor,
                  backgroundColor: Colors.grey.shade200,
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT);
            } else {
              showMsg("${cnst.SomethingWrong}");
            }
          }, onError: (e) {
            showMsg("${cnst.SomethingWrong}");
          });
        }

        pr.hide();
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("${cnst.NoInternet}");
    }
    _deleteAll();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Dashboard', (Route<dynamic> route) => false);
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
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Dashboard', (Route<dynamic> route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${title}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Dashboard', (Route<dynamic> route) => false);
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _cart.length > 0
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: _cart.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    _cart[index]['picture'] == null ||
                                            _cart[index]['picture'] == "" ||
                                            _cart[index]['picture'].length > 0
                                        ? Image.asset(
                                            "assets/background.png",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            _cart[index]['picture']["images"]
                                                [0],
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.fill,
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_cart[index]["name"]}",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${cnst.INR} ${_cart[index]["sellingprice"]}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _update(
                                                          _cart[index], "min");
                                                    },
                                                    child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                cnst.appPrimaryMaterialColor[
                                                                    500]),
                                                        child: Center(
                                                          child: Text(
                                                            "-",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Text(
                                                      "${_cart[index]["quantity"]}",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _update(
                                                          _cart[index], "add");
                                                    },
                                                    child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                cnst.appPrimaryMaterialColor[
                                                                    500]),
                                                        child: Center(
                                                          child: Text(
                                                            "+",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      Text(
                        "${totlaAmount}: ${total}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                    "${cnst.NoData}",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(5),
          child: MaterialButton(
            elevation: 5.0,
            height: 40,
            minWidth: MediaQuery.of(context).size.width,
            color: cnst.appPrimaryMaterialColor,
            child: new Text('${checkout}',
                style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            onPressed: () {
              if (_cart.length > 0) {
                _checkOut();
              } else {
                Fluttertoast.showToast(
                    msg: "First add product in Cart",
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT);
              }
            },
          ),
        ),
      ),
    );
  }
}
