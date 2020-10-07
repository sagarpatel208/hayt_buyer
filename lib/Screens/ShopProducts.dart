import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ItemCard.dart';
import 'package:strings/strings.dart';

class ShopProducts extends StatefulWidget {
  var sellerId;
  ShopProducts(this.sellerId);
  @override
  _ShopProductsState createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  bool isLoading = false;
  List _products = [];
  @override
  void initState() {
    getShopProducts();

    super.initState();
  }

  translate(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String name = "",
          placeofproduct = "",
          city = "",
          district = "",
          color = "",
          description = "";
      AppServices.Transalate(pr[i]["name"]).then((data) async {
        name = data.data;
        setState(() {
          pr[i]["name"] = name;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["placeofproduct"]).then((data) async {
        placeofproduct = data.data;
        setState(() {
          pr[i]["placeofproduct"] = placeofproduct;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["city"]).then((data) async {
        city = data.data;
        setState(() {
          pr[i]["city"] = city;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["district"]).then((data) async {
        district = data.data;
        setState(() {
          pr[i]["district"] = district;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["color"]).then((data) async {
        color = data.data;
        setState(() {
          pr[i]["color"] = color;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["description"]).then((data) async {
        description = data.data;
        setState(() {
          pr[i]["description"] = description;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
    }
    setState(() {
      _products = pr;
    });
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
            List dt = [];
            for (int i = 0; i < service.length; i++) {
              if (service[i]["sellerid"].toString() ==
                  widget.sellerId.toString()) {
                dt.add(service[i]);
              }
            }

            if (dt.length > 0) {
              await translate(dt);
            } else {
              setState(() {
                _products.clear();
              });
            }
            setState(() {
              isLoading = false;
            });
            print("data:::::: ${_products}");
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
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _products.clear();
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
                aspectRatio: 16.0 / 11.0,
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
                        fit: BoxFit.fill,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Row(
                          children: [
                            Text(
                              _products[index]["averageRating"] == null ||
                                      _products[index]["averageRating"] == ""
                                  ? "0"
                                  : "${double.parse(_products[index]["averageRating"].toString()).toStringAsFixed(2)} ",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              "assets/star.png",
                              height: 13,
                              width: 13,
                              color: cnst.appPrimaryMaterialColor,
                            )
                          ],
                        )
                      ],
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
