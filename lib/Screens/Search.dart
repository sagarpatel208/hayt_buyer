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
  String title = "Title",
      searchTextBox = "Search anything...",
      selectOption = "Select Option",
      searchShop = "Search Shop",
      searchProduct = "Search Product",
      searchService = "Search Service";
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    //_setData();
  }

  _setData() {
    AppServices.Transalate("Search").then((data) async {
      setState(() {
        title = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Search anything...").then((data) async {
      setState(() {
        searchTextBox = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Select Option").then((data) async {
      setState(() {
        selectOption = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Search Shop").then((data) async {
      setState(() {
        searchShop = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Search Product").then((data) async {
      setState(() {
        searchProduct = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Search Service").then((data) async {
      setState(() {
        searchService = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
  }

  translateShop(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String firstname = "",
          lastname = "",
          shopname = "",
          email = "",
          phone = "",
          dob;
      AppServices.Transalate(pr[i]["firstname"]).then((data) async {
        firstname = data.data;
        setState(() {
          pr[i]["firstname"] = firstname;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["lastname"]).then((data) async {
        lastname = data.data;
        setState(() {
          pr[i]["lastname"] = lastname;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["shopname"]).then((data) async {
        shopname = data.data;
        setState(() {
          pr[i]["shopname"] = shopname;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["dob"]).then((data) async {
        dob = data.data;
        setState(() {
          pr[i]["dob"] = dob;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["phone"]).then((data) async {
        phone = data.data;
        setState(() {
          pr[i]["phone"] = phone;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
      AppServices.Transalate(pr[i]["email"]).then((data) async {
        email = data.data;
        setState(() {
          pr[i]["email"] = email;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
    }
    setState(() {
      _shop = pr;
    });
  }

  _searchShop() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchShop(edtSearch.text, {}).then((data) async {
          if (data.data == "0") {
            if (data.value.length > 0) {_shop=data.value;
             // await translateShop(data.value);
            } else {
              setState(() {
                _shop.clear();
              });
            }
          } else {
            setState(() {
              _shop.clear();
            });
          }
          pr.hide();
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

  translateProduct(List pr) {
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

  _searchProduct() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchProduct(edtSearch.text, {}).then((data) async {
          if (data.data == "0") {
            if (data.value.length > 0) {
              _product=data.value;
              //await translateProduct(data.value);
            } else {
              setState(() {
                _product.clear();
              });
            }
          } else {
            setState(() {
              _product.clear();
            });
          }
          pr.hide();
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

  translateService(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String name = "",
          placeofservice = "",
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
      AppServices.Transalate(pr[i]["placeofservice"]).then((data) async {
        placeofservice = data.data;
        setState(() {
          pr[i]["placeofservice"] = placeofservice;
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
      _service = pr;
    });
  }

  _searchService() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.SearchService(edtSearch.text, {}).then((data) async {
          pr.hide();
          if (data.data == "0") {
            if (data.value.length > 0) {
              _service=data.value;
              ///await translateService(data.value);
            } else {
              setState(() {
                _service.clear();
              });
            }
          } else {
            setState(() {
              _service.clear();
            });
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
                          hintText: "${searchTextBox}",
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      elevation: 5.0,
                      height: 50,
                      minWidth: 100,
                      color: cnst.appPrimaryMaterialColor,
                      child: new Text('${title}',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white)),
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
                              "${cnst.NoData}",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ))
                      : _selectedOptions == "Search Product"
                          ? _product.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _product.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ProductComponent(_product[index]);
                                  })
                              : Center(
                                  child: Text(
                                  "${cnst.NoData}",
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
                                        return ServiceComponent(
                                            _service[index]);
                                      })
                                  : Center(
                                      child: Text(
                                      "${cnst.NoData}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black54),
                                    ))
                              : Text(""),
                )
              ],
            ),
          )),
    );
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
                    fit: BoxFit.fill,
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
                    widget._product["picture"] == null ||
                    widget._product["picture"].length > 0
                ? Image.asset(
                    "assets/background.png",
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "assets/background.png",
                    image: widget._product["picture"]["images"][0],
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
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
                    widget._service["picture"] == null ||
                    widget._service["picture"].length > 0
                ? Image.asset(
                    "assets/background.png",
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "assets/background.png",
                    image: widget._service["picture"]["images"][0],
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
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
