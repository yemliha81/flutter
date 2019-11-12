import 'package:flutter/material.dart';
import 'package:google_maps_app/GoogleMapPage.dart';
import 'AddGarage.dart';
import 'PlacesExample.dart';
import 'GarageDetail.dart';
import 'main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberPage extends StatefulWidget {
  MemberPage({this.userid}) : super();
  final String userid;

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  List list = List();
  bool isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get("http://patrongeldi.com/garaj/api/user_garages/" + userid);
    if (response.statusCode == 200) {
      list = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
      return _showData();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future navigateToPlaces(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlacesExample()));
  }

  Future navigateToAddGarage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddGarage()));
  }

  Future navigateToAddMap(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GoogleMapPage()));
  }

  _showData() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(list.length, (index) {
              return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GarageDetail(
                                garageId: list[index]['garage_id'],
                                photo: list[index]['photo'],
                                title: list[index]['title'],
                                description: list[index]['description'])));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Image.network(
                              "http://patrongeldi.com/garaj/img/garage/thumbnail/" +
                                  list[index]['photo']),
                        ),
                      ),
                      Center(
                        child: Text(list[index]['title']),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
    /*ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "http://patrongeldi.com/garaj/img/garage/thumbnail/" +
                          list[index]['photo']),
                ),
                title: Text(list[index]['title']),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GarageDetail(
                              garageId: list[index]['garage_id'],
                              photo: list[index]['photo'],
                              title: list[index]['title'],
                              description: list[index]['description'])));
                },
                trailing: Icon(Icons.keyboard_arrow_right),
              );
            });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Member ID : " + userid),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.add),
            onTap: () {
              navigateToAddGarage(context);
            },
          ),
          SizedBox(width: 20)
        ],
      ),
      body: _showData(),
      floatingActionButton:
          FloatingActionButton(onPressed: _fetchData, child: Icon(Icons.list)),
    );
  }
}
