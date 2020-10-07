import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/FeedsComments.dart';
import 'package:hayt_buyer/Screens/SellerProfile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List _feeds = [];
  bool isLoading = true;
  @override
  void initState() {
    getAllFeeds();
  }

  getAllFeeds() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        AppServices.GetAllFeeds(id, {}).then((data) async {
          if (data.data == "0") {
            setState(() {
              isLoading = false;
              //_feeds = data.value;
            });
            for (int i = 0; i < data.value.length; i++) {
              if (data.value[i]["status"] == "1") {
                _feeds.add(data.value[i]);
              }
            }
          } else {
            setState(() {
              isLoading = false;
              _feeds.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _feeds.clear();
          });
          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        _feeds.clear();
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
    return SafeArea(
      child: Scaffold(
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : _feeds.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: _feeds.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FeedsComponents(_feeds[index]);
                      })
                  : Center(
                      child: Text("No Feeds Available",
                          style:
                              TextStyle(fontSize: 20, color: Colors.black38)),
                    )),
    );
  }
}

class FeedsComponents extends StatefulWidget {
  var _feeds;
  FeedsComponents(this._feeds);
  @override
  _feedsComponentsState createState() => _feedsComponentsState();
}

class _feedsComponentsState extends State<FeedsComponents> {
  ProgressDialog pr;
  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  addFollow() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData data = FormData.fromMap({
          "sellerid": widget._feeds["sellerid"],
          "status": "0",
          "userid": id
        });
        AppServices.AddFollow(data).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              widget._feeds["isFollow"] = "1";
            });
            Fluttertoast.showToast(
                msg: "Follow successfully",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
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

  deleteFollow() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData data = FormData.fromMap({});
        print("id: ${widget._feeds["followid"]}");
        AppServices.DeleteFollow(widget._feeds["followid"], data).then(
            (data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              widget._feeds["isFollow"] = "0";
            });
            Fluttertoast.showToast(
                msg: "Unfollow successfully",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
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

  addLike() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData data =
            FormData.fromMap({"userid": id, "feedid": widget._feeds["id"]});
        AppServices.GiveFeedLike(data).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              widget._feeds["isLike"] = "1";
              widget._feeds["total_likes"] =
                  (int.parse(widget._feeds["total_likes"]) + 1).toString();
            });
            Fluttertoast.showToast(
                msg: "Like give",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
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

  removeLike() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData data =
            FormData.fromMap({"userid": id, "feedid": widget._feeds["id"]});
        AppServices.RemoveFeedLike(data).then((data) async {
          pr.hide();
          if (data.data == "0") {
            setState(() {
              widget._feeds["isLike"] = "0";
              widget._feeds["total_likes"] =
                  (int.parse(widget._feeds["total_likes"]) - 1).toString();
            });
            Fluttertoast.showToast(
                msg: "Like removed",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget._feeds["sellerid"] == null ||
                        widget._feeds["sellerid"] == "") {
                      Fluttertoast.showToast(
                          msg:
                              "Something is wrong!! you can't see Seller Profile.",
                          textColor: cnst.appPrimaryMaterialColor[700],
                          backgroundColor: Colors.grey.shade100,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerProfile(
                                    widget._feeds["sellerid"],
                                  )));
                    }
                  },
                  child: Text(
                    widget._feeds["shopname"] == null ||
                            widget._feeds["shopname"] == ""
                        ? "Shopname"
                        : widget._feeds["shopname"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget._feeds["sellerid"] == null ||
                        widget._feeds["sellerid"] == "") {
                      Fluttertoast.showToast(
                          msg: "You can't follow this seller",
                          textColor: cnst.appPrimaryMaterialColor[700],
                          backgroundColor: Colors.grey.shade100,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      if (widget._feeds["isFollow"] == "1") {
                        deleteFollow();
                      } else {
                        addFollow();
                      }
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget._feeds["isFollow"] == "1"
                              ? cnst.appPrimaryMaterialColor
                              : Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Text(
                          widget._feeds["isFollow"] == "1"
                              ? "Followed"
                              : "Follow",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget._feeds["isFollow"] == "1"
                                  ? Colors.white
                                  : cnst.appPrimaryMaterialColor),
                        ),
                      )),
                )
              ],
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
                ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              widget._feeds["description"].toString().length > 30
                  ? widget._feeds["description"].toString().substring(0, 29)
                  : widget._feeds["description"],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  widget._feeds["isLike"] == "1"
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      widget._feeds["isLike"] == "1" ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  if (widget._feeds["isLike"] == "1") {
                    removeLike();
                  } else {
                    addLike();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FeedsComments(widget._feeds["id"], () {
                                setState(() {
                                  widget._feeds["total_comments"] = int.parse(
                                          widget._feeds["total_comments"]) +
                                      1;
                                });
                              })));
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "${widget._feeds["total_likes"]} likes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FeedsComments(widget._feeds["id"], () {
                              setState(() {
                                widget._feeds["total_comments"] =
                                    int.parse(widget._feeds["total_comments"]) +
                                        1;
                              });
                            })));
              },
              child: Text(
                "View All ${widget._feeds["total_comments"]} Comments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
