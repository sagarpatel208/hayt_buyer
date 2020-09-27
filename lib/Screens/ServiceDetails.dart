import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:hayt_buyer/Screens/ImageView.dart';

class ServiceDetails extends StatefulWidget {
  var _services;
  ServiceDetails(this._services);
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  List<String> imgList = [];
  @override
  void initState() {
    _setImages();
  }

  _setImages() {
    if (widget._services["picture"].length > 0) {
      for (int i = 0; i < widget._services["picture"]["images"].length; i++) {
        imgList.add(widget._services["picture"]["images"][i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Service Details"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                                    padding: const EdgeInsets.only(left: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageView(item, imgList)));
                                      },
                                      child: Image.network(item,
                                          fit: BoxFit.fill,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                    padding: const EdgeInsets.only(left: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: "Image not available",
                                            textColor: Colors.white,
                                            backgroundColor:
                                                cnst.appPrimaryMaterialColor,
                                            gravity: ToastGravity.BOTTOM,
                                            toastLength: Toast.LENGTH_SHORT);
                                      },
                                      child: Image.asset(
                                          "assets/background.png",
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 210),
                                    ),
                                  ))
                              .toList(),
                        ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              bottomLeft: Radius.circular(13)),
                          color: cnst.appPrimaryMaterialColor[600]),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 13),
                          child: RichText(
                            text: TextSpan(
                              text: widget._services["discount"],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "\nOff",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  widget._services["name"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  widget._services["description"].toString().length > 30
                      ? widget._services["description"]
                          .toString()
                          .substring(0, 29)
                      : widget._services["description"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 12),
                child: RichText(
                  text: TextSpan(
                    text: "${widget._services["sellingprice"]}    ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget._services["oldprice"],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: RichText(
                  text: TextSpan(
                    text: widget._services["placeofservice"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: ", ${widget._services["city"]}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: " (${widget._services["district"]})",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
