// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NearestLocationsPage extends StatefulWidget {
  const NearestLocationsPage({super.key});

  @override
  State<NearestLocationsPage> createState() => _NearestLocationsPageState();
}

class _NearestLocationsPageState extends State<NearestLocationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NearestLocations Page')),
    );
  }
}
