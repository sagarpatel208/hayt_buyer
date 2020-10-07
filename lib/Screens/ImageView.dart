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
  PageController controller;
  @override
  void initState() {
    int ind = widget.images.indexOf(widget.image);
    controller = new PageController(initialPage: ind);
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
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, position) {
              return Image.network(widget.images[position],
                  fit: BoxFit.fill, width: MediaQuery.of(context).size.width);
            },
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
