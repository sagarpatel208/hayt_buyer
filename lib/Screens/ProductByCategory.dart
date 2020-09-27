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
  List _vipProducts = [];
  List<int> _rating = [];
  int ind = 0;
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
        AppServices.ProductsByCategory(widget.categoryId, {}).then(
            (data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
            });
            List service = data.value;
            for (int i = 0; i < service.length; i++) {
              if (service[i]["status"] != "0") {
                _vipProducts.add(service[i]);
                _rating.add(0);
                //  await getRatings(_vipProducts[i]["id"]);
              }
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Products by Category"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _vipProducts.length > 0
              ? GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_vipProducts.length, (index) {
                    // Future<int> r = getRatings(_vipProducts[index]["id"]);
                    //print("r:${r}");
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
                builder: (context) => ItemCard(_vipProducts[index])));
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
                child: _vipProducts[index]["picture"] == null ||
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Text("${trans()}"),
                    //Text("${tr("Sagar")}"),
                    Text(
                      //_transalate(_vipProducts[index]['name']),
                      capitalize(_vipProducts[index]['name']),
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
                          "${cnst.INR} ${capitalize(_vipProducts[index]['sellingprice'])}",
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
                              _vipProducts[index]["averageRating"] == null ||
                                      _vipProducts[index]["averageRating"] == ""
                                  ? "0"
                                  : "${double.parse(_vipProducts[index]["averageRating"].toString()).toStringAsFixed(2)} ",
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
