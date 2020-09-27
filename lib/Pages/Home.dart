import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ItemCard.dart';
import 'package:hayt_buyer/Screens/ShopProducts.dart';
import 'package:strings/strings.dart';
import 'package:translator/translator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Tab(text: "VIP"),
              Tab(text: "New"),
              Tab(text: "Shops"),
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
    /* return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.green,
          child: new Center(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
          )),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );*/
  }
}

class VIP extends StatefulWidget {
  @override
  _VIPState createState() => _VIPState();
}

class _VIPState extends State<VIP> {
  final translator = GoogleTranslator();
  bool isLoading = true;
  List _vipProducts = [];
  List<int> _rating = [];
  final input = "Здравствуйте. Ты в порядке?";
  String txt = "";

  @override
  void initState() {
    getVIPProducts();

    //print('Sagarrrr:: ${AppServices.Transalate("Hello")}');
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
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["name"] = name;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
      AppServices.Transalate(pr[i]["placeofproduct"]).then((data) async {
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["placeofproduct"] = placeofproduct;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
      AppServices.Transalate(pr[i]["city"]).then((data) async {
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["city"] = city;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
      AppServices.Transalate(pr[i]["district"]).then((data) async {
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["district"] = district;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
      AppServices.Transalate(pr[i]["color"]).then((data) async {
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["color"] = color;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
      AppServices.Transalate(pr[i]["description"]).then((data) async {
        print("msg: ${data.message}, ${data.data}");
        name = data.data;
        setState(() {
          pr[i]["description"] = description;
        });
      }, onError: (e) {
        showMsg("Something went wrong.");
        name = "sa";
      });
    }
    _vipProducts = pr;
  }

  tr(String input) async {
    String text = await transsss(input);
    print("text: ${text}");
    return text;
  }

  transsss(String input) {
    AppServices.Transalate(input).then((data) async {
      print("msg: ${data.message}, ${data.data}");
      return data.data;
    }, onError: (e) {
      showMsg("Something went wrong.");
      return " ";
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
            for (int i = 0; i < service.length; i++) {
              if (service[i]["vipstatus"] == "1") {
                _vipProducts.add(service[i]);
                // await getRatings(_vipProducts[i]["id"]);
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
                "No VIP Products",
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
        AppServices.GetAllProducts({}).then((data) async {
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

  getRatings(String pId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AppServices.GetProductRatings(pId, {}).then((data) async {
          if (data.data == "0" && data.value.length > 0) {
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
            _rating[ind++] = (rates / i).round();
            //_rating.add((rates / i)
            //.round());
            print("_rating: ${_rating}");
            // return (rates / i).round;
          } else {
            setState(() {
              isLoading = false;
              _rating[ind++] = 0;
            });
            // return 0;
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _rating.clear();
          });
          showMsg("Something went wrong.");
          //return 0;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _rating.clear();
      });
      showMsg("No Internet Connection.");
      // return 0;
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
                "No New Products",
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

class Shops extends StatefulWidget {
  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  bool isLoading = false;
  List _seller = [];

  @override
  void initState() {
    getAdmins();

    super.initState();
  }

  getAdmins() async {
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
            });
            List service = data.value;
            for (int i = 0; i <= service.length; i++) {
              _seller.add(service[i]);
            }
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
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _seller.clear();
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
                "No Shops available",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ));
  }

  Widget _getListItemUI(int index) {
    return GestureDetector(
      onTap: () {
        print("jump");
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
                              fit: BoxFit.cover,
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
