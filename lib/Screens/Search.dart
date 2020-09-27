import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _selectedOptions = "Select Option";
  List _shop = [], _product = [], _service = [];
  TextEditingController edtSearch = new TextEditingController();
  ProgressDialog pr;
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  _searchShop() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchShop(edtSearch.text, {}).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              _shop = data.value;
            });
          } else {
            setState(() {
              _shop.clear();
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _searchProduct() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchProduct(edtSearch.text, {}).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              _product = data.value;
            });
          } else {
            setState(() {
              _product.clear();
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _searchService() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchService(edtSearch.text, {}).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              _service = data.value;
            });
          } else {
            setState(() {
              _service.clear();
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
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
          title: Text("Search"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Dashboard', (Route<dynamic> route) => false);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: new DropdownButton<String>(
                        items: <String>[
                          'Select Option',
                          'Search Shop',
                          'Search Product',
                          'Search Service'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: _selectedOptions,
                        onChanged: (value) {
                          setState(() {
                            _shop = [];
                            _product = [];
                            _service = [];
                            edtSearch.text = "";
                            _selectedOptions = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      cursorColor: cnst.appPrimaryMaterialColor,
                      controller: edtSearch,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Search anything",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 0.1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    elevation: 5.0,
                    height: 50,
                    minWidth: 100,
                    color: cnst.appPrimaryMaterialColor,
                    child: new Text('Search',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: () {
                      if (_selectedOptions == "Select Option") {
                        Fluttertoast.showToast(
                            msg: "Select what you want to search...",
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT);
                      } else if (_selectedOptions == "Search Shop") {
                        _searchShop();
                      } else if (_selectedOptions == "Search Product") {
                        _searchProduct();
                      } else if (_selectedOptions == "Search Service") {
                        _searchService();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: _selectedOptions == "Search Shop"
                    ? _shop.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: _shop.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ShopComponent(_shop[index]);
                            })
                        : Center(
                            child: Text(
                            "No Shops available",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ))
                    : _selectedOptions == "Search Product"
                        ? _product.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _product.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductComponent(_product[index]);
                                })
                            : Center(
                                child: Text(
                                "No Products available",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ))
                        : _selectedOptions == "Search Service"
                            ? _service.length > 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: _service.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ServiceComponent(_service[index]);
                                    })
                                : Center(
                                    child: Text(
                                    "No Service available",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ))
                            : Text(""),
              )
            ],
          ),
        ));
  }
}

class ShopComponent extends StatefulWidget {
  var _shop;
  ShopComponent(this._shop);
  @override
  _ShopComponentState createState() => _ShopComponentState();
}

class _ShopComponentState extends State<ShopComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget._shop["logo"] == "" || widget._shop["logo"] == null
                ? Image.asset(
                    "assets/background.png",
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "assets/background.png",
                    image: widget._shop["logo"],
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 2,
                color: Colors.grey,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${widget._shop["firstname"]} ${widget._shop["lastname"]}"),
                        Text("")
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget._shop["shopname"]}"),
                        Text("${widget._shop["phone"]}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductComponent extends StatefulWidget {
  var _product;
  ProductComponent(this._product);
  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget._product["picture"] == "" ||
                    widget._product["picture"] == null
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 2,
                color: Colors.grey,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      ),
    );
  }
}

class ServiceComponent extends StatefulWidget {
  var _service;
  ServiceComponent(this._service);
  @override
  _ServiceComponentState createState() => _ServiceComponentState();
}

class _ServiceComponentState extends State<ServiceComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget._service["picture"] == "" ||
                    widget._service["picture"] == null
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 2,
                color: Colors.grey,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      ),
    );
  }
}
