import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;

class SellerProfile extends StatefulWidget {
  String _sellerId;
  SellerProfile(this._sellerId);
  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  bool isLoading = true;
  List _productProfile = [], _serviceProfile = [], _feedsProfile = [];

  @override
  void initState() {
    _getProductProfile();

    super.initState();
  }

  _getProductProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.SellerProductProfile(widget._sellerId, {}).then(
            (data) async {
          if (data.data == "0") {
            setState(() {
              _productProfile = data.value;
            });
          } else {
            setState(() {
              _productProfile.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            _productProfile.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _productProfile.clear();
      });
      showMsg("No Internet Connection.");
    }
    _getServiceProfile();
  }

  _getServiceProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.SellerServiceProfile(widget._sellerId, {}).then(
            (data) async {
          if (data.data == "0") {
            setState(() {
              _serviceProfile = data.value;
            });
          } else {
            setState(() {
              _serviceProfile.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            _serviceProfile.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _serviceProfile.clear();
      });
      showMsg("No Internet Connection.");
    }
    _getFeedProfile();
  }

  _getFeedProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.SellerFeedsProfile(widget._sellerId, {}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
              _feedsProfile = data.value;
            });
          } else {
            setState(() {
              isLoading = false;
              _feedsProfile.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _feedsProfile.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _feedsProfile.clear();
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
    print("id: ${widget._sellerId}");
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Seller Profile"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.black45,
                    labelColor: cnst.appPrimaryMaterialColor,
                    indicatorColor: cnst.appPrimaryMaterialColor,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Product"),
                      Tab(text: "Services"),
                      Tab(text: "Feeds"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _productProfile.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _productProfile.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductProfileComponents(
                                      _productProfile[index]);
                                })
                            : Center(
                                child: Text("No Product Available",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black38)),
                              ),
                        _serviceProfile.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _serviceProfile.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ServiceProfileComponents(
                                      _serviceProfile[index]);
                                })
                            : Center(
                                child: Text("No Services Available",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black38)),
                              ),
                        _feedsProfile.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _feedsProfile.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return FeedsProfileComponents(
                                      _feedsProfile[index]);
                                })
                            : Center(
                                child: Text("No Feeds Available",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black38)),
                              )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ProductProfileComponents extends StatefulWidget {
  var _product;
  ProductProfileComponents(this._product);
  @override
  _ProductProfileComponentsState createState() =>
      _ProductProfileComponentsState();
}

class _ProductProfileComponentsState extends State<ProductProfileComponents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          widget._product["picture"] == "" || widget._product["picture"] == null
              ? Image.asset(
                  "assets/background.png",
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : FadeInImage.assetNetwork(
                  placeholder: "assets/background.png",
                  image: widget._product["picture"],
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget._product["name"]}"),
                      Text("${widget._product["placeofproduct"]}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("${widget._product["description"]}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceProfileComponents extends StatefulWidget {
  var _service;
  ServiceProfileComponents(this._service);
  @override
  _ServiceProfileComponentsState createState() =>
      _ServiceProfileComponentsState();
}

class _ServiceProfileComponentsState extends State<ServiceProfileComponents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          widget._service["picture"] == "" || widget._service["picture"] == null
              ? Image.asset(
                  "assets/background.png",
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : FadeInImage.assetNetwork(
                  placeholder: "assets/background.png",
                  image: widget._service["picture"],
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget._service["name"]}"),
                      Text("${widget._service["placeofservice"]}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("${widget._service["description"]}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedsProfileComponents extends StatefulWidget {
  var _feeds;
  FeedsProfileComponents(this._feeds);
  @override
  _FeedsProfileComponentsState createState() => _FeedsProfileComponentsState();
}

class _FeedsProfileComponentsState extends State<FeedsProfileComponents> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Text(
              widget._feeds["name"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          widget._feeds["image"] == null || widget._feeds["image"] == ""
              ? Image.asset(
                  "assets/background.png",
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : FadeInImage.assetNetwork(
                  placeholder: "assets/background.png",
                  image: widget._feeds["image"],
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5, bottom: 10),
            child: Text(
              widget._feeds["description"],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
