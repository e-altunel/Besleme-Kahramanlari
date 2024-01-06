import 'dart:math';

class Point {
  final String name;
  final double foodAmount;
  final double latitude;
  final double longitude;
  final int foodLevel;
  int distance = 0;

  Point({
    required this.name,
    required this.foodAmount,
    required this.latitude,
    required this.longitude,
    required this.foodLevel,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      name: json['name'],
      foodAmount: json['food_amount'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      foodLevel: json['food_level'],
    );
  }

  void calculateDistance(double userLatitude, double userLongitude) {
    double earthRadius = 6371.0; // km
    double dLat = (userLatitude - latitude) * (pi / 180);
    double dLon = (userLongitude - longitude) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(latitude * (pi / 180)) *
            cos(userLatitude * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = (earthRadius * c).round();
  }
}
