import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsComments extends StatefulWidget {
  var _feedId;
  Function onChange;
  FeedsComments(this._feedId, this.onChange);
  @override
  _FeedsCommentsState createState() => _FeedsCommentsState();
}

class _FeedsCommentsState extends State<FeedsComments> {
  TextEditingController edtComment = new TextEditingController();
  bool isLoading = false;
  List _feedCommentList = [];
  String userId = "";
  ProgressDialog pr;

  @override
  void initState() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    _getFeedComments();
    _getLocal();
  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(cnst.Session.id);
    });
  }

  _getFeedComments() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);

        AppServices.GetFeedComments(widget._feedId, {}).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.data == "0") {
            setState(() {
              _feedCommentList = data.value;
            });
            print("d: ${_feedCommentList}");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });

          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });

      showMsg("No Internet Connection.");
    }
  }

  _sendMessage() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData d = FormData.fromMap({
          "userid": id,
          "feedid": widget._feedId,
          "comment": edtComment.text,
        });

        AppServices.AddFeedComment(d).then((data) async {
          pr.hide();
          if (data.data == "0") {
            Fluttertoast.showToast(
                msg: "Comment added",
                textColor: cnst.appPrimaryMaterialColor[700],
                backgroundColor: Colors.grey.shade100,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            widget.onChange();
            Navigator.pop(context);
          } else {
            showMsg("Something went wrong.");
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Comment"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _feedCommentList.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _feedCommentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FeedsCommentComponents(
                                userId, _feedCommentList[index]);
                          })
                      : Center(
                          child: Text(
                          "No Comments available",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        )),
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 15, top: 10),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      minLines: 2,
                      scrollPadding: EdgeInsets.all(0),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      cursorColor: cnst.appPrimaryMaterialColor,
                      controller: edtComment,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _sendMessage();
                          },
                        ),
                        hintText: "Comment",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class FeedsCommentComponents extends StatefulWidget {
  String userId;
  var _feedComment;
  FeedsCommentComponents(this.userId, this._feedComment);
  @override
  _feedCommentListComponentsState createState() =>
      _feedCommentListComponentsState();
}

class _feedCommentListComponentsState extends State<FeedsCommentComponents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          widget._feedComment['image'] == null ||
                  widget._feedComment['image'] == ""
              ? ClipOval(
                  child: Image.asset("assets/background.png",
                      height: 45, width: 45, fit: BoxFit.cover),
                )
              : ClipOval(
                  child: Image.network(
                    widget._feedComment['image'],
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget._feedComment["name"]}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("${widget._feedComment["comment"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
