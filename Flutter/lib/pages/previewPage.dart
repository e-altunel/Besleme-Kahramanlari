import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import "package:beslemekahramanlari/API/api.dart";
import "package:beslemekahramanlari/components/userInfo.dart";
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationC {
  final String name;
  final int id ;
  LocationC({required this.name, required this.id});
}

class previewPage extends StatefulWidget {
  final File imageFile;
  LatLng? currentP;
  previewPage({required this.imageFile, this.currentP});

  @override
  State<previewPage> createState() => _previewPageState();
}

class _previewPageState extends State<previewPage> {
  DateTime now = DateTime.now();
  int currentPage = 0;
  LatLng? currentP;
  String feed = '0';
  final _textcontroller = TextEditingController();
  late Uint8List imageData;
  List<LocationC> locations = []; // List to store locations
  LocationC? selectedLocation; // Selected location

  @override
  void initState() {
    super.initState();
    currentP = widget.currentP;
    //imageData = widget.imageFile.readAsBytesSync();
    fetchLocations(); // Fetch locations when the widget is initialized
  }

  // Function to fetch locations from the backend
  Future<void> fetchLocations() async {
    var response = await http.post(
      Uri.parse(url + "get-feed-points/"),
      headers: {
        HttpHeaders.authorizationHeader : 'Token ' + UserInfo.token, // user-info token
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(<String, double>{
        "latitude": currentP?.latitude ?? 40.0 ,
        "longitude": currentP?.longitude ?? 30.0,
      }
      )
    );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        for (int i=0;i<data['feed_points'].length ;i++){
          locations.add(LocationC(name: data['feed_points'][i]['name'], id: data['feed_points'][i]['pk']));
        }
        setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Stack (children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/animas.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child:
                IconButton(
                  onPressed: (){} ,
                  icon: Image.asset("lib/images/back_icon.png", width: 150, height: 50,),
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Preview",
                    style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 245, 59, 2)),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                child: Container(
                  width: 99999, 
                  height: 2, 
                  color: Color.fromARGB(255, 245, 59, 2),
                ),
              ),
              Positioned(
                top: 55,
                right: -1,
                child:
                Text(UserInfo.username,style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              Positioned(//image will be loaded
                top: 100,
                left: -1,
                child: /*Image.memory(imageData)*/ Image(
                      image: const AssetImage("lib/images/beslemekahramanlarilogo.png"),
                      width: screenWidth.toDouble(),
                      height: 300,
                    ),
              ),   

              const Positioned(
                top: 400,
                left: -1,
                child:
                  Text("Select Location: ",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),     

              Positioned(
                top: 400,
                left: 200,
                child:
                  //Text("Location: GTU",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
                  DropdownButton<LocationC>(
                  value: selectedLocation,
                  items: locations.map((location) {
                    return DropdownMenuItem<LocationC>(
                      value: location,
                      child: Text(location.name),
                    );
                  }).toList(),
                  onChanged: (LocationC? value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                ),
              ),
              Positioned(
                top: 400,
                right: -1,
                child:
                  Text("${now.day}.${now.month}.${now.year}",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              Positioned(
                top: 425,
                right: -1,
                child:
                  Text("${now.hour}.${now.minute}",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _textcontroller,
                      decoration: InputDecoration(
                        hintText: "Enter amount of food(Gr.)",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(_textcontroller);
                            _textcontroller.clear();
                          },
                          icon: const Icon(Icons.clear)
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 245, 59, 2),
                            minimumSize: Size(100, 50),
                            onPrimary: Color.fromARGB(255, 255, 255, 255),// Background color
                          ),
                          child: Text("Share!"),
                          onPressed: ()async{
                            feed = _textcontroller.text;
                            print("button pressed: ");
                            print(feed);
                            if (selectedLocation != null) {
                              print("Selected Location: ${selectedLocation!.name}");
                              var request = http.MultipartRequest('POST', Uri.parse(url + 'share-post/'));
                              request.files.add(http.MultipartFile.fromBytes('image', await widget.imageFile.readAsBytes()));
                              final headers = {
                                HttpHeaders.authorizationHeader : 'Token ' + UserInfo.token, // user-info token
                                HttpHeaders.contentTypeHeader: "application/json"
                              };
                              request.headers.addEntries(headers.entries);
                              final fields = <String, String>{
                                "feed_point": selectedLocation!.id.toString(),
                                "food_amount": feed
                              };
                              request.fields.addEntries(fields.entries);
                              var response = await request.send();
                              print(response);
                              // Perform your actions here when a location is selected
/*
                              List<int> imageBytes = widget.imageFile.readAsBytesSync();
                              Map<String, dynamic> requestData = {
                                "post": base64Encode(imageBytes),
                                "feed_point": selectedLocation!.id,
                                "food_amount ": feed,
                              };
                              try{
                                var responses = await http.post(
                                  Uri.parse(url + "share-post/"),
                                  headers: {
                                    HttpHeaders.authorizationHeader: UserInfo.token,
                                    HttpHeaders.contentTypeHeader: "application/json",
                                  },
                                  body: jsonEncode(requestData),
                                );
                              }
                              catch(error){}*/
                            }
                            else {
                              // Display a message or take appropriate action when no location is selected
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Location Not Selected'),
                                    content: Text('Please select a location before sharing.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                  ),
                ),
              ),
        ],
      ),
      appBar: AppBar(
        title: const Text("Besleme Kahramanları"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
        backgroundColor: const Color.fromARGB(255, 252, 81, 2),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                "lib/images/beslemekahramanlarilogo.png"), // Resim dosyanızın yolunu belirtin
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 0;
                    },
                  );
                },
                icon: Icon(Icons.maps_home_work_sharp,
                    color: currentPage == 0
                        ? const Color.fromARGB(255, 245, 59, 2)
                        : const Color.fromARGB(255, 0, 0, 0))),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 1;
                    },
                  );
                },
                icon: Icon(Icons.location_pin,
                    color: currentPage == 1
                        ? const Color.fromARGB(255, 245, 59, 2)
                        : const Color.fromARGB(255, 0, 0, 0))),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 2;
                    },
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: currentPage == 2
                      ? const Color.fromARGB(255, 245, 59, 2)
                      : const Color.fromARGB(255, 0, 0, 0),
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}