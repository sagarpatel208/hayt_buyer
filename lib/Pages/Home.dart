import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ItemCard.dart';
import 'package:hayt_buyer/Screens/ShopProducts.dart';
import 'package:strings/strings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String title1 = "VIP", title2 = "New", title3 = "Shops";

  @override
  void initState() {
    // translate();
  }

  translate() {
    AppServices.Transalate("VIP").then((data) async {
      setState(() {
        title1 = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("New").then((data) async {
      setState(() {
        title2 = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    AppServices.Transalate("Shops").then((data) async {
      setState(() {
        title3 = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
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
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorColor: cnst.appPrimaryMaterialColor,
            labelColor: cnst.appPrimaryMaterialColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black45,
            tabs: [
              Tab(text: title1),
              Tab(text: title2),
              Tab(text: title3),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TabBarView(
                children: [
                  VIP(),
                  New(),
                  Shops(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VIP extends StatefulWidget {
  @override
  _VIPState createState() => _VIPState();
}

class _VIPState extends State<VIP> {
  bool isLoading = true;
  List _vipProducts = [];

  @override
  void initState() {
    getVIPProducts();
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
      _vipProducts = pr;
    });
  }

  getVIPProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetAllProducts({}).then((data) async {
          if (data.data == "0") {
            List service = data.value;
            //List dt = [];
            for (int i = 0; i < service.length; i++) {
              if (service[i]["vipstatus"] == "1") {
                //dt.add(service[i]);
                _vipProducts.add(service[i]);
              }
            }
            /*if (dt.length > 0) {
              await translate(dt);
            } else {
              setState(() {
                _vipProducts.clear();
              });
            }*/
            setState(() {
              isLoading = false;
            });
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
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _vipProducts.clear();
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : _vipProducts.length > 0
            ? GridView.count(
                crossAxisCount: 2,
                children: List.generate(_vipProducts.length, (index) {
                  return _getListItemUI(index);
                }),
              )
            : Center(
                child: Text(
                "${cnst.NoData}",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
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
                aspectRatio: 16.0 / 11.0,
                child:  _vipProducts[index]["picture"] == null ||
                    _vipProducts[index]["picture"] == "" ||
                    _vipProducts[index]["picture"].length == 0 ||
                    _vipProducts[index]["picture"]["images"].length == 0 ||
                    _vipProducts[index]["picture"]["images"] == null
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
                                  ? "0 "
                                  : "${_vipProducts[index]["averageRating"]} ",
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

class New extends StatefulWidget {
  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  bool isLoading = false;
  List _vipProducts = [];

  int ind = 0;

  @override
  void initState() {
    getVIPProducts();
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
      _vipProducts = pr;
    });
  }

  getVIPProducts() async {
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
            // List dt = [];
            for (int i = 0; i < service.length; i++) {
              if (service[i]["status"] == "1") {
                //dt.add(service[i]);
                _vipProducts.add(service[i]);
              }
            }
            /*if (dt.length > 0) {
              await translate(dt);
            } else {
              setState(() {
                _vipProducts.clear();
              });
            }*/
            setState(() {
              isLoading = false;
            });
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
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _vipProducts.clear();
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
    return isLoading
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
                "${cnst.NoData}",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
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
                aspectRatio: 16.0 / 11.0,
                child:  _vipProducts[index]["picture"] == null ||
                    _vipProducts[index]["picture"] == "" ||
                    _vipProducts[index]["picture"].length == 0 ||
                    _vipProducts[index]["picture"]["images"].length == 0 ||
                    _vipProducts[index]["picture"]["images"] == null
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
                        fit: BoxFit.fill,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
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

class Shops extends StatefulWidget {
  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  bool isLoading = true;
  List _seller = [];

  @override
  void initState() {
    super.initState();
    _getSeller();
  }

  translate(List pr) {
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
      _seller = pr;
    });
  }

  _getSeller() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetAllSeller({}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
              _seller = data.value;
            });

            /*if (data.value.length > 0) {
              await translate(data.value);
            } else {
              setState(() {
                _seller.clear();
              });
            }
            setState(() {
              isLoading = false;
            });*/
          } else {
            setState(() {
              isLoading = false;
              _seller.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _seller.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _seller.clear();
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : _seller.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _seller.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getListItemUI(index);
                })
            : Center(
                child: Text(
                "${cnst.NoData}",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
  }

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopProducts(_seller[index]["id"])));
      },
      child: Container(
        child: Card(
          elevation: 4,
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShopProducts(_seller[index]["id"])));
                  },
                  child: Stack(
                    children: [
                      _seller[index]['logo'] == null ||
                              _seller[index]['logo'] == ""
                          ? Image.asset("assets/background.png",
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover)
                          : Image.network(
                              _seller[index]['logo'],
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "${capitalize(_seller[index]["shopname"])}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
