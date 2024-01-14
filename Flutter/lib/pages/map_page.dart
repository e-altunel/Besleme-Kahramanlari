//import 'dart:html';
import 'dart:io';
import 'dart:async'; // Import Timer
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:beslemekahramanlari/components/userInfo.dart";
import "package:beslemekahramanlari/API/api.dart";
import "package:beslemekahramanlari/pages/previewPage.dart";
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class mapPage extends StatefulWidget {
  const mapPage({super.key}); 
  @override
  State<mapPage > createState() => _mapPageState();
}
class _mapPageState extends State<mapPage>{
  int currentPage = 0;
  static const LatLng _pGooglePlex = LatLng(40.823099, 29.347767);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Location _locationController = new Location();
  LatLng? _currentP = null;
  XFile? pickedFile;
  List<Marker> markersList = [];

  @override
  void initState(){
    super.initState();
    addCustomIcon().then((_) {
    getmarkers(markerIcon);
    });
    getlocationupdates();
    Timer.periodic(Duration(seconds: 10), (timer) {
      getmarkers(markerIcon);
    });
  }

    Future<void> openCamera() async {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => previewPage(imageFile: File(pickedFile!.path), currentP: _currentP),
          ),
        );
      }
    }

  Future<void> addCustomIcon() async {
    ByteData data = await rootBundle.load("lib/images/loca.png");
    Uint8List bytes = data.buffer.asUint8List();

    // Use the image package to resize the image
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    img.Image resizedImage = img.copyResize(image, width: 135, height: 135);

    // Convert the resized image back to Uint8List
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));

    markerIcon = await BitmapDescriptor.fromBytes(resizedBytes);

    // Ensure that markerIcon is not null before proceeding
    if (markerIcon != null) {
      setState(() {
        // Update the state only if the markerIcon is successfully loaded
        markerIcon = markerIcon;
      });
    }
  }

  Future<void> getlocationupdates() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }
    else{
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentLocation){
      if (currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  void getmarkers(BitmapDescriptor markericon) async {
    markersList.clear();
    var response = await http.post(
      Uri.parse(url + "get-feed-points/"),
      headers: {
        HttpHeaders.authorizationHeader : 'Token ' + UserInfo.token, // user-info token
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(<String, double>{
        "latitude": _currentP?.latitude ?? 40.0 ,
        "longitude": _currentP?.longitude ?? 30.0,
      }
      )
    );
      if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (int i=0;i<data['feed_points'].length ;i++){
        markersList.add(Marker(
          markerId: MarkerId(data['feed_points'][i]['name']), 
          icon: markericon, 
          position: LatLng(data['feed_points'][i]['latitude'], data['feed_points'][i]['longitude']),
          infoWindow: InfoWindow(
            title: "Point: " + data['feed_points'][i]['name'],
            snippet: "Capacity: %" + data['feed_points'][i]['food_amount'].toString()
            ),
          ),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack (children : [ _currentP == null 
        ? const Center(
            child: Text("Loading..."),
          ) 
        : GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _pGooglePlex,
              zoom: 13,),
            markers: {
              Marker(
                markerId: const MarkerId("_currentlocation"), 
                icon: BitmapDescriptor.defaultMarker, 
                position: _currentP!
              ),
              ...markersList,
            },
          ),
          Positioned(
            bottom: 2,
            right: 50,
            child:
            IconButton(
              onPressed: openCamera,
              icon: Image.asset("lib/images/add_marker.png", width: 70, height: 90,),
            ),
          ),
        ]
      ),
    );
  }
}