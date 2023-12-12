// ignore_for_file: prefer_const_constructors

import 'package:beslemekahramanlari/pages/profile.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void goProfile(BuildContext context) {
    print("goProfile function called");
    // Example: Navigating to ProfilePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  int currentPage = 1;
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
              iconSize: 30)
        ],
        backgroundColor: const Color.fromARGB(255, 252, 81, 2),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                "lib/images/beslemekahramanlarilogo.png"), // Resim dosyanızın yolunu belirtin
          ),
        ),
      ),
      body: Text(
        "Deneme $currentPage",
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
                icon: Icon(
                  Icons.sort,
                  color: currentPage == 0
                      ? const Color.fromARGB(255, 245, 59, 2)
                      : const Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                )),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 1;
                    },
                  );
                },
                icon: Icon(Icons.travel_explore,
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
