import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlacesExample(title: 'Flutter Demo Home Page'),
    );
  }
}

class PlacesExample extends StatefulWidget {
  PlacesExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlacesExampleState createState() => _PlacesExampleState();
}

class _PlacesExampleState extends State<PlacesExample> {
  LatLng latlng = LatLng(
    -33.8670522,
    151.1957362,
  );
  Iterable markers = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    try {
      final response =
          await http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&key=AIzaSyCi2eeZa31Xy-HY3MwIGSC1p3jED5opsfc');

      final int statusCode = response.statusCode;

      if (statusCode == 201 || statusCode == 200) {
        Map responseBody = json.decode(response.body);
        List results = responseBody["results"];

        Iterable _markers = Iterable.generate(10, (index) {
          Map result = results[index];
          Map location = result["geometry"]["location"];
          LatLng latLngMarker = LatLng(location["lat"], location["lng"]);

          return Marker(markerId: MarkerId("marker$index"),position: latLngMarker);
        });

        setState(() {
          markers = _markers;
        });
      } else {
        throw Exception('Error');
      }
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("widget title"),
      ),
      body: GoogleMap(
        markers: Set.from(
          markers,
        ),
        initialCameraPosition: CameraPosition(target: latlng, zoom: 15.0),
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }

}