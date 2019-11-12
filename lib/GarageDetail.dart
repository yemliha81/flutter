import 'package:flutter/material.dart';

class GarageDetail extends StatefulWidget {
  final String garageId;
  final String photo;
  final String title;
  final String description;
  GarageDetail({this.garageId, this.photo, this.title, this.description});

  @override
  _GarageDetailState createState() => _GarageDetailState();
}

class _GarageDetailState extends State<GarageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail ID : " + widget.garageId),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(widget.title),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(widget.description),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/loader.gif",
                  image: "http://patrongeldi.com/garaj/img/garage/source/" +
                      widget.photo,
                ),
              ),
            ),
          ],
        ));
  }
}
