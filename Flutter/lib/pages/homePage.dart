// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:beslemekahramanlari/pages/profile.dart';
import 'package:beslemekahramanlari/pages/map_page.dart'; // Import your MapPage
import 'package:beslemekahramanlari/pages/discover_page.dart'; // Import your DiscoverPage
import 'package:beslemekahramanlari/pages/nearest_locations_page.dart'; // Import your NearestLocationsPage

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1;

  // List of pages
  final List<Widget> _pages = [
    NearestLocationsPage(),
    mapPage(),
    DiscoverPage(),
  ];

  void goProfile(BuildContext context) {
    print("goProfile function called");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Besleme Kahramanlari',
          style: TextStyle(
            fontFamily: 'LilitaOne',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => goProfile(context),
            icon: const Icon(Icons.account_circle),
            iconSize: 30,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 252, 81, 2),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                "lib/images/beslemekahramanlarilogo.png"), // Adjust the image path as necessary
          ),
        ),
      ),
      body: _pages[currentPage], // Display the selected page
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  currentPage = 0;
                });
              },
              icon: Icon(
                Icons.sort,
                color: currentPage == 0
                    ? const Color.fromARGB(255, 245, 59, 2)
                    : const Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  currentPage = 1;
                });
              },
              icon: Icon(
                Icons.travel_explore,
                color: currentPage == 1
                    ? const Color.fromARGB(255, 245, 59, 2)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  currentPage = 2;
                });
              },
              icon: Icon(
                Icons.search,
                color: currentPage == 2
                    ? const Color.fromARGB(255, 245, 59, 2)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
