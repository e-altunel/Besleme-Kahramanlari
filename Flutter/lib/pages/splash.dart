// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import "package:beslemekahramanlari/pages/login.dart";
import "package:flutter/material.dart";

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatetoLogin();
  }

  _navigatetoLogin() async {
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundimage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  'Besleme Kahramanlari',
                  style: TextStyle(
                    fontFamily: 'LilitaOne',
                    fontSize: 60,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2.0
                      ..color = Colors.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.pets,
                  color: Colors.red[1000],
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
