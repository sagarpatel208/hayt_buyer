import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;

class ImageView extends StatefulWidget {
  String image;
  List<String> images;
  ImageView(this.image, this.images);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int index;
  @override
  void initState() {
    int ind = widget.images.indexOf(widget.image);
    print("img: ${ind}");
    setState(() {
      index = widget.images.indexOf(widget.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          body: Stack(
        children: [
          Center(
            child: CarouselSlider(
              options: CarouselOptions(
                  autoPlay: false,
                  initialPage: index,
                  height: MediaQuery.of(context).size.height / 1.2,
                  autoPlayAnimationDuration: Duration(milliseconds: 100)),
              items: widget.images
                  .map((item) => Image.network(item,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width))
                  .toList(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cnst.appPrimaryMaterialColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.clear, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
