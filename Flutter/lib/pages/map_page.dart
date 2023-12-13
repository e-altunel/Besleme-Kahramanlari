import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key}); 
  @override
  State<mapPage > createState() => _mapPageState();
}
class _mapPageState extends State<mapPage> {
  int currentPage = 0;
  static const LatLng _pGooglePlex = LatLng(40.823099, 29.347767);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Location _locationController = new Location();
  LatLng? _currentP = null;
  XFile? pickedFile;
  @override
  void initState(){
    addCustomIcon();
    super.initState();
    getlocationupdates();
  }

    Future<void> openCamera() async {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // Do something with the picked image file
        print("Image picked");
      }
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40,40)), "lib/images/loca.png",)
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
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
              position: _currentP!),
            Marker(
              markerId: const MarkerId("_sourcelocation"), 
              icon: markerIcon, 
              position: _pGooglePlex,
              infoWindow: const InfoWindow(
                title: "nokta 1",
                snippet: "doluluk oranı"
                ),
              ),
            Marker(
              markerId: const MarkerId("_destionationlocation"), 
              icon: markerIcon, 
              position: _pApplePark,
              infoWindow: const InfoWindow(
                title: "nokta 2",
                snippet: "doluluk oranı"
                ),
              ),
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