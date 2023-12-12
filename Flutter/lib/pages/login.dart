import 'package:beslemekahramanlari/components/ext.dart';
import 'package:beslemekahramanlari/pages/homePage.dart';
import "package:flutter/material.dart";
import '../components/my_textfield.dart';
import '../components/my_button.dart';

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

  // sign user in
  void SignUserIn(BuildContext context) {
    if (_password == "" || _mail == "") {
      bottom_message(context, "Please fill all fields");
    } else if (_mail.length < 5 || _mail.contains("@") == false) {
      bottom_message(context, "Please enter a valid mail");
    } else if (_password.length < 5) {
      bottom_message(context, "Please enter a valid password");
    } // Perform any authentication logic here
    else {
      canSignIn = true;
    }
    if (canSignIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              MyButton(onTap: () => SignUserIn(context)),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
