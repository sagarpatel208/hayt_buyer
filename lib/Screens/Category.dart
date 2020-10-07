import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ProductByCategory.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List _category = [];
  bool isLoading = true;
  String title = "Category";
  @override
  void initState() {
    getAllCategory();
    //_setData();
  }

  _setData() {
    AppServices.Transalate("Category").then((data) async {
      setState(() {
        title = data.data;
      });
    }, onError: (e) {
      showMsg("${cnst.SomethingWrong}");
    });
    getAllCategory();
  }

  translate(List pr) {
    for (int i = 0; i < pr.length; i++) {
      String name = "";
      AppServices.Transalate(pr[i]["name"]).then((data) async {
        name = data.data;
        setState(() {
          pr[i]["name"] = name;
        });
      }, onError: (e) {
        showMsg("${cnst.SomethingWrong}");
      });
    }
    setState(() {
      _category = pr;
    });
  }

  getAllCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.GetAllCategory({}).then((data) async {
          if (data.data == "0") {
            if (data.value.length > 0) {
              _category = data.value;
              //await translate(data.value);
            } else {
              setState(() {
                _category.clear();
              });
            }
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _category.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _category.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _category.clear();
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Dashboard', (Route<dynamic> route) => false);
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _category.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _category.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryComponents(_category[index]);
                    })
                : Center(
                    child: Text("${cnst.NoData}",
                        style: TextStyle(fontSize: 20, color: Colors.black54)),
                  ));
  }
}

class CategoryComponents extends StatefulWidget {
  var _category;
  CategoryComponents(this._category);
  @override
  _CategoryComponentsState createState() => _CategoryComponentsState();
}

class _CategoryComponentsState extends State<CategoryComponents> {
  ProgressDialog pr;
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  _deleteCategory() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        AppServices.DeleteCategory(widget._category["id"], {}).then(
            (data) async {
          pr.hide();
          if (data.data == "0") {
            Fluttertoast.showToast(
                msg: "Category deleted successfully",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, '/Category');
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

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Hayt Seller"),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductByCategory(
                      widget._category["id"],
                    )));
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget._category["image"] == "" ||
                          widget._category["image"] == null
                      ? Image.asset(
                          "assets/background.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget._category["image"],
                          fit: BoxFit.fill,
                          height: 60,
                          width: 60,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(widget._category["name"]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
                child: Container(
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
