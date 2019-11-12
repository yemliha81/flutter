import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';

class AddGarage extends StatefulWidget {
  AddGarage({this.userid}) : super();
  final String userid;

  final String title = "Upload Image Demo";

  @override
  AddGarageState createState() => AddGarageState();
}

class AddGarageState extends State<AddGarage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  /*void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }*/

  void _setMarkerPosition(lat, lng) {
    setState(() {
      ltlng = lat+','+lng;
      print(ltlng);
    });
  }
 

  void _onAddMarkerButtonPressed() {
    setState(() {
      _setMarkerPosition(_lastMapPosition.latitude.toString(), _lastMapPosition.longitude.toString());
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        draggable: true,
        onDragEnd: ((value) {
            _setMarkerPosition(value.latitude.toString(), value.longitude.toString());
          }),
        infoWindow: InfoWindow(
          title: _lastMapPosition.toString(),
          //snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    //print(_lastMapPosition);
  }

  String status = 'no status';
  String errMessage = 'error sending data';
  String photo = '';
  String ltlng = '';
  String uploadEndPoint = 'http://patrongeldi.com/garaj/api/actions';
  Future<File> file;
  String base64Image;
  File tmpFile;

  TextEditingController imageTitle = new TextEditingController();
  TextEditingController imageDescription = new TextEditingController();

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    //String fileName = tmpFile.path.split('/').last;
    sendData();
  }

  sendData() {
    setStatus("Uploading, plesae wait...");
    http.post(uploadEndPoint, body: {
      "action": "addGarage",
      "user_id": userid,
      "image": base64Image,
      "ltlng": ltlng,
      "title": imageTitle.text,
      "description": imageDescription.text,
    }).then((result) {
      // print(base64Image);
      //var datauser = json.decode(result.body);
      setStatus(result.statusCode == 200 ? "successfull" : errMessage);
      //print(result.body);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test Page " + userid),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text("Welcome to Member Page User : " + userid),
          ),
          Container(
            height: 250.0,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
          ),
          RaisedButton(
            onPressed: _onAddMarkerButtonPressed,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            color: Colors.green,
            child: const Icon(Icons.add_location, size: 36.0),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
          ),
          showImage(),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: imageTitle,
              decoration: InputDecoration(
                hintText: 'Image Title',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: imageDescription,
              decoration: InputDecoration(
                hintText: 'Image Description',
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: RaisedButton(
                  onPressed: chooseImage,
                  child: Text("Choose Image"),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: RaisedButton(
                  onPressed: sendData,
                  child: Text("Send Data"),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}
