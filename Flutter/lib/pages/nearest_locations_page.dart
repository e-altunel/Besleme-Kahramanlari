// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:beslemekahramanlari/components/points.dart';
import 'package:beslemekahramanlari/API/api.dart';
import 'package:flutter/material.dart';

class NearestLocationsPage extends StatefulWidget {
  NearestLocationsPage({Key? key}) : super(key: key);
  @override
  State<NearestLocationsPage> createState() => _NearestLocationsPageState();
}

class _NearestLocationsPageState extends State<NearestLocationsPage> {
  List<Point> points = [];
  @override
  void initState() {
    super.initState();
    getNearestLocations();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearest Locations',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: ListView(
        children: points.map((point) => _buildLocationCard(point)).toList(),
      ),
    );
  }

  Future<void> getNearestLocations() async {
    final response = await Backend.getNearestLocations(41.0082, 28.9784);
    if (response.statusCode == 200) {
      setState(() {
        final json = jsonDecode(response.body);
        final points = json['feed_points'];
        for (final pointdata in points) {
          Point point = Point.fromJson(pointdata);
          point.calculateDistance(41.0082, 28.9784);
          this.points.add(point);
        }
      });
    }
  }

  Widget _buildLocationCard(Point point) {
    final name = point.name;
    final capacity = point.foodAmount.toString() + ' g';
    final distance = point.distance.toString() + ' m';
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.battery_saver,
                  color: Colors.red,
                ),
                SizedBox(width: 4.0),
                Text(capacity),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.directions,
                  color: Colors.blue,
                ),
                SizedBox(width: 4.0),
                Text(distance),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Buraya "Götür" butonuna basıldığında yapılacak işlem eklenir.
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Arka plan rengi
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map,
                    color: Colors.black,
                  ),
                  SizedBox(width: 4.0),
                  Text(' GOOGLE MAPS', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
