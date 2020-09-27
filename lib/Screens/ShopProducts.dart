import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ItemCard.dart';
import 'package:strings/strings.dart';

class ShopProducts extends StatefulWidget {
  var AdminId;
  ShopProducts(this.AdminId);
  @override
  _ShopProductsState createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  bool isLoading = false;
  List _products = [];
  List<int> _rating = [];
  @override
  void initState() {
    getShopProducts();

    super.initState();
  }

  getShopProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetAllProducts({}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
            });
            List service = data.value;
            for (int i = 0; i < service.length; i++) {
              if (service[i]["sellerid"].toString() ==
                  widget.AdminId.toString()) {
                _products.add(service[i]);
                await getRatings(_products[i]["id"]);
              }
            }
          } else {
            setState(() {
              isLoading = false;
              _products.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _products.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _products.clear();
      });
      showMsg("No Internet Connection.");
    }
  }

  getRatings(String pId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetProductRatings(pId, {}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
            });
            int rates = 0;
            int i = 0;
            for (i = 0; i < data.value.length; i++) {
              rates = rates + int.parse(data.value[i]["rating"]);
            }
            print("rates: ${rates}, ${i}");
            print("S: ${rates / i}");
            //int rt = int.parse((rates / i).toString());
            _rating.add((rates / i)
                .round()); //_rating.add(int.parse((rates / i).toString()));
            print("_rating: ${_rating}");
          } else {
            setState(() {
              isLoading = false;
              _rating.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _rating.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _rating.clear();
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
        title: Text("Products"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.length > 0
              ? GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_products.length, (index) {
                    return _getListItemUI(index);
                  }),
                )
              : Center(
                  child: Text(
                  "No Products available",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                )),
    );
  }

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemCard(_products[index])));
      },
      child: Container(
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16.0 / 12.0,
                child: _products[index]["picture"] == null ||
                        _products[index]["picture"] == "" ||
                        _products[index]["picture"].length == 0
                    ? Image.asset(
                        "assets/background.png",
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: "assets/background.png",
                        image: _products[index]["picture"]["images"][0],
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      capitalize(_products[index]['name']),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${cnst.INR} ${capitalize(_products[index]['sellingprice'])}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
