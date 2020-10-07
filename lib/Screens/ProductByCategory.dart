import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ItemCard.dart';
import 'package:strings/strings.dart';

class ProductByCategory extends StatefulWidget {
  String categoryId;
  ProductByCategory(this.categoryId);
  @override
  _ProductByCategoryState createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  bool isLoading = false;
  List _product = [];
  String title = "Product by Category";
  int ind = 0;
  @override
  void initState() {
    super.initState();
    getProductByCategory();
    //_setData();
  }

  _setData() {
    AppServices.Transalate("Products by Category").then((data) async {
      setState(() {
        title = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
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
      _product = pr;
    });
  }

  getProductByCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.ProductsByCategory(widget.categoryId, {}).then(
            (data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
            });
            List service = data.value;
            //List dt = [];
            for (int i = 0; i < service.length; i++) {
              if (service[i]["status"] != "0") {
                _product.add(service[i]);
                //dt.add(service[i]);
              }
            }
            /*if (dt.length > 0) {
              await translate(dt);
            } else {
              setState(() {
                _product.clear();
              });
            }*/
            setState(() {
              isLoading = false;
            });
            //print("data:::::: ${_product}");
          } else {
            setState(() {
              isLoading = false;
              _product.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _product.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _product.clear();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _product.length > 0
              ? GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_product.length, (index) {
                    // Future<int> r = getRatings(_product[index]["id"]);
                    //print("r:${r}");
                    return _getListItemUI(index);
                  }),
                )
              : Center(
                  child: Text(
                  "${cnst.NoData}",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                )),
    );
  }

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ItemCard(_product[index])));
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
                child: _product[index]["picture"] == null ||
                        _product[index]["picture"] == "" ||
                        _product[index]["picture"].length == 0
                    ? Image.asset(
                        "assets/background.png",
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: "assets/background.png",
                        image: _product[index]["picture"]["images"][0],
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
                    //Text("${trans()}"),
                    //Text("${tr("Sagar")}"),
                    Text(
                      //_transalate(_product[index]['name']),
                      capitalize(_product[index]['name']),
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
                          "${cnst.INR} ${capitalize(_product[index]['sellingprice'])}",
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
                              _product[index]["averageRating"] == null ||
                                      _product[index]["averageRating"] == ""
                                  ? "0"
                                  : "${double.parse(_product[index]["averageRating"].toString()).toStringAsFixed(2)} ",
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
