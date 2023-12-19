import "dart:convert";

import "package:beslemekahramanlari/components/userInfo.dart";
import "package:http/http.dart" as http;

const String url = "http://192.168.1.16:8000/api/";

class Backend {
  static Future<http.Response> register(String firstName, String lastName,
      String username, String email, String password) {
    return http.post(
      Uri.parse(url + "register"),
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
      Uri.parse(url + "login"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
  }

  static Future<http.Response> get_profile(String username, String password) {
    return http.post(
      Uri.parse(url + "login"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token' + UserInfo.token
      },
      body: jsonEncode(<String, String>{'user_id': UserInfo.pk}),
    );
  }
}
