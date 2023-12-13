import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class previewPage extends StatefulWidget {
  @override
  State<previewPage> createState() => _previewPageState();
}

class _previewPageState extends State<previewPage> {
  int currentPage = 0;
  String feed = '0';
  final _textcontroller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack (children: [
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
              const Positioned(
                top: 55,
                right: -1,
                child:
                Text("#userid",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              Positioned(
                top: 100,
                left: -1,
                child: Image(
                      image: const AssetImage("lib/images/beslemekahramanlarilogo.png"),
                      width: screenWidth.toDouble(),
                      height: 300,
                    ),
              ),              
              const Positioned(
                top: 400,
                left: -1,
                child:
                  Text("Location: GTU",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              const Positioned(
                top: 400,
                right: -1,
                child:
                  Text("13.11.2023",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
              ),
              const Positioned(
                top: 425,
                right: -1,
                child:
                  Text("19:32",style: TextStyle(fontSize: 25, color: Color.fromARGB(184, 38, 0, 255))), // color deişecek
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
                          onPressed: (){
                            feed = _textcontroller.text;
                            print("button pressed: ");
                            print(feed);
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