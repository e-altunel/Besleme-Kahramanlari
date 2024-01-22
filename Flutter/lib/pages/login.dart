import 'dart:convert';

import 'package:beslemekahramanlari/API/api.dart';
import 'package:beslemekahramanlari/components/ext.dart';
import 'package:beslemekahramanlari/components/userInfo.dart';
import 'package:beslemekahramanlari/pages/homePage.dart';
import 'package:beslemekahramanlari/pages/signUp_page.dart';
import "package:flutter/material.dart";
import '../components/my_textfield.dart';
import '../components/my_button.dart';
import 'package:http/http.dart';
import "../components/userInfo.dart";

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool canSignIn = false;
  String _mail = "";
  String _password = "";

  void navigateToSignUpPage(BuildContext context) {
    // Use Navigator to push the sign-up page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SignUpPage()), // Replace SignUpPage with your actual sign-up page class
    );
  }

  // sign user in
  void SignUserIn(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;

    Backend.login(username, password).then((response) {
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Eğer "token" alanı varsa al
        if (jsonResponse.containsKey("token") &&
            jsonResponse.containsKey("user")) {
          Map<String, dynamic> userMap = jsonResponse["user"];
          UserInfo.token = jsonResponse["token"].toString();
          UserInfo.username = userMap["username"].toString();
          UserInfo.pk = userMap["pk"].toString();
          UserInfo.email = userMap["email"].toString();
          UserInfo.password = userMap["password"].toString();
          UserInfo.food_amount = userMap["food_amount"].toString();
          UserInfo.first_name = userMap["first_name"].toString();
          UserInfo.last_name = userMap["last_name"].toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Successfully logged in",
                style: TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Color.fromARGB(255, 3, 255, 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please enter a correct username and password",
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      // Handle network-related errors
      print("Error during login: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error during login, Try again later",
            style: TextStyle(color: Colors.black, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/animas.jpg'),
        fit: BoxFit.cover,
      )),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Besleme Kahramanlari',
                  style: TextStyle(
                    fontFamily: 'LilitaOne',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.pets,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 30),
              const Text("Welcome Back",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 25),
              MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                  onTextChanged: (value) {
                    _mail = value; // Store email value
                  }),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  onTextChanged: (value) {
                    _password = value; // Store password value
                  }),
              const SizedBox(height: 10),
              MyButton(onTap: () => SignUserIn(context)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => navigateToSignUpPage(context),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
