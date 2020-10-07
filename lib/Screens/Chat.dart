import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/AppServices.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/NewConversation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isLoading = true;
  List _sellerChatList = [];
  String userId = "";
  @override
  void initState() {
    _getUserToBuyerChat();
    _getLocal();
  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(cnst.Session.id);
    });
  }

  _getUserToBuyerChat() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData data = FormData.fromMap({"userid": id});
        print("iiii: ${id}");
        AppServices.GetUsersToSellerChatList(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.data == "0") {
            setState(() {
              _sellerChatList = data.value;
            });
            print("d: ${_sellerChatList}");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });

          showMsg("${cnst.SomethingWrong}");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat with Seller"),
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _sellerChatList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _sellerChatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AdminChatListComponents(
                          userId, _sellerChatList[index]);
                    })
                : Center(
                    child: Text(
                    "No Chats available",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  )),
      ),
    );
  }
}

class AdminChatListComponents extends StatefulWidget {
  String userId;
  var _Admin;
  AdminChatListComponents(this.userId, this._Admin);
  @override
  _sellerChatListComponentsState createState() =>
      _sellerChatListComponentsState();
}

class _sellerChatListComponentsState extends State<AdminChatListComponents> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewConversation(
                        widget.userId,
                        widget._Admin["id"].toString(),
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              widget._Admin['logo'] == null || widget._Admin['logo'] == ""
                  ? ClipOval(
                      child: Image.asset("assets/background.png",
                          height: 65, width: 65, fit: BoxFit.cover),
                    )
                  : ClipOval(
                      child: Image.network(
                        widget._Admin['logo'],
                        height: 65,
                        width: 65,
                        fit: BoxFit.fill,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("${widget._Admin["shopname"]}"),
              ),
            ],
          ),
        ));
  }
}
