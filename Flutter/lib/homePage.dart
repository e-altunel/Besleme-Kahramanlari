import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "images/beslemekahramanlarilogo.png",
              height: 60,
            ),
            Center(
              child: Image.asset(
                "images/BeslemeHeader.png",
                height: 60,
              ),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
      ),
    );
  }
}
