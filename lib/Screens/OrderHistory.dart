import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool isLoading = false;
  List _orderHistory = [];
  @override
  void initState() {
    getOrderHistory();
  }

  getOrderHistory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        AppServices.GetOrderHistory(id, {}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
              _orderHistory = data.value;
            });
          } else {
            setState(() {
              isLoading = false;
              _orderHistory.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _orderHistory.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _orderHistory.clear();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _orderHistory.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _orderHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderComponents(_orderHistory[index]);
                  })
              : Center(
                  child: Text(
                  "No Order History",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                )),
    );
  }
}

class OrderComponents extends StatefulWidget {
  var _order;
  OrderComponents(this._order);
  @override
  _OrderComponentsState createState() => _OrderComponentsState();
}

class _OrderComponentsState extends State<OrderComponents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              widget._order['picture'] == null || widget._order['picture'] == ""
                  ? Image.asset("assets/background.png",
                      height: 65, width: 65, fit: BoxFit.cover)
                  : Image.network(
                      widget._order['picture'],
                      height: 65,
                      width: 65,
                      fit: BoxFit.fill,
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._order["name"] == "" ||
                                widget._order["name"] == null
                            ? "Product name"
                            : "${widget._order["name"]}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          widget._order["quantity"] == "" ||
                                  widget._order["quantity"] == null
                              ? "1"
                              : "${widget._order["quantity"]}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          widget._order["totalammount"] == "" ||
                                  widget._order["totalammount"] == null
                              ? "1"
                              : "${widget._order["totalammount"]}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
