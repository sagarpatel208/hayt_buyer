import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/CartDBHelper.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ImageView.dart';
import 'package:hayt_buyer/Screens/NewConversation.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

class ItemCard extends StatefulWidget {
  var _item;

  ItemCard(this._item);
  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final _cartDBHelper = CartDBHelper.instance;
  ProgressDialog pr;
  bool isLoading = true;
  String userId = "";
  List<String> imgList = [];
  List relatedProducts = [];
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    _getLocal();
    _setImages();
    getRelatedProducts();
  }

  _setImages() {
    if (widget._item["picture"].length > 0) {
      for (int i = 0; i < widget._item["picture"]["images"].length; i++) {
        imgList.add(widget._item["picture"]["images"][i]);
      }
    }
  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(cnst.Session.id);
    });
  }

  void _insertCart(
      String pid, String name, String sellingPrice, String picture) async {
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
  }

  _insertFav() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData d = FormData.fromMap(
            {"productid": widget._item["id"], "userid": id, "status": "0"});
        print("${widget._item["id"]}, ${id}");
        AppServices.AddToFav(d).then((data) async {
          pr.hide();
          if (data.data == "0") {
            Fluttertoast.showToast(
                msg: data.message,
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            /*Navigator.of(context).pushNamedAndRemoveUntil(
          '/Dashboard', (Route<dynamic> route) => false);*/
          } else {
            showMsg("${cnst.SomethingWrong}");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("${cnst.NoInternet}");
    }
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
      relatedProducts = pr;
    });
  }

  getRelatedProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetRelatedProducts(widget._item["sellerid"], {}).then(
            (data) async {
          if (data.data == "0") {
            setState(() {
              relatedProducts = data.value;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              relatedProducts.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            relatedProducts.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        relatedProducts.clear();
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

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemCard(relatedProducts[index])));
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16.0 / 11.0,
              child: relatedProducts[index]["picture"] == null ||
                      relatedProducts[index]["picture"] == "" ||
                      relatedProducts[index]["picture"].length == 0
                  ? Image.asset(
                      "assets/background.png",
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: "assets/background.png",
                      image: relatedProducts[index]["picture"]["images"][0],
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
                    //_transalate(relatedProducts[index]['name']),
                    capitalize(relatedProducts[index]['name']),
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
                        "${cnst.INR} ${capitalize(relatedProducts[index]['sellingprice'])}",
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
                            relatedProducts[index]["averageRating"] == null ||
                                    relatedProducts[index]["averageRating"] ==
                                        ""
                                ? "0"
                                : "${double.parse(relatedProducts[index]["averageRating"].toString()).toStringAsFixed(2)} ",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        imgList.length > 0
                            // ignore: missing_required_param
                            ? CarouselSlider(
                                options: CarouselOptions(
                                    autoPlay: true,
                                    height: 210,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 100)),
                                items: imgList
                                    .map((item) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageView(
                                                              item, imgList)));
                                            },
                                            child: Image.network(item,
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 210),
                                          ),
                                        ))
                                    .toList(),
                              )
                            : CarouselSlider(
                                options: CarouselOptions(
                                    autoPlay: true,
                                    height: 210,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 100)),
                                items: ["1"]
                                    .map((item) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: GestureDetector(
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg: "Image not available",
                                                  textColor: Colors.white,
                                                  backgroundColor: cnst
                                                      .appPrimaryMaterialColor,
                                                  gravity: ToastGravity.BOTTOM,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            },
                                            child: Image.asset(
                                                "assets/background.png",
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 210),
                                          ),
                                        ))
                                    .toList(),
                              ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.arrow_back),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              capitalize(widget._item['name']),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                widget._item['averageRating'] == null ||
                                        widget._item['averageRating'] == ""
                                    ? "0"
                                    : widget._item['averageRating'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Image.asset(
                                "assets/star.png",
                                height: 14,
                                width: 14,
                                color: cnst.appPrimaryMaterialColor,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            capitalize(widget._item['description']),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "${cnst.INR} ${widget._item["sellingprice"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "${capitalize(widget._item["placeofproduct"])}, ${capitalize(widget._item["city"])}, ${capitalize(widget._item["district"])}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget._item["sellingprice"]
                                          .toString()
                                          .contains("-") ||
                                      widget._item["sellingprice"]
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
                                        widget._item["id"].toString(),
                                        widget._item["name"].toString(),
                                        widget._item["sellingprice"].toString(),
                                        widget._item["picture"].toString());
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (widget._item["sellingprice"]
                                          .toString()
                                          .contains("-") ||
                                      widget._item["sellingprice"]
                                          .toString()
                                          .contains("/")) {
                                    Fluttertoast.showToast(
                                        msg: "Product can't added in Favorite",
                                        textColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_SHORT);
                                  } else {
                                    _insertFav();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewConversation(
                                              userId,
                                              widget._item["sellerid"])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.comment,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: relatedProducts.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  "Related Products",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      relatedProducts.length, (index) {
                                    return _getListItemUI(index);
                                  }),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  )
                ],
              ));
  }
}
