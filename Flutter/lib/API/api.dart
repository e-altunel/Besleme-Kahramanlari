import "dart:convert";
import "dart:io";

import "package:beslemekahramanlari/components/userInfo.dart";
import "package:http/http.dart" as http;

const String url = "http://192.168.1.10:8000/api/";

class Backend {
  static Future<http.Response> register(String firstName, String lastName,
      String username, String email, String password) {
    return http.post(
      Uri.parse(url + "register/"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
      }),
    );
  }

  static Future<http.Response> login(String username, String password) {
    return http.post(
      Uri.parse(url + "login/"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
  }

  static Future<http.Response> get_profile(String username, String password) {
    return http.post(
      Uri.parse(url + "login/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token' + UserInfo.token
      },
      body: jsonEncode(<String, String>{'user_id': UserInfo.pk}),
    );
  }

  static Future<http.Response> getLatestPosts() {
    return http.get(
      Uri.parse(url + "get-posts/"), // Adjust the endpoint as per your API
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token ' + UserInfo.token,
      },
    );
  }

  static Future<http.Response> reportPost(int postId) {
    return http.post(
      Uri.parse(url + "report-post/"), // Adjust the endpoint as per your API
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token ' + UserInfo.token,
      },
      body: jsonEncode(<String, int>{
        'post_id': postId,
      }),
    );
  }

  static Future<http.Response> getNearestLocations(
      double latitude, double longitude) {
    return http.post(Uri.parse(url + "get-feed-points/"),
        headers: {
          HttpHeaders.authorizationHeader:
              'Token ' + UserInfo.token, // user-info token
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: jsonEncode(<String, double>{
          "latitude": latitude,
          "longitude": longitude,
        }));
  }

  static Future<http.Response> getFeedPoint(int feedPointId) async {
    var response = await http.get(
      Uri.parse(url + "get-feed-point/" + feedPointId.toString() + "/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token ' + UserInfo.token,
      },
    );
    return response;
  }

  static Future<http.Response> changePassword(
      String oldPassword, String newPassword) {
    return http.post(
      Uri.parse(url + "change-password/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token ' + UserInfo.token, // Eğer gerekliyse
      },
      body: jsonEncode(<String, String>{
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );
  }
}
